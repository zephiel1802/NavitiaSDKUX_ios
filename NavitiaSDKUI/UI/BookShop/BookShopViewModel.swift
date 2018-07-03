//
//  BookShopViewModel.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class BookShopViewModel: NSObject {
    
    public var bookShopDidChange: ((BookShopViewModel) -> ())?
    public var bookShopDisplayError: ((BookShopViewModel, Int) -> ())?
    public private(set) var loading: Bool = true
    public private(set) var offersRetrieved: Bool = true
    
    var bookOffer = [[VSCTBookOffer]]() {
        didSet {
            bookShopDidChange!(self)
        }
    }
    
    func request() {
        loading = true
        bookOffer = []
        
        NavitiaSDKPartners.shared.getOffers(callbackSuccess: { (offersArray) in
            self.bookOffer.append(offersArray.filter { ($0 as! VSCTBookOffer).type == .Ticket } as! [VSCTBookOffer])
            self.bookOffer.append(offersArray.filter { ($0 as! VSCTBookOffer).type == .Membership } as! [VSCTBookOffer])
            self.loading = false
            self.offersRetrieved = true
        }) { (statusCode, data) in
            self.offersRetrieved = false
            self.loading = false
            self.bookShopDidChange!(self)
            self.bookShopDisplayError!(self, statusCode)            
        }
    }
    
    var isConnected: Bool {
        get {
            if let userInfo = NavitiaSDKPartners.shared.userInfo as? KeolisUserInfo {
                if userInfo.accountStatus != .anonymous {
                    return true
                }
            }
            
            return false
        }
    }
    
}
