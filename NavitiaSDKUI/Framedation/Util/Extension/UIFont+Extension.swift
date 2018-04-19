//
//  UIFont+Extension.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

public extension UIFont {
    
    public static func registerFontWithFilenameString(filenameString: String, bundle: Bundle) {
        guard let pathForResourceString = bundle.path(forResource: filenameString, ofType: nil) else {
            print("UIFont+:  Failed to register font - path for resource not found.")
            return
        }

        guard let fontData = NSData(contentsOfFile: pathForResourceString) else {
            print("UIFont+:  Failed to register font - font data could not be loaded.")
            return
        }

        guard let dataProvider = CGDataProvider(data: fontData) else {
            print("UIFont+:  Failed to register font - data provider could not be loaded.")
            return
        }
        
        let fontRef = CGFont(dataProvider)
        
        var errorRef: Unmanaged<CFError>? = nil
        if let fontRef = fontRef {
            if (CTFontManagerRegisterGraphicsFont(fontRef, &errorRef) == false) {
                print("UIFont+:  Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
            }
        }
    }
    
}
