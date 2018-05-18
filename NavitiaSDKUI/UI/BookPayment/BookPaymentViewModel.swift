//
//  BookPaymentViewModel.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class BookPaymentViewModel: NSObject {
    
    public var bookPaymentDidChange: ((BookPaymentViewModel) -> ())?
    public var returnPayment: (() -> ())?
    public private(set) var loading: Bool = true
    
    var bookOffer = [[VSCTBookOffer]]() {
        didSet {
            bookPaymentDidChange!(self)
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
