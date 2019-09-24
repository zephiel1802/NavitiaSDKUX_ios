//
//  TicketPriceView.swift
//  NavitiaSDKUI
//
//  Created by PAR-MAC001 on 24/09/2019.
//

import Foundation
import UIKit

private enum PriceState {
    case no_price
    case full_price
    case incomplete_price
    case unavailable_price
}

class TicketPriceView: UIView {
    
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceUnavailableLabel: UILabel!
    @IBOutlet weak var priceLabelCenterYConstraint: NSLayoutConstraint!
    
    // MARK: - UINib
    
    static var identifier: String {
        return String(describing: self)
    }
    
    class func instanceFromNib() -> TicketPriceView {
        return UINib(nibName: identifier, bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: nil, options: nil)[0] as! TicketPriceView
    }
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func awakeAfter(using aDecoder: NSCoder) -> Any? {
        guard subviews.isEmpty else {
            return self
        }
        
        let ticketPriceView = TicketPriceView.instanceFromNib()
        
        ticketPriceView.translatesAutoresizingMaskIntoConstraints = false
        ticketPriceView.frame = self.bounds
        
        return ticketPriceView
    }
    
    //MARK: - Public methods
    
    func setPrice(ticketInputs: [TicketInput]?,
                    navitiaPricedTickets: [PricedTicket]?,
                    hermaasPricedTickets: [PricedTicket]?,
                    unsupportedSectionIdList: [String]?,
                    unexpectedErrorTicketIdList: [String]?,
                    priceIsLoaded: Bool = false) {
        var totalPrice: Double = 0
        var isPriceMissing = false
        
        if (unsupportedSectionIdList?.count ?? 0) > 0 || (unexpectedErrorTicketIdList?.count ?? 0) > 0 {
            isPriceMissing = true
        }
        
        if (hermaasPricedTickets ?? []).count < (ticketInputs ?? []).count {
            isPriceMissing = true
        }
        
        // aggregate navitia and hermaas ticket's
        var tickets: [PricedTicket] = []
        if let navitiaTickets = navitiaPricedTickets {
            tickets.append(contentsOf: navitiaTickets)
        }
        if let hermaasTickets = hermaasPricedTickets {
            tickets.append(contentsOf: hermaasTickets)
        }
        
        // Compute total price
        for ticket in tickets {
            if let price = ticket.priceWithTax, ticket.currency.lowercased() == "eur" {
                totalPrice += price
            } else {
                isPriceMissing = true
            }
        }
        
        if tickets.count == 0 {
            updatePriceDisplaying(state: isPriceMissing && priceIsLoaded ? .unavailable_price : .no_price, price: nil)
        } else {
            updatePriceDisplaying(state: isPriceMissing ? .incomplete_price : .full_price, price: totalPrice)
        }
    }
    
    // MARK: - Private methods
    
    private func updatePriceDisplaying(state: PriceState, price: Double?) {
        switch state {
        case .no_price:
            isHidden = true
            
        case .full_price:
            if let price = price {
                isHidden = false
                priceLabel.isHidden = false
                priceLabel.text = String(format: "price".localized(), price)
                fromLabel.isHidden = true
                priceLabelCenterYConstraint.priority = UILayoutPriority.defaultHigh + 1
            } else {
                updatePriceDisplaying(state: .unavailable_price, price: nil)
            }
            
        case .incomplete_price:
            if let price = price {
                isHidden = false

                priceLabel.isHidden = false
                priceLabel.text = String(format: "price".localized(), price)
                fromLabel.text = "from".localized()
                fromLabel.isHidden = false
                priceLabelCenterYConstraint.priority = UILayoutPriority.defaultLow
            } else {
                updatePriceDisplaying(state: .unavailable_price, price: nil)
            }
            
        case .unavailable_price:
            isHidden = false
            fromLabel.isHidden = true
            priceLabel.isHidden = true
            priceUnavailableLabel.isHidden = false
        }
    }
}
