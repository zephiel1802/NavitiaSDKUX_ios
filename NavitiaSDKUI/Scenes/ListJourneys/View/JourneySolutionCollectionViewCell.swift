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
    
    private enum PriceState {
        case no_price
        case full_price
        case incomplete_price
        case unavailable_price
    }
    
    @IBOutlet weak var accessiblityView: UIView!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet var durationWalkerLabel: UILabel!
    @IBOutlet weak var friezeView: FriezeView!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet var durationTopContraint: NSLayoutConstraint!
    @IBOutlet var durationBottomContraint: NSLayoutConstraint!
    @IBOutlet var durationLeadingContraint: NSLayoutConstraint!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var priceLabelCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var PriceUnavailableLabel: UILabel!
    @IBOutlet weak var loadingActivityIndicatorView: UIActivityIndicatorView!
    
    public var journeySolutionDelegate: JourneySolutionCollectionViewCellDelegate?
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
    internal var friezeSections: [FriezePresenter.FriezeSection] = [] {
        didSet {
            updateJourneySummaryView()
        }
    }
    var isLoaded = false
    internal var unsupportedSectionIdList: [String]?
    internal var unexpectedErrorTicketIdList: [String]?
    internal var ticketInputs: [TicketInput]? {
        didSet {
            if let ticketInputList = ticketInputs, !isLoaded {
                if ticketInputList.count > 0, journeySolutionDelegate != nil {
                    hermaasPricedTickets = nil
                    load(true)
                    journeySolutionDelegate!.getPrice(ticketsInputList: ticketInputList, callback: { (pricedTicketList) in
                        self.hermaasPricedTickets = pricedTicketList
                    })
                } else {
                    DispatchQueue.main.async {
                        self.load(false)
                        self.totalPrice()
                    }
                }
            }
        }
    }
    internal var navitiaPricedTickets: [PricedTicket]? {
        didSet {
            DispatchQueue.main.async {
                if self.navitiaPricedTickets != nil && self.ticketInputs == nil {
                    self.load(false)
                } else if !self.isLoaded {
                    self.load(true)
                }
                
                self.totalPrice()
            }
        }
    }
    internal var hermaasPricedTickets: [PricedTicket]? {
        didSet {
            DispatchQueue.main.async {
                if self.hermaasPricedTickets != nil {
                    self.load(false)
                } else if !self.isLoaded {
                    self.load(true)
                }
                
                self.totalPrice()
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
    }
    
    private func setArrow() {
        arrowImageView.image = "arrow_right".getIcon()
        arrowImageView.tintColor = Configuration.Color.secondary
    }
    
    private func totalPrice() {
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
            updatePriceDisplaying(state: isPriceMissing && isLoaded ? .unavailable_price : .no_price, price: nil)
        } else {
            updatePriceDisplaying(state: isPriceMissing ? .incomplete_price : .full_price, price: totalPrice)
        }
        
        updateJourneySummaryView()
    }
    
    private func load(_ startAnimating: Bool) {
        if startAnimating {
            loadingActivityIndicatorView.startAnimating()
        } else {
            loadingActivityIndicatorView.stopAnimating()
        }
        
        loadingActivityIndicatorView.isHidden = !startAnimating
        isLoaded = !startAnimating
    }
    
    internal func updateJourneySummaryView() {
        var updatedFriezeSections = [FriezePresenter.FriezeSection]()
        var errorTicketIdList = [String]()
        
        if isLoaded {
            if let unexpectedErrorTicketIdList = unexpectedErrorTicketIdList {
                errorTicketIdList.append(contentsOf: unexpectedErrorTicketIdList)
            }
            
            if let ticketInputs = ticketInputs, let hermaasPricedTickets = hermaasPricedTickets {
                for ticket in ticketInputs {
                    if !hermaasPricedTickets.contains(where: { (hermaasTicket) -> Bool in
                        return hermaasTicket.ticketId == ticket.ride.ticketId
                    }) {
                        errorTicketIdList.append(ticket.ride.ticketId)
                    }
                }
            }
        }
        
        for friezeSection in friezeSections {
            var updatedFriezeSection = friezeSection
            if let ticketId = friezeSection.ticketId, errorTicketIdList.contains(ticketId) {
                updatedFriezeSection.hasBadge = true
            }
            
            updatedFriezeSections.append(updatedFriezeSection)
        }
        
        friezeView.addSection(friezeSections: updatedFriezeSections)
    }
    
    private func updatePriceDisplaying(state: PriceState, price: Double?) {
        switch state {
        case .no_price:
            priceView.isHidden = true
            
        case .full_price:
            if let price = price {
                priceView.isHidden = false
                priceLabel.isHidden = false
                priceLabel.text = String(format: "price".localized(), price)
                fromLabel.isHidden = true
                priceLabelCenterYConstraint.priority = UILayoutPriority.defaultHigh + 1
            } else {
                updatePriceDisplaying(state: .unavailable_price, price: nil)
            }
            
        case .incomplete_price:
            if let price = price {
                priceView.isHidden = false
                priceLabel.isHidden = false
                priceLabel.text = String(format: "price".localized(), price)
                fromLabel.text = "from".localized()
                fromLabel.isHidden = false
                priceLabelCenterYConstraint.priority = UILayoutPriority.defaultLow
            } else {
                updatePriceDisplaying(state: .unavailable_price, price: nil)
            }
            
        case .unavailable_price:
            priceView.isHidden = false
            fromLabel.isHidden = true
            priceLabel.isHidden = true
            PriceUnavailableLabel.isHidden = false
        }
    }
}
