//
//  BookRecapViewModel.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 21/05/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class BookRecapViewModel: NSObject {
    
    public var bookRecapViewModel: ((BookRecapViewModel) -> ())?
    public private(set) var loading: Bool = true

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
