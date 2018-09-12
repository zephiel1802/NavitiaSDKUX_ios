//
//  JourneyRoadmapPresenter.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

protocol JourneyRoadmapPresentationLogic {
    
    func presentRoadmap(response: JourneyRoadmap.GetRoadmap.Response)
    func presentMap(response: JourneyRoadmap.GetMap.Response)
}

class JourneyRoadmapPresenter: JourneyRoadmapPresentationLogic {
    
    weak var viewController: JourneyRoadmapDisplayLogic?
  
  // MARK: Do something
    func presentRoadmap(response: JourneyRoadmap.GetRoadmap.Response) {
        var departure: JourneyRoadmap.GetRoadmap.ViewModel.DepartureArrival
        var arrival: JourneyRoadmap.GetRoadmap.ViewModel.DepartureArrival
        
        departure = JourneyRoadmap.GetRoadmap.ViewModel.DepartureArrival(mode: .departure,
                                                                         information: response.journey.sections?.first?.from?.name ?? "",
                                                                         time: response.journey.departureDateTime?.toDate(format: Configuration.date)?.toString(format: Configuration.time) ?? "",
                                                                         calorie: nil)
        
        arrival = JourneyRoadmap.GetRoadmap.ViewModel.DepartureArrival(mode: .arrival,
                                                                         information: response.journey.sections?.last?.to?.name ?? "",
                                                                         time: response.journey.arrivalDateTime?.toDate(format: Configuration.date)?.toString(format: Configuration.time) ?? "",
                                                                         calorie: "232")
        // String(format: "%d", Int((Double(walkingDistance) * Configuration.caloriePerSecWalking + Double(bikeDistance) * Configuration.caloriePerSecBike).rounded()))
        
        var viewModelSections: [JourneyRoadmap.GetRoadmap.ViewModel.Section] = []
        
        
        
        if let sections = response.journey.sections {

            for (index, section) in sections.enumerated() {
                
                let type = JourneyRoadmap.GetRoadmap.ViewModel.Section.ModelType.init(rawValue: (section.type?.rawValue)!)!
                
                var mode: JourneyRoadmap.GetRoadmap.ViewModel.Section.Mode?
                if let sectionMode = section.mode?.rawValue {
                    mode = JourneyRoadmap.GetRoadmap.ViewModel.Section.Mode.init(rawValue: sectionMode)!
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
                
                let path = section.path
                
                let stopDate = getStopDate(section: section)
                
                var waiting: String?
                if sections[safe: index - 1]?.type == .waiting {
                    waiting = sections[safe: index - 1]?.duration?.minuteToString()
                }

                let disruptions = getDisruption(section: section, disruptions: response.disruptions)
                
                let poi = section.from?.poi ?? section.to?.poi
  
                let icon = Modes().getModeIcon(section: section)
                
                let displayInformations = JourneyRoadmap.GetRoadmap.ViewModel.DisplayInformations(commercialMode: section.displayInformations?.commercialMode ?? "",
                                                                                                  color: section.displayInformations?.color?.toUIColor() ?? UIColor.black,
                                                                                                  directionTransit: section.displayInformations?.direction ?? "",
                                                                                                  code: transportCode)
                
                let viewModelSection = JourneyRoadmap.GetRoadmap.ViewModel.Section(type: type,
                                                                                   mode: mode,
                                                                                   from: from,
                                                                                   to: to,
                                                                                   startTime: startTime,
                                                                                   endTime: endTime,
                                                                                   time: time,
                                                                                   path: path,
                                                                                   stopDate: stopDate,
                                                                                   displayInformations: displayInformations,
                                                                                   waiting: waiting,
                                                                                   disruptions: disruptions,
                                                                                   poi: poi,
                                                                                   icon: icon)
        
                viewModelSections.append(viewModelSection)
            }
        }

        let viewModel = JourneyRoadmap.GetRoadmap.ViewModel(departure: departure, arrival: arrival, emission: JourneyRoadmap.GetRoadmap.ViewModel.Emission(journeyValue: (response.journey.co2Emission?.value!)!), sections: viewModelSections, disruptions: response.disruptions, journey: response.journey)
        viewController?.displaySomething(viewModel: viewModel)
    }
    
    func presentMap(response: JourneyRoadmap.GetMap.Response) {
        let viewModel = JourneyRoadmap.GetMap.ViewModel(journey: response.journey)
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
}


