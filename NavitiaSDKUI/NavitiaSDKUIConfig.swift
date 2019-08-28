//
//  NavitiaSDKUXConfig.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//
import UIKit
import Foundation

@objc public protocol JourneyRootViewController {
    
    var journeysRequest: JourneysRequest? { get set }
}

@objc public class NavitiaSDKUI: NSObject {
    
    @objc public static let shared = NavitiaSDKUI()
    
    open var navitiaSDK: NavitiaSDK!
    open var bundle: Bundle! {
        didSet {
            UIFont.registerFontWithFilenameString(filenameString: "SDKIcons.ttf", bundle: NavitiaSDKUI.shared.bundle)
        }
    }
    
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
    
    @objc public var secondaryColor: UIColor {
        get {
            return Configuration.Color.secondary
        }
        set {
            Configuration.Color.secondary = newValue
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
    
    @objc public var maxHistory: Int {
        get {
            return Configuration.maxHistory
        }
        set {
            Configuration.maxHistory = newValue
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
    
    @objc public var formJourney: Bool {
        get {
            return Configuration.formJourney
        }
        set {
            Configuration.formJourney = newValue
        }
    }
    
    @objc public var modeForm: [ModeButtonModel] {
        get {
            return Configuration.modeForm
        }
        set {
            Configuration.modeForm = newValue
        }
    }
    
    @objc public var pictos: [String:UIImage] {
        get {
            return Configuration.pictos
        }
    }
    
    public var titlesConfig: TitlesConfig? {
        get {
            return Configuration.titlesConfig
        }
        set {
            Configuration.titlesConfig = newValue
        }
    }
    
    @objc public var rootViewController: JourneyRootViewController? {
        get {
            let storyboard = UIStoryboard(name: "Journey", bundle: bundle)
            
            if Configuration.formJourney {
                return storyboard.instantiateViewController(withIdentifier: "FormJourneyViewController") as? JourneyRootViewController
            }
            
            return storyboard.instantiateViewController(withIdentifier: "ListJourneysViewController") as? JourneyRootViewController
        }
    }
    
    @objc open func addCustomizedTransportMode(name: String, icon: UIImage) {
        Configuration.pictos[name] = icon.withRenderingMode(.alwaysTemplate)
    }
    
    @objc open func addCustomizedPicto(bikeImage: UIImage? = nil,
                                       busImage: UIImage? = nil,
                                       carImage: UIImage? = nil,
                                       taxiImage: UIImage? = nil,
                                       trainImage: UIImage? = nil,
                                       metroImage: UIImage? = nil,
                                       originImage: UIImage? = nil,
                                       destinationImage: UIImage? = nil) {
        // optional mode picto
        if let bikeImage = bikeImage {
            Configuration.pictos["bike"] = bikeImage.withRenderingMode(.alwaysTemplate)
        }
        if let busImage = busImage {
            Configuration.pictos["bus"] = busImage.withRenderingMode(.alwaysTemplate)
        }
        if let carImage = carImage {
            Configuration.pictos["car"] = carImage.withRenderingMode(.alwaysTemplate)
        }
        if let taxiImage = taxiImage {
            Configuration.pictos["taxi"] = taxiImage.withRenderingMode(.alwaysTemplate)
        }
        if let trainImage = trainImage {
            Configuration.pictos["train"] = trainImage.withRenderingMode(.alwaysTemplate)
        }
        if let metroImage = metroImage {
            Configuration.pictos["metro"] = metroImage.withRenderingMode(.alwaysTemplate)
        }
        
        // Origin and destination picto
        Configuration.pictos["origin"] = originImage ?? UIImage(named: "departure_color",
                                                                in: NavitiaSDKUI.shared.bundle,
                                                                compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        
        Configuration.pictos["destination"] = destinationImage ?? UIImage(named: "arrival_color",
                                                                          in: NavitiaSDKUI.shared.bundle,
                                                                          compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }
}

enum Configuration {
    
    static let fontIconsName = "SDKIcons"
    static var modeForm = [ModeButtonModel(title: "public_transport".localized().capitalized, type: "metro",
                                           selected: true, firstSectionMode: ["walking"],
                                           lastSectionMode: ["walking"], physicalMode: nil),
                           ModeButtonModel(title: "bike_noun".localized().capitalized, type: "bike",
                                           selected: false, firstSectionMode: ["bike"],
                                           lastSectionMode: ["bike"], physicalMode: nil),
                           ModeButtonModel(title: "car_noun".localized().capitalized, type: "car",
                                           selected: false, firstSectionMode: ["car"],
                                           lastSectionMode: ["car"], physicalMode: nil)]
    static var titlesConfig: TitlesConfig?
    
    // Format
    static let datetime = "yyyyMMdd'T'HHmmss"
    static let dateInterval = "dd/MM/yy"
    static let time = "HH:mm"
    static let timeFormJourney = "EEEE d MMMM '-' HH:mm"
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
    static var maxHistory = 10
    
    static var multiNetwork = false
    static var formJourney = false
    
    static var pictos: [String:UIImage] = [:]
    
    // Color
    enum Color {
        static var main = #colorLiteral(red: 0.2509803922, green: 0.5843137255, blue: 0.5568627451, alpha: 1)
        static var secondary = #colorLiteral(red: 0.2509803922, green: 0.5843137255, blue: 0.5568627451, alpha: 1)
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
        static let shadow = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        static let headerTitle = #colorLiteral(red: 0.2509803922, green: 0.2509803922, blue: 0.2509803922, alpha: 1)
    }
}

public class GenerateRequest: NSObject {
    
    public enum ModeType: String {
        case bike = "bike"
        case bss = "bss"
        case car = "car"
        case ridesharing = "ridesharing"
        case walking = "walking"
    }
    
    public struct ModeForm {
        var title: String
        var icon: String
        var selected: Bool
        var mode: ModeType
        var physicalMode: [String]?
    }
    
    var modeForm = [ModeForm]()
    
    public init(modeForm: [ModeForm]) {
        self.modeForm = modeForm
    }

    internal func getPhysicalModes() -> [String]? {
        var physicalMode = [String]()

        for mode in modeForm {
            if let physiMode = mode.physicalMode {
                physicalMode += physiMode
            }
        }

        if physicalMode.count == 0 {
            return nil
        }

        return physicalMode
    }
}

public struct TitlesConfig: Decodable {
    
    var formTitle: String?
    var journeysTitle: String?
    var roadmapTitle: String?
    var ridesharingOffersTitle: String?
    var autocompleteTitle: String?
    
    public init(formTitle: String?,
                journeysTitle: String?,
                roadmapTitle: String?,
                ridesharingOffersTitle: String?,
                autocompleteTitle: String?) {
        self.formTitle = formTitle
        self.journeysTitle = journeysTitle
        self.roadmapTitle = roadmapTitle
        self.ridesharingOffersTitle = ridesharingOffersTitle
        self.autocompleteTitle = autocompleteTitle
    }
    
    enum CodingKeys: String, CodingKey {
        case formTitle = "form"
        case journeysTitle = "journeys"
        case roadmapTitle = "roadmap"
        case ridesharingOffersTitle = "ridesharing"
        case autocompleteTitle = "autocomplete"
    }
}
