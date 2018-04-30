//
//  KeolisAccountManagementUtils.swift
//  NavitiaSDKPartners
//
//  Created by Valentin COUSIEN on 04/04/2018.
//  Copyright © 2018 Kisio. All rights reserved.
//

import Foundation

extension String {
    func hmac(key: String) -> String {
        do {
            let arrayKey : Array<UInt8> = (key.data(using: .utf8)?.bytes)!
            let arrayStr : Array<UInt8> = (self.data(using: .utf8)?.bytes)!
            let hmac = HMAC(key: arrayKey, variant: .sha1)
            let hmaced = try hmac.authenticate(arrayStr)
            let finalStr = hmaced.toHexString()
            return finalStr
        } catch {
            return "12345678"
        }
        
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    func hexadecimal() -> Data? {
        var data = Data(capacity: self.count / 2)
        
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSMakeRange(0, utf16.count)) { match, flags, stop in
            let byteString = (self as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }
        
        guard data.count > 0 else { return nil }
        
        return data
    }
    
    func encrypt(key: String) -> String! {
        return String(utf8String: self.cString(using: .utf8)!)!.hmac(key: key).hexadecimal()?.base64EncodedString()
    }
    
    func encodeURIComponent() -> String? {
        let characterSet = NSMutableCharacterSet.alphanumeric()
        characterSet.addCharacters(in: "-_.!~*'()")
        
        return self.addingPercentEncoding(withAllowedCharacters: characterSet as CharacterSet)
    }
}
