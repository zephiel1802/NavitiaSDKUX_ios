//
//  AutocompletionHistory.swift
//  NavitiaSDKUI
//
//  Copyright © 2019 kisio. All rights reserved.
//

import Foundation

struct AutocompletionHistory {
    
    let id: Int
    let coverage: String
    let name: String
    let idNavitia: String
    let type: String
    
    init(id: Int, coverage: String, name: String, idNavitia: String, type: String) {
        self.id = id
        self.coverage = coverage
        self.name = name
        self.idNavitia = idNavitia
        self.type = type
    }
}
