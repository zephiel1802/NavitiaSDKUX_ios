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
