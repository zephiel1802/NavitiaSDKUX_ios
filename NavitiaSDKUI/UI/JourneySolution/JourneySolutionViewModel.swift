//
//  JourneySolutionViewModel.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 23/03/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class JourneySolutionViewModel: NSObject {

    var journeySolutionDidChange: ((JourneySolutionViewModel) -> ())?
    
  //  var journeys: [Journey] = []
    var journeySolutionModels: [JourneySolutionModel] = []
    var journeyRidesharingSolutionModels: [JourneySolutionModel] = []
    
    func request() {
        if NavitiaSDKUIConfig.shared.navitiaSDK != nil {
            NavitiaSDKUIConfig.shared.navitiaSDK.journeysApi.newJourneysRequestBuilder()
                .withFrom("2.38;48.84")
                .withTo("2.29;48.82")
                .get { (result, error) in
                    if let journeys = result?.journeys {
                      //  self.journeys = journeys
                        self.parseNavitia(journeys: journeys)
                        self.journeySolutionDidChange?(self)
                      //  print(journeys)
                    }
            }
        }
    }
    
    func parseNavitia(journeys: [Journey]) {
        for journey in journeys {
            let journeySolutionModel = JourneySolutionModel(journey: journey)
            if journeySolutionModel.distances.ridesharing != 0 {
                journeyRidesharingSolutionModels.append(journeySolutionModel)
            } else {
                journeySolutionModels.append(journeySolutionModel)
            }
        }
    }
    
}
