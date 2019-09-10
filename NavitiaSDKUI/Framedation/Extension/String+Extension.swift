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
        dateFormatter.locale = Locale(identifier: "fr_FR")
        
        return dateFormatter.date(from: self)
    }
    
    func toUIColor(defaultColor: UIColor = Configuration.Color.gray) -> UIColor {
        if self == "" {
            return defaultColor
        }
        
        var cString:String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return defaultColor
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
    
    func localized(bundle: Bundle = NavitiaSDKUI.shared.bundle, value: String = "", comment: String = "") -> String {
        return NSLocalizedString(self, bundle: bundle, value: value, comment: comment)
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else {
            return NSAttributedString()
        }
        
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    func indices(of occurrence: String) -> [Int] {
        var indices = [Int]()
        var position = startIndex
        
        while let range = range(of: occurrence, range: position..<endIndex) {
            let i = distance(from: startIndex,
                             to: range.lowerBound)
            indices.append(i)
            let offset = occurrence.distance(from: occurrence.startIndex,
                                             to: occurrence.endIndex) - 1
            guard let after = index(range.lowerBound,
                                    offsetBy: offset,
                                    limitedBy: endIndex) else {
                                        break
            }
            
            position = index(after: after)
        }
        
        return indices
    }
    
    func getIcon(applicationBundle: Bundle? = Configuration.applicationBundle,
                 sdkBundle: Bundle? = NavitiaSDKUI.shared.bundle,
                 renderingMode: UIImage.RenderingMode = UIImage.RenderingMode.alwaysTemplate,
                 customizable: Bool = false) -> UIImage? {
        if customizable,
            let applicationBundle = applicationBundle,
            let iconImage = UIImage(named: self, in: applicationBundle, compatibleWith: nil) {
            return iconImage.withRenderingMode(renderingMode)
        } else if let sdkBundle = sdkBundle, let iconImage = UIImage(named: self, in: sdkBundle, compatibleWith: nil) {
            return iconImage.withRenderingMode(renderingMode)
        }
        
        return nil
    }
}
