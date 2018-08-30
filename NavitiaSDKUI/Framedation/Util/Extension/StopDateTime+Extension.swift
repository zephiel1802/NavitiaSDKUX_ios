//
//  LinkSchema+Extension.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 30/08/2018.
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
