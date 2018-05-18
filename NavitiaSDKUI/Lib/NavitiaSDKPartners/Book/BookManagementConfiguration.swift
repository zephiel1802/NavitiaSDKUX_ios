//
//  BookManagementConfiguration.swift
//  NavitiaSDKPartners
//
//  Created by Valentin COUSIEN on 18/04/2018.
//  Copyright © 2018 Kisio. All rights reserved.
//

import Foundation

@objc(BookManagementConfiguration) public protocol BookManagementConfiguration {
    
    var type : BookManagementType { get }
    var url : String { get }
}
