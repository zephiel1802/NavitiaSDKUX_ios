//
//  JourneySolutionCollectionViewCell.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

protocol JourneySolutionCollectionViewCellDelegate {
    
    func getPrice(ticketsInputList: [TicketInput], callback:  @escaping ((_ pricedTicketList: [PricedTicket]) -> ()))
}

class JourneySolutionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var accessiblityView: UIView!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet var durationWalkerLabel: UILabel!
    @IBOutlet weak var friezeView: FriezeView!
    @IBOutlet weak var arrowLabel: UILabel!
    @IBOutlet var durationTopContraint: NSLayoutConstraint!
    @IBOutlet var durationBottomContraint: NSLayoutConstraint!
    @IBOutlet var durationLeadingContraint: NSLayoutConstraint!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    
    private var delegate: JourneySolutionCollectionViewCellDelegate?
    private var walkingInformationIsHidden: Bool = false {
        didSet {
            durationWalkerLabel.isHidden = walkingInformationIsHidden
            durationTopContraint.isActive = !walkingInformationIsHidden
            durationBottomContraint.isActive = !walkingInformationIsHidden
            durationLeadingContraint.isActive = !walkingInformationIsHidden
        }
    }
    
    internal var dateTime: String? {
        didSet {
            if let dateTime = dateTime {
                dateTimeLabel.attributedText = NSMutableAttributedString().bold(dateTime)
            }
        }
    }
    internal var duration: NSMutableAttributedString? {
        didSet {
            if let duration = duration {
                durationLabel.attributedText = duration
            }
        }
    }
    internal var walkingDescription: NSMutableAttributedString? {
        didSet {
            if let walkingDescription = walkingDescription {
                durationWalkerLabel.attributedText = walkingDescription
                walkingInformationIsHidden = false
            } else {
                walkingInformationIsHidden = true
            }
        }
    }
    internal var accessibility: String? {
        get {
            return accessiblityView.accessibilityLabel
        }
        set {
            accessiblityView.accessibilityLabel = newValue
        }
    }
    internal var ticketInputs: [TicketInput]? {
        didSet {
            if let ticketInputList = ticketInputs {
                delegate?.getPrice(ticketsInputList: ticketInputList, callback: { (pricedTicketList) in
                    self.pricedTickets = pricedTicketList
                })
            }
        }
    }
    internal var pricedTickets: [PricedTicket]? {
        didSet {
            if let pricedTickets = pricedTickets {
                loadingView.alpha = 0
                loadingView.isHidden = true
                totalPrice(tickets: pricedTickets)
            } else {
                loadingView.alpha = 0.7
                loadingView.isHidden = false
                totalPrice(tickets: [])
            }
        }
    }
    
    // MARK: - UINib
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    // MARK: - Function
    
    private func setup() {
        setShadow()
        setArrow()
        
        if let ticketInputList = ticketInputs {
            delegate?.getPrice(ticketsInputList: ticketInputList, callback: { (pricedTicketList) in
                self.pricedTickets = pricedTicketList
            })
        }
    }
    
    private func setArrow() {
        arrowLabel.attributedText = NSMutableAttributedString().icon("arrow-right", color: Configuration.Color.secondary, size: 15)
    }
    
    private func totalPrice(tickets: [PricedTicket]) {
        var totalPrice: Double = 0
        var nbPriceMissing = 0
        
        for ticket in tickets {
            if let price = ticket.priceWithTax, ticket.currency.lowercased() == "eur" {
                totalPrice += price
            } else {
                nbPriceMissing += 1
            }
        }
        
        if tickets.count == 0 || tickets.count == nbPriceMissing {
            priceLabel.text = ""
        } else {
            var priceText = nbPriceMissing > 0 ? "From " : ""
            priceText += "\(totalPrice)€"
            priceLabel.text = priceText
        }
    }
    
    internal func setJourneySummaryView(friezeSections: [FriezePresenter.FriezeSection]) {
        friezeView.addSection(friezeSections: friezeSections)
    }
}
