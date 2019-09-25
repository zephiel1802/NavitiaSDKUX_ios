//
//  PricesModel.swift
//  CryptoSwift
//
//  Created by PAR-MAC001 on 20/09/2019.
//

import Foundation

@objc open class PricesModel: NSObject {
    
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
    
    public init(state: PriceState = PriceState.no_price,
                 totalPrice: Double?,
                 navitiaPricedTickets: [PricedTicket]?,
                 hermaasPricedTickets: [PricedTicket]?,
                 unbookableSectionIdList: [String]?,
                 unexpectedErrorTicketIdList: [String]?) {
        self.state = state
        self.totalPrice = totalPrice
        self.navitiaPricedTickets = navitiaPricedTickets
        self.hermaasPricedTickets = hermaasPricedTickets
        self.unbookableSectionIdList = unbookableSectionIdList
        self.unexpectedErrorTicketIdList = unexpectedErrorTicketIdList
    }
}
