//
//  VSCTBookManagement.swift
//  NavitiaSDKPartners
//
//  Created by Valentin COUSIEN on 18/04/2018.
//  Copyright © 2018 Kisio. All rights reserved.
//

import Foundation

@objc(VSCTBookManagement) public class VSCTBookManagement : NSObject, BookManagement {
    
    private var stockedOffers : [VSCTBookOffer] = []
    
    public var cart: [BookManagementCartItem] = []
    
    public var _vsctConfiguration : VSCTBookManagementConfiguration? = nil
    
    public var _token : String {
        get {
            return UserDefaults.standard.string(forKey: "__NavitiaSDKPartners_VSCTBookManagement_token") ?? ""
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "__NavitiaSDKPartners_VSCTBookManagement_token")
        }
    }
    
    public var bookConfiguration : BookManagementConfiguration? {
        get {
            return _vsctConfiguration
        }
        
        set {
            _vsctConfiguration = (newValue as! VSCTBookManagementConfiguration)
        }
    }
    
    public func getBookManagementName() -> String {
        
        return "VSCT"
    }
    
    public func getBookManagementType() -> BookManagementType {
        
        return .VSCT
    }
    
    private func _getHeader() -> [String: String] {
        
        return ["Content-Type" : "application/json"]
    }
    
    private func _getConnectedHeader() -> [String: String] {
        
        return [ "Content-Type" : "application/json",
                 "Authorization" : "Bearer \(_token)"]
    }
    
    func _getUrl() -> String {
        return _vsctConfiguration!.url + _vsctConfiguration!.network
    }
    
    internal func openSession(callbackSuccess: @escaping () -> Void, callbackError: @escaping (Int, [String: Any]?) -> Void) {
        NavitiaSDKPartnersRequestBuilder.post(stringUrl: "\(_getUrl())/sessions?mticket=true&authToken=\((NavitiaSDKPartners.shared.accountManagement as! KeolisAccountManagement)._accessToken)&hideMyAccount=true", header: _getHeader()) { (success, statusCode, data) in
            
            if success {
                self._token = (data!["token"] as! String)
                callbackSuccess()
            } else {
                callbackError(statusCode, data)
            }
        }
    }
    
    public func getOffers(callbackSuccess : @escaping ([BookOffer]?) -> Void, callbackError : @escaping (Int, [String: Any]?) -> Void) {
        if NavitiaSDKPartners.shared.isConnected {
            NavitiaSDKPartners.shared.refreshToken(callbackSuccess: {
                self.openSession(callbackSuccess: {
                    NavitiaSDKPartnersRequestBuilder.get(returnArray: true, stringUrl: "\(self._getUrl())/offers?", header: self._getConnectedHeader()) { (success, statusCode, data) in
                        
                        if success {
                            self.stockedOffers = self.parseOffers(data: data!)
                            callbackSuccess(self.stockedOffers)
                        } else {
                            callbackError(statusCode, data)
                        }
                    }
                }, callbackError: { (statusCode, data) in
                    callbackError(statusCode, data)
                })
            }, callbackError: { (statusCode, data) in
                callbackError(statusCode, data)
            })

        } else {
            NavitiaSDKPartners.shared.createAccount(callbackSuccess: {
                self.openSession(callbackSuccess: {
                    NavitiaSDKPartnersRequestBuilder.get(returnArray: true, stringUrl: "\(self._getUrl())/offers?", header: self._getConnectedHeader()) { (success, statusCode, data) in
                        
                        if success {
                            callbackSuccess(self.parseOffers(data: data!))
                        } else {
                            callbackError(statusCode, data)
                        }
                    }
                }, callbackError: { (statusCode, data) in
                    callbackError(statusCode, data)
                })
            }, callbackError: { (statusCode, data) in
                callbackError(statusCode, data)
            })
        }
    }
    
    public func getOffers(offerType: BookOfferType, callbackSuccess: @escaping ([BookOffer]?) -> Void, callbackError: @escaping (Int, [String : Any]?) -> Void) {
        getOffers(callbackSuccess: { (offersArray) in
            
            if offersArray == nil  {
                callbackSuccess(nil)
                return
            }
            callbackSuccess(offersArray?.filter { ($0 as! VSCTBookOffer).type == offerType })
        }) { (statusCode, data) in
            
            callbackError(statusCode, data)
        }
    }
    
    public func addOffer(offerId: Int, callbackSuccess: @escaping () -> Void, callbackError: @escaping (Int, [String : Any]?) -> Void) {
        callbackSuccess()
    }
    
    public func removeOffer(offerId: Int, callbackSuccess: @escaping () -> Void, callbackError: @escaping (Int, [String : Any]?) -> Void) {
        callbackSuccess()
    }
    
    public func setOfferQuantity(offerId: Int, quantity: Int, callbackSuccess: @escaping () -> Void, callbackError: @escaping (Int, [String : Any]?) -> Void) {
        callbackSuccess()
    }

}

extension VSCTBookManagement {
    func parseOffers(data : [String: Any?]) -> [VSCTBookOffer] {
        
        var array : [VSCTBookOffer] = []
        (data["array"] as! [[String: Any]]).forEach { rawOffer in
            let offer : VSCTBookOffer = VSCTBookOffer()
            
            offer.id = (rawOffer["id"] as! String)
            offer.productId = (rawOffer["idProduit"] as! String)
            offer.title = (rawOffer["label"] as! String)
            offer.maxQuantity = (rawOffer["maxQuantity"] as! Int)
            offer.currency = ((rawOffer["fare"] as! [String: Any])["currency"] as! String)
            offer.type = (rawOffer["typeOffer"] as! String) == "PASS" ? BookOfferType.Membership : BookOfferType.Ticket
            offer.shortDescription = NavitiaSDKPartnersExtension.getString(from: (rawOffer["description"] as! String))!
            offer.VAT = ((rawOffer["fare"] as! [String: Any])["tva"] as! Float)
            offer.saleable = (rawOffer["saleable"] as! Bool)
            offer.displayOrder = (rawOffer["displayOrder"] as! Int)
            offer.legalInfos = (rawOffer["legalInfos"] as! String)
            offer.imageUrl = (((rawOffer["image"] as! [String: Any])["link"] as! [String: Any])["href"] as! String)
            offer.price = (((rawOffer["fare"] as! [String: Any])["price"] as! NSNumber).floatValue)
            
            array.append(offer)
        }
        
        array.sort { (first, second) -> Bool in
            first.displayOrder < second.displayOrder
        }
        
        return array.filter({ (offer) -> Bool in
            offer.saleable
        })
    }
}
