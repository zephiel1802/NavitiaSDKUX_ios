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
    public var bytes: Array<UInt8> {
        return data(using: String.Encoding.utf8, allowLossyConversion: true)?.bytes ?? Array(utf8)
    }
    
    public func md5() -> String {
        return bytes.md5().toHexString()
    }
    
    public func sha1() -> String {
        return bytes.sha1().toHexString()
    }
    
    public func sha224() -> String {
        return bytes.sha224().toHexString()
    }
    
    public func sha256() -> String {
        return bytes.sha256().toHexString()
    }
    
    public func sha384() -> String {
        return bytes.sha384().toHexString()
    }
    
    public func sha512() -> String {
        return bytes.sha512().toHexString()
    }
    
    public func sha3(_ variant: SHA3.Variant) -> String {
        return bytes.sha3(variant).toHexString()
    }
    
    public func crc32(seed: UInt32? = nil, reflect: Bool = true) -> String {
        return bytes.crc32(seed: seed, reflect: reflect).bytes().toHexString()
    }
    
    public func crc32c(seed: UInt32? = nil, reflect: Bool = true) -> String {
        return bytes.crc32(seed: seed, reflect: reflect).bytes().toHexString()
    }
    
    public func crc16(seed: UInt16? = nil) -> String {
        return bytes.crc16(seed: seed).bytes().toHexString()
    }
    
    /// - parameter cipher: Instance of `Cipher`
    /// - returns: hex string of bytes
    public func encrypt(cipher: Cipher) throws -> String {
        return try bytes.encrypt(cipher: cipher).toHexString()
    }
    
    /// - parameter cipher: Instance of `Cipher`
    /// - returns: base64 encoded string of encrypted bytes
    public func encryptToBase64(cipher: Cipher) throws -> String? {
        return try bytes.encrypt(cipher: cipher).toBase64()
    }
    
    // decrypt() does not make sense for String
    
    /// - parameter authenticator: Instance of `Authenticator`
    /// - returns: hex string of string
    public func authenticate<A: Authenticator>(with authenticator: A) throws -> String {
        return try bytes.authenticate(with: authenticator).toHexString()
    }
    
}
