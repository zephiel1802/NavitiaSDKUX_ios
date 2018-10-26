//
//  Seeds.swift
//  NavitiaSDKUITests
//
//  Copyright © 2018 kisio. All rights reserved.
//

import XCTest
@testable import NavitiaSDKUI

class Seeds {
    
    var navitiaResponse: Journeys?
    var journeys: [Journey]?
    var ridesharing: [Journey]?
    var disruptions: [Disruption]?
    var notes: [Note]?
    var context: Context?
    
    init() {
        navitiaResponse = fetchJourneyWithJSON()
    }
    
    private func fetchJourneyWithJSON() -> Journeys? {
        do {
            let bundle = Bundle(for: type(of: self))
            guard let url = bundle.url(forResource: "Journey", withExtension: "json") else {
                XCTFail("Missing file: Journey.json")
                return nil
            }
            
            let json = try Data(contentsOf: url)
            guard let jsonString = String(data: json, encoding: .utf8) else {
                XCTFail("Missing file: Journey.json")
                return nil
            }
            
            let journeys = Mapper<Journeys>().map(JSONString: jsonString)
            
            parseJourneyResponse(result: journeys)
            return journeys
        } catch {
            return nil
        }
    }
    
    private func parseJourneyResponse(result: Journeys?) {
        if let result = result {
            var journeys: [Journey] = []
            var ridesharing: [Journey] = []
            
            if let allJourneys = result.journeys {
                for journey in allJourneys {
                    if journey.isRidesharing {
                        ridesharing.append(journey)
                    } else {
                        journeys.append(journey)
                    }
                }
            }
            
            self.journeys = journeys
            self.ridesharing = ridesharing
            self.disruptions = result.disruptions
            self.notes = result.notes
            self.context = result.context
        }
    }
}
