//
//  Collection+Extension.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

extension Collection {
    
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
}

// CryptoSwift
extension Collection where Self.Element == UInt8, Self.Index == Int {
    // Big endian order
    func toUInt32Array() -> Array<UInt32> {
        if isEmpty {
            return []
        }
        
        var result = Array<UInt32>(reserveCapacity: 16)
        for idx in stride(from: startIndex, to: endIndex, by: 4) {
            let val = UInt32(bytes: self, fromIndex: idx).bigEndian
            result.append(val)
        }
        
        return result
    }
    
    // Big endian order
    func toUInt64Array() -> Array<UInt64> {
        if isEmpty {
            return []
        }
        
        var result = Array<UInt64>(reserveCapacity: 32)
        for idx in stride(from: startIndex, to: endIndex, by: 8) {
            let val = UInt64(bytes: self, fromIndex: idx).bigEndian
            result.append(val)
        }
        
        return result
    }
}

