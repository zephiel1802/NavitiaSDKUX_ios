//
//  Section+Extension.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

extension Section {
    
    public func getNote(notes: [Note], id: String) -> Note? {
        for note in notes {
            if note.id == id {
                return note
            }
        }
        
        return nil
    }
    
    public func disruptions(disruptions: [Disruption]) -> [Disruption] {
        if disruptions.count > 0, let displayInformations = displayInformations, let displayInformationsLinks = displayInformations.links {
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
