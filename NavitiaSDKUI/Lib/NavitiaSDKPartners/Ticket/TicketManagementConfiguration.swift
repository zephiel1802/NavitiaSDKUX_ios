//
//  TicketManagementConfiguration.swift
//  NavitiaSDKPartners
//
//  Created by Valentin COUSIEN on 09/05/2018.
//  Copyright © 2018 Kisio. All rights reserved.
//

import Foundation

@objc(TicketManagementConfiguration) public protocol TicketManagementConfiguration {
    
    var type : TicketManagementType { get }
}
