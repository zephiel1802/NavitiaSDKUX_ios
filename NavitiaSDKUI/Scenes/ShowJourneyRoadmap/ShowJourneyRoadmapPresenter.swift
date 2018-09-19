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
    
    // MARK: Presenter
    
    func presentRoadmap(response: ShowJourneyRoadmap.GetRoadmap.Response) {
        guard let departure = getDepartureViewModel(journey: response.journey),
            let sectionsClean = getSectionsClean(response: response),
            let arrival = getArrivalViewModel(journey: response.journey),
            let emission = getEmission(response: response) else {
            return
        }

        let viewModel = ShowJourneyRoadmap.GetRoadmap.ViewModel(ridesharing: getRidesharing(journeyRidesharing: response.journeyRidesharing),
                                                                departure: departure,
                                                                sections: sectionsClean,
                                                                arrival: arrival,
                                                                emission: emission,
                                                                disruptions: response.disruptions,
                                                                journey: response.journey,
                                                                ridesharingJourneys: response.journeyRidesharing)
        
        viewController?.displayRoadmap(viewModel: viewModel)
    }
    
    // A construire
    func presentMap(response: ShowJourneyRoadmap.GetMap.Response) {
        let viewModel = ShowJourneyRoadmap.GetMap.ViewModel(journey: response.journey)
        viewController?.displayMap(viewModel: viewModel)
    }
    
    // A completer
    func presentBss(response: ShowJourneyRoadmap.FetchBss.Response) {
        guard let poi = getPoi(poi: response.poi) else {
            return
        }
        
        response.notify(poi)
    }
    
    // MARK: Ridesharing
    
    private func getRidesharingSection(ridesharingJourney: Journey?) -> Section? {
        guard let ridesharingJourney = ridesharingJourney, let ridesharingSections = ridesharingJourney.sections else {
            return nil
        }
        
        for section in ridesharingSections {
            if section.type == .ridesharing {
                return section
            }
        }
        
        return nil
    }
    
    private func getRidesharing(journeyRidesharing: Journey?) -> ShowJourneyRoadmap.GetRoadmap.ViewModel.Ridesharing? {
        guard let ridesharingSection = getRidesharingSection(ridesharingJourney: journeyRidesharing) else {
            return nil
        }
        
        let network = ridesharingSection.ridesharingInformations?.network ?? ""
        let departure = ridesharingSection.departureDateTime?.toDate(format: Configuration.date)?.toString(format: Configuration.timeRidesharing) ?? ""
        let driverPictureURL = ridesharingSection.ridesharingInformations?.driver?.image ?? ""
        let driverNickname = ridesharingSection.ridesharingInformations?.driver?.alias ?? ""
        let driverGender = ridesharingSection.ridesharingInformations?.driver?.gender?.rawValue ?? ""
        let rating = ridesharingSection.ridesharingInformations?.driver?.rating?.value ?? 0
        let ratingCount = ridesharingSection.ridesharingInformations?.driver?.rating?.count ?? 0
        let departureAddress = ridesharingSection.from?.name ?? ""
        let arrivalAddress = ridesharingSection.to?.name ?? ""
        let seatsCount = ridesharingSection.ridesharingInformations?.seats?.available
        let price = journeyRidesharing?.fare?.total?.value ?? ""
        let deepLink = ridesharingSection.links?[safe: 0]?.href ?? ""
        let ridesharingViewModel = ShowJourneyRoadmap.GetRoadmap.ViewModel.Ridesharing(network: network,
                                                                                       departure: departure,
                                                                                       driverPictureURL: driverPictureURL,
                                                                                       driverNickname: driverNickname,
                                                                                       driverGender: driverGender,
                                                                                       rating: rating,
                                                                                       ratingCount: ratingCount,
                                                                                       departureAddress: departureAddress,
                                                                                       arrivalAddress: arrivalAddress,
                                                                                       seatsCount: seatsCount,
                                                                                       price: price,
                                                                                       deepLink: deepLink)

        return ridesharingViewModel
    }
    
    // MARK: DepartureViewModel
    
    private func getDepartureViewModel(journey: Journey) -> ShowJourneyRoadmap.GetRoadmap.ViewModel.DepartureArrival? {
        if let departureName = getDepartureName(journey: journey), let departureTime = getDepartureTime(journey: journey) {
            let departureViewModel = ShowJourneyRoadmap.GetRoadmap.ViewModel.DepartureArrival(mode: .departure,
                                                                                              information: departureName,
                                                                                              time: departureTime,
                                                                                              calorie: nil)
            
            return departureViewModel
        }
        
        return nil
    }
    
    private func getDepartureName(journey: Journey) -> String? {
        return journey.sections?.first?.from?.name
    }
    
    private func getDepartureTime(journey: Journey) -> String? {
        guard let departureDate = journey.departureDateTime?.toDate(format: Configuration.date) else {
            return nil
        }
        
        return departureDate.toString(format: Configuration.time)
    }
    
    // MARK: ArrivalViewModel
    
    private func getArrivalViewModel(journey: Journey) -> ShowJourneyRoadmap.GetRoadmap.ViewModel.DepartureArrival? {
        if let arrivalName = getArrivalName(journey: journey),
            let arrivalTime = getArrivalTime(journey: journey),
            let calorie = getCalorie(journey: journey) {
            let arrivalViewModel = ShowJourneyRoadmap.GetRoadmap.ViewModel.DepartureArrival(mode: .arrival,
                                                                                            information: arrivalName,
                                                                                            time: arrivalTime,
                                                                                            calorie: calorie)
            
            return arrivalViewModel
        }
        
        return nil
    }
    
    private func getArrivalName(journey: Journey) -> String? {
        return journey.sections?.last?.to?.name
    }
    
    private func getArrivalTime(journey: Journey) -> String? {
        guard let arrivalDate = journey.arrivalDateTime?.toDate(format: Configuration.date) else {
            return nil
        }
        
        return arrivalDate.toString(format: Configuration.time)
    }
    
    private func getCalorie(journey: Journey) -> String? {
        guard let walkingDistance = journey.distances?.walking, let bikeDistance = journey.distances?.bike else {
            return nil
        }
        
        let calorie = (Double(walkingDistance) * Configuration.caloriePerSecWalking + Double(bikeDistance) * Configuration.caloriePerSecBike).rounded()
        
        return String(format: "%d", calorie)
    }
    
    // MARK: Section
    
    private func getType(section: Section) -> ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.ModelType? {
        guard let typeRawValue = section.type?.rawValue,
            let type = ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.ModelType.init(rawValue: typeRawValue) else {
                return nil
        }
        
        return type
    }
    
    private func getMode(section: Section) -> ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.Mode? {
        guard let modeRawValue = section.mode?.rawValue,
            let mode = ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.Mode.init(rawValue: modeRawValue) else {
                return nil
        }
        
        return mode
    }
    
    private func getFrom(section: Section) -> String {
        return section.from?.name ?? ""
    }
    
    private func getTo(section: Section) -> String {
        return section.to?.name ?? ""
    }
    
    private func getDepartureDateTime(section: Section) -> String {
        guard let departureDate = section.departureDateTime?.toDate(format: Configuration.date) else {
            return ""
        }
        
        return departureDate.toString(format: Configuration.time)
    }
    
    private func getArrivalDateTime(section: Section) -> String {
        guard let arrivalDate = section.arrivalDateTime?.toDate(format: Configuration.date) else {
            return ""
        }
        
        return arrivalDate.toString(format: Configuration.time)
    }
    
    private func getDuration(section: Section) -> String {
        guard let duration = section.duration else {
            return ""
        }
        
        return duration.minuteToString()
    }
    
    private func getWaiting(sectionBefore: Section?, section: Section) -> String? {
        guard let sectionBefore = sectionBefore else {
            return nil
        }
        
        if sectionBefore.type == .waiting {
            return getDuration(section: sectionBefore)
        }
        
        return nil
    }
    
    func getStopDate(section: Section) -> [String] {
        var stopDate = [String]()
        
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
        
        let standsViewModel = ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.Stands(availablePlaces: availablePlaces,
                                                                                          availableBikes: availableBikes)
        let poiViewModel = ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.Poi(name: name,
                                                                                    network: network,
                                                                                    lat: lat,
                                                                                    lont: lon,
                                                                                    addressName: addressName,
                                                                                    addressId: addressId,
                                                                                    stands: standsViewModel)
        
        return poiViewModel
    }
    
    private func getSectionsClean(response: ShowJourneyRoadmap.GetRoadmap.Response) -> [ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean]? {
        var sectionsClean = [ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean]()
        
        if let sections = response.journey.sections {
            for (index, section) in sections.enumerated() {
                guard let type = getType(section: section) else {
                    return nil
                }
                
                let sectionClean = ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean(type: type,
                                                                                            mode: getMode(section: section),
                                                                                            from: getFrom(section: section),
                                                                                            to: getTo(section: section),
                                                                                            startTime: getDepartureDateTime(section: section),
                                                                                            endTime: getArrivalDateTime(section: section),
                                                                                            duration: getDuration(section: section),
                                                                                            path: getPath(section: section),
                                                                                            stopDate: getStopDate(section: section),
                                                                                            displayInformations: getDisplayInformations(displayInformations: section.displayInformations),
                                                                                            waiting: getWaiting(sectionBefore: sections[safe: index - 1], section: section),
                                                                                            disruptions: getDisruption(section: section, disruptions: response.disruptions),
                                                                                            notes: getNotesOnDemandTransport(section: section, notes: response.notes),
                                                                                            poi: getPoi(poi: section.from?.poi ?? section.to?.poi),
                                                                                            icon: Modes().getModeIcon(section: section),
                                                                                            bssRealTime: getBssRealTime(section: section),
                                                                                            section: section)
                sectionsClean.append(sectionClean)
            }
        }
        
        return sectionsClean
    }
    
    // MARK: Emission
    
    private func getEmission(response: ShowJourneyRoadmap.GetRoadmap.Response) -> ShowJourneyRoadmap.GetRoadmap.ViewModel.Emission? {
        guard let journeyValue = response.journey.co2Emission?.value else {
            return nil
        }
        
        let carValue = response.context.carDirectPath?.co2Emission?.value
        let emissionViewModel = ShowJourneyRoadmap.GetRoadmap.ViewModel.Emission(journey: journeyValue,
                                                                                 car: carValue)
        
        return emissionViewModel
    }
    
    // MARK: DisplayInformations
    
    private func getCommercialMode(displayInformations: VJDisplayInformation?) -> String {
        return displayInformations?.commercialMode ?? ""
    }
    
    private func getColor(displayInformations: VJDisplayInformation?) -> UIColor {
        guard let color = displayInformations?.color else {
            return .black
        }
        
        return color.toUIColor()
    }
    
    private func getDirection(displayInformations: VJDisplayInformation?) -> String {
        return displayInformations?.direction ?? ""
    }
    
    private func getTransportCode(displayInformations: VJDisplayInformation?) -> String {
        guard let code = displayInformations?.code, !code.isEmpty else {
            return ""
        }
        
        return code
    }
    
    private func getDisplayInformations(displayInformations: VJDisplayInformation?) -> ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.DisplayInformations {
        let commercialMode = getCommercialMode(displayInformations: displayInformations)
        let color = getColor(displayInformations: displayInformations)
        let direction = getDirection(displayInformations: displayInformations)
        let code = getTransportCode(displayInformations: displayInformations)
        let displayInformationsClean = ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.DisplayInformations(commercialMode: commercialMode,
                                                                                                                color: color,
                                                                                                                directionTransit: direction,
                                                                                                                code: code)
        
        return displayInformationsClean
    }
    
    private func getNotesOnDemandTransport(section: Section, notes: [Note]?) -> [ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.Note] {
        var noteOnDemandTransport = [ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.Note]()
        
        for note in section.selectLinks(type: "notes") {
            if let notes = notes, let id = note.id, let note = section.getNote(notes: notes, id: id) {
                noteOnDemandTransport.append(ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.Note(content: note.value ?? ""))
            }
        }
        
        if let firstStopDateTimes = section.stopDateTimes?.first {
            let links = firstStopDateTimes.selectLinks(type: "notes")
            if links.count > 0 {
                for i in links {
                    if let notes = notes, let id = i.id, let note = section.getNote(notes: notes, id: id) {
                        noteOnDemandTransport.append(ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.Note(content: note.value ?? ""))
                    }
                }
                return noteOnDemandTransport
            }
        }
        
        if let laststopDateTimes = section.stopDateTimes?.last {
            for i in laststopDateTimes.selectLinks(type: "notes") {
                if let notes = notes, let id = i.id, let note = section.getNote(notes: notes, id: id) {
                    noteOnDemandTransport.append(ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.Note(content: note.value ?? ""))
                }
            }
        }
        
        return noteOnDemandTransport
    }
    
    // Disruption /!\
    
    func getDisruption(section: Section, disruptions: [Disruption]?) -> [Disruption] {
        var sectionDisruptions = [Disruption]()
        
        guard let disruptions = disruptions else {
            return sectionDisruptions
        }
        
        if disruptions.count > 0, let displayInformations = section.displayInformations, let displayInformationsLinks = displayInformations.links {
            var disruptionLinkIds = [String]()
            for linkSchema in displayInformationsLinks {
                if let schemaType = linkSchema.type, let schemaId = linkSchema.id, schemaType == "disruption" {
                    disruptionLinkIds.append(schemaId)
                }
            }
            
            for disruption in disruptions {
                if let disruptionId = disruption.id, disruption.applicationPeriods != nil && disruptionLinkIds.contains(disruptionId) {
                    sectionDisruptions.append(getDisruptionWithSortedMessages(disruptionIn: disruption))
                }
            }
            
            let sortedDisruptions = getSortedDisruptions(disruptions:sectionDisruptions)
            
            return sortedDisruptions
        }
        
        return sectionDisruptions
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
    
}

extension StopDateTime {
    
    func selectLinks(type: String) -> [LinkSchema] {
        var selectLinks = [LinkSchema]()
        
        guard let links = self.links else {
            return selectLinks
        }
        
        for link in links {
            if link.type == type {
                selectLinks.append(link)
            }
        }
        
        return selectLinks
    }
    
}

extension Section {
    
    public func getNote(notes: [Note], id: String) -> Note? {
        for note in notes {
            if note.id == id {
                return note
            }
        }
        
        return nil
    }
    
    func selectLinks(type: String) -> [LinkSchema] {
        var selectLinks = [LinkSchema]()
        
        guard let links = self.links else {
            return selectLinks
        }
        
        for link in links {
            if link.type == type {
                selectLinks.append(link)
            }
        }
        
        return selectLinks
    }
    
}
