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
    var cartTotalPrice : Float { get }
    var cartTotalVAT : Float { get }
    
    func getBookManagementName() -> String
    func getBookManagementType() -> BookManagementType
    
    func getOffers(callbackSuccess : @escaping ([BookOffer]?) -> Void, callbackError : @escaping (Int, [String: Any]?) -> Void)
    func getOffers(offerType: BookOfferType, callbackSuccess: @escaping ([BookOffer]?) -> Void, callbackError: @escaping (Int, [String: Any]?) -> Void)
    func addOffer(offerId: String, callbackSuccess: @escaping () -> Void, callbackError : @escaping (Int, [String: Any]?) -> Void)
    func removeOffer(offerId: String, callbackSuccess: @escaping () -> Void, callbackError: @escaping (Int, [String: Any]?) -> Void)
    func setOfferQuantity(offerId: String, quantity: Int, callbackSuccess: @escaping () -> Void, callbackError: @escaping (Int, [String: Any]?) -> Void)
    
}
