//
//  UIViewController+Extension.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

extension StopDateTime {
    
    func selectLinks(type: String) -> [LinkSchema] {
        var selectLinks = [LinkSchema]()
        
        guard let links = self.links else {
            return selectLinks
        }
        
        for link in links {
            if link.type == type {
                selectLinks.append(link)
            }
        }
        
        return selectLinks
    }
}
