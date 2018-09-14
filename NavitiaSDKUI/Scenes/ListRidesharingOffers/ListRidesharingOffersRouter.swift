//
//  ListRidesharingOffersRouter.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

protocol ListRidesharingOffersRoutingLogic {
    
}

protocol ListRidesharingOffersDataPassing {
    
    var dataStore: ListRidesharingOffersDataStore? { get }
}

class ListRidesharingOffersRouter: NSObject, ListRidesharingOffersRoutingLogic, ListRidesharingOffersDataPassing {
    
    weak var viewController: ListRidesharingOffersViewController?
    var dataStore: ListRidesharingOffersDataStore?
}
