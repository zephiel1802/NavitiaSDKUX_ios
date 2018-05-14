//
//  JourneySolutionRidesharingViewModel.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class JourneySolutionRidesharingViewModel: NSObject {

    var journey: Journey? {
        didSet {
            self.journeySolutionRidesharingDidChange?(self)
        }
    }
    var ridesharingJourneys: [Journey]?
    
    var journeySolutionRidesharingDidChange: ((JourneySolutionRidesharingViewModel) -> ())?
    
}
