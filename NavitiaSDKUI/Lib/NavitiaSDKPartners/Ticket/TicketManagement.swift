//
//  TicketManagement.swift
//  NavitiaSDKPartners
//
//  Created by Valentin COUSIEN on 09/05/2018.
//  Copyright © 2018 Kisio. All rights reserved.
//

import Foundation

@objc(TicketManagement) public protocol TicketManagement {
    
    func getTicketManagementName() -> String
    func getTicketManagementType() -> TicketManagementType
    
    var ticketConfiguration : TicketManagementConfiguration? { get set }
    
    var hasValidTickets : Bool { get }
    
    func syncWallet(    callbackSuccess : @escaping () -> Void,
                        callbackError : @escaping (Int, [String: Any]?) -> Void )
    
    func showWallet(    callbackSuccess : @escaping (UIViewController) -> Void,
                        callbackError : @escaping (Int, [String: Any]?) -> Void )
}
