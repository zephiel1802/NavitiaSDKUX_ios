//
//  String+Extension.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

extension String {
    
    var localized: String {
        get {
            return NSLocalizedString(self, comment: self)
        }
    }
    
    func toDate(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
    
    func toUIColor() -> UIColor {
        var cString:String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func localized(withComment: String = "", bundle: Bundle) -> String {
        return NSLocalizedString(self, bundle: NavitiaSDKUI.shared.bundle, value: "", comment: withComment)
    }
    
    func isValidEmail() -> Bool {
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z ]{2,64}")
        
        return emailPredicate.evaluate(with: self)
    }
    
    // CryptoSwift
    func md5() -> String {
        return self.utf8.lazy.map({ $0 as UInt8 }).md5().toHexString()
    }
    
    func sha1() -> String {
        return self.utf8.lazy.map({ $0 as UInt8 }).sha1().toHexString()
    }
    
    func sha224() -> String {
        return self.utf8.lazy.map({ $0 as UInt8 }).sha224().toHexString()
    }
    
    func sha256() -> String {
        return self.utf8.lazy.map({ $0 as UInt8 }).sha256().toHexString()
    }
    
    func sha384() -> String {
        return self.utf8.lazy.map({ $0 as UInt8 }).sha384().toHexString()
    }
    
    func sha512() -> String {
        return self.utf8.lazy.map({ $0 as UInt8 }).sha512().toHexString()
    }
    
    func sha3(_ variant: SHA3.Variant) -> String {
        return self.utf8.lazy.map({ $0 as UInt8 }).sha3(variant).toHexString()
    }
    
    func crc32(seed: UInt32? = nil, reflect: Bool = true) -> String {
        return self.utf8.lazy.map({ $0 as UInt8 }).crc32(seed: seed, reflect: reflect).bytes().toHexString()
    }
    
    func crc16(seed: UInt16? = nil) -> String {
        return self.utf8.lazy.map({ $0 as UInt8 }).crc16(seed: seed).bytes().toHexString()
    }
    
    /// - parameter cipher: Instance of `Cipher`
    /// - returns: hex string of bytes
    func encrypt(cipher: Cipher) throws -> String {
        return try Array(self.utf8).encrypt(cipher: cipher).toHexString()
    }
    
    /// - parameter cipher: Instance of `Cipher`
    /// - returns: base64 encoded string of encrypted bytes
    func encryptToBase64(cipher: Cipher) throws -> String? {
        return try Array(self.utf8).encrypt(cipher: cipher).toBase64()
    }
    
    // decrypt() does not make sense for String
    
    /// - parameter authenticator: Instance of `Authenticator`
    /// - returns: hex string of string
    func authenticate<A: Authenticator>(with authenticator: A) throws -> String {
        return try Array(self.utf8).authenticate(with: authenticator).toHexString()
    }
    
}
