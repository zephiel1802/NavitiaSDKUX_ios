//
//  NavitiaSDKPartners.swift
//
//  Created by Valentin COUSIEN on 07/03/2018.
//  Copyright © 2018 Valentin COUSIEN. All rights reserved.
//

import Foundation

@objc(NavitiaSDKPartners) public class NavitiaSDKPartners : NSObject {
    
    private override init() { }
    internal var accountManagement : AccountManagement? = nil
    internal var bookManagement : BookManagement? = nil
    
    public static let shared = NavitiaSDKPartners()
    
    @objc public func getAccountManagement() -> AccountManagement? {
        
        return accountManagement
    }
    
    @objc public func getBookManagement() -> BookManagement? {
        
        return bookManagement
    }
    
    @objc public func initialize(accountConfiguration : AccountManagementConfiguration?, bookConfiguration : BookManagementConfiguration?) {

        if accountConfiguration != nil {
            setAccountManagement(for: (accountConfiguration?.type)!)?.configuration = accountConfiguration
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
    
    public var configuration: AccountManagementConfiguration? {
        get {
            return (accountManagement?.configuration)
        }
        set {
            accountManagement?.configuration = newValue
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
    
    public var cart: [BookManagementCartItem] {
        get {
            if bookManagement == nil {
                return [ ]
            }
            return bookManagement!.cart
        }
    }
    
    public var cartTotalVAT : Float {
        get {
            if bookManagement == nil {
                return 0.0
            }
            return bookManagement!.cartTotalVAT
        }
    }
    
    public var cartTotalPrice : Float {
        get {
            if bookManagement == nil {
                return 0.0
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
    
    public func getOffers(callbackSuccess: @escaping ([BookOffer]?) -> Void, callbackError: @escaping (Int, [String : Any]?) -> Void) {
        
        if bookManagement == nil {
            let error = NavitiaSDKPartnersReturnCode.bookManagementNotInit
            callbackError(error.getCode(), error.getError())
            return
        }
        bookManagement?.getOffers(callbackSuccess: callbackSuccess, callbackError: callbackError)
    }
    
    public func getOffers(offerType: BookOfferType, callbackSuccess: @escaping ([BookOffer]?) -> Void, callbackError: @escaping (Int, [String : Any]?) -> Void) {
        
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
}
