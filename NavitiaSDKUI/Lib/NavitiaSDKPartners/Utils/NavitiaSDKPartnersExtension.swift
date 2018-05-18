//
//  NavitiaSDKPartnersExtension.swift
//  NavitiaSDKPartners
//
//  Created by Valentin COUSIEN on 21/03/2018.
//  Copyright © 2018 Kisio. All rights reserved.
//

import Foundation

public class NavitiaSDKPartnersExtension {
    
    public class func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    public class func isValidEmail(str : String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: str)
    }
    
    public class func getString(from htmlEncodedString: String) -> String? {
        
        guard let data = htmlEncodedString.data(using: .utf8) else {
            return nil
        }
        
        guard let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil) else {
            return nil
        }
        
        var finalStr = String.init(attributedString.string)
        if finalStr.last == "\n" {
            finalStr.removeLast()
        }
        return finalStr
    }
}

extension UIColor {
    var redValue: CGFloat{ return CIColor(color: self).red }
    var greenValue: CGFloat{ return CIColor(color: self).green }
    var blueValue: CGFloat{ return CIColor(color: self).blue }
    var alphaValue: CGFloat{ return CIColor(color: self).alpha }
}

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
    
    
    func encodeURIComponent() -> String? {
        let characterSet = NSMutableCharacterSet.alphanumeric()
        characterSet.addCharacters(in: "-_.!~*'()")
        
        return self.addingPercentEncoding(withAllowedCharacters: characterSet as CharacterSet)
    }
    
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                substring(with: substringFrom..<substringTo)
            }
        }
    }
    
    public func extractTransactionSogenActif() -> String? {
        return self.slice(from: "<span id=\"span_sips_trans_ref_table_id_transaction_result\">", to: "</span>")
    }
    
    public func extractCustomerSogenActif() -> String? {
        return self.slice(from: "<span id=\"span_sips_trans_ref_table_id_customer_result\">", to: "</span>")
    }
}
