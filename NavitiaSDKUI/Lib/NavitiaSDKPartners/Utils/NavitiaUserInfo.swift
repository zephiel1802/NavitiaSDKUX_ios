//
//  NavitiaUserInfo.swift
//  NavitiaSDKPartners
//
//  Created by Valentin COUSIEN on 21/03/2018.
//  Copyright © 2018 Kisio. All rights reserved.
//

import Foundation

@objc(NavitiaUserInfo) public protocol NavitiaUserInfo {
    
    var firstName : String { get set }
    var lastName : String { get set }
    var email : String { get set }
    var id : String { get set }
}
