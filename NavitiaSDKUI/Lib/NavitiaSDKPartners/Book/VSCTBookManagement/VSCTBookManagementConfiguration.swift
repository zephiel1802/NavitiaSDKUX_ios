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
    
    public let url: String = ( NavitiaSDKPartners.shared.environment == .Preprod ? "https://preprod1.vad.vad.keolis.vsct.fr/api/rs/" : "https://vad.keolis.com/api/rs/" )
    public let baseUrl : String = ( NavitiaSDKPartners.shared.environment == .Preprod ? "https://preprod1.vad.vad.keolis.vsct.fr" : "https://vad.keolis.com" )
    
    public var network: String
    
    public init(network : String) {
        
        self.network = network
    }
    
}
