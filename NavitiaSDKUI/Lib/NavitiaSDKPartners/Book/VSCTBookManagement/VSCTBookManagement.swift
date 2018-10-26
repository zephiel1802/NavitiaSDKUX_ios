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
    
    public private(set) var orderId : String = ""
    public private(set) var cart: [NavitiaBookCartItem] = []
    
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
    
    public var paymentBaseUrl : String {
        get {
            return (_vsctConfiguration?.baseUrl)!
        }
    }
    
    internal func openSession(callbackSuccess: @escaping () -> Void, callbackError: @escaping (Int, [String: Any]?) -> Void) {
        NavitiaSDKPartnersRequestBuilder.post(stringUrl: "\(_getUrl())/sessions?mticket=true&authToken=\((NavitiaSDKPartners.shared.accountManagement as! KeolisAccountManagement)._accessToken)&hideMyAccount=true", header: _getHeader()) { (success, statusCode, data) in
            print(data)
            if success {
                print("NavitiaSDKPartners/openSession : success")
                self._token = (data!["token"] as! String)
                self.cartId = (data!["basket"] as! String)
                callbackSuccess()
            } else {
                print("NavitiaSDKPartners/openSession : error")
                if NavitiaSDKPartnersReturnCode(rawValue: statusCode) != nil {
                    
                    callbackError(statusCode, NavitiaSDKPartnersReturnCode(rawValue: statusCode)?.getError())
                } else {
                    
                    callbackError(NavitiaSDKPartnersReturnCode.internalServerError.getCode(), NavitiaSDKPartnersReturnCode.internalServerError.getError())
                }
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
                if NavitiaSDKPartnersReturnCode(rawValue: statusCode) != nil {
                    
                    callbackError(statusCode, NavitiaSDKPartnersReturnCode(rawValue: statusCode)?.getError())
                } else {
                    
                    callbackError(NavitiaSDKPartnersReturnCode.internalServerError.getCode(), NavitiaSDKPartnersReturnCode.internalServerError.getError())
                }
            }
        })
    }
    
    public func getOffers(callbackSuccess : @escaping ([NavitiaBookOffer]) -> Void, callbackError : @escaping (Int, [String: Any]?) -> Void) {
        if NavitiaSDKPartners.shared.isConnected {
            self.openSession(callbackSuccess: {
                NavitiaSDKPartnersRequestBuilder.get(returnArray: true, stringUrl: "\(self._getUrl())/offers?", header: self._getConnectedHeader()) { (success, statusCode, data) in
                    
                    if success {
                        print("NavitiaSDKPartners/getOffers : success")
                        self.stockedOffers = self.parseOffers(data: data!)
                        callbackSuccess(self.stockedOffers)
                    } else {
                        print("NavitiaSDKPartners/getOffers : error")
                        if NavitiaSDKPartnersReturnCode(rawValue: statusCode) != nil {
                            
                            callbackError(statusCode, NavitiaSDKPartnersReturnCode(rawValue: statusCode)?.getError())
                        } else {
                            
                            callbackError(NavitiaSDKPartnersReturnCode.internalServerError.getCode(), NavitiaSDKPartnersReturnCode.internalServerError.getError())
                        }
                    }
                }
            }, callbackError: { (statusCode, data) in
                NavitiaSDKPartners.shared.refreshToken(callbackSuccess: {
                    self.openSession(callbackSuccess: {
                        NavitiaSDKPartnersRequestBuilder.get(returnArray: true, stringUrl: "\(self._getUrl())/offers?", header: self._getConnectedHeader()) { (success, statusCode, data) in
                            if success {
                                print("NavitiaSDKPartners/getOffers : success")
                                self.stockedOffers = self.parseOffers(data: data!)
                                callbackSuccess(self.stockedOffers)
                            } else {
                                print("NavitiaSDKPartners/getOffers : error")
                                if NavitiaSDKPartnersReturnCode(rawValue: statusCode) != nil {
                                    
                                    callbackError(statusCode, NavitiaSDKPartnersReturnCode(rawValue: statusCode)?.getError())
                                } else {
                                    
                                    callbackError(NavitiaSDKPartnersReturnCode.internalServerError.getCode(), NavitiaSDKPartnersReturnCode.internalServerError.getError())
                                }
                            }
                        }
                    }, callbackError: { (statusCode, data) in
                        if NavitiaSDKPartnersReturnCode(rawValue: statusCode) != nil {
                            
                            callbackError(statusCode, NavitiaSDKPartnersReturnCode(rawValue: statusCode)?.getError())
                        } else {
                            
                            callbackError(NavitiaSDKPartnersReturnCode.internalServerError.getCode(), NavitiaSDKPartnersReturnCode.internalServerError.getError())
                        }
                    })
                }, callbackError: { (statusCode, data) in
                    if NavitiaSDKPartnersReturnCode(rawValue: statusCode) != nil {
                        
                        callbackError(statusCode, NavitiaSDKPartnersReturnCode(rawValue: statusCode)?.getError())
                    } else {
                        
                        callbackError(NavitiaSDKPartnersReturnCode.internalServerError.getCode(), NavitiaSDKPartnersReturnCode.internalServerError.getError())
                    }
                })
            })
        } else {
            NavitiaSDKPartners.shared.createAccount(callbackSuccess: {
                self.openSession(callbackSuccess: {
                    NavitiaSDKPartnersRequestBuilder.get(returnArray: true, stringUrl: "\(self._getUrl())/offers?", header: self._getConnectedHeader()) { (success, statusCode, data) in
                        
                        if success {
                            print("NavitiaSDKPartners/getOffers : success")
                            self.stockedOffers = self.parseOffers(data: data!)
                            callbackSuccess(self.stockedOffers)
                        } else {
                            print("NavitiaSDKPartners/getOffers : error")
                            if NavitiaSDKPartnersReturnCode(rawValue: statusCode) != nil {
                                
                                callbackError(statusCode, NavitiaSDKPartnersReturnCode(rawValue: statusCode)?.getError())
                            } else {
                                
                                callbackError(NavitiaSDKPartnersReturnCode.internalServerError.getCode(), NavitiaSDKPartnersReturnCode.internalServerError.getError())
                            }
                        }
                    }
                }, callbackError: { (statusCode, data) in
                    print("NavitiaSDKPartners/getOffers : error")
                    if NavitiaSDKPartnersReturnCode(rawValue: statusCode) != nil {
                        
                        callbackError(statusCode, NavitiaSDKPartnersReturnCode(rawValue: statusCode)?.getError())
                    } else {
                        
                        callbackError(NavitiaSDKPartnersReturnCode.internalServerError.getCode(), NavitiaSDKPartnersReturnCode.internalServerError.getError())
                    }
                })
            }, callbackError: { (statusCode, data) in
                print("NavitiaSDKPartners/getOffers : error")
                if NavitiaSDKPartnersReturnCode(rawValue: statusCode) != nil {
                    
                    callbackError(statusCode, NavitiaSDKPartnersReturnCode(rawValue: statusCode)?.getError())
                } else {
                    
                    callbackError(NavitiaSDKPartnersReturnCode.internalServerError.getCode(), NavitiaSDKPartnersReturnCode.internalServerError.getError())
                }
            })
        }
    }
    
    public func getOffers(offerType: NavitiaBookOfferType, callbackSuccess: @escaping ([NavitiaBookOffer]) -> Void, callbackError: @escaping (Int, [String : Any]?) -> Void) {
        getOffers(callbackSuccess: { (offersArray) in
            
            if offersArray.count == 0  {
                callbackSuccess([])
                return
            }
            callbackSuccess(offersArray.filter { ($0 as! VSCTBookOffer).type == offerType })
        }) { (statusCode, data) in
            
            if NavitiaSDKPartnersReturnCode(rawValue: statusCode) != nil {
                
                callbackError(statusCode, NavitiaSDKPartnersReturnCode(rawValue: statusCode)?.getError())
            } else {
                
                callbackError(NavitiaSDKPartnersReturnCode.internalServerError.getCode(), NavitiaSDKPartnersReturnCode.internalServerError.getError())
            }
        }
    }
    
    public func addOffer(offerId: String, callbackSuccess: @escaping () -> Void, callbackError: @escaping (Int, [String : Any]?) -> Void) {
        
        let offerItem = stockedOffers.first { (offer) -> Bool in
            offer.id == offerId
        }
        
        if offerItem == nil {
            print("NavitiaSDKPartners/addOffer : error")
            let error = NavitiaSDKPartnersReturnCode.wrongOfferId
            callbackError(error.getCode(), error.getError())
            return
        } else if offerItem!.saleable == false && offerItem!.maxQuantity != 0 {
            print("NavitiaSDKPartners/addOffer : error")
            let error = NavitiaSDKPartnersReturnCode.offerNotSaleable
            callbackError(error.getCode(), error.getError())
            return
        }
        
        let cartItem = cart.first(where: { (bookOffer) -> Bool in
            (bookOffer.bookOffer as! VSCTBookOffer).id == offerId
        })
        
        if cartItem == nil {
            cart.append(NavitiaBookCartItem(bookOffer: offerItem!, quantity: 1))
        } else if cartItem!.quantity < (cartItem!.bookOffer as! VSCTBookOffer).maxQuantity {
            cartItem!.setQuantity(q: cartItem!.quantity + 1)
        } else {
            print("NavitiaSDKPartners/addOffer : error")
            let error = NavitiaSDKPartnersReturnCode.maxQuantity
            callbackError(error.getCode(), error.getError())
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
            let error = NavitiaSDKPartnersReturnCode.wrongOfferId
            callbackError(error.getCode(), error.getError())
            return
        } else if offerItem!.saleable == false && offerItem!.maxQuantity != 0 {
            print("NavitiaSDKPartners/removeOffer : error")
            let error = NavitiaSDKPartnersReturnCode.offerNotSaleable
            callbackError(error.getCode(), error.getError())
            return
        }
        
        let cartItem = cart.first(where: { (bookOffer) -> Bool in
            (bookOffer.bookOffer as! VSCTBookOffer).id == offerId
        })
        
        if cartItem == nil || cartItem?.quantity == 0 {
            print("NavitiaSDKPartners/removeOffer : error")
            let error = NavitiaSDKPartnersReturnCode.notInCart
            callbackError(error.getCode(), error.getError())
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
            print("NavitiaSDKPartners/setOfferQuantity : error")
            let error = NavitiaSDKPartnersReturnCode.wrongOfferId
            callbackError(error.getCode(), error.getError())
            return
        } else if offerItem!.saleable == false || offerItem!.maxQuantity == 0 {
            print("NavitiaSDKPartners/setOfferQuantity : error")
            let error = NavitiaSDKPartnersReturnCode.offerNotSaleable
            callbackError(error.getCode(), error.getError())
            return
        }
        
        let cartItem = cart.first(where: { (bookOffer) -> Bool in
            (bookOffer.bookOffer as! VSCTBookOffer).id == offerId
        })
        
        if cartItem == nil {
            if quantity > offerItem!.maxQuantity {
                cart.append(NavitiaBookCartItem(bookOffer: offerItem!, quantity: offerItem!.maxQuantity))
            } else {
                cart.append(NavitiaBookCartItem(bookOffer: offerItem!, quantity: quantity))
            }
        } else if quantity < (cartItem!.bookOffer as! VSCTBookOffer).maxQuantity {
            cartItem!.setQuantity(q: quantity)
        } else {
            print("NavitiaSDKPartners/setOfferQuantity : error")
            let error = NavitiaSDKPartnersReturnCode.maxQuantity
            callbackError(error.getCode(), error.getError())
            return
        }
        
        print("NavitiaSDKPartners/setOfferQuantity : success")
        callbackSuccess()
    }
    
    public func getOrderValidation(callbackSuccess : @escaping ([NavitiaBookCartItem]) -> Void, callbackError : @escaping (Int, [String: Any]?) -> Void) {
        
        if cart.isEmpty {
            print("NavitiaSDKPartners/getOrderValidation : error")
            let error = NavitiaSDKPartnersReturnCode.cartEmpty
            callbackError(error.getCode(), error.getError())
            return
        }
        
        NavitiaSDKPartners.shared.refreshToken(callbackSuccess: {
            self.openSession(callbackSuccess: {
                self.addItemsInAPI(callbackSuccess: {
                    print("NavitiaSDKPartners/addToBasket : success")
                    NavitiaSDKPartnersRequestBuilder.get(stringUrl: "\(self._getUrl())/baskets/\(self.cartId)/validation", header: self._getConnectedHeader(), completion: { (success, statusCode, data) in
                        if success {
                            callbackSuccess(self.cart)
                        } else {
                            if NavitiaSDKPartnersReturnCode(rawValue: statusCode) != nil {
                                
                                callbackError(statusCode, NavitiaSDKPartnersReturnCode(rawValue: statusCode)?.getError())
                            } else {
                                
                                callbackError(NavitiaSDKPartnersReturnCode.internalServerError.getCode(), NavitiaSDKPartnersReturnCode.internalServerError.getError())
                            }
                        }
                    })
                }, callbackError: {(statusCode, data) in
                    
                    print("NavitiaSDKPartners/addToBasket : error")
                    var error : NavitiaSDKPartnersReturnCode
                    if statusCode == 400 && ((data!["array"] as! [[String: Any]])[0]["code"] as! Int) == 2002 {
                        error = NavitiaSDKPartnersReturnCode.maximumAmountReached
                        callbackError(error.getCode(), error.getError())
                    } else {
                        if NavitiaSDKPartnersReturnCode(rawValue: statusCode) != nil {
                            
                            callbackError(statusCode, NavitiaSDKPartnersReturnCode(rawValue: statusCode)?.getError())
                        } else {
                            
                            callbackError(NavitiaSDKPartnersReturnCode.internalServerError.getCode(), NavitiaSDKPartnersReturnCode.internalServerError.getError())
                        }
                    }
                })
            }, callbackError: { (statusCode, data) in
                if NavitiaSDKPartnersReturnCode(rawValue: statusCode) != nil {
                    
                    callbackError(statusCode, NavitiaSDKPartnersReturnCode(rawValue: statusCode)?.getError())
                } else {
                    
                    callbackError(NavitiaSDKPartnersReturnCode.internalServerError.getCode(), NavitiaSDKPartnersReturnCode.internalServerError.getError())
                }
            })
        }, callbackError: { (statusCode, data) in
            
            if NavitiaSDKPartnersReturnCode(rawValue: statusCode) != nil {
                
                callbackError(statusCode, NavitiaSDKPartnersReturnCode(rawValue: statusCode)?.getError())
            } else {
                
                callbackError(NavitiaSDKPartnersReturnCode.internalServerError.getCode(), NavitiaSDKPartnersReturnCode.internalServerError.getError())
            }
        })
        
    }
    
    public func resetCart(callbackSuccess : @escaping () -> Void, callbackError : @escaping (Int, [String: Any]?) -> Void) {
        
        cart = []
        print("NavitiaSDKPartners/resetCart : success")
        callbackSuccess()
    }
    
    public func launchPayment(email : String = NavitiaSDKPartners.shared.userInfo.email, color : UIColor = UIColor.white , callbackSuccess: @escaping (String) -> Void, callbackError: @escaping (Int, [String : Any]?) -> Void) {
        
        if NavitiaSDKPartnersExtension.isValidEmail(str: email) == false {
            var data = NavitiaSDKPartnersReturnCode.badParameter.getError()
            var details : [String: Any] = [ : ]
            details["email"] = NavitiaSDKPartnersParameterCode.invalid
            data["details"] = details
            callbackError(NavitiaSDKPartnersReturnCode.badParameter.getCode(), data)
            return
        }
        
        let content : [String: Any] = [ "contactInfo" : [ "firstName": (NavitiaSDKPartners.shared.isAnonymous ? "" :
            NavitiaSDKPartners.shared.userInfo.firstName),
                                                          "lastName": (NavitiaSDKPartners.shared.isAnonymous ? "" :
                                                            NavitiaSDKPartners.shared.userInfo.lastName),
                                                          "email": email,
                                                          "emailconfirmation": email ],
                                        "deliveryMode" : ["type": "M_TICKET_CB2D",
                                                          "label": "M-Ticket",
                                                          "displayOrder": 1,
                                                          "active" : 1,
                                                          "tva" : 0,
                                                          "rate" : 0,
                                                          "delay" : 0,
                                                          "productCode": "0"],
                                        "paymentMean" : [ "label" : "Carte Bancaire",
                                                          "type" : "CB",
                                                          "displayOrder" : 1 ] ]
        NavitiaSDKPartnersRequestBuilder.post(stringUrl: _getUrl() + "/orders", header: _getConnectedHeader(), content: content) { (success, statusCode, data) in
            if success {
                print("NavitiaSDKPartners/createOrder : success")
                if data != nil && data!["referenceOrder"] != nil {
                    self.orderId = (data!["referenceOrder"] as! String)
                }
                NavitiaSDKPartnersRequestBuilder.get(stringUrl: self._getUrl() + "/payment/sogenactif/paymentmeans", header: self._getConnectedHeader(), completion: { (success, statusCode, data) in
                    if success && data != nil {
                        print("NavitiaSDKPartners/launchPayment : success")
                        callbackSuccess(self.customPaymentMeanHTML(htmlCode: data!["paymentMeans"] as! String, color: color))
                    } else {
                        print("NavitiaSDKPartners/launchPayment : error")
                        if NavitiaSDKPartnersReturnCode(rawValue: statusCode) != nil {
                            
                            callbackError(statusCode, NavitiaSDKPartnersReturnCode(rawValue: statusCode)?.getError())
                        } else {
                            
                            callbackError(NavitiaSDKPartnersReturnCode.internalServerError.getCode(), NavitiaSDKPartnersReturnCode.internalServerError.getError())
                        }
                    }
                })
            } else {
                print("NavitiaSDKPartners/createOrder : error")
                if statusCode == 400 && data != nil && ((data!["array"] as! [[String: Any]])[0]["code"] as? Int) == 2000 {
                    let error = NavitiaSDKPartnersReturnCode.cartNotValidated
                    var returnData = error.getError()
                    returnData["details"] = (data!["array"] as! [[String: Any]])[0]
                    callbackError(error.getCode(), returnData)
                    return
                } else if statusCode == 401 {
                    let error = NavitiaSDKPartnersReturnCode.paymentTimeOut
                    callbackError(error.getCode(), error.getError())
                    return
                }
                
                if NavitiaSDKPartnersReturnCode(rawValue: statusCode) != nil {
                    
                    callbackError(statusCode, NavitiaSDKPartnersReturnCode(rawValue: statusCode)?.getError())
                } else {
                    
                    callbackError(NavitiaSDKPartnersReturnCode.internalServerError.getCode(), NavitiaSDKPartnersReturnCode.internalServerError.getError())
                }
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
                                                      title: (rawOffer["label"] as! String),
                                                      shortDescription: NavitiaSDKPartnersExtension.getString(from: (rawOffer["description"] as! String))!,
                                                      price: (((rawOffer["fare"] as! [String: Any])["price"] as! NSNumber).floatValue),
                                                      currency: ((rawOffer["fare"] as! [String: Any])["currency"] as! String),
                                                      maxQuantity: (rawOffer["maxQuantity"] as! Int),
                                                      type: (rawOffer["typeOffer"] as! String) == "PASS" ? NavitiaBookOfferType.Membership : NavitiaBookOfferType.Ticket,
                                                      VATRate: ((rawOffer["fare"] as! [String: Any])["tva"] as! Float),
                                                      saleable: (rawOffer["saleable"] as! Bool),
                                                      displayOrder: (rawOffer["displayOrder"] as! Int),
                                                      legalInfos: NavitiaSDKPartnersExtension.getString(from:(rawOffer["legalInfos"] as! String))!,
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
    
    func customPaymentMeanHTML( htmlCode : String, color : UIColor = UIColor.white ) -> String {
        
        let newHtmlCode = htmlCode.replacingOccurrences(of: "SRC=\"", with: "SRC=\"" + (self._vsctConfiguration?.baseUrl)!)
        
        let before = """
        <HTML lang="fr">
        <BODY style="background-color: rgb(\(Int(color.redValue * 255)), \(Int(color.greenValue * 255)), \(Int(color.blueValue * 255))); height: 100%;">
        <DIV style="height: 100%; width: 100%; display: table;">
        """
        
        let after = """
        </DIV>
        </BODY>
        <SCRIPT>
        document.body.style.margin = 0;
        var formElement = document.querySelector('form');
        if (formElement) {
            formElement.style.height = "100%";
            formElement.style.display = "table-cell";
            formElement.style.verticalAlign = "middle";
        }

        var headerTextElement = document.querySelector('div[align="center"] > img[border="0"]');
        if (headerTextElement && headerTextElement.parentElement) {
            headerTextElement.parentElement.outerHTML = "";
        }

        var intervalImagesElements = document.querySelectorAll('div[align="center"] > img');
        if (intervalImagesElements) {
            for (var i = 0; i < intervalImagesElements.length; i++) {
                intervalImagesElements[i].parentNode.removeChild(intervalImagesElements[i]);
            }
        }

        var interlineElements = document.getElementsByTagName('br');
        if (interlineElements) {
            while (interlineElements.length > 0) {
                interlineElements[0].parentNode.removeChild(interlineElements[0]);
            }
        }
        
        function resizeBankCards() {
            var bankCardInputElements = document.querySelectorAll('input[type="IMAGE"]');
            if (bankCardInputElements && bankCardInputElements.length > 0) {
                var interspaceBetweenBankCards = 10;
                var inputAspectRatio = 1.57;
                var totalBlankSpace = ((bankCardInputElements.length - 1) + 2) * interspaceBetweenBankCards;
                var totalWidth = document.body.clientWidth;
                var totalHeight = document.body.clientHeight;
                var bankCardImageComputedWidth = (totalWidth - totalBlankSpace) / bankCardInputElements.length;
                var bankCardImageComputedHeight = bankCardImageComputedWidth / inputAspectRatio;
                if (bankCardImageComputedHeight > totalHeight) {
                    bankCardImageComputedHeight = totalHeight - 20;
                    bankCardImageComputedWidth = inputAspectRatio * bankCardImageComputedHeight;
                }

                for (var i = 0; i < bankCardInputElements.length; i++) {
                    bankCardInputElements[i].style.width = bankCardImageComputedWidth;
                    if (i != bankCardInputElements.length - 1) {
                        bankCardInputElements[i].style.marginRight = interspaceBetweenBankCards;
                    }
                }
            }
        }

        document.addEventListener("DOMContentLoaded", function(event) {
            resizeBankCards();
        });
        window.onresize = function(event) {
            resizeBankCards();
        }
        </SCRIPT>
        </HTML>
        """
        
        return """
        \(before)
        \(newHtmlCode)
        \(after)
        """
    }
}
