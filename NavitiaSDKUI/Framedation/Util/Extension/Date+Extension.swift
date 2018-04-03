//
//  Date+Extension.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 26/03/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

extension Date {
    
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
