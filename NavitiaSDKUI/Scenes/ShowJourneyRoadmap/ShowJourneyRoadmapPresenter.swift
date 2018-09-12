//
//  ShowJourneyRoadmapPresenter.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

protocol ShowJourneyRoadmapPresentationLogic {
    
    func presentRoadmap(response: ShowJourneyRoadmap.GetRoadmap.Response)
    func presentMap(response: ShowJourneyRoadmap.GetMap.Response)
    func presentBss(response: ShowJourneyRoadmap.FetchBss.Response)
}

class ShowJourneyRoadmapPresenter: ShowJourneyRoadmapPresentationLogic {
    
    weak var viewController: ShowJourneyRoadmapDisplayLogic?
  
    // MARK: Do something
    
    func presentBss(response: ShowJourneyRoadmap.FetchBss.Response) {
        guard let poi = getPoi(poi: response.poi) else {
            return
        }
        
        response.notify(poi)
    }
    
    func presentRoadmap(response: ShowJourneyRoadmap.GetRoadmap.Response) {
        var departure: ShowJourneyRoadmap.GetRoadmap.ViewModel.DepartureArrival
        var arrival: ShowJourneyRoadmap.GetRoadmap.ViewModel.DepartureArrival
        
        departure = ShowJourneyRoadmap.GetRoadmap.ViewModel.DepartureArrival(mode: .departure,
                                                                         information: response.journey.sections?.first?.from?.name ?? "",
                                                                         time: response.journey.departureDateTime?.toDate(format: Configuration.date)?.toString(format: Configuration.time) ?? "",
                                                                         calorie: nil)
        
        arrival = ShowJourneyRoadmap.GetRoadmap.ViewModel.DepartureArrival(mode: .arrival,
                                                                         information: response.journey.sections?.last?.to?.name ?? "",
                                                                         time: response.journey.arrivalDateTime?.toDate(format: Configuration.date)?.toString(format: Configuration.time) ?? "",
                                                                         calorie: "232")

        var viewModelSections: [ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean] = []
        
        
        
        if let sections = response.journey.sections {

            for (index, section) in sections.enumerated() {
                
                let type = ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.ModelType.init(rawValue: (section.type?.rawValue)!)!
                
                var mode: ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.Mode?
                if let sectionMode = section.mode?.rawValue {
                    mode = ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.Mode.init(rawValue: sectionMode)!
                }
                
                var transportCode: String?
                if let code = section.displayInformations?.code, !code.isEmpty {
                    transportCode = code
                }
                
                let from = section.from?.name ?? ""
                
                let to = section.to?.name ?? ""
                
                let startTime = section.departureDateTime?.toDate(format: Configuration.date)?.toString(format: Configuration.time) ?? ""
                
                let endTime = section.arrivalDateTime?.toDate(format: Configuration.date)?.toString(format: Configuration.time) ?? ""
                
                let time = section.duration?.minuteToString()
                
                let path = getPath(section: section)
                
                let stopDate = getStopDate(section: section)
                
                var waiting: String?
                if sections[safe: index - 1]?.type == .waiting {
                    waiting = sections[safe: index - 1]?.duration?.minuteToString()
                }

                let disruptions = getDisruption(section: section, disruptions: response.disruptions)
                
                let poi = getPoi(poi: section.from?.poi ?? section.to?.poi)
  
                let icon = Modes().getModeIcon(section: section)
                
                let bssRealTime = getBssRealTime(section: section)
                
                let displayInformations = ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.DisplayInformations(commercialMode: section.displayInformations?.commercialMode ?? "",
                                                                                                               color: section.displayInformations?.color?.toUIColor() ?? UIColor.black,
                                                                                                               directionTransit: section.displayInformations?.direction ?? "",
                                                                                                               code: transportCode)
                
                let viewModelSection = ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean(type: type,
                                                                                   mode: mode,
                                                                                   from: from,
                                                                                   to: to,
                                                                                   startTime: startTime,
                                                                                   endTime: endTime,
                                                                                   duration: time,
                                                                                   path: path,
                                                                                   stopDate: stopDate,
                                                                                   displayInformations: displayInformations,
                                                                                   waiting: waiting,
                                                                                   disruptions: disruptions,
                                                                                   poi: poi,
                                                                                   icon: icon,
                                                                                   bssRealTime: bssRealTime,
                                                                                   section: section)
        
                viewModelSections.append(viewModelSection)
            }
        }

        let viewModel = ShowJourneyRoadmap.GetRoadmap.ViewModel(departure: departure,
                                                            sections: viewModelSections,
                                                            arrival: arrival,
                                                            emission: ShowJourneyRoadmap.GetRoadmap.ViewModel.Emission(journeyValue: (response.journey.co2Emission?.value!)!),
                                                            disruptions: response.disruptions,
                                                            journey: response.journey)
        
        viewController?.displaySomething(viewModel: viewModel)
    }
    
    func presentMap(response: ShowJourneyRoadmap.GetMap.Response) {
        let viewModel = ShowJourneyRoadmap.GetMap.ViewModel(journey: response.journey)
        viewController?.displayMap(viewModel: viewModel)
    }
    
    func getStopDate(section: Section) -> [String] {
        var stopDate: [String] = []
        
        if let stopDateTimes = section.stopDateTimes {
            for (index, stop) in stopDateTimes.enumerated() {
                if let name = stop.stopPoint?.name {
                    if index != 0 && index != (stopDateTimes.count - 1) {
                        stopDate.append(name)
                    }
                }
            }
        }
        
        return stopDate
    }
    
    func getDisruption(section: Section, disruptions: [Disruption]?) -> [Disruption] {
        guard let disruptions = disruptions else {
            return [Disruption]()
        }
        
        if disruptions.count > 0, let displayInformations = section.displayInformations, let displayInformationsLinks = displayInformations.links {
            var disruptionLinkIds = [String]()
            for linkSchema in displayInformationsLinks {
                if let schemaType = linkSchema.type, let schemaId = linkSchema.id , schemaType == "disruption" {
                    disruptionLinkIds.append(schemaId)
                }
            }
            
            var sectionDisruptions = [Disruption]()
            for disruption in disruptions {
                if let disruptionId = disruption.id, disruption.applicationPeriods != nil && disruptionLinkIds.contains(disruptionId) {
                    sectionDisruptions.append(getDisruptionWithSortedMessages(disruptionIn: disruption))
                }
            }
            
            return getSortedDisruptions(disruptions:sectionDisruptions)
        }
        
        return [Disruption]()
    }
    
    fileprivate func getSortedDisruptions(disruptions: [Disruption]) -> [Disruption] {
        var mutatedDisruptions = disruptions
        for (i, _) in mutatedDisruptions.enumerated() {
            var j = i + 1
            while (j < mutatedDisruptions.count) {
                if mutatedDisruptions[j].level.rawValue > mutatedDisruptions[i].level.rawValue {
                    let substituteDisruption = mutatedDisruptions[j]
                    mutatedDisruptions[j] = mutatedDisruptions[i]
                    mutatedDisruptions[i] = substituteDisruption
                }
                
                j += 1
            }
        }
        
        return mutatedDisruptions
    }
    
    /*
     Channel Types Order :
     1- Mobile
     2- Web and Mobile
     3- Web
     */
    fileprivate func getDisruptionWithSortedMessages(disruptionIn: Disruption) -> Disruption {
        let disruptionOut = disruptionIn
        if let messages = disruptionOut.messages {
            var sortedMessages = [Message]()
            for message in messages {
                if let channelTypes = message.channel?.types, channelTypes.count > 0 {
                    if channelTypes.contains(Channel.Types.mobile) && channelTypes.contains(Channel.Types.web) {
                        sortedMessages.insert(message, at: getInsertionIndex(messages: sortedMessages, channelType: 2))
                    } else if channelTypes.contains(Channel.Types.mobile) {
                        sortedMessages.insert(message, at: 0)
                    } else if channelTypes.contains(Channel.Types.web) {
                        sortedMessages.insert(message, at: getInsertionIndex(messages: sortedMessages, channelType: 3))
                    }
                }
            }
            
            disruptionOut.messages = sortedMessages
        }
        
        return disruptionOut
    }
    
    /*
     Channel Types Order :
     1- Mobile
     2- Web and Mobile
     3- Web
     */
    fileprivate func getInsertionIndex(messages: [Message], channelType: Int) -> Int {
        if messages.count >= 1 && channelType != 1 {
            var outIndex = 0
            for (index, message) in messages.enumerated() {
                if let channelTypes = message.channel?.types {
                    if (channelType == 2 && channelTypes.contains(Channel.Types.web)) || (channelType == 3 && channelTypes.contains(Channel.Types.web) && !channelTypes.contains(Channel.Types.mobile)) {
                        return index
                    }
                }
                
                outIndex = index
            }
            
            return channelType == 2 || channelType == 3 ? outIndex + 1 : 0
        }
        
        return 0;
    }
    
    func getBssRealTime(section: Section) -> Bool {
        if let sectionDepartureTime = section.departureDateTime?.toDate(format: "yyyyMMdd'T'HHmmss"), let currentDateTime = Date().toLocalDate(format: "yyyyMMdd'T'HHmmss"), abs(sectionDepartureTime.timeIntervalSince(currentDateTime)) <= Configuration.bssApprovalTimeThreshold {
            return true
        }
        return false
    }
    
    func getPath(section: Section) -> [ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.Path] {
        var newPaths = [ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.Path]()
        
        guard let paths = section.path else {
            return newPaths
        }
        
        for (_, path) in paths.enumerated() {
            newPaths.append(ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.Path(direction: path.direction ?? 0,
                                                                                  length: path.length ?? 0,
                                                                                  name: path.name ?? ""))
        }
        return newPaths
    }
    
    func getPoi(poi: Poi?) -> ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.Poi? {
        guard let name = poi?.name,
            let network = poi?.properties?["network"],
            let latString = poi?.coord?.lat,
            let lat = Double(latString),
            let lonString = poi?.coord?.lon,
            let lon = Double(lonString),
            let addressName = poi?.address?.name,
            let addressId = poi?.address?.id,
            let availablePlaces = poi?.stands?.availablePlaces,
            let availableBikes = poi?.stands?.availableBikes else {
            return nil
        }

        return ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.Poi(name: name,
                                                 network: network,
                                                 lat: lat,
                                                 lont: lon,
                                                 addressName: addressName,
                                                 addressId: addressId,
                                                 stands: ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.Stands(availablePlaces: availablePlaces,
                                                                                                                 availableBikes: availableBikes))
    }
    
}


