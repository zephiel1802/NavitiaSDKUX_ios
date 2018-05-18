//
//  NavitiaSDKPartners.swift
//
//  Created by Valentin COUSIEN on 07/03/2018.
//  Copyright © 2018 Valentin COUSIEN. All rights reserved.
//

import Foundation

@objc(NavitiaSDKPartners) open class NavitiaSDKPartners : NSObject {
    
    private override init() { }
    internal var accountManagement : AccountManagement? = nil
    internal var bookManagement : BookManagement? = nil
    
    @objc public static let shared = NavitiaSDKPartners()
    
    @objc public func getAccountManagement() -> AccountManagement? {
        
        return accountManagement
    }
    
    @objc public func getBookManagement() -> BookManagement? {
        
        return bookManagement
    }
    
    @objc public func initialize( accountConfiguration : AccountManagementConfiguration? = nil,
                                  bookConfiguration : BookManagementConfiguration? = nil) {

        if accountConfiguration != nil {
            setAccountManagement(for: (accountConfiguration?.type)!)?.accountConfiguration = accountConfiguration
        }
        
        if bookConfiguration != nil {
            setBookManagement(for: (bookConfiguration?.type)!)?.bookConfiguration = bookConfiguration
        }
        
    }
    
    func setAccountManagement(for type : AccountManagementType) -> AccountManagement? {
        
        switch type {
        case .Keolis :
            accountManagement = KeolisAccountManagement()
        case .undefined:
            accountManagement = nil
        }
        
        print("NavitiaSDKPartners : Account system set to \(accountManagement?.getAccountManagementName() ?? "undefined")")
        return accountManagement
    }
    
    func setBookManagement(for type: BookManagementType) -> BookManagement? {
        switch type {
        case .VSCT:
            bookManagement = VSCTBookManagement()
        default:
            bookManagement = nil
        }
        
        print("NavitiaSDKPartners : Book system set to \(bookManagement?.getBookManagementName() ?? "undefined")")
        return bookManagement
    }
    
}

extension NavitiaSDKPartners : AccountManagement {
    
    public func refreshToken(callbackSuccess: @escaping () -> Void, callbackError: @escaping (Int, [String : Any]?) -> Void) {
        if accountManagement == nil {
            callbackError(NavitiaSDKPartnersReturnCode.accountManagementNotInit.rawValue, ["error" : "accountManagement not initialized"])
            return
        }
        accountManagement?.refreshToken(callbackSuccess: callbackSuccess, callbackError: callbackError)
    }
    
    public var accessToken : String {
        get {
            if accountManagement == nil {
                return ""
            }
            return accountManagement!.accessToken
        }
    }
    
    public var isConnected : Bool {
        get {
            if accountManagement == nil {
                return false
            }
            return accountManagement!.isConnected
        }
    }
    
    public var isAnonymous : Bool {
        get {
            if accountManagement == nil {
                return false
            }
            return accountManagement!.isAnonymous
        }
    }
    
    public var accountConfiguration: AccountManagementConfiguration? {
        get {
            return (accountManagement?.accountConfiguration)
        }
        set {
            accountManagement?.accountConfiguration = newValue
        }
    }
    
    public var userInfo : NavitiaUserInfo {
        get {
            if accountManagement == nil {
                return KeolisUserInfo()
            }
            return accountManagement!.userInfo
        }
    }
    
    public func createAccount( callbackSuccess: @escaping () -> Void,
                               callbackError: @escaping (Int, [String : Any]?) -> Void) {
        
        if accountManagement == nil {
            callbackError(NavitiaSDKPartnersReturnCode.accountManagementNotInit.rawValue, ["error" : "accountManagement not initialized"])
            return
        }
        accountManagement?.createAccount(callbackSuccess: callbackSuccess, callbackError: callbackError)
    }
    
    public func createAccount( firstName: String, lastName: String, email: String, birthdate: Date?, password: String, courtesy : NavitiaSDKPartnersCourtesy,
                               callbackSuccess: @escaping () -> Void,
                               callbackError: @escaping (Int, [String : Any]?) -> Void) {
        
        if accountManagement == nil {
            callbackError(NavitiaSDKPartnersReturnCode.accountManagementNotInit.rawValue, ["error" : "accountManagement not initialized"])
            return
        }
        accountManagement?.createAccount(firstName: firstName, lastName: lastName, email: email, birthdate: birthdate, password: password, courtesy : courtesy, callbackSuccess: callbackSuccess, callbackError: callbackError)
    }
    
    public func transformAccount(firstName: String, lastName: String, email: String, birthdate: Date?, password: String, courtesy : NavitiaSDKPartnersCourtesy, callbackSuccess: @escaping () -> Void, callbackError: @escaping (Int, [String : Any]?) -> Void) {
        
        if accountManagement == nil {
            callbackError(NavitiaSDKPartnersReturnCode.accountManagementNotInit.rawValue, ["error" : "accountManagement not initialized"])
            return
        }
        accountManagement?.transformAccount(firstName: firstName, lastName: lastName, email: email, birthdate: birthdate, password: password, courtesy : courtesy, callbackSuccess: callbackSuccess, callbackError: callbackError)
    }
    
    public func activateAccount( internetAccountId: String, token: String,
                                 callbackSuccess: @escaping () -> Void,
                                 callbackError: @escaping (Int, [String : Any]?) -> Void) {
        if accountManagement == nil {
            callbackError(NavitiaSDKPartnersReturnCode.accountManagementNotInit.rawValue, ["error" : "accountManagement not initialized"])
            return
        }
        accountManagement?.activateAccount(internetAccountId: internetAccountId, token: token, callbackSuccess: callbackSuccess, callbackError: callbackError)
    }
    
    public func authenticate( username: String, password: String,
                              callbackSuccess : @escaping () -> Void,
                              callbackError : @escaping (Int, [String: Any]?) -> Void) {
        if accountManagement == nil {
            callbackError(NavitiaSDKPartnersReturnCode.accountManagementNotInit.rawValue, ["error" : "accountManagement not initialized"])
            return
        }
        accountManagement?.authenticate( username: username, password: password,
                                         callbackSuccess: callbackSuccess,
                                         callbackError: callbackError)
    }
    
    public func logOut( callbackSuccess : @escaping () -> Void,
                        callbackError : @escaping (Int, [String: Any]?) -> Void) {
        if accountManagement == nil {
            callbackError(NavitiaSDKPartnersReturnCode.accountManagementNotInit.rawValue, ["error" : "accountManagement not initialized"])
            return
        }
        accountManagement?.logOut(callbackSuccess: callbackSuccess, callbackError: callbackError)
    }
    
    public func resetPassword( email: String,
                               callbackSuccess: @escaping () -> Void,
                               callbackError: @escaping (Int, [String : Any]?) -> Void) {
        if accountManagement == nil {
            callbackError(NavitiaSDKPartnersReturnCode.accountManagementNotInit.rawValue, ["error" : "accountManagement not initialized"])
            return
        }
        accountManagement?.resetPassword(email: email, callbackSuccess: callbackSuccess, callbackError: callbackError)
    }
    
    public func updatePassword( oldPassword : String, newPassword: String,
                                callbackSuccess: @escaping () -> Void,
                                callbackError: @escaping (Int, [String : Any]?) -> Void) {
        if accountManagement == nil {
            callbackError(NavitiaSDKPartnersReturnCode.accountManagementNotInit.rawValue, ["error" : "accountManagement not initialized"])
            return
        }
        accountManagement?.updatePassword(oldPassword : oldPassword, newPassword: newPassword, callbackSuccess: callbackSuccess, callbackError: callbackError)
    }
    
    public func getAccountManagementName() -> String {
        
        return (accountManagement?.getAccountManagementName())!
    }
    
    public func getAccountManagementType() -> AccountManagementType {
        
        return (accountManagement?.getAccountManagementType())!
    }
    
    public func getUserInfo( callbackSuccess : @escaping (NavitiaUserInfo) -> Void,
                             callbackError : @escaping (Int, [String: Any]?) -> Void) {
        if accountManagement == nil {
            callbackError(NavitiaSDKPartnersReturnCode.accountManagementNotInit.rawValue, ["error" : "accountManagement not initialized"])
            return
        }
        accountManagement?.getUserInfo(callbackSuccess: callbackSuccess, callbackError: callbackError)
    }
    
    public func updateInfo(firstName: String = "", lastName: String = "", email: String = "", birthdate: Date? = nil, courtesy: NavitiaSDKPartnersCourtesy = .Unknown, callbackSuccess: @escaping () -> Void, callbackError: @escaping (Int, [String : Any]?) -> Void) {
        
        if accountManagement == nil {
            callbackError(NavitiaSDKPartnersReturnCode.accountManagementNotInit.rawValue, ["error" : "accountManagement not initialized"])
            return
        }
        accountManagement?.updateInfo(firstName: firstName, lastName: lastName, email: email, birthdate: birthdate, courtesy: courtesy, callbackSuccess: callbackSuccess, callbackError: callbackError)
    }
    
    public func sendActivationEmail(callbackSuccess: @escaping () -> Void, callbackError: @escaping (Int, [String : Any]?) -> Void) {
        
        if accountManagement == nil {
            callbackError(NavitiaSDKPartnersReturnCode.accountManagementNotInit.rawValue, ["error" : "accountManagement not initialized"])
            return
        }
        accountManagement?.sendActivationEmail(callbackSuccess: callbackSuccess, callbackError: callbackError)
    }
}

extension NavitiaSDKPartners : BookManagement {
    
    public var orderId: String {
        get {
            if bookManagement == nil {
                return ""
            }
            return bookManagement!.orderId
        }
    }
    
    public var paymentBaseUrl: String {
        get {
            if bookManagement == nil {
                return ""
            }
            return bookManagement!.paymentBaseUrl
        }
    }
    
    public var cart: [NavitiaBookCartItem] {
        get {
            if bookManagement == nil {
                return [ ]
            }
            return bookManagement!.cart
        }
    }
    
    public var cartTotalVAT : NavitiaSDKPartnersPrice {
        get {
            if bookManagement == nil {
                return NavitiaSDKPartnersPrice()
            }
            return bookManagement!.cartTotalVAT
        }
    }
    
    public var cartTotalPrice : NavitiaSDKPartnersPrice {
        get {
            if bookManagement == nil {
                return NavitiaSDKPartnersPrice()
            }
            return bookManagement!.cartTotalPrice
        }
    }

    public var bookConfiguration: BookManagementConfiguration? {
        get {
            return (bookManagement?.bookConfiguration)
        }
        set {
            bookManagement?.bookConfiguration = newValue
        }
    }
    
    public func getBookManagementName() -> String {
        
        if bookManagement == nil {
            return "undefined"
        }
        return (bookManagement?.getBookManagementName())!
    }
    
    public func getBookManagementType() -> BookManagementType {
        
        if bookManagement == nil {
            return .undefined
        }
        return (bookManagement?.getBookManagementType())!
    }
    
    public func getOffers(callbackSuccess: @escaping ([NavitiaBookOffer]) -> Void, callbackError: @escaping (Int, [String : Any]?) -> Void) {
        
        if bookManagement == nil {
            let error = NavitiaSDKPartnersReturnCode.bookManagementNotInit
            callbackError(error.getCode(), error.getError())
            return
        }
        bookManagement?.getOffers(callbackSuccess: callbackSuccess, callbackError: callbackError)
    }
    
    public func getOffers(offerType: NavitiaBookOfferType, callbackSuccess: @escaping ([NavitiaBookOffer]) -> Void, callbackError: @escaping (Int, [String : Any]?) -> Void) {
        
        if bookManagement == nil {
            let error = NavitiaSDKPartnersReturnCode.bookManagementNotInit
            callbackError(error.getCode(), error.getError())
            return
        }
        bookManagement?.getOffers(offerType: offerType, callbackSuccess: callbackSuccess, callbackError: callbackError)
    }
    public func addOffer(offerId: String, callbackSuccess: @escaping () -> Void, callbackError: @escaping (Int, [String : Any]?) -> Void) {
        
        if bookManagement == nil {
            let error = NavitiaSDKPartnersReturnCode.bookManagementNotInit
            callbackError(error.getCode(), error.getError())
            return
        }
        bookManagement?.addOffer(offerId: offerId, callbackSuccess: callbackSuccess, callbackError: callbackError)
    }
    
    public func removeOffer(offerId: String, callbackSuccess: @escaping () -> Void, callbackError: @escaping (Int, [String : Any]?) -> Void) {
        
        if bookManagement == nil {
            let error = NavitiaSDKPartnersReturnCode.bookManagementNotInit
            callbackError(error.getCode(), error.getError())
            return
        }
        bookManagement?.removeOffer(offerId: offerId, callbackSuccess: callbackSuccess, callbackError: callbackError)
    }
    
    public func setOfferQuantity(offerId: String, quantity: Int, callbackSuccess: @escaping () -> Void, callbackError: @escaping (Int, [String : Any]?) -> Void) {
        
        if bookManagement == nil {
            let error = NavitiaSDKPartnersReturnCode.bookManagementNotInit
            callbackError(error.getCode(), error.getError())
            return
        }
        bookManagement?.setOfferQuantity(offerId: offerId, quantity: quantity, callbackSuccess: callbackSuccess, callbackError: callbackError)
    }
    
    public func getOrderValidation(callbackSuccess : @escaping ([NavitiaBookCartItem]) -> Void, callbackError : @escaping (Int, [String: Any]?) -> Void) {
        
        if bookManagement == nil {
            let error = NavitiaSDKPartnersReturnCode.bookManagementNotInit
            callbackError(error.getCode(), error.getError())
            return
        }
        bookManagement?.getOrderValidation(callbackSuccess : callbackSuccess, callbackError : callbackError)
    }
    
    public func resetCart(callbackSuccess: @escaping () -> Void, callbackError: @escaping (Int, [String : Any]?) -> Void) {
        
        if bookManagement == nil {
            let error = NavitiaSDKPartnersReturnCode.bookManagementNotInit
            callbackError(error.getCode(), error.getError())
            return
        }
        bookManagement?.resetCart(callbackSuccess: callbackSuccess, callbackError: callbackError)
    }
    
    public func launchPayment(email : String = NavitiaSDKPartners.shared.userInfo.email, color: UIColor = UIColor.white, callbackSuccess: @escaping (String) -> Void, callbackError: @escaping (Int, [String : Any]?) -> Void) {
        
        if bookManagement == nil {
            let error = NavitiaSDKPartnersReturnCode.bookManagementNotInit
            callbackError(error.getCode(), error.getError())
            return
        }
        bookManagement?.launchPayment(email : email, color : color, callbackSuccess: callbackSuccess, callbackError: callbackError)
    }
}
