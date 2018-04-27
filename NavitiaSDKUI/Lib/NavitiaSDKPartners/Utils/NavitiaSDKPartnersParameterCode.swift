//
//  NavitiaSDKPartnersParameterCode
//  NavitiaSDKPartners
//
//  Created by Vincent CATILLON on 24/04/2018.
//  Copyright © 2018 Kisio. All rights reserved.
//

@objc public enum NavitiaSDKPartnersParameterCode : Int {
    
    case empty = 0
    case invalid = 1
    
    public static let all: [String: Int] = [
        "empty" : empty.rawValue,
        "invalid" : invalid.rawValue
    ]
}

