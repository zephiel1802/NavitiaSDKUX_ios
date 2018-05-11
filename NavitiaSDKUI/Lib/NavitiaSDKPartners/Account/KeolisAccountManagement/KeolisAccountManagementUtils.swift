//
//  KeolisAccountManagementUtils.swift
//  NavitiaSDKPartners
//
//  Created by Valentin COUSIEN on 04/04/2018.
//  Copyright © 2018 Kisio. All rights reserved.
//

import Foundation

extension String {
    func encrypt(key: String) -> String! {
        return String(utf8String: self.cString(using: .utf8)!)!.hmac(key: key).hexadecimal()?.base64EncodedString()
    }
}
