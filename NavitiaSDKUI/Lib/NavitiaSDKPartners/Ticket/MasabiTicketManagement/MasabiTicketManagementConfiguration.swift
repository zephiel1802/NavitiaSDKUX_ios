//
//  MasabiTicketManagementConfiguration.swift
//  NavitiaSDKPartners
//
//  Created by Valentin COUSIEN on 09/05/2018.
//  Copyright © 2018 Kisio. All rights reserved.
//

import Foundation
import JustRideSDK

@objc(MasabiTicketManagementConfiguration) public class MasabiTicketManagementConfiguration : NSObject, TicketManagementConfiguration {
    
    public let type: TicketManagementType = .Masabi
    public let UIConfiguration : MJRUIConfiguration?
    
    var MasabiSharedInstance : MJRSDK = MJRSDK()
    
    public init( data : Data ) {
        MasabiSharedInstance = MJRSDK.init(configuration: data)
        UIConfiguration = MasabiSharedInstance.uiConfiguration
        UIConfiguration?.ticket.visualValidationTextFormatLine1 = MJRVisualValidationFormat.time24Hour
    }
    
}
