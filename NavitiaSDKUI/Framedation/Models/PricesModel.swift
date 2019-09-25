//
//  PricesModel.swift
//  CryptoSwift
//
//  Created by PAR-MAC001 on 20/09/2019.
//

import Foundation

struct PricesModel {
    
    public enum PriceState {
        case no_price
        case full_price
        case incomplete_price
        case unavailable_price
    }
    
    var state = PriceState.no_price
    var totalPrice: Double?
    var navitiaPricedTickets: [PricedTicket]?
    var hermaasPricedTickets: [PricedTicket]?
    var unbookableSectionIdList: [String]?
    var unexpectedErrorTicketIdList: [String]?
}
