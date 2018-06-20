//
//  BookManagement.swift
//  NavitiaSDKPartners
//
//  Created by Valentin COUSIEN on 18/04/2018.
//  Copyright © 2018 Kisio. All rights reserved.
//

import Foundation

@objc(BookManagement) public protocol BookManagement {

    func getBookManagementName() -> String
    func getBookManagementType() -> BookManagementType
    
    var bookConfiguration : BookManagementConfiguration? { get set }
    var paymentBaseUrl : String { get }
    var cart : [NavitiaBookCartItem] { get } // Real time updated
    var orderId : String { get } // Order id 
    var cartTotalPrice : NavitiaSDKPartnersPrice { get }
    var cartTotalVAT : NavitiaSDKPartnersPrice { get }
    
    func getOffers( callbackSuccess : @escaping ([NavitiaBookOffer]) -> Void,
                    callbackError : @escaping (Int, [String: Any]?) -> Void)
    
    func getOffers( offerType: NavitiaBookOfferType,
                    callbackSuccess: @escaping ([NavitiaBookOffer]) -> Void,
                    callbackError: @escaping (Int, [String: Any]?) -> Void)
    
    func addOffer(  offerId: String,
                    callbackSuccess: @escaping () -> Void,
                    callbackError : @escaping (Int, [String: Any]?) -> Void)
    
    func removeOffer(   offerId: String,
                        callbackSuccess: @escaping () -> Void,
                        callbackError: @escaping (Int, [String: Any]?) -> Void)
    
    func setOfferQuantity(  offerId: String, quantity: Int,
                            callbackSuccess: @escaping () -> Void,
                            callbackError: @escaping (Int, [String: Any]?) -> Void)
    
    func getOrderValidation(    callbackSuccess : @escaping ([NavitiaBookCartItem]) -> Void,
                                callbackError : @escaping (Int, [String: Any]?) -> Void)
    
    func resetCart( callbackSuccess: @escaping () -> Void,
                    callbackError : @escaping (Int, [String: Any]?) -> Void)
    
    func launchPayment( email : String, color : UIColor,
                        callbackSuccess : @escaping (String) -> Void,
                        callbackError: @escaping (Int, [String: Any]?) -> Void)
}
