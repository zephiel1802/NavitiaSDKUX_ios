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
    public private(set) var notConnected: Bool = false
    
    var bookOffer = [[VSCTBookOffer]]() {
        didSet {
            bookShopDidChange!(self)
        }
    }
    
    func request() {
        loading = true
        self.bookOffer = []
        NavitiaSDKPartners.shared.getOffers(callbackSuccess: { (offersArray) in
            self.bookOffer.append(offersArray.filter { ($0 as! VSCTBookOffer).type == .Ticket } as! [VSCTBookOffer])
            self.bookOffer.append(offersArray.filter { ($0 as! VSCTBookOffer).type == .Membership } as! [VSCTBookOffer])
            self.loading = false
            self.notConnected = false
        }) { (statusCode, data) in
            self.notConnected = true
            self.loading = false
            self.bookOffer = []
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
