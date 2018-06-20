//
//  PaymentReturnValueSogenActif.swift
//  NavitiaSDKPartners
//
//  Created by Valentin COUSIEN on 04/05/2018.
//  Copyright © 2018 Kisio. All rights reserved.
//

import Foundation

public class NavitiaSDKPartnersSogenActif {
    public enum PaymentReturnValue {
        case error
        case cancel
        case success
        case unknown
    }
    
    public class func getReturnValue(url: String) -> NavitiaSDKPartnersSogenActif.PaymentReturnValue {
        if url.range(of: "commandes") != nil {
            if url.range(of: "payment?oid=") != nil {
                if url.range(of: "payst=cancel") != nil {
                    return .cancel
                } else if url.range(of: "payst=error") != nil {
                    return .error
                }
            } else if url.range(of: "recap?oid=") != nil {
                return .success
            }
        }
        return .unknown
    }
}
