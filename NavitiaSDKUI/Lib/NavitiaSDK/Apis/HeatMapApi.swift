//
// HeatMapApi.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation

open class CoverageLonLatHeatMapsRequestBuilder: NSObject {
    let currentApi: HeatMapApi

    /**
    * enum for parameter datetimeRepresents
    */
    public enum DatetimeRepresents: String { 
        case arrival = "arrival"
        case departure = "departure"
    }
    /**
    * enum for parameter firstSectionMode
    */
    public enum FirstSectionMode: String { 
        case walking = "walking"
        case car = "car"
        case bike = "bike"
        case bss = "bss"
        case ridesharing = "ridesharing"
    }
    /**
    * enum for parameter lastSectionMode
    */
    public enum LastSectionMode: String { 
        case walking = "walking"
        case car = "car"
        case bike = "bike"
        case bss = "bss"
        case ridesharing = "ridesharing"
    }
    /**
    * enum for parameter dataFreshness
    */
    public enum DataFreshness: String { 
        case baseSchedule = "base_schedule"
        case adaptedSchedule = "adapted_schedule"
        case realtime = "realtime"
    }
    /**
    * enum for parameter travelerType
    */
    public enum TravelerType: String { 
        case cyclist = "cyclist"
        case luggage = "luggage"
        case wheelchair = "wheelchair"
        case standard = "standard"
        case motorist = "motorist"
        case fastWalker = "fast_walker"
        case slowWalker = "slow_walker"
    }
    /**
    * enum for parameter directPath
    */
    public enum DirectPath: String { 
        case indifferent = "indifferent"
        case only = "only"
        case _none = "none"
    }
    var lat:Double? = nil
    var lon:Double? = nil
    var from:String? = nil
    var to:String? = nil
    var datetime:Date? = nil
    var datetimeRepresents: DatetimeRepresents? = nil
    var maxNbTransfers:Int32? = nil
    var minNbTransfers:Int32? = nil
    var firstSectionMode: [String]? = nil
    var lastSectionMode: [String]? = nil
    var maxDurationToPt:Int32? = nil
    var maxWalkingDurationToPt:Int32? = nil
    var maxBikeDurationToPt:Int32? = nil
    var maxBssDurationToPt:Int32? = nil
    var maxCarDurationToPt:Int32? = nil
    var maxRidesharingDurationToPt:Int32? = nil
    var walkingSpeed:Float? = nil
    var bikeSpeed:Float? = nil
    var bssSpeed:Float? = nil
    var carSpeed:Float? = nil
    var ridesharingSpeed:Float? = nil
    var forbiddenUris:[String]? = nil
    var allowedId:[String]? = nil
    var disruptionActive:Bool? = nil
    var dataFreshness: DataFreshness? = nil
    var maxDuration:Int32? = nil
    var wheelchair:Bool? = nil
    var travelerType: TravelerType? = nil
    var directPath: DirectPath? = nil
    var freeRadiusFrom:Int32? = nil
    var freeRadiusTo:Int32? = nil
    var resolution:Int32? = nil
    var debugURL: String? = nil

    public init(currentApi: HeatMapApi) {
        self.currentApi = currentApi
    }

    open func withLat(_ lat: Double?) -> CoverageLonLatHeatMapsRequestBuilder {
        self.lat = lat
        
        return self
    }
    open func withLon(_ lon: Double?) -> CoverageLonLatHeatMapsRequestBuilder {
        self.lon = lon
        
        return self
    }
    open func withFrom(_ from: String?) -> CoverageLonLatHeatMapsRequestBuilder {
        self.from = from
        
        return self
    }
    open func withTo(_ to: String?) -> CoverageLonLatHeatMapsRequestBuilder {
        self.to = to
        
        return self
    }
    open func withDatetime(_ datetime: Date?) -> CoverageLonLatHeatMapsRequestBuilder {
        self.datetime = datetime
        
        return self
    }
    open func withDatetimeRepresents(_ datetimeRepresents: DatetimeRepresents?) -> CoverageLonLatHeatMapsRequestBuilder {
        self.datetimeRepresents = datetimeRepresents

        return self
    }
    open func withMaxNbTransfers(_ maxNbTransfers: Int32?) -> CoverageLonLatHeatMapsRequestBuilder {
        self.maxNbTransfers = maxNbTransfers
        
        return self
    }
    open func withMinNbTransfers(_ minNbTransfers: Int32?) -> CoverageLonLatHeatMapsRequestBuilder {
        self.minNbTransfers = minNbTransfers
        
        return self
    }
    open func withFirstSectionMode(_ firstSectionMode: [FirstSectionMode]?) -> CoverageLonLatHeatMapsRequestBuilder {
        guard let firstSectionMode = firstSectionMode else {
            return self
        }
        
        var items = [String]()
        for item in firstSectionMode {
            items.append(item.rawValue)
        }
        self.firstSectionMode = items

        return self
    }
    open func withLastSectionMode(_ lastSectionMode: [LastSectionMode]?) -> CoverageLonLatHeatMapsRequestBuilder {
        guard let lastSectionMode = lastSectionMode else {
            return self
        }
        
        var items = [String]()
        for item in lastSectionMode {
            items.append(item.rawValue)
        }
        self.lastSectionMode = items

        return self
    }
    open func withMaxDurationToPt(_ maxDurationToPt: Int32?) -> CoverageLonLatHeatMapsRequestBuilder {
        self.maxDurationToPt = maxDurationToPt
        
        return self
    }
    open func withMaxWalkingDurationToPt(_ maxWalkingDurationToPt: Int32?) -> CoverageLonLatHeatMapsRequestBuilder {
        self.maxWalkingDurationToPt = maxWalkingDurationToPt
        
        return self
    }
    open func withMaxBikeDurationToPt(_ maxBikeDurationToPt: Int32?) -> CoverageLonLatHeatMapsRequestBuilder {
        self.maxBikeDurationToPt = maxBikeDurationToPt
        
        return self
    }
    open func withMaxBssDurationToPt(_ maxBssDurationToPt: Int32?) -> CoverageLonLatHeatMapsRequestBuilder {
        self.maxBssDurationToPt = maxBssDurationToPt
        
        return self
    }
    open func withMaxCarDurationToPt(_ maxCarDurationToPt: Int32?) -> CoverageLonLatHeatMapsRequestBuilder {
        self.maxCarDurationToPt = maxCarDurationToPt
        
        return self
    }
    open func withMaxRidesharingDurationToPt(_ maxRidesharingDurationToPt: Int32?) -> CoverageLonLatHeatMapsRequestBuilder {
        self.maxRidesharingDurationToPt = maxRidesharingDurationToPt
        
        return self
    }
    open func withWalkingSpeed(_ walkingSpeed: Float?) -> CoverageLonLatHeatMapsRequestBuilder {
        self.walkingSpeed = walkingSpeed
        
        return self
    }
    open func withBikeSpeed(_ bikeSpeed: Float?) -> CoverageLonLatHeatMapsRequestBuilder {
        self.bikeSpeed = bikeSpeed
        
        return self
    }
    open func withBssSpeed(_ bssSpeed: Float?) -> CoverageLonLatHeatMapsRequestBuilder {
        self.bssSpeed = bssSpeed
        
        return self
    }
    open func withCarSpeed(_ carSpeed: Float?) -> CoverageLonLatHeatMapsRequestBuilder {
        self.carSpeed = carSpeed
        
        return self
    }
    open func withRidesharingSpeed(_ ridesharingSpeed: Float?) -> CoverageLonLatHeatMapsRequestBuilder {
        self.ridesharingSpeed = ridesharingSpeed
        
        return self
    }
    open func withForbiddenUris(_ forbiddenUris: [String]?) -> CoverageLonLatHeatMapsRequestBuilder {
        self.forbiddenUris = forbiddenUris
        
        return self
    }
    open func withAllowedId(_ allowedId: [String]?) -> CoverageLonLatHeatMapsRequestBuilder {
        self.allowedId = allowedId
        
        return self
    }
    open func withDisruptionActive(_ disruptionActive: Bool?) -> CoverageLonLatHeatMapsRequestBuilder {
        self.disruptionActive = disruptionActive
        
        return self
    }
    open func withDataFreshness(_ dataFreshness: DataFreshness?) -> CoverageLonLatHeatMapsRequestBuilder {
        self.dataFreshness = dataFreshness

        return self
    }
    open func withMaxDuration(_ maxDuration: Int32?) -> CoverageLonLatHeatMapsRequestBuilder {
        self.maxDuration = maxDuration
        
        return self
    }
    open func withWheelchair(_ wheelchair: Bool?) -> CoverageLonLatHeatMapsRequestBuilder {
        self.wheelchair = wheelchair
        
        return self
    }
    open func withTravelerType(_ travelerType: TravelerType?) -> CoverageLonLatHeatMapsRequestBuilder {
        self.travelerType = travelerType

        return self
    }
    open func withDirectPath(_ directPath: DirectPath?) -> CoverageLonLatHeatMapsRequestBuilder {
        self.directPath = directPath

        return self
    }
    open func withFreeRadiusFrom(_ freeRadiusFrom: Int32?) -> CoverageLonLatHeatMapsRequestBuilder {
        self.freeRadiusFrom = freeRadiusFrom
        
        return self
    }
    open func withFreeRadiusTo(_ freeRadiusTo: Int32?) -> CoverageLonLatHeatMapsRequestBuilder {
        self.freeRadiusTo = freeRadiusTo
        
        return self
    }
    open func withResolution(_ resolution: Int32?) -> CoverageLonLatHeatMapsRequestBuilder {
        self.resolution = resolution
        
        return self
    }



    open func withDebugURL(_ debugURL: String?) -> CoverageLonLatHeatMapsRequestBuilder {
        self.debugURL = debugURL
        return self
    }

    open func makeUrl() -> String {
        var path = "/coverage/{lon};{lat}/heat_maps"

        if let lat = lat {
            let latPreEscape: String = "\(lat)"
            let latPostEscape: String = latPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
            path = path.replacingOccurrences(of: "{lat}", with: latPostEscape, options: .literal, range: nil)
        }

        if let lon = lon {
            let lonPreEscape: String = "\(lon)"
            let lonPostEscape: String = lonPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
            path = path.replacingOccurrences(of: "{lon}", with: lonPostEscape, options: .literal, range: nil)
        }

        let URLString = String(format: "%@%@", NavitiaSDKAPI.basePath, path)
        let url = NSURLComponents(string: URLString)

        let paramValues: [String: Any?] = [
            "from": self.from, 
            "to": self.to, 
            "datetime": self.datetime?.encodeToJSON(), 
            "datetime_represents": self.datetimeRepresents?.rawValue, 
            "max_nb_transfers": self.maxNbTransfers?.encodeToJSON(), 
            "min_nb_transfers": self.minNbTransfers?.encodeToJSON(), 
            "first_section_mode[]": self.firstSectionMode, 
            "last_section_mode[]": self.lastSectionMode, 
            "max_duration_to_pt": self.maxDurationToPt?.encodeToJSON(), 
            "max_walking_duration_to_pt": self.maxWalkingDurationToPt?.encodeToJSON(), 
            "max_bike_duration_to_pt": self.maxBikeDurationToPt?.encodeToJSON(), 
            "max_bss_duration_to_pt": self.maxBssDurationToPt?.encodeToJSON(), 
            "max_car_duration_to_pt": self.maxCarDurationToPt?.encodeToJSON(), 
            "max_ridesharing_duration_to_pt": self.maxRidesharingDurationToPt?.encodeToJSON(), 
            "walking_speed": self.walkingSpeed, 
            "bike_speed": self.bikeSpeed, 
            "bss_speed": self.bssSpeed, 
            "car_speed": self.carSpeed, 
            "ridesharing_speed": self.ridesharingSpeed, 
            "forbidden_uris[]": self.forbiddenUris, 
            "allowed_id[]": self.allowedId, 
            "disruption_active": self.disruptionActive, 
            "data_freshness": self.dataFreshness?.rawValue, 
            "max_duration": self.maxDuration?.encodeToJSON(), 
            "wheelchair": self.wheelchair, 
            "traveler_type": self.travelerType?.rawValue, 
            "direct_path": self.directPath?.rawValue, 
            "free_radius_from": self.freeRadiusFrom?.encodeToJSON(), 
            "free_radius_to": self.freeRadiusTo?.encodeToJSON(), 
            "resolution": self.resolution?.encodeToJSON()
        ]
        url?.queryItems = APIHelper.mapValuesToQueryItems(values: paramValues)
        url?.percentEncodedQuery = url?.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")

        return (debugURL ?? url?.string ?? URLString)
    }

    open func get(completion: @escaping ((_ data: HeatMap1?,_ error: Error?) -> Void)) {
        if (self.lat == nil) {
            completion(nil, ErrorResponse.Error(500, nil, NSError(domain: "localhost", code: 500, userInfo: ["reason": "Missing mandatory argument : lat"])))
        }
        if (self.lon == nil) {
            completion(nil, ErrorResponse.Error(500, nil, NSError(domain: "localhost", code: 500, userInfo: ["reason": "Missing mandatory argument : lon"])))
        }

        request(self.makeUrl())
            .authenticate(user: currentApi.token, password: "")
            .validate()
            .responseObject{ (response: (DataResponse<HeatMap1>)) in
                switch response.result {
                case .success:
                    completion(response.result.value, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }

    open func rawGet(completion: @escaping ((_ data: String?,_ error: Error?) -> Void)) {
    if (self.lat == nil) {
        completion(nil, ErrorResponse.Error(500, nil, NSError(domain: "localhost", code: 500, userInfo: ["reason": "Missing mandatory argument : lat"])))
    }
    if (self.lon == nil) {
        completion(nil, ErrorResponse.Error(500, nil, NSError(domain: "localhost", code: 500, userInfo: ["reason": "Missing mandatory argument : lon"])))
    }

    request(self.makeUrl())
        .authenticate(user: currentApi.token, password: "")
        .validate()
        .responseString{ (response: (DataResponse<String>)) in
            switch response.result {
            case .success:
                completion(response.result.value, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}

open class CoverageRegionHeatMapsRequestBuilder: NSObject {
    let currentApi: HeatMapApi

    /**
    * enum for parameter datetimeRepresents
    */
    public enum DatetimeRepresents: String { 
        case arrival = "arrival"
        case departure = "departure"
    }
    /**
    * enum for parameter firstSectionMode
    */
    public enum FirstSectionMode: String { 
        case walking = "walking"
        case car = "car"
        case bike = "bike"
        case bss = "bss"
        case ridesharing = "ridesharing"
    }
    /**
    * enum for parameter lastSectionMode
    */
    public enum LastSectionMode: String { 
        case walking = "walking"
        case car = "car"
        case bike = "bike"
        case bss = "bss"
        case ridesharing = "ridesharing"
    }
    /**
    * enum for parameter dataFreshness
    */
    public enum DataFreshness: String { 
        case baseSchedule = "base_schedule"
        case adaptedSchedule = "adapted_schedule"
        case realtime = "realtime"
    }
    /**
    * enum for parameter travelerType
    */
    public enum TravelerType: String { 
        case cyclist = "cyclist"
        case luggage = "luggage"
        case wheelchair = "wheelchair"
        case standard = "standard"
        case motorist = "motorist"
        case fastWalker = "fast_walker"
        case slowWalker = "slow_walker"
    }
    /**
    * enum for parameter directPath
    */
    public enum DirectPath: String { 
        case indifferent = "indifferent"
        case only = "only"
        case _none = "none"
    }
    var region:String? = nil
    var from:String? = nil
    var to:String? = nil
    var datetime:Date? = nil
    var datetimeRepresents: DatetimeRepresents? = nil
    var maxNbTransfers:Int32? = nil
    var minNbTransfers:Int32? = nil
    var firstSectionMode: [String]? = nil
    var lastSectionMode: [String]? = nil
    var maxDurationToPt:Int32? = nil
    var maxWalkingDurationToPt:Int32? = nil
    var maxBikeDurationToPt:Int32? = nil
    var maxBssDurationToPt:Int32? = nil
    var maxCarDurationToPt:Int32? = nil
    var maxRidesharingDurationToPt:Int32? = nil
    var walkingSpeed:Float? = nil
    var bikeSpeed:Float? = nil
    var bssSpeed:Float? = nil
    var carSpeed:Float? = nil
    var ridesharingSpeed:Float? = nil
    var forbiddenUris:[String]? = nil
    var allowedId:[String]? = nil
    var disruptionActive:Bool? = nil
    var dataFreshness: DataFreshness? = nil
    var maxDuration:Int32? = nil
    var wheelchair:Bool? = nil
    var travelerType: TravelerType? = nil
    var directPath: DirectPath? = nil
    var freeRadiusFrom:Int32? = nil
    var freeRadiusTo:Int32? = nil
    var resolution:Int32? = nil
    var debugURL: String? = nil

    public init(currentApi: HeatMapApi) {
        self.currentApi = currentApi
    }

    open func withRegion(_ region: String?) -> CoverageRegionHeatMapsRequestBuilder {
        self.region = region
        
        return self
    }
    open func withFrom(_ from: String?) -> CoverageRegionHeatMapsRequestBuilder {
        self.from = from
        
        return self
    }
    open func withTo(_ to: String?) -> CoverageRegionHeatMapsRequestBuilder {
        self.to = to
        
        return self
    }
    open func withDatetime(_ datetime: Date?) -> CoverageRegionHeatMapsRequestBuilder {
        self.datetime = datetime
        
        return self
    }
    open func withDatetimeRepresents(_ datetimeRepresents: DatetimeRepresents?) -> CoverageRegionHeatMapsRequestBuilder {
        self.datetimeRepresents = datetimeRepresents

        return self
    }
    open func withMaxNbTransfers(_ maxNbTransfers: Int32?) -> CoverageRegionHeatMapsRequestBuilder {
        self.maxNbTransfers = maxNbTransfers
        
        return self
    }
    open func withMinNbTransfers(_ minNbTransfers: Int32?) -> CoverageRegionHeatMapsRequestBuilder {
        self.minNbTransfers = minNbTransfers
        
        return self
    }
    open func withFirstSectionMode(_ firstSectionMode: [FirstSectionMode]?) -> CoverageRegionHeatMapsRequestBuilder {
        guard let firstSectionMode = firstSectionMode else {
            return self
        }
        
        var items = [String]()
        for item in firstSectionMode {
            items.append(item.rawValue)
        }
        self.firstSectionMode = items

        return self
    }
    open func withLastSectionMode(_ lastSectionMode: [LastSectionMode]?) -> CoverageRegionHeatMapsRequestBuilder {
        guard let lastSectionMode = lastSectionMode else {
            return self
        }
        
        var items = [String]()
        for item in lastSectionMode {
            items.append(item.rawValue)
        }
        self.lastSectionMode = items

        return self
    }
    open func withMaxDurationToPt(_ maxDurationToPt: Int32?) -> CoverageRegionHeatMapsRequestBuilder {
        self.maxDurationToPt = maxDurationToPt
        
        return self
    }
    open func withMaxWalkingDurationToPt(_ maxWalkingDurationToPt: Int32?) -> CoverageRegionHeatMapsRequestBuilder {
        self.maxWalkingDurationToPt = maxWalkingDurationToPt
        
        return self
    }
    open func withMaxBikeDurationToPt(_ maxBikeDurationToPt: Int32?) -> CoverageRegionHeatMapsRequestBuilder {
        self.maxBikeDurationToPt = maxBikeDurationToPt
        
        return self
    }
    open func withMaxBssDurationToPt(_ maxBssDurationToPt: Int32?) -> CoverageRegionHeatMapsRequestBuilder {
        self.maxBssDurationToPt = maxBssDurationToPt
        
        return self
    }
    open func withMaxCarDurationToPt(_ maxCarDurationToPt: Int32?) -> CoverageRegionHeatMapsRequestBuilder {
        self.maxCarDurationToPt = maxCarDurationToPt
        
        return self
    }
    open func withMaxRidesharingDurationToPt(_ maxRidesharingDurationToPt: Int32?) -> CoverageRegionHeatMapsRequestBuilder {
        self.maxRidesharingDurationToPt = maxRidesharingDurationToPt
        
        return self
    }
    open func withWalkingSpeed(_ walkingSpeed: Float?) -> CoverageRegionHeatMapsRequestBuilder {
        self.walkingSpeed = walkingSpeed
        
        return self
    }
    open func withBikeSpeed(_ bikeSpeed: Float?) -> CoverageRegionHeatMapsRequestBuilder {
        self.bikeSpeed = bikeSpeed
        
        return self
    }
    open func withBssSpeed(_ bssSpeed: Float?) -> CoverageRegionHeatMapsRequestBuilder {
        self.bssSpeed = bssSpeed
        
        return self
    }
    open func withCarSpeed(_ carSpeed: Float?) -> CoverageRegionHeatMapsRequestBuilder {
        self.carSpeed = carSpeed
        
        return self
    }
    open func withRidesharingSpeed(_ ridesharingSpeed: Float?) -> CoverageRegionHeatMapsRequestBuilder {
        self.ridesharingSpeed = ridesharingSpeed
        
        return self
    }
    open func withForbiddenUris(_ forbiddenUris: [String]?) -> CoverageRegionHeatMapsRequestBuilder {
        self.forbiddenUris = forbiddenUris
        
        return self
    }
    open func withAllowedId(_ allowedId: [String]?) -> CoverageRegionHeatMapsRequestBuilder {
        self.allowedId = allowedId
        
        return self
    }
    open func withDisruptionActive(_ disruptionActive: Bool?) -> CoverageRegionHeatMapsRequestBuilder {
        self.disruptionActive = disruptionActive
        
        return self
    }
    open func withDataFreshness(_ dataFreshness: DataFreshness?) -> CoverageRegionHeatMapsRequestBuilder {
        self.dataFreshness = dataFreshness

        return self
    }
    open func withMaxDuration(_ maxDuration: Int32?) -> CoverageRegionHeatMapsRequestBuilder {
        self.maxDuration = maxDuration
        
        return self
    }
    open func withWheelchair(_ wheelchair: Bool?) -> CoverageRegionHeatMapsRequestBuilder {
        self.wheelchair = wheelchair
        
        return self
    }
    open func withTravelerType(_ travelerType: TravelerType?) -> CoverageRegionHeatMapsRequestBuilder {
        self.travelerType = travelerType

        return self
    }
    open func withDirectPath(_ directPath: DirectPath?) -> CoverageRegionHeatMapsRequestBuilder {
        self.directPath = directPath

        return self
    }
    open func withFreeRadiusFrom(_ freeRadiusFrom: Int32?) -> CoverageRegionHeatMapsRequestBuilder {
        self.freeRadiusFrom = freeRadiusFrom
        
        return self
    }
    open func withFreeRadiusTo(_ freeRadiusTo: Int32?) -> CoverageRegionHeatMapsRequestBuilder {
        self.freeRadiusTo = freeRadiusTo
        
        return self
    }
    open func withResolution(_ resolution: Int32?) -> CoverageRegionHeatMapsRequestBuilder {
        self.resolution = resolution
        
        return self
    }



    open func withDebugURL(_ debugURL: String?) -> CoverageRegionHeatMapsRequestBuilder {
        self.debugURL = debugURL
        return self
    }

    open func makeUrl() -> String {
        var path = "/coverage/{region}/heat_maps"

        if let region = region {
            let regionPreEscape: String = "\(region)"
            let regionPostEscape: String = regionPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
            path = path.replacingOccurrences(of: "{region}", with: regionPostEscape, options: .literal, range: nil)
        }

        let URLString = String(format: "%@%@", NavitiaSDKAPI.basePath, path)
        let url = NSURLComponents(string: URLString)

        let paramValues: [String: Any?] = [
            "from": self.from, 
            "to": self.to, 
            "datetime": self.datetime?.encodeToJSON(), 
            "datetime_represents": self.datetimeRepresents?.rawValue, 
            "max_nb_transfers": self.maxNbTransfers?.encodeToJSON(), 
            "min_nb_transfers": self.minNbTransfers?.encodeToJSON(), 
            "first_section_mode[]": self.firstSectionMode, 
            "last_section_mode[]": self.lastSectionMode, 
            "max_duration_to_pt": self.maxDurationToPt?.encodeToJSON(), 
            "max_walking_duration_to_pt": self.maxWalkingDurationToPt?.encodeToJSON(), 
            "max_bike_duration_to_pt": self.maxBikeDurationToPt?.encodeToJSON(), 
            "max_bss_duration_to_pt": self.maxBssDurationToPt?.encodeToJSON(), 
            "max_car_duration_to_pt": self.maxCarDurationToPt?.encodeToJSON(), 
            "max_ridesharing_duration_to_pt": self.maxRidesharingDurationToPt?.encodeToJSON(), 
            "walking_speed": self.walkingSpeed, 
            "bike_speed": self.bikeSpeed, 
            "bss_speed": self.bssSpeed, 
            "car_speed": self.carSpeed, 
            "ridesharing_speed": self.ridesharingSpeed, 
            "forbidden_uris[]": self.forbiddenUris, 
            "allowed_id[]": self.allowedId, 
            "disruption_active": self.disruptionActive, 
            "data_freshness": self.dataFreshness?.rawValue, 
            "max_duration": self.maxDuration?.encodeToJSON(), 
            "wheelchair": self.wheelchair, 
            "traveler_type": self.travelerType?.rawValue, 
            "direct_path": self.directPath?.rawValue, 
            "free_radius_from": self.freeRadiusFrom?.encodeToJSON(), 
            "free_radius_to": self.freeRadiusTo?.encodeToJSON(), 
            "resolution": self.resolution?.encodeToJSON()
        ]
        url?.queryItems = APIHelper.mapValuesToQueryItems(values: paramValues)
        url?.percentEncodedQuery = url?.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")

        return (debugURL ?? url?.string ?? URLString)
    }

    open func get(completion: @escaping ((_ data: HeatMap1?,_ error: Error?) -> Void)) {
        if (self.region == nil) {
            completion(nil, ErrorResponse.Error(500, nil, NSError(domain: "localhost", code: 500, userInfo: ["reason": "Missing mandatory argument : region"])))
        }

        request(self.makeUrl())
            .authenticate(user: currentApi.token, password: "")
            .validate()
            .responseObject{ (response: (DataResponse<HeatMap1>)) in
                switch response.result {
                case .success:
                    completion(response.result.value, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }

    open func rawGet(completion: @escaping ((_ data: String?,_ error: Error?) -> Void)) {
    if (self.region == nil) {
        completion(nil, ErrorResponse.Error(500, nil, NSError(domain: "localhost", code: 500, userInfo: ["reason": "Missing mandatory argument : region"])))
    }

    request(self.makeUrl())
        .authenticate(user: currentApi.token, password: "")
        .validate()
        .responseString{ (response: (DataResponse<String>)) in
            switch response.result {
            case .success:
                completion(response.result.value, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}



open class HeatMapApi: APIBase {
    let token: String

    public init(token: String) {
        self.token = token
    }

    public func newCoverageLonLatHeatMapsRequestBuilder() -> CoverageLonLatHeatMapsRequestBuilder {
        return CoverageLonLatHeatMapsRequestBuilder(currentApi: self)
    }
    public func newCoverageRegionHeatMapsRequestBuilder() -> CoverageRegionHeatMapsRequestBuilder {
        return CoverageRegionHeatMapsRequestBuilder(currentApi: self)
    }
}
