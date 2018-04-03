//
//  String+Extension.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 26/03/2018.
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
}
