//
//  NavitiaSDKUXConfig.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 23/03/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

open class NavitiaSDKUIConfig: NSObject {
    
    open static let shared = NavitiaSDKUIConfig()
    
    open var navitiaSDK: NavitiaSDK!
    var token: String!
    
    open func setToken(token: String) {
        self.token = token
        self.navitiaSDK = NavitiaSDK(configuration: NavitiaConfiguration(token: token))
    }
    
    open func getToken() -> String {
        return self.token
    }

}
