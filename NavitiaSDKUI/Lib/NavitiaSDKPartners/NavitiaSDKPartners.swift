//
//  NavitiaSDKPartners.swift
//
//  Created by Valentin COUSIEN on 07/03/2018.
//  Copyright © 2018 Valentin COUSIEN. All rights reserved.
//

import Foundation

@objc public enum Environnement : Int {
    case Preprod
    case Prod
}

@objc(NavitiaSDKPartners) open class NavitiaSDKPartners : NSObject {
    
    private override init() { }
    
    public var environnement : Environnement = .Preprod
    
    internal var accountManagement : AccountManagement? = nil
    internal var bookManagement : BookManagement? = nil
    internal var ticketManagement : TicketManagement? = nil
    
    
    @objc public static let shared = NavitiaSDKPartners() // Entry point of SDK (singleton : NavitiaSDKPartners.shared)

    
    @objc public func getAccountManagement() -> AccountManagement? {
        
        return accountManagement
    }
    
    @objc public func getBookManagement() -> BookManagement? {
        
        return bookManagement
    }
    
    @objc public func getTicketManagement() -> TicketManagement? {
        
        return ticketManagement
    }
    
    // Initialization of the whole SDK
    @objc public func initialize( accountConfiguration : AccountManagementConfiguration? = nil,
                                  bookConfiguration : BookManagementConfiguration? = nil,
                                  ticketConfiguration : TicketManagementConfiguration? = nil) {

        if accountConfiguration != nil {
            setAccountManagement(for: (accountConfiguration?.type)!)?.accountConfiguration = accountConfiguration
        }
        
        if bookConfiguration != nil {
            setBookManagement(for: (bookConfiguration?.type)!)?.bookConfiguration = bookConfiguration
        }
        
        if ticketConfiguration != nil {
            setTicketManagement(for: (ticketConfiguration?.type)!)?.ticketConfiguration = ticketConfiguration
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
    
    func setTicketManagement(for type: TicketManagementType) -> TicketManagement? {
        switch type {
        case .Masabi:
            ticketManagement = MasabiTicketManagement()
        default:
            ticketManagement = nil
        }
        
        print("NavitiaSDKPartners : Ticket system set to \(ticketManagement?.getTicketManagementName() ?? "undefined")")
        return ticketManagement
    }
}

extension NavitiaSDKPartners : AccountManagement { // Implementation of AccountManagement protocol, allow to call protocol directly from shared instance (singleton)
    
    public func getAccountManagementName() -> String {
        
        return (accountManagement?.getAccountManagementName())!
    }
    
    public func getAccountManagementType() -> AccountManagementType {
        
        return (accountManagement?.getAccountManagementType())!
    }
    
    public var accessToken : String { // Need to be gettable due to Masabi Log In using it
        get {
            if accountManagement == nil {
                return ""
            }
            return accountManagement!.accessToken
        }
    }
    
    public var isConnected : Bool { // Return true if user is logged in
        get {
            if accountManagement == nil {
                return false
            }
            return accountManagement!.isConnected
        }
    }
    
    public var isAnonymous : Bool { // Return true if user is connected and using an anonymous account
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
            let error = NavitiaSDKPartnersReturnCode.accountManagementNotInit
            callbackError(error.getCode(), error.getError())
            return
        }
        accountManagement?.createAccount(callbackSuccess: callbackSuccess, callbackError: callbackError)
    }
    
    public func createAccount( firstName: String, lastName: String, email: String, birthdate: Date?, password: String, courtesy : NavitiaSDKPartnersCourtesy,
                               callbackSuccess: @escaping () -> Void,
                               callbackError: @escaping (Int, [String : Any]?) -> Void) {
        
        if accountManagement == nil {
            let error = NavitiaSDKPartnersReturnCode.accountManagementNotInit
            callbackError(error.getCode(), error.getError())
            return
        }
        accountManagement?.createAccount(firstName: firstName, lastName: lastName, email: email, birthdate: birthdate, password: password, courtesy : courtesy, callbackSuccess: callbackSuccess, callbackError: callbackError)
    }
    
    public func transformAccount(firstName: String, lastName: String, email: String, birthdate: Date?, password: String, courtesy : NavitiaSDKPartnersCourtesy, callbackSuccess: @escaping () -> Void, callbackError: @escaping (Int, [String : Any]?) -> Void) {
        
        if accountManagement == nil {
            let error = NavitiaSDKPartnersReturnCode.accountManagementNotInit
            callbackError(error.getCode(), error.getError())
            return
        }
        accountManagement?.transformAccount(firstName: firstName, lastName: lastName, email: email, birthdate: birthdate, password: password, courtesy : courtesy, callbackSuccess: callbackSuccess, callbackError: callbackError)
    }
    
    public func activateAccount( internetAccountId: String, token: String,
                                 callbackSuccess: @escaping () -> Void,
                                 callbackError: @escaping (Int, [String : Any]?) -> Void) {
        if accountManagement == nil {
            let error = NavitiaSDKPartnersReturnCode.accountManagementNotInit
            callbackError(error.getCode(), error.getError())
            return
        }
        accountManagement?.activateAccount(internetAccountId: internetAccountId, token: token, callbackSuccess: callbackSuccess, callbackError: callbackError)
    }
    
    public func authenticate( username: String, password: String,
                              callbackSuccess : @escaping () -> Void,
                              callbackError : @escaping (Int, [String: Any]?) -> Void) {
        if accountManagement == nil {
            let error = NavitiaSDKPartnersReturnCode.accountManagementNotInit
            callbackError(error.getCode(), error.getError())
            return
        }
        accountManagement?.authenticate( username: username, password: password,
                                         callbackSuccess: callbackSuccess,
                                         callbackError: callbackError)
    }
    
    public func refreshToken(callbackSuccess: @escaping () -> Void, callbackError: @escaping (Int, [String : Any]?) -> Void) {
        if accountManagement == nil {
            let error = NavitiaSDKPartnersReturnCode.accountManagementNotInit
            callbackError(error.getCode(), error.getError())
            return
        }
        accountManagement?.refreshToken(callbackSuccess: callbackSuccess, callbackError: callbackError)
    }
    
    public func logOut( callbackSuccess : @escaping () -> Void,
                        callbackError : @escaping (Int, [String: Any]?) -> Void) {
        if accountManagement == nil {
            let error = NavitiaSDKPartnersReturnCode.accountManagementNotInit
            callbackError(error.getCode(), error.getError())
            return
        }
        accountManagement?.logOut(callbackSuccess: callbackSuccess, callbackError: callbackError)
    }
    
    public func resetPassword( email: String,
                               callbackSuccess: @escaping () -> Void,
                               callbackError: @escaping (Int, [String : Any]?) -> Void) {
        if accountManagement == nil {
            let error = NavitiaSDKPartnersReturnCode.accountManagementNotInit
            callbackError(error.getCode(), error.getError())
            return
        }
        accountManagement?.resetPassword(email: email, callbackSuccess: callbackSuccess, callbackError: callbackError)
    }
    
    public func updatePassword( oldPassword : String, newPassword: String,
                                callbackSuccess: @escaping () -> Void,
                                callbackError: @escaping (Int, [String : Any]?) -> Void) {
        if accountManagement == nil {
            let error = NavitiaSDKPartnersReturnCode.accountManagementNotInit
            callbackError(error.getCode(), error.getError())
            return
        }
        accountManagement?.updatePassword(oldPassword : oldPassword, newPassword: newPassword, callbackSuccess: callbackSuccess, callbackError: callbackError)
    }
    
    public func getUserInfo( callbackSuccess : @escaping (NavitiaUserInfo) -> Void,
                             callbackError : @escaping (Int, [String: Any]?) -> Void) {
        if accountManagement == nil {
            let error = NavitiaSDKPartnersReturnCode.accountManagementNotInit
            callbackError(error.getCode(), error.getError())
            return
        }
        accountManagement?.getUserInfo(callbackSuccess: callbackSuccess, callbackError: callbackError)
    }
    
    public func updateInfo( firstName : String = "", lastName : String = "", email : String = "", birthdate : Date? = nil, courtesy : NavitiaSDKPartnersCourtesy = .Unknown,
                            callbackSuccess: @escaping () -> Void,
                            callbackError: @escaping (Int, [String : Any]?) -> Void) {
        
        if accountManagement == nil {
            let error = NavitiaSDKPartnersReturnCode.accountManagementNotInit
            callbackError(error.getCode(), error.getError())
            return
        }
        accountManagement?.updateInfo(firstName: firstName, lastName: lastName, email: email, birthdate: birthdate, courtesy: courtesy, callbackSuccess: callbackSuccess, callbackError: callbackError)
    }
    
    public func sendActivationEmail(callbackSuccess: @escaping () -> Void, callbackError: @escaping (Int, [String : Any]?) -> Void) {
        
        if accountManagement == nil {
            let error = NavitiaSDKPartnersReturnCode.accountManagementNotInit
            callbackError(error.getCode(), error.getError())
            return
        }
        accountManagement?.sendActivationEmail(callbackSuccess: callbackSuccess, callbackError: callbackError)
    }
}

extension NavitiaSDKPartners : BookManagement {
    
    public var paymentBaseUrl: String {
        if bookManagement == nil {
            return ""
        }
        return bookManagement!.paymentBaseUrl
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
    
    public var orderId: String {
        get {
            if bookManagement == nil {
                return ""
            }
            return bookManagement!.orderId
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

extension NavitiaSDKPartners : TicketManagement {
    
    public var hasValidTickets: Bool {
        
        if ticketManagement == nil {
            return false
        }
        return ticketManagement!.hasValidTickets
    }
    
    public func getTicketManagementName() -> String {
        
        if ticketManagement == nil {
            return ""
        }
        return (ticketManagement?.getTicketManagementName())!
    }
    
    public func getTicketManagementType() -> TicketManagementType {
        
        if ticketManagement == nil {
            return .undefined
        }
        return (ticketManagement?.getTicketManagementType())!
    }
   
    public var ticketConfiguration: TicketManagementConfiguration? {
        get {
            return (ticketManagement?.ticketConfiguration)
        }
        set {
            ticketManagement?.ticketConfiguration = newValue
        }
    }
    
    public func syncWallet(callbackSuccess: @escaping () -> Void, callbackError: @escaping (Int, [String : Any]?) -> Void) {
        
        if ticketManagement == nil {
            let error = NavitiaSDKPartnersReturnCode.ticketManagementNotInit
            callbackError(error.getCode(), error.getError())
            return
        }
        ticketManagement?.syncWallet(callbackSuccess: callbackSuccess, callbackError: callbackError)
    }
    
    public func showWallet(callbackSuccess: @escaping (UIViewController) -> Void, callbackError: @escaping (Int, [String : Any]?) -> Void) {
        
        if ticketManagement == nil {
            let error = NavitiaSDKPartnersReturnCode.ticketManagementNotInit
            callbackError(error.getCode(), error.getError())
            return
        }
        ticketManagement?.showWallet(callbackSuccess: callbackSuccess, callbackError: callbackError)
    }
    
}
