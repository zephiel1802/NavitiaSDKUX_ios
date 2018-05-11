//
//  BookManagement.swift
//  NavitiaSDKPartners
//
//  Created by Valentin COUSIEN on 18/04/2018.
//  Copyright © 2018 Kisio. All rights reserved.
//

import Foundation

@objc(BookManagement) public protocol BookManagement {

    var bookConfiguration : BookManagementConfiguration? { get set }
    var cart : [BookManagementCartItem] { get }
    var orderId : String { get }
    var paymentBaseUrl : String { get }
    var cartTotalPrice : NavitiaSDKPartnersPrice { get }
    var cartTotalVAT : NavitiaSDKPartnersPrice { get }
    
    func getBookManagementName() -> String
    func getBookManagementType() -> BookManagementType
    
    func getOffers(callbackSuccess : @escaping ([BookOffer]) -> Void, callbackError : @escaping (Int, [String: Any]?) -> Void)
    func getOffers(offerType: BookOfferType, callbackSuccess: @escaping ([BookOffer]) -> Void, callbackError: @escaping (Int, [String: Any]?) -> Void)
    func addOffer(offerId: String, callbackSuccess: @escaping () -> Void, callbackError : @escaping (Int, [String: Any]?) -> Void)
    func removeOffer(offerId: String, callbackSuccess: @escaping () -> Void, callbackError: @escaping (Int, [String: Any]?) -> Void)
    func setOfferQuantity(offerId: String, quantity: Int, callbackSuccess: @escaping () -> Void, callbackError: @escaping (Int, [String: Any]?) -> Void)
    func getOrderValidation(callbackSuccess : @escaping ([BookManagementCartItem]) -> Void, callbackError : @escaping (Int, [String: Any]?) -> Void)
    func resetCart(callbackSuccess: @escaping () -> Void, callbackError : @escaping (Int, [String: Any]?) -> Void)
    func launchPayment(email : String, color : UIColor, callbackSuccess : @escaping (String) -> Void, callbackError: @escaping (Int, [String: Any]?) -> Void)
}
