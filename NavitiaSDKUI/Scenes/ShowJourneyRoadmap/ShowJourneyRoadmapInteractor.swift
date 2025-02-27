//
//  ShowJourneyRoadmapInteractor.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//
import UIKit

protocol ShowJourneyRoadmapBusinessLogic {
    
    func getRoadmap(request: ShowJourneyRoadmap.GetRoadmap.Request)
    func getMap(request: ShowJourneyRoadmap.GetMap.Request)
    func fetchBss(request: ShowJourneyRoadmap.FetchBss.Request)
    func fetchPark(request: ShowJourneyRoadmap.FetchPark.Request)
}

public protocol ShowJourneyRoadmapDataStore {
    
    var journey: Journey? { get set }
    var journeyPriceModel: PricesModel? { get set }
    var journeyRidesharing: Journey? { get set }
    var disruptions: [Disruption]? { get set }
    var notes: [Note]? { get set }
    var context: Context? { get set }
    var navitiaTickets: [Ticket]? { get set }
    var maasOrderId: Int? { get set }
    var maasTicketsJson: String? { get set }
    var totalPrice: (value: Float?, currency: String?)? { get set }
    var journeyInputJson: String? { get set }
}

class ShowJourneyRoadmapInteractor: ShowJourneyRoadmapBusinessLogic, ShowJourneyRoadmapDataStore {
    
    var journeyInputJson: String?
    var presenter: ShowJourneyRoadmapPresentationLogic?
    var journeysWorker = NavitiaWorker()
    var journey: Journey?
    var journeyPriceModel: PricesModel?
    var journeyRidesharing: Journey?
    var disruptions: [Disruption]?
    var notes: [Note]?
    var context: Context?
    var navitiaTickets: [Ticket]?
    var maasOrderId: Int?
    var maasTicketsJson: String?
    var totalPrice: (value: Float?, currency: String?)?
  
    // MARK: Get Roadmap
  
    func getRoadmap(request: ShowJourneyRoadmap.GetRoadmap.Request) {
        guard let journey = journey, let context = context else {
            return
        }
        
        let maasJourney = MaasJourney(context: context,
                                      disruptions: disruptions,
                                      journeys: [journey],
                                      tickets: navitiaTickets,
                                      hermaasTickets: journeyPriceModel?.hermaasPricedTickets)
        do {
            let summaryInputData = try JSONEncoder().encode(maasJourney)
            journeyInputJson = String(data: summaryInputData, encoding: .utf8)
        } catch {
            journeyInputJson = nil
        }
        
        // Add sections info to maas tickets
        let maasTickets = getMaasTickets(sectionsList: journey.sections, maasTickets: maasTicketsJson)
        let response = ShowJourneyRoadmap.GetRoadmap.Response(journey: journey,
                                                              journeyRidesharing: journeyRidesharing,
                                                              journeyPriceModel: journeyPriceModel,
                                                              disruptions: disruptions,
                                                              notes: notes,
                                                              context: context,
                                                              navitiaTickets: navitiaTickets,
                                                              maasOrderId: maasOrderId,
                                                              maasTickets: maasTickets,
                                                              totalPrice: totalPrice)
        presenter?.presentRoadmap(response: response)
    }
    
    // MARK: Get Map
    
    func getMap(request: ShowJourneyRoadmap.GetMap.Request) {
        guard let journey = journey else {
            return
        }
        
        let response = ShowJourneyRoadmap.GetMap.Response(journey: journey, journeyRidesharing: journeyRidesharing)
        presenter?.presentMap(response: response)
    }
    
    // MARK: Fetch Bss
    
    func fetchBss(request: ShowJourneyRoadmap.FetchBss.Request) {
        journeysWorker.fetchBss(coord: (lat: request.lat, lon: request.lon),
                                distance: request.distance,
                                id: request.id) { (poi) in
                                    guard let poi = poi else {
                                        return
                                    }
                                    
                                    
                                    let response = ShowJourneyRoadmap.FetchBss.Response(poi: poi, type: request.type, notify: request.notify)
                                    self.presenter?.presentBss(response: response)
        }
    }
    
    // MARK: Fetch Park
    
    func fetchPark(request: ShowJourneyRoadmap.FetchPark.Request) {
        journeysWorker.fetchPark(coord: (lat: request.lat, lon: request.lon),
                                distance: request.distance,
                                id: request.id) { (poi) in
                                    guard let poi = poi else {
                                        return
                                    }
                                    
                                    let response = ShowJourneyRoadmap.FetchPark.Response(poi: poi, notify: request.notify)
                                    self.presenter?.presentPark(response: response)
        }
    }
    
    // MARK: Maas Tickets
    
    private func getMaasTickets(sectionsList: [Section]?, maasTickets: String?) -> [MaasTicket]? {
        guard let sectionsList = sectionsList, let maasTickets = maasTickets, let maasTicketsData = maasTickets.data(using: .utf8) else {
            return nil
        }
        
        do {
            let decodedMaasTicketsList = try JSONDecoder().decode([MaasTicket].self, from: maasTicketsData)
            var maasTickets = [MaasTicket]()
            
            for section in sectionsList {
                for decodedMaasTicket in decodedMaasTicketsList {
                    if let mode = section.mode,
                        mode == .taxi,
                        decodedMaasTicket.productId == 3 {
                        let maasTicket = MaasTicket(productId: decodedMaasTicket.productId,
                                                    ticketId: decodedMaasTicket.ticketId,
                                                    ticket: decodedMaasTicket.ticket,
                                                    from: section.from?.name,
                                                    to: section.to?.name,
                                                    departureDatetime: section.departureDateTime,
                                                    arrivalDatetime: section.arrivalDateTime,
                                                    physicalMode: "taxi")
                        maasTickets.append(maasTicket)
                        break
                    } else if let type = section.type,
                        type == .publicTransport,
                        let links = section.links,
                        let ticketId = decodedMaasTicket.ticketId,
                        !ticketId.isEmpty {
                        for link in links {
                            if let type = link.type,
                                type == "ticket",
                                let linkId = link.id,
                                ticketId == linkId {
                                var physicalMode = ""
                                for link in links {
                                    if let type = link.type,
                                        type == "physical_mode",
                                        let linkId = link.id {
                                        let linkInfo = linkId.split(separator: ":")
                                        physicalMode = String(linkInfo[1])
                                        break
                                    }
                                }
                                
                                let maasTicket = MaasTicket(productId: decodedMaasTicket.productId,
                                                            ticketId: ticketId,
                                                            ticket: decodedMaasTicket.ticket,
                                                            from: section.from?.name,
                                                            to: section.to?.name,
                                                            departureDatetime: section.departureDateTime,
                                                            arrivalDatetime: section.arrivalDateTime,
                                                            physicalMode: physicalMode)
                                maasTickets.append(maasTicket)
                                break
                            }
                        }
                    }
                }
            }
            
            return maasTickets
        } catch {
            return nil
        }
    }
}
