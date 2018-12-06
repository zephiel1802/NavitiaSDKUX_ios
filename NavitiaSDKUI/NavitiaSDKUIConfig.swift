//
//  NavitiaSDKUXConfig.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

@objc open class NavitiaSDKUI: NSObject {
    
    @objc public static let shared = NavitiaSDKUI()
    
    open var navitiaSDK: NavitiaSDK!
    open var bundle: Bundle!
    
    private var token: String! {
        didSet {
            self.navitiaSDK = NavitiaSDK(configuration: NavitiaConfiguration(token: token))
        }
    }
    
    @objc public func initialize(token: String) {
        self.token = token
    }
    
    @objc public var mainColor: UIColor {
        get {
            return Configuration.Color.main
        }
        set {
            Configuration.Color.main = newValue
        }
    }
    
    @objc public var originColor: UIColor {
        get {
            return Configuration.Color.origin
        }
        set {
            Configuration.Color.origin = newValue
        }
    }
    
    @objc public var destinationColor: UIColor {
        get {
            return Configuration.Color.destination
        }
        set {
            Configuration.Color.destination = newValue
        }
    }
    
    @objc public var multiNetwork: Bool {
        get {
            return Configuration.multiNetwork
        }
        set {
            Configuration.multiNetwork = newValue
        }
    }
}

enum Configuration {
    
    static let fontIconsName = "SDKIcons"
    
    // Format
    static let date = "yyyyMMdd'T'HHmmss"
    static let dateInterval = "dd/MM/yy"
    static let time = "HH:mm"
    static let timeJourneySolution = "EEE dd MMM - HH:mm"
    static let timeRidesharing = "HH'h'mm"
    
    // TimeInterval
    static let parkTimeInterval = TimeInterval(30)
    static let bssTimeInterval = TimeInterval(30)
    static let approvalTimeThreshold = TimeInterval(7200)
    
    // Constant
    static let caloriePerSecWalking = 0.071625714285714
    static let caloriePerSecBike = 0.11442857142857142
    static let minWalkingValueFrieze = 180 
    
    static var multiNetwork = false
    
    // Color
    enum Color {
        static var main = #colorLiteral(red: 0.2509803922, green: 0.5843137255, blue: 0.5568627451, alpha: 1)
        static var origin = #colorLiteral(red: 0, green: 0.7333333333, blue: 0.4588235294, alpha: 1)
        static var destination = #colorLiteral(red: 0.6901960784, green: 0.01176470588, blue: 0.3254901961, alpha: 1)
        static var dialogBackground = main.withAlphaComponent(0.5)
        static var markerTitle = main.withAlphaComponent(0.73)
        static var disruptionBloking = #colorLiteral(red: 0.662745098, green: 0.2666666667, blue: 0.2588235294, alpha: 1)
        static var disruptionInformation = #colorLiteral(red: 0.1921568627, green: 0.4392156863, blue: 0.5607843137, alpha: 1)
        static var disruptionNonBloking = #colorLiteral(red: 0.5411764706, green: 0.4274509804, blue: 0.231372549, alpha: 1)
        static var alertView = #colorLiteral(red: 0.8470588235, green: 0.9294117647, blue: 0.968627451, alpha: 1)
        static var alertInfoDarker = #colorLiteral(red: 0.1882352941, green: 0.4392156863, blue: 0.5568627451, alpha: 1)
        static var alertSuccess = #colorLiteral(red: 0.8666666667, green: 0.937254902, blue: 0.8470588235, alpha: 1)
        static var alertSuccessDarker = #colorLiteral(red: 0.2392156863, green: 0.4588235294, blue: 0.2392156863, alpha: 1)
        static var alertWarning = #colorLiteral(red: 0.9882352941, green: 0.968627451, blue: 0.8862745098, alpha: 1)
        static var alertWarningDarker = #colorLiteral(red: 0.537254902, green: 0.4274509804, blue: 0.2274509804, alpha: 1)
        static var alertError = #colorLiteral(red: 0.9490196078, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
        static var alertErrorDarker = #colorLiteral(red: 0.6588235294, green: 0.2666666667, blue: 0.2588235294, alpha: 1)
        static var white = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        static var black = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        static var gray = #colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1)
        static var darkerGray = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        static let red = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        static let orange = #colorLiteral(red: 0.9725490196, green: 0.5803921569, blue: 0.02352941176, alpha: 1)
        static let background = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
        static let headerTitle = #colorLiteral(red: 0.2509803922, green: 0.2509803922, blue: 0.2509803922, alpha: 1)
    }
}
