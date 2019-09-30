//
//  PricesModel.swift
//  CryptoSwift
//
//  Created by PAR-MAC001 on 20/09/2019.
//

import Foundation

@objc public class PricesModel: NSObject {
    
    public enum PriceState {
        case no_price
        case full_price
        case incomplete_price
        case unavailable_price
        case unbookable
    }
    
    var state = PriceState.no_price
    var totalPrice: Double?
    var navitiaPricedTickets: [PricedTicket]?
    var hermaasPricedTickets: [PricedTicket]?
    var unbookableSectionIdList: [String]?
    var unexpectedErrorTicketList: [(productId: Int, ticketId: String)]?
    var ticketsInput: [TicketInput]?
    
    public init(state: PriceState = PriceState.no_price,
                 totalPrice: Double?,
                 navitiaPricedTickets: [PricedTicket]?,
                 ticketsInput: [TicketInput]?,
                 hermaasPricedTickets: [PricedTicket]?,
                 unbookableSectionIdList: [String]?,
                 unexpectedErrorTicketList: [(productId: Int, ticketId: String)]?) {
        self.state = state
        self.totalPrice = totalPrice
        self.navitiaPricedTickets = navitiaPricedTickets
        self.ticketsInput = ticketsInput
        self.hermaasPricedTickets = hermaasPricedTickets
        self.unbookableSectionIdList = unbookableSectionIdList
        self.unexpectedErrorTicketList = unexpectedErrorTicketList
    }
}
