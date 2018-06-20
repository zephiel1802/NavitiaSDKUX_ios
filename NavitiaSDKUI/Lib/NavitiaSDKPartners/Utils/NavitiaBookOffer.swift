//
//  BookOffer.swift
//  NavitiaSDKPartners
//
//  Created by Valentin COUSIEN on 19/04/2018.
//  Copyright © 2018 Kisio. All rights reserved.
//

import Foundation

@objc(NavitiaBookOffer) public protocol NavitiaBookOffer {
    
    var id : String { get }
    var productId : String { get }
    var title : String { get }
    var shortDescription : String { get }
    var price : Float { get }
    var currency : String { get }
    var maxQuantity : Int { get }
    var type : NavitiaBookOfferType { get }
    var VATRate : Float { get }
    var saleable : Bool { get }
    var displayOrder : Int { get }
    var legalInfos : String { get }
    var VAT : Float { get }
    
    func toDictionnary() -> [String: Any]
}
