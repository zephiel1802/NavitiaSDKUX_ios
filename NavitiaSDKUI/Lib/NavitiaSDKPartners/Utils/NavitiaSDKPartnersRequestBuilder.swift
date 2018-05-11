//
//  NavitiaSDKPartnersRequestBuilder.swift
//
//  Created by Valentin COUSIEN on 09/03/2018.
//  Copyright © 2018 Valentin COUSIEN. All rights reserved.
//

import Foundation

enum JSONSerializationError : Error {
    case not_json_object
    case not_json_array
}

internal class NavitiaSDKPartnersRequestBuilder {
    
    class func get(returnArray : Bool = false, stringUrl : String, header : [String: String], completion : @escaping (Bool, Int, [String : Any]?) -> Void ) -> Void {
        
        if Reachability.isConnectedToNetwork() == false {
            print("NavitiaSDKPartners : no internet connection")
            
            DispatchQueue.main.async {
                completion(false, NavitiaSDKPartnersReturnCode.notConnected.getCode(), NavitiaSDKPartnersReturnCode.notConnected.getError())
            }
            return
        }
        
        guard let url = URL(string: stringUrl) else {
            print("NavitiaSDKPartners : error on url")
            
            DispatchQueue.main.async {
                completion(false, NavitiaSDKPartnersReturnCode.internalError.getCode(), NavitiaSDKPartnersReturnCode.internalError.getError())
            }
            return
        }
        
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = header
        config.timeoutIntervalForRequest = 20
        config.timeoutIntervalForResource = 20
        let session = URLSession(configuration: config)
        
        session.dataTask(with: url) { (data, response, error) in
            
            
            guard error == nil else {
                
                
                if (error! as NSError).code == -1001 {
                    completion(false, NavitiaSDKPartnersReturnCode.timeOut.getCode(), NavitiaSDKPartnersReturnCode.timeOut.getError())
                    return
                }
                
                print("NavitiaSDKPartners : error on task")
                DispatchQueue.main.async {
                    completion(false, NavitiaSDKPartnersReturnCode.internalError.getCode(), NavitiaSDKPartnersReturnCode.internalError.getError())
                }
                return
            }
            
            guard let responseData = data else {
                
                print("NavitiaSDKPartners : no data")
                DispatchQueue.main.async {
                    completion(false, NavitiaSDKPartnersReturnCode.internalError.getCode(), NavitiaSDKPartnersReturnCode.internalError.getError())
                }
                return
            }
            
            do {
                
                if ( (response as? HTTPURLResponse)?.statusCode == 200 && responseData.isEmpty) {
                    
                    DispatchQueue.main.async {
                        completion(true, (response as! HTTPURLResponse).statusCode, nil)
                    }
                    return
                } else if ( (response as? HTTPURLResponse)?.statusCode != 200 && !(responseData.isEmpty) ) {
                    
                    DispatchQueue.main.async {
                        completion(false, (response as! HTTPURLResponse).statusCode, nil)
                    }
                    return
                }
                
                var serializedData : [String: Any] = [ : ]
                
                if returnArray {
                    
                    guard let tempSerialized  = try JSONSerialization.jsonObject(with: responseData, options: []) as? [[String : Any]] else {
                        print("NavitiaSDKPartners : error on serialization")
                        DispatchQueue.main.async {
                            completion(false, (response as! HTTPURLResponse).statusCode, nil)
                        }
                        return
                    }
                    serializedData["array"] = tempSerialized
                } else {
                    
                    guard let tempSerialized = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String : Any] else {
                        print("NavitiaSDKPartners : error on serialization")
                        DispatchQueue.main.async {
                            completion(false, (response as! HTTPURLResponse).statusCode, nil)
                        }
                        return
                    }
                    serializedData = tempSerialized
                }
                DispatchQueue.main.async {
                    completion(true, (response as! HTTPURLResponse).statusCode, serializedData)
                }
                return 
            } catch {
                
                print("NavitiaSDKPartners : error on serializedData")
                DispatchQueue.main.async {
                    completion( ((response as! HTTPURLResponse).statusCode < 300 ? true : false) , (response as! HTTPURLResponse).statusCode, nil)
                }
                return
            }
            }.resume()
    }
    
    class func post(stringUrl : String, header : [String : String], content : [String : Any] = [ : ], completion : @escaping (Bool, Int, [String : Any]?) -> Void ) -> Void {
        
        if Reachability.isConnectedToNetwork() == false {
            print("NavitiaSDKPartners : no internet connection")
            DispatchQueue.main.async {
                completion(false, NavitiaSDKPartnersReturnCode.notConnected.getCode(), NavitiaSDKPartnersReturnCode.notConnected.getError())
            }
            return
        }
        
        guard let url = URL(string: stringUrl) else {
            print("NavitiaSDKPartners : error on url")
            
            DispatchQueue.main.async {
                completion(false, NavitiaSDKPartnersReturnCode.internalError.rawValue, nil)
            }
            return
        }
        
        var urlRequest = URLRequest(url: url, timeoutInterval: 20)
        
        for (key, value) in header {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        urlRequest.httpMethod = "POST"
        
        do {
            if content.isEmpty {
                urlRequest.httpBody = nil
            } else {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: content)
            }
        } catch {
            print("NavitiaSDKPartners : error on urlRequest Body")
            DispatchQueue.main.async {
                completion(false, NavitiaSDKPartnersReturnCode.internalError.rawValue, nil)
            }
            return
        }
        
        let session = URLSession.shared
        session.dataTask(with: urlRequest) { ( data, response, error ) in
            
            guard error == nil else {
                if response != nil {
                    if (error! as NSError).code == -1001 {
                        DispatchQueue.main.async {
                            completion(false, NavitiaSDKPartnersReturnCode.timeOut.getCode(), NavitiaSDKPartnersReturnCode.timeOut.getError())
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        completion(true, (response as! HTTPURLResponse).statusCode, nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(false, NavitiaSDKPartnersReturnCode.internalError.getCode(), NavitiaSDKPartnersReturnCode.internalError.getError())
                    }
                }
                return
            }
            
            guard let responseData = data else {
                
                print("NavitiaSDKPartners : no data")
                DispatchQueue.main.async {
                    completion(false, (response as! HTTPURLResponse).statusCode, nil)
                }
                return
            }
            
            do {
                
                if ( (response as? HTTPURLResponse)?.statusCode == 200 && responseData.isEmpty) {
                    
                    DispatchQueue.main.async {
                        completion(true, (response as! HTTPURLResponse).statusCode, nil)
                    }
                    return
                }
                
                if ( ((response as? HTTPURLResponse)?.statusCode)! >= 500 ) {
                    
                    DispatchQueue.main.async {
                        completion(false, (response as! HTTPURLResponse).statusCode, nil)
                    }
                    return
                }
                
                var serializedData : [String : Any] = [:]
                do {
                    guard let serializedObject = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String : Any] else {
                        throw JSONSerializationError.not_json_object
                    }
                    serializedData = serializedObject
                } catch JSONSerializationError.not_json_object {
                    guard let serializedArray = try JSONSerialization.jsonObject(with: responseData, options: []) as? [[String : Any]] else {
                        
                        print("NavitiaSDKPartners : error on serialization")
                        DispatchQueue.main.async {
                            completion(false, (response as! HTTPURLResponse).statusCode, nil)
                        }
                        return
                    }
                    serializedData["array"] = serializedArray
                }
                
                if (response as! HTTPURLResponse).statusCode >= 300 {
                    DispatchQueue.main.async {
                        completion(false, (response as! HTTPURLResponse).statusCode, serializedData)
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    completion(true, (response as! HTTPURLResponse).statusCode, serializedData)
                }
                return
                
            } catch {
                
                print("NavitiaSDKPartners : error on serializedData")
                
                DispatchQueue.main.async {
                    completion(false, (response as! HTTPURLResponse).statusCode, nil)
                }
                return
            }
        }.resume()
    }
    
    class func soapPost(stringUrl : String, header : [String : String], soapMessage : String = "", completion : @escaping (Bool, Int, XMLIndexer?) -> Void ) -> Void {
        
        if Reachability.isConnectedToNetwork() == false {
            print("NavitiaSDKPartners : no internet connection")
            DispatchQueue.main.async {
                completion(false, NavitiaSDKPartnersReturnCode.notConnected.getCode(), nil)
            }
            return
        }
        
        let urlRequest = NSMutableURLRequest(url: NSURL(string: stringUrl)! as URL,
                                             cachePolicy: .useProtocolCachePolicy,
                                             timeoutInterval: 20)
        for (key, value) in header {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = NSData(data: soapMessage.data(using: String.Encoding.utf8)!) as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: urlRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                
                if (error! as NSError).code == -1001 {
                    
                    DispatchQueue.main.async {
                        completion(false, NavitiaSDKPartnersReturnCode.timeOut.getCode(), nil)
                    }
                } else {
                    
                    DispatchQueue.main.async {
                        completion(false, NavitiaSDKPartnersReturnCode.internalError.getCode(), nil)
                    }
                }
            } else {
                let httpResponse = response as? HTTPURLResponse
                if (httpResponse?.statusCode)! < 300 {
                    let dataParsed = SWXMLHash.parse(NSString(data: data!, encoding:  String.Encoding.utf8.rawValue)! as String)
                    DispatchQueue.main.async {
                        completion(true, 200, dataParsed)
                    }
                } else {
                    let dataParsed = SWXMLHash.parse(NSString(data: data!, encoding:  String.Encoding.utf8.rawValue)! as String)
                    DispatchQueue.main.async {
                        completion(false, (httpResponse?.statusCode)!, dataParsed)
                    }
                }
            }
        })
        dataTask.resume()
    }
}
