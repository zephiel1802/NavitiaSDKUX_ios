//
//  NavitiaSDKPartnersReturnCodes.swift
//  NavitiaSDKPartners
//
//  Created by Valentin COUSIEN on 03/04/2018.
//  Copyright © 2018 Kisio. All rights reserved.
//

@objc public enum NavitiaSDKPartnersReturnCode : Int {
    
    case notLogged = 9001 // no account connected
    case notConnected = 9002 // no internet connection
    case internalError = 9003 // error in sdk request
    case accountManagementNotInit = 9004 // at this moment, the account management is not initialized
    case badParameter = 9005 // your parameters are not valid
    case timeOut = 9006 // request timed out, default time 20sec
    case invalidGrant = 9007 // authenticate error : invalid grant
    case infoAlreadyUsed = 9008 // createAccount error : info already used
    case bookManagementNotInit = 9009 // at this moment, the book management is not initialized
    case notMatchingAccount = 9010 // credential not matching any account
    case wrongOfferId = 9011 // offerId passed to function is not matching any offer
    case offerNotSaleable = 9012 // offer is not saleable or maxQuantity == 0
    case maxQuantity = 9013 // can't add to cart, already maxed
    case notInCart = 9014 // trying to remove an offer not in cart
    case cartNotValidated = 9015 // cart was not validated
    case cartEmpty = 9016 // cart is empty
    case ticketManagementNotInit = 9017 // at this moment, the ticket management is not initialized
    case masabiDeviceChangeError = 9018 // masabi error on sync wallet, warn user device change credit will be used
    case masabiNoDeviceChangeCredit = 9019 // masabi error on sync wallet, user don't any device change token left
    case passwordInvalid = 9020 // on update password, old password is not matching current password
    case paymentTimeOut = 9021 // if you take too much time between validation and payment
    case maximumAmountReached = 9022 // Cart total is too big at validation time
    case masabiAuthenticateError = 9023 // Masabi authenticate error
    case failedToMigrate = 9024 // fail on migration

    public static let all: [String: Int] = [
        "notLogged" : notLogged.rawValue,
        "notConnected" : notConnected.rawValue,
        "internalError" : internalError.rawValue,
        "accountManagementNotInit" : accountManagementNotInit.rawValue,
        "badParameter" : badParameter.rawValue,
        "timeOut" : timeOut.rawValue,
        "invalidGrant" : invalidGrant.rawValue,
        "passwordInvalid" : passwordInvalid.rawValue,
        "infoAlreadyUsed" : infoAlreadyUsed.rawValue,
        "bookManagementNotInit" : bookManagementNotInit.rawValue,
        "notMatchingAccount" : notMatchingAccount.rawValue,
        "wrongOfferId" : wrongOfferId.rawValue,
        "offerNotSaleable" : offerNotSaleable.rawValue,
        "maxQuantity" : maxQuantity.rawValue,
        "notInCart" : notInCart.rawValue,
        "cartNotValidated" : cartNotValidated.rawValue,
        "cartEmpty" : cartEmpty.rawValue,
        "ticketManagementNotInit" : ticketManagementNotInit.rawValue,
        "masabiDeviceChangeError" : masabiDeviceChangeError.rawValue,
        "masabiNoDeviceChangeCredit" : masabiNoDeviceChangeCredit.rawValue,
        "paymentTimeOut" : paymentTimeOut.rawValue,
        "masabiAuthenticateError" : masabiAuthenticateError.rawValue,
        "failedToMigrate" : failedToMigrate.rawValue,
        "maximumAmountReached" : maximumAmountReached.rawValue
    ]
    
    func getError() -> [String: Any] {
        var error : [String: Any] = [ : ]
        switch self {
        case .notLogged:
            error["error"] = "Not logged"
            break
        case .notConnected:
            error["error"] = "Not connected"
            break
        case .internalError:
            error["error"] = "Internal error"
            break
        case .accountManagementNotInit:
            error["error"] = "Account Management not init"
            break
        case .badParameter:
            error["error"] = "Bad parameter"
            break
        case .timeOut:
            error["error"] = "Request timed out"
            break
        case .passwordInvalid:
            error["error"] = "Password invalid"
            break
        case .invalidGrant:
            error["error"] = "Invalid grant"
            break
        case .infoAlreadyUsed:
            error["error"] = "Credential already used"
            break
        case .bookManagementNotInit:
            error["error"] = "Book Management not init"
            break
        case .notMatchingAccount:
            error["error"] = "Not matching account"
            break
        case .wrongOfferId:
            error["error"] = "Wrong offer ID"
            break
        case .offerNotSaleable:
            error["error"] = "Offer not saleable"
            break
        case .maxQuantity:
            error["error"] = "Max quantity"
            break
        case .notInCart:
            error["error"] = "Not in cart"
            break
        case .cartNotValidated:
            error["error"] = "Cart not validated"
            break
        case .cartEmpty:
            error["error"] = "Cart empty"
            break
        case .ticketManagementNotInit:
            error["error"] = "Ticket management not init"
            break
        case .masabiDeviceChangeError:
            error["error"] = "Masabi/Warning : Warning device changed"
            break
        case .masabiNoDeviceChangeCredit:
            error["error"] = "Masabi/Error : No device change credit"
            break
        case .paymentTimeOut:
            error["error"] = "Payment timed out"
            break
        case .maximumAmountReached:
            error["error"] = "Maximum amount reached"
            break
        case .masabiAuthenticateError:
            error["error"] = "Masabi authenticate error"
            break
        case .failedToMigrate:
            error["error"] = "Failed to migrate"
            break
        }
        return error
    }
    
    func getCode() -> Int {
        return self.rawValue
    }
}
