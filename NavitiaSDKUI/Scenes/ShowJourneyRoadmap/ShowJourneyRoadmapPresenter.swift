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
    
    func presentBss(response: ShowJourneyRoadmap.FetchBss.Response) {
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
    
    private func getRidesharingAccessibility(departureAddress: String, arrivalAddress: String) -> String {
        return String(format: "ridesharing_offer".localized(bundle: NavitiaSDKUI.shared.bundle), departureAddress, arrivalAddress)
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
        let accessibility = getRidesharingAccessibility(departureAddress: departureAddress, arrivalAddress: arrivalAddress)
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
                                                                                       deepLink: deepLink,
                                                                                       accessibility: accessibility)

        return ridesharingViewModel
    }
    
    // MARK: DepartureViewModel
    
    private func getDepartureViewModel(journey: Journey) -> ShowJourneyRoadmap.GetRoadmap.ViewModel.DepartureArrival? {
        if let departureName = getDepartureName(journey: journey),
            let departureTime = getDepartureTime(journey: journey) {
            let accessibility = getDepartureAccessibilty(journey: journey, mode: .departure)
            let departureViewModel = ShowJourneyRoadmap.GetRoadmap.ViewModel.DepartureArrival(mode: .departure,
                                                                                              information: departureName,
                                                                                              time: departureTime,
                                                                                              calorie: nil,
                                                                                              accessibility: accessibility)
            
            
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
    
    private func getDepartureAccessibilty(journey: Journey, mode: ShowJourneyRoadmap.GetRoadmap.ViewModel.DepartureArrival.Mode) -> String {
        guard let name = journey.sections?.first?.from?.name,
            let dateTime = journey.departureDateTime?.toDate(format: Configuration.date) else {
                return ""
        }
        
        let hourComponents = Foundation.Calendar.current.dateComponents([.hour, .minute], from: dateTime)
        
        if let hours = DateComponentsFormatter.localizedString(from: hourComponents, unitsStyle: .spellOut) {
            return String(format: "departure_at_from".localized(bundle: NavitiaSDKUI.shared.bundle), hours, name)
        }
        
        return ""
    }
    
    private func getArrivalAccessibilty(journey: Journey, mode: ShowJourneyRoadmap.GetRoadmap.ViewModel.DepartureArrival.Mode) -> String {
        guard let name = journey.sections?.last?.to?.name,
            let dateTime = journey.arrivalDateTime?.toDate(format: Configuration.date) else {
                return ""
        }
        
        let hourComponents = Foundation.Calendar.current.dateComponents([.hour, .minute], from: dateTime)
        
        if let hours = DateComponentsFormatter.localizedString(from: hourComponents, unitsStyle: .spellOut) {
            return String(format: "arrival_at_to".localized(bundle: NavitiaSDKUI.shared.bundle), hours, name)
        }
        
        return ""
    }
    
    // MARK: ArrivalViewModel
    
    private func getArrivalViewModel(journey: Journey) -> ShowJourneyRoadmap.GetRoadmap.ViewModel.DepartureArrival? {
        if let arrivalName = getArrivalName(journey: journey),
            let arrivalTime = getArrivalTime(journey: journey),
            let calorie = getCalorie(journey: journey) {
            let accessibility = getArrivalAccessibilty(journey: journey, mode: .arrival)
            let arrivalViewModel = ShowJourneyRoadmap.GetRoadmap.ViewModel.DepartureArrival(mode: .arrival,
                                                                                            information: arrivalName,
                                                                                            time: arrivalTime,
                                                                                            calorie: calorie,
                                                                                            accessibility: accessibility)
            
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
        
        return String(format: "%d", Int(calorie))
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
    
    private func getActionDescription(section: Section) -> String? {
        guard let type = section.type else {
            return nil
        }
        
        if let network = section.from?.poi?.properties?["network"] ?? section.to?.poi?.properties?["network"] {
            if type == .bssRent {
                return String(format: "take_a_bike_at".localized(bundle: NavitiaSDKUI.shared.bundle), network)
            } else if type == .bssPutBack {
                return String(format: "dock_bike_at".localized(bundle: NavitiaSDKUI.shared.bundle), network)
            }
        }
        
        guard let mode = section.mode else {
            return nil
        }
        
        if mode == .ridesharing {
            return "take_the_ridesharing".localized(bundle: NavitiaSDKUI.shared.bundle)
        } else {
            return "to_with_uppercase".localized(bundle: NavitiaSDKUI.shared.bundle)
        }
    }
    
    private func getDuration(section: Section) -> String? {
        guard let duration = section.duration else {
            return nil
        }
        
        if section.type != .streetNetwork && section.type != .waiting {
            return nil
        }
        
        var template = ""
        if let mode = section.mode {
            switch mode {
            case .walking:
                template = "a_time_walk".localized(bundle: NavitiaSDKUI.shared.bundle)
            case .car:
                template = "a_time_drive".localized(bundle: NavitiaSDKUI.shared.bundle)
            case .bike, .bss:
                template = "a_time_ride".localized(bundle: NavitiaSDKUI.shared.bundle)
            case .ridesharing:
                template = String(format: "%@ %@", "about".localized(bundle: NavitiaSDKUI.shared.bundle), "a_time_drive".localized(bundle: NavitiaSDKUI.shared.bundle))
            default:
                return nil
            }
        }
        
        let durationString = duration.minuteToString()
        if section.type == .waiting {
            template = "wait".localized(bundle: NavitiaSDKUI.shared.bundle) + " %@"
        }
        var durationTemplate = durationString + " " + "units_minutes".localized(bundle: NavitiaSDKUI.shared.bundle)
        if duration == 1 {
            durationTemplate = durationString + " " + "units_minute".localized(bundle: NavitiaSDKUI.shared.bundle)
        } else if duration == 0 {
            durationTemplate = "less_than_a".localized(bundle: NavitiaSDKUI.shared.bundle) + " " + "units_minute".localized(bundle: NavitiaSDKUI.shared.bundle)
        }
        
        return String(format: template, durationTemplate)
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
    
    func getPoi(section: Section?/*poi: Poi?*/) -> ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.Poi? {
        guard let type = section?.type,
            type != .streetNetwork,
            let poi = section?.from?.poi ?? section?.to?.poi,
            let name = poi.name,
            let network = poi.properties?["network"],
            let latString = poi.coord?.lat,
            let lat = Double(latString),
            let lonString = poi.coord?.lon,
            let lon = Double(lonString),
            let addressName = poi.address?.name,
            let addressId = poi.address?.id else {
                return nil
        }
        
        let standsViewModel = getStands(stands: poi.stands, type: type)
        let poiViewModel = ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.Poi(name: name,
                                                                                    network: network,
                                                                                    lat: lat,
                                                                                    lont: lon,
                                                                                    addressName: addressName,
                                                                                    addressId: addressId,
                                                                                    stands: standsViewModel)
        
        return poiViewModel
    }
    
    private func getStands(stands: Stands?, type: Section.ModelType) -> ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.Stands? {
        guard let stands = stands else {
            return nil
        }
        
        switch type {
        case .bssRent:
            if let availableBikes = stands.availableBikes {
                let standsViewModel = ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.Stands(availability: String(format: "bss_bikes_available".localized(bundle: NavitiaSDKUI.shared.bundle), availableBikes),
                                                                                              icon: nil)
                return standsViewModel
            }
        case .bssPutBack:
            if let availablePlaces = stands.availablePlaces {
                let standsViewModel = ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.Stands(availability: String(format: "bss_available_bikes_plural".localized(bundle: NavitiaSDKUI.shared.bundle), availablePlaces),
                                                                                                                   icon: nil)
                return standsViewModel
            }
        default:
            return nil
        }
        
        return nil
    }
    
    private func getBackground(section: Section) -> Bool {
        guard let mode = section.mode else {
            return true
        }
        
        if mode == .ridesharing || mode == .carnopark {
            return true
        }
        return false
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
                                                                                        actionDescription: getActionDescription(section: section),
                                                                                        duration: getDuration(section: section),
                                                                                        path: getPaths(section: section),
                                                                                        stopDate: getStopDate(section: section),
                                                                                        displayInformations: getDisplayInformations(displayInformations: section.displayInformations),
                                                                                        waiting: getWaiting(sectionBefore: sections[safe: index - 1], section: section),
                                                                                        disruptions: getDisruption(section: section, disruptions: response.disruptions),
                                                                                        disruptionsClean: getDisruptionClean(section: section, disruptions: response.disruptions),
                                                                                        notes: getNotesOnDemandTransport(section: section, notes: response.notes),
                                                                                        poi: getPoi(section: section),
                                                                                        icon: Modes().getMode(section: section),
                                                                                        bssRealTime: getBssRealTime(section: section),
                                                                                        background: getBackground(section: section),
                                                                                        section: section)
                sectionsClean.append(sectionClean)
            }
        }
        
        return sectionsClean
    }
    
    // MARK: Emission
    
    private func getEmission(response: ShowJourneyRoadmap.GetRoadmap.Response) -> ShowJourneyRoadmap.GetRoadmap.ViewModel.Emission? {
        guard let journeyValue = response.journey.co2Emission?.value,
            let journeyCarbonSummary = getFormattedEmission(emissionValue: journeyValue) else {
            return nil
        }

        let carCarbonSummary = getFormattedEmission(emissionValue: response.context.carDirectPath?.co2Emission?.value)
        
        var emissionViewModel = ShowJourneyRoadmap.GetRoadmap.ViewModel.Emission.init(journey: journeyCarbonSummary,
                                                                                      car: carCarbonSummary,
                                                                                      accessibility: "")
        let accessibilityLabel = getEmissionAccessibility(emissionViewModel: emissionViewModel)
        
        emissionViewModel.accessibility = accessibilityLabel
        
        return emissionViewModel
    }
    
    private func getFormattedEmission(emissionValue: Double?) -> (value: Double, unit: String)? {
        guard var emissionValue = emissionValue else {
            return nil
        }
        
        var carbonUnit = "units_g".localized(bundle: NavitiaSDKUI.shared.bundle)
        if emissionValue >= 1000 {
            emissionValue = emissionValue / 1000
            carbonUnit = "units_kg".localized(bundle: NavitiaSDKUI.shared.bundle)
        }
        carbonUnit.append(String(format: " %@", "carbon".localized(bundle: NavitiaSDKUI.shared.bundle)))
        
        return (value: emissionValue, unit: carbonUnit)
    }
    
    private func getValueEmissionAccessibility(value: Double, unit: String) -> String {
        if unit == "g CO2" {
            return String(format: "%.1f %@ %@. ", value, "gram".localized(bundle: NavitiaSDKUI.shared.bundle), "of_carbon_dioxide".localized(bundle: NavitiaSDKUI.shared.bundle))
        } else if unit == "Kg CO2" {
            return String(format: "%.1f %@ %@. ", value, "kilogram".localized(bundle: NavitiaSDKUI.shared.bundle), "of_carbon_dioxide".localized(bundle: NavitiaSDKUI.shared.bundle))
        }
        
        return ""
    }
    
    private func getEmissionAccessibility(emissionViewModel: ShowJourneyRoadmap.GetRoadmap.ViewModel.Emission) -> String {
        var accessibilityLabel = String(format: "carbon_footprint".localized(bundle: NavitiaSDKUI.shared.bundle), getValueEmissionAccessibility(value: emissionViewModel.journey.value, unit: emissionViewModel.journey.unit))
        if let car = emissionViewModel.car {
            accessibilityLabel += String(format: "carbon_comparison_car".localized(bundle: NavitiaSDKUI.shared.bundle), getValueEmissionAccessibility(value: car.value, unit: car.unit))
        }
        
        return accessibilityLabel
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
    
    private func getTransportCode(displayInformations: VJDisplayInformation?) -> String? {
        guard let code = displayInformations?.code, !code.isEmpty else {
            return nil
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
        
        guard section.type == .onDemandTransport else {
            return noteOnDemandTransport
        }
        
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
    
    func getDateDisruption(disruption: Disruption) -> String {
        if let startDate = disruption.applicationPeriods?.first?.begin?.toDate(format: Configuration.date),
            let endDate = disruption.applicationPeriods?.first?.end?.toDate(format: Configuration.date) {
            return String(format: "%@ %@ %@ %@", "from".localized(bundle: NavitiaSDKUI.shared.bundle),
                          startDate.toString(format: Configuration.dateInterval),
                          "to_period".localized(bundle: NavitiaSDKUI.shared.bundle),
                          endDate.toString(format: Configuration.dateInterval))
        }
        return ""
    }
    
    func getAccessibilityDisruption(disruption: Disruption) -> String {
        let title = disruption.severity?.name ?? ""
        let information = Disruption.message(disruption: disruption)?.text?.htmlToAttributedString?.string ?? ""
        var startDate = ""
        var endDate = ""
        
        if let start = disruption.applicationPeriods?.first?.begin?.toDate(format: Configuration.date) {
            startDate = DateFormatter.localizedString(from: start, dateStyle: .medium, timeStyle: .none)
        }
        if let end = disruption.applicationPeriods?.first?.end?.toDate(format: Configuration.date) {
            endDate = DateFormatter.localizedString(from: end, dateStyle: .medium, timeStyle: .none)
        }

        return String(format: "%@ %@ %@ %@ %@ : %@.",
                      title,
                      "from".localized(bundle: NavitiaSDKUI.shared.bundle),
                      startDate,
                      "to_period".localized(bundle: NavitiaSDKUI.shared.bundle),
                      endDate,
                      information)
    }
    
    func getDisruptionClean(section: Section, disruptions: [Disruption]?) -> [ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.DisruptionClean] {
        let disruptions = getDisruption(section: section, disruptions: disruptions)
        var disruptionsClean = [ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.DisruptionClean]()

        for (_, disruption) in disruptions.enumerated() {
            
            let disruptionClean = ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.DisruptionClean(color: disruption.severity?.color?.toUIColor() ?? UIColor.red,
                                                                                                       icon: Disruption.iconName(of: disruption.level),
                                                                                                       title: disruption.severity?.name ?? "",
                                                                                                       date: getDateDisruption(disruption: disruption),
                                                                                                       information: Disruption.message(disruption: disruption)?.text?.htmlToAttributedString?.string,
                                                                                                       accessibility: getAccessibilityDisruption(disruption: disruption))
            disruptionsClean.append(disruptionClean)
        }
        return disruptionsClean
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
    
    private func getDirectionPath(pathDirection: Int32?) -> String {
        guard let pathDirection = pathDirection else {
            return "arrow_right"
        }
        
        if pathDirection == 0 {
            return "arrow_straight"
        } else if pathDirection < 0 {
            return "arrow_left"
        } else {
            return "arrow_right"
        }
    }
    
    private func getDirectionInstruction(pathDirection: Int32, pathLength: Int32, pathInstruction: String) -> String {
        if pathDirection == 0 {
            return pathInstruction == "" ? String(format: "%@ %@", "carry_straight_on".localized(bundle: NavitiaSDKUI.shared.bundle), String(format: "for_meter".localized(bundle: NavitiaSDKUI.shared.bundle), pathLength)) : String(format: "%@ %@ %@", "continue_on".localized(bundle: NavitiaSDKUI.shared.bundle), pathInstruction, String(format: "for_meter".localized(bundle: NavitiaSDKUI.shared.bundle), pathLength))
        } else if pathDirection < 0 {
            return pathInstruction == "" ? String(format: "%@ %@", "turn_left".localized(bundle: NavitiaSDKUI.shared.bundle), String(format: "in_meter".localized(bundle: NavitiaSDKUI.shared.bundle), pathLength)) : String(format: "%@ %@ %@", "turn_left_on".localized(bundle: NavitiaSDKUI.shared.bundle), pathInstruction, String(format: "in_meter".localized(bundle: NavitiaSDKUI.shared.bundle), pathLength))
        } else {
            return pathInstruction == "" ? String(format: "%@ %@", "turn_right".localized(bundle: NavitiaSDKUI.shared.bundle), String(format: "in_meter".localized(bundle: NavitiaSDKUI.shared.bundle), pathLength)) : String(format: "%@ %@ %@", "turn_right_on".localized(bundle: NavitiaSDKUI.shared.bundle), pathInstruction, String(format: "in_meter".localized(bundle: NavitiaSDKUI.shared.bundle), pathLength))
        }
    }
    
    private func getPath(path: Path) -> ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.Path {
        let path = ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.Path(directionIcon: getDirectionPath(pathDirection: path.direction),
                                                                             instruction: getDirectionInstruction(pathDirection: path.direction ?? 0,
                                                                                                                  pathLength: path.length ?? 0,
                                                                                                                  pathInstruction: path.name ?? ""))
        
        return path
    }
    
    private func getPaths(section: Section) -> [ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.Path]? {
        var newPaths = [ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.Path]()
        
        guard let paths = section.path, let mode = section.mode else {
            return newPaths
        }
        
        if mode == .ridesharing || mode == .carnopark {
            return nil
        }
        
        for (_, path) in paths.enumerated() {
            let path = getPath(path: path)
            newPaths.append(path)
        }
        
        return newPaths
    }
}
