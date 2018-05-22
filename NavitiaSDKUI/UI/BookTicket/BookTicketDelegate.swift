//
//  BookDelegate.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 21/05/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

@objc public protocol BookTicketDelegate {
    
    func onDisplayCreateAccount()
    func onDisplayConnectionAccount()
    func onDisplayTicket()
    func onDismissBookTicket()
    
}
