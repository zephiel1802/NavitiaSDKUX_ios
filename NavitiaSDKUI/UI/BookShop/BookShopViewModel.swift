//
//  BookShopViewModel.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class BookShopViewModel: NSObject {
    
    public var bookShopDidChange: ((BookShopViewModel) -> ())?
    public private(set) var loading: Bool = true
    
    var bookOffer = [[VSCTBookOffer]]() {
        didSet {
            bookShopDidChange!(self)
        }
    }
    
    func request() {
        loading = true
        NavitiaSDKPartners.shared.getOffers(callbackSuccess: { (offersArray) in
            self.bookOffer.append(offersArray.filter { ($0 as! VSCTBookOffer).type == .Ticket } as! [VSCTBookOffer])
            self.bookOffer.append(offersArray.filter { ($0 as! VSCTBookOffer).type == .Membership } as! [VSCTBookOffer])
            self.loading = false
        }) {(statusCode, data) in
            self.loading = false
        }
    }
    
}
