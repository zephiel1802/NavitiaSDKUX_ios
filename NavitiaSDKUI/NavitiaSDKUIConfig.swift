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
    open var color = ColorConfiguration()
    
    open var navitiaSDK: NavitiaSDK!
    open var token: String!
    
    open func setToken(token: String) {
        self.token = token
        self.navitiaSDK = NavitiaSDK(configuration: NavitiaConfiguration(token: token))
    }
    
    open func getToken() -> String {
        return self.token
    }

}

public struct ColorConfiguration {
    public var primary = UIColor(red:0.40, green:0.40, blue:0.40, alpha:1.0) {
        didSet {
            self.primaryText = contrastColor(color: self.primary, brightColor: self.brightText, darkColor: self.darkText)
        }
    }
    var primaryText = UIColor.white
    public var secondary = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.0) {
        didSet {
            self.secondaryText = contrastColor(color: self.secondary, brightColor: self.brightText, darkColor: self.darkText)
        }
    }
    var secondaryText = UIColor.white
    public var tertiary = UIColor(red:0.25, green:0.58, blue:0.56, alpha:1.0) {
        didSet {
            self.tertiaryText = contrastColor(color: self.tertiary, brightColor: self.brightText, darkColor: self.darkText)
        }
    }
    var tertiaryText = UIColor.white
    public var brightText = UIColor.white
    public var darkText = UIColor.black
    let white = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    let lighterGray = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.0)
    let lightGray = UIColor(red:0.80, green:0.80, blue:0.80, alpha:1.0)
    let gray = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
    let darkGray = UIColor(red:0.25, green:0.25, blue:0.25, alpha:1.0)
    let darkerGray = UIColor(red:0.12, green:0.12, blue:0.12, alpha:1.0)
    public var origin = UIColor(red:0, green:0.73, blue:0.46, alpha:1.0)
    public var destination = UIColor(red:0.69, green:0.01, blue:0.33, alpha:1.0)
    public var ridesharingSeparatorColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1.0)
    let orange = UIColor(red:0.97, green:0.58, blue:0.02, alpha:1.0)
}
