//
//  NavitiaSDKPartnersCourtesyEnum.swift
//  NavitiaSDKPartners
//
//  Created by Valentin COUSIEN on 12/04/2018.
//  Copyright © 2018 Kisio. All rights reserved.
//

import Foundation

@objc public enum NavitiaSDKPartnersCourtesy : Int {
    case Mr = 0
    case Ms = 1
    case Mrs = 2
    case Unknown = 3

    public static let all: [String: Int] = [
        "mr" : Mr.rawValue,
        "ms" : Ms.rawValue,
        "mrs" : Mrs.rawValue,
        "unknown" : Unknown.rawValue
    ]

    func toKeolis() -> String {
        switch self {
        case .Mr:
            return "M."
        default:
            return "MME"
        }
    }
    
    static func fromKeolis(str : String) -> NavitiaSDKPartnersCourtesy {
        if str == "M." {
            return .Mr
        } else if str == "MME" {
            return .Mrs
        }
        return .Unknown
    }
}
