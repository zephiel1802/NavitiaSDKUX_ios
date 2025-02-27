//
// CoordApi.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class CoordLonLatRequestBuilder: NSObject {
    let currentApi: CoordApi

    var lat:Double? = nil
    var lon:Double? = nil
    var debugURL: String? = nil

    public init(currentApi: CoordApi) {
        self.currentApi = currentApi
    }

    open func withLat(_ lat: Double?) -> CoordLonLatRequestBuilder {
        self.lat = lat
        
        return self
    }
    open func withLon(_ lon: Double?) -> CoordLonLatRequestBuilder {
        self.lon = lon
        
        return self
    }



    open func withDebugURL(_ debugURL: String?) -> CoordLonLatRequestBuilder {
        self.debugURL = debugURL
        return self
    }

    open func makeUrl() -> String {
        var path = "/coord/{lon};{lat}/"

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


        return (debugURL ?? url?.string ?? URLString)
    }

    open func get(completion: @escaping ((_ data: DictAddresses?,_ error: Error?) -> Void)) {
        if (self.lat == nil) {
            completion(nil, ErrorResponse.Error(500, nil, NSError(domain: "localhost", code: 500, userInfo: ["reason": "Missing mandatory argument : lat"])))
        }
        if (self.lon == nil) {
            completion(nil, ErrorResponse.Error(500, nil, NSError(domain: "localhost", code: 500, userInfo: ["reason": "Missing mandatory argument : lon"])))
        }

        request(self.makeUrl())
            .authenticate(user: currentApi.token, password: "")
            .validate()
            .responseObject{ (response: (DataResponse<DictAddresses>)) in
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

open class CoordsLonLatRequestBuilder: NSObject {
    let currentApi: CoordApi

    var lat:Double? = nil
    var lon:Double? = nil
    var debugURL: String? = nil

    public init(currentApi: CoordApi) {
        self.currentApi = currentApi
    }

    open func withLat(_ lat: Double?) -> CoordsLonLatRequestBuilder {
        self.lat = lat
        
        return self
    }
    open func withLon(_ lon: Double?) -> CoordsLonLatRequestBuilder {
        self.lon = lon
        
        return self
    }



    open func withDebugURL(_ debugURL: String?) -> CoordsLonLatRequestBuilder {
        self.debugURL = debugURL
        return self
    }

    open func makeUrl() -> String {
        var path = "/coords/{lon};{lat}/"

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


        return (debugURL ?? url?.string ?? URLString)
    }

    open func get(completion: @escaping ((_ data: DictAddresses?,_ error: Error?) -> Void)) {
        if (self.lat == nil) {
            completion(nil, ErrorResponse.Error(500, nil, NSError(domain: "localhost", code: 500, userInfo: ["reason": "Missing mandatory argument : lat"])))
        }
        if (self.lon == nil) {
            completion(nil, ErrorResponse.Error(500, nil, NSError(domain: "localhost", code: 500, userInfo: ["reason": "Missing mandatory argument : lon"])))
        }

        request(self.makeUrl())
            .authenticate(user: currentApi.token, password: "")
            .validate()
            .responseObject{ (response: (DataResponse<DictAddresses>)) in
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



open class CoordApi: APIBase {
    let token: String

    public init(token: String) {
        self.token = token
    }

    public func newCoordLonLatRequestBuilder() -> CoordLonLatRequestBuilder {
        return CoordLonLatRequestBuilder(currentApi: self)
    }
    public func newCoordsLonLatRequestBuilder() -> CoordsLonLatRequestBuilder {
        return CoordsLonLatRequestBuilder(currentApi: self)
    }
}
