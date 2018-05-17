//
//  KeolisAccountStatus.swift
//  NavitiaSDKPartners
//
//  Created by Valentin COUSIEN on 10/04/2018.
//  Copyright © 2018 Kisio. All rights reserved.
//

import Foundation

@objc public enum KeolisAccountStatus : Int {
    
    case anonymous = 0
    case waitingActivation = 1
    case activated = 2
    case deactivated = 3
    case withTempPassword = 4
    
    public static let all: [String: Int] = [
        "anonymous" : anonymous.rawValue,
        "waitingActivation" : waitingActivation.rawValue,
        "activated" : activated.rawValue,
        "deactivated" : deactivated.rawValue,
        "withTempPassword" : withTempPassword.rawValue
    ]

    func getStatus() -> [String: Any] {
        var status : [String: Any] = [ : ]
        switch self {
        case .anonymous:
            status = [ "code" : self.rawValue,
                       "label" : "Anonymous" ]
            break
        case .waitingActivation:
            status = [ "code" : self.rawValue,
                       "label" : "Waiting for activation" ]
            break
        case .activated:
            status = [ "code" : self.rawValue,
                       "label" : "Activated" ]
            break
        case .deactivated:
            status = [ "code" : self.rawValue,
                       "label" : "Deactivated" ]
            break
        case .withTempPassword:
            status = [ "code" : self.rawValue,
                       "label" : "With temporary password" ]
            break
        }
        return status
    }
}
