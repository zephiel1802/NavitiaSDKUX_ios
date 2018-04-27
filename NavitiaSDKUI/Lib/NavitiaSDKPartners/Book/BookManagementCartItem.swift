//
//  BookManagementCartItem.swift
//  NavitiaSDKPartners
//
//  Created by Valentin COUSIEN on 22/04/2018.
//  Copyright © 2018 Kisio. All rights reserved.
//

import Foundation

@objc(BookManagementCartItem) public class BookManagementCartItem: NSObject {
    
    var bookOffer : BookOffer
    var quantity : Int
    
    init(bookOffer : BookOffer, quantity : Int) {
        
        self.bookOffer = bookOffer
        self.quantity = quantity
    }
}
