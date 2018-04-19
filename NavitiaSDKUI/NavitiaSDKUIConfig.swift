//
//  NavitiaSDKUXConfig.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

open class NavitiaSDKUIConfig: NSObject {
    
    open static let shared = NavitiaSDKUIConfig()
    
    open var navitiaSDK: NavitiaSDK!
    open var bundle: Bundle!
    
    private var token: String! {
        didSet {
            self.navitiaSDK = NavitiaSDK(configuration: NavitiaConfiguration(token: token))
        }
    }
    
    public func setToken(token: String) {
        self.token = token
    }

}

enum Configuration {
    
    static let fontIconsName = "SDKIcons"
    
    // Format
    static let date = "yyyyMMdd'T'HHmmss"
    static let time = "HH:mm"
    static let timeJourneySolution = "EEE dd MMM - HH:mm"
    static let timeRidesharing = "HH'h'mm"
    
    // Color
    enum Color {
        static var tertiary = UIColor(red:0.25, green:0.58, blue:0.56, alpha:1.0)
        static var origin = UIColor(red:0, green:0.73, blue:0.46, alpha:1.0)
        static var destination = UIColor(red:0.69, green:0.01, blue:0.33, alpha:1.0)
        static let orange = UIColor(red:0.97, green:0.58, blue:0.02, alpha:1.0)
        static let gray = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
    }
    
}
