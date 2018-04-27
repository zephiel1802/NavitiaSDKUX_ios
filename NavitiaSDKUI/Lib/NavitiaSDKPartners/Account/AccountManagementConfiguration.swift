//
//  NavitiaSDKPartnersAccountConfiguration.swift
//  NavitiaSDKPartners
//
//  Created by Valentin COUSIEN on 23/03/2018.
//  Copyright © 2018 Kisio. All rights reserved.
//

import Foundation

@objc(AccountManagementConfiguration) public protocol AccountManagementConfiguration {
    
    var type : AccountManagementType { get }
    var url : String { get }
}
