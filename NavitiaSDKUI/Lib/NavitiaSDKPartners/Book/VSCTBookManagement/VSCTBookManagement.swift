//
//  VSCTBookManagement.swift
//  NavitiaSDKPartners
//
//  Created by Valentin COUSIEN on 18/04/2018.
//  Copyright © 2018 Kisio. All rights reserved.
//

import Foundation

@objc(VSCTBookManagement) public class VSCTBookManagement : NSObject, BookManagement {
    
    private var cartId : String = ""
    private var stockedOffers : [VSCTBookOffer] = []
    
    public private(set) var cart: [BookManagementCartItem] = []
    
    public var cartTotalPrice : NavitiaSDKPartnersPrice {
        get {
            let money = NavitiaSDKPartnersPrice()
            var totalPrice : Float = 0.0
            cart.forEach { (item) in
                totalPrice += item.itemPrice
            }
            
            let currency : String = (cart.first?.bookOffer.currency) ?? ""
            money.currency = currency
            money.value = totalPrice
            return money
        }
    }
    
    public var cartTotalVAT : NavitiaSDKPartnersPrice {
        get {
            let money = NavitiaSDKPartnersPrice()
            var totalVAT : Float = 0.0
            cart.forEach { (item) in
                totalVAT += item.itemVAT
            }
            
            let currency : String = (cart.first?.bookOffer.currency) ?? ""
            money.currency = currency
            money.value = totalVAT
            return money
        }
    }
    
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
    
    internal func addItemsInAPI(index : Int = 0, callbackSuccess : @escaping () -> Void, callbackError : @escaping (Int, [String: Any]?) -> Void) {
        NavitiaSDKPartnersRequestBuilder.post(stringUrl: "\(self._getUrl())/baskets/\(self.cartId)/items/?simulate=false", header: self._getConnectedHeader(), content: ["offer": ["id" : self.cart[index].bookOffer.id], "quantity" : self.cart[index].quantity], completion: { (success, statusCode, data) in

            if success {
                if self.cart.count == index + 1 { //isLast
                    callbackSuccess()
                } else {
                    self.addItemsInAPI(index: index + 1, callbackSuccess: callbackSuccess, callbackError: callbackError)
                }
            } else {
                callbackError(statusCode, data)
            }
        })
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
    
    public func addOffer(offerId: String, callbackSuccess: @escaping () -> Void, callbackError: @escaping (Int, [String : Any]?) -> Void) {
        
        let offerItem = stockedOffers.first { (offer) -> Bool in
            offer.id == offerId
        }
        
        if offerItem == nil {
            print("NavitiaSDKPartners/addOffer : error")
            callbackError(NavitiaSDKPartnersReturnCode.badParameter.getCode(), NavitiaSDKPartnersReturnCode.badParameter.getError())
            return
        } else if offerItem!.saleable == false && offerItem!.maxQuantity != 0 {
            print("NavitiaSDKPartners/addOffer : error")
            callbackError(NavitiaSDKPartnersReturnCode.badParameter.getCode(), NavitiaSDKPartnersReturnCode.badParameter.getError())
            return
        }
        
        let cartItem = cart.first(where: { (bookOffer) -> Bool in
            (bookOffer.bookOffer as! VSCTBookOffer).id == offerId
        })
        
        if cartItem == nil {
            cart.append(BookManagementCartItem(bookOffer: offerItem!, quantity: 1))
        } else if cartItem!.quantity < (cartItem!.bookOffer as! VSCTBookOffer).maxQuantity {
            cartItem!.setQuantity(q: cartItem!.quantity + 1)
        } else {
            print("NavitiaSDKPartners/addOffer : error")
            callbackError(NavitiaSDKPartnersReturnCode.internalError.getCode(), ["error" : "max quantity"])
            return
        }
        
        print("NavitiaSDKPartners/addOffer : success")
        callbackSuccess()
    }
    
    public func removeOffer(offerId: String, callbackSuccess: @escaping () -> Void, callbackError: @escaping (Int, [String : Any]?) -> Void) {
        let offerItem = stockedOffers.first { (offer) -> Bool in
            offer.id == offerId
        }
        
        if offerItem == nil {
            print("NavitiaSDKPartners/removeOffer : error")
            callbackError(NavitiaSDKPartnersReturnCode.badParameter.getCode(), NavitiaSDKPartnersReturnCode.badParameter.getError())
            return
        } else if offerItem!.saleable == false && offerItem!.maxQuantity != 0 {
            print("NavitiaSDKPartners/removeOffer : error")
            callbackError(NavitiaSDKPartnersReturnCode.badParameter.getCode(), NavitiaSDKPartnersReturnCode.badParameter.getError())
            return
        }
        
        let cartItem = cart.first(where: { (bookOffer) -> Bool in
            (bookOffer.bookOffer as! VSCTBookOffer).id == offerId
        })
        
        if cartItem == nil || cartItem?.quantity == 0 {
            print("NavitiaSDKPartners/removeOffer : error")
            callbackError(NavitiaSDKPartnersReturnCode.badParameter.getCode(), NavitiaSDKPartnersReturnCode.badParameter.getError())
            return
        }
        
        print("NavitiaSDKPartners/removeOffer : success")
        cartItem!.setQuantity(q: cartItem!.quantity - 1)
        cart = cart.filter({ (item) -> Bool in
            item.quantity > 0
        })
        
        callbackSuccess()
    }
    
    public func setOfferQuantity(offerId: String, quantity: Int, callbackSuccess: @escaping () -> Void, callbackError: @escaping (Int, [String : Any]?) -> Void) {
        
        let offerItem = stockedOffers.first { (offer) -> Bool in
            offer.id == offerId
        }
        
        if offerItem == nil {
            print("NavitiaSDKPartners/removeOffer : error")
            callbackError(NavitiaSDKPartnersReturnCode.badParameter.getCode(), NavitiaSDKPartnersReturnCode.badParameter.getError())
            return
        } else if offerItem!.saleable == false && offerItem!.maxQuantity != 0 {
            print("NavitiaSDKPartners/removeOffer : error")
            callbackError(NavitiaSDKPartnersReturnCode.badParameter.getCode(), NavitiaSDKPartnersReturnCode.badParameter.getError())
            return
        }
        
        let cartItem = cart.first(where: { (bookOffer) -> Bool in
            (bookOffer.bookOffer as! VSCTBookOffer).id == offerId
        })
        
        if cartItem == nil {
            cart.append(BookManagementCartItem(bookOffer: offerItem!, quantity: quantity))
        } else if quantity < (cartItem!.bookOffer as! VSCTBookOffer).maxQuantity {
            cartItem!.setQuantity(q: quantity)
        } else {
            print("NavitiaSDKPartners/addOffer : error")
            callbackError(NavitiaSDKPartnersReturnCode.internalError.getCode(), ["error" : "max quantity"])
            return
        }
        
        print("NavitiaSDKPartners/addOffer : success")
        callbackSuccess()
    }
    
    public func getOrderValidation(callbackSuccess : @escaping ([BookManagementCartItem]) -> Void, callbackError : @escaping (Int, [String: Any]?) -> Void) {
        
        if cart.isEmpty {
            callbackError(NavitiaSDKPartnersReturnCode.badParameter.getCode(), NavitiaSDKPartnersReturnCode.badParameter.getError())
            return
        }
        
        NavitiaSDKPartnersRequestBuilder.post(stringUrl: "\(_getUrl())/baskets", header: _getConnectedHeader()) { (success, statusCode, data) in
            if success && data != nil {
                self.cartId = data!["id"] as! String
                self.addItemsInAPI(callbackSuccess: {
                    NavitiaSDKPartnersRequestBuilder.get(stringUrl: "\(self._getUrl())/baskets/\(self.cartId)/validation", header: self._getConnectedHeader(), completion: { (success, statusCode, data) in
                        if success {
                            callbackSuccess(self.cart)
                        } else {
                            callbackError(statusCode, data)
                        }
                    })
                }, callbackError: {(statusCode, data) in
                    callbackError(statusCode, data)
                })
            } else {
                callbackError(statusCode, data)
            }
        }
    }
}

extension VSCTBookManagement {
    func parseOffers(data : [String: Any?]) -> [VSCTBookOffer] {
        
        var array : [VSCTBookOffer] = []
        (data["array"] as! [[String: Any]]).forEach { rawOffer in
            let offer : VSCTBookOffer = VSCTBookOffer(id: (rawOffer["id"] as! String),
                                                      productId: (rawOffer["idProduit"] as! String),
                                                      title: (rawOffer["label"] as! String), shortDescription: NavitiaSDKPartnersExtension.getString(from: (rawOffer["description"] as! String))!,
                                                      price: (((rawOffer["fare"] as! [String: Any])["price"] as! NSNumber).floatValue),
                                                      currency: ((rawOffer["fare"] as! [String: Any])["currency"] as! String),
                                                      maxQuantity: (rawOffer["maxQuantity"] as! Int),
                                                      type: (rawOffer["typeOffer"] as! String) == "PASS" ? BookOfferType.Membership : BookOfferType.Ticket,
                                                      VATRate: ((rawOffer["fare"] as! [String: Any])["tva"] as! Float),
                                                      saleable: (rawOffer["saleable"] as! Bool),
                                                      displayOrder: (rawOffer["displayOrder"] as! Int),
                                                      legalInfos: (rawOffer["legalInfos"] as! String),
                                                      imageUrl: (((rawOffer["image"] as! [String: Any])["link"] as! [String: Any])["href"] as! String),
                                                      displayOffer : (rawOffer["display"] as! Bool),
                                                      mandatoryAccount: false)
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
