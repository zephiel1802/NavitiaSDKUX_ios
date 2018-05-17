//
//  VSCTBookManagementConfiguration.swift
//  NavitiaSDKPartners
//
//  Created by Valentin COUSIEN on 18/04/2018.
//  Copyright © 2018 Kisio. All rights reserved.
//

import Foundation

@objc(VSCTBookManagementConfiguration) public class VSCTBookManagementConfiguration : NSObject, BookManagementConfiguration {
    
    public let type: BookManagementType = .VSCT
    public let url: String = "https://preprod1.vad.vad.keolis.vsct.fr/api/rs/"
    public let baseUrl : String = "https://preprod1.vad.vad.keolis.vsct.fr"
    public var network: String
    
    public init(network : String) {
        
        self.network = network
    }
    
}
