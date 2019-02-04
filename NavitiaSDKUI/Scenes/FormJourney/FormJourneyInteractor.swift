//
//  FormJourneyInteractor.swift
//  NavitiaSDKUI
//
//  Copyright © 2019 kisio. All rights reserved.
//

import UIKit

protocol FormJourneyBusinessLogic {
    
}

protocol FormJourneyDataStore {
    var from: (name: String?, id: String)? { get set }
    var to: (name: String?, id: String)? { get set }
}

class FormJourneyInteractor: FormJourneyBusinessLogic, FormJourneyDataStore {
    var presenter: FormJourneyPresentationLogic?
    
    var from: (name: String?, id: String)?
    var to: (name: String?, id: String)?
}
