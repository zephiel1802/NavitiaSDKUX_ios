//
//  BookManagementCartItem.swift
//  NavitiaSDKPartners
//
//  Created by Valentin COUSIEN on 22/04/2018.
//  Copyright © 2018 Kisio. All rights reserved.
//

import Foundation

@objc(BookManagementCartItem) public class BookManagementCartItem: NSObject {
    
    public private(set) var bookOffer : BookOffer
    public private(set) var quantity : Int
    
    public var itemPrice : Float {
        get {
            return Float(quantity) * bookOffer.price
        }
    }
    
    public var itemVAT : Float {
        get {
            return Float(quantity) * bookOffer.VAT
        }
    }
    
    func setQuantity(q : Int) {
        quantity = q
    }
    
    init(bookOffer : BookOffer, quantity : Int) {
        
        self.bookOffer = bookOffer
        self.quantity = quantity
    }
}
