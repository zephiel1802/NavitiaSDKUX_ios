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
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var priceLabelCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var PriceUnavailableLabel: UILabel!
    
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
    private var isLoaded = false
    internal var unsupportedSectionIdList: [String]?
    internal var unexpectedErrorTicketIdList: [String]?
    internal var ticketInputs: [TicketInput]? {
        didSet {
            if let ticketInputList = ticketInputs, isLoaded == false {
                if ticketInputList.count > 0 {
                    hermaasPricedTickets = nil
                    journeySolutionDelegate?.getPrice(ticketsInputList: ticketInputList, callback: { (pricedTicketList) in
                        self.hermaasPricedTickets = pricedTicketList
                    })
                } else {
                    DispatchQueue.main.async {
                        self.loadingView.alpha = 0
                        self.loadingView.isHidden = true
                        self.isLoaded = true
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
                    self.loadingView.alpha = 0
                    self.loadingView.isHidden = true
                    self.isLoaded = true
                } else if !self.isLoaded {
                    self.loadingView.alpha = 0.7
                    self.loadingView.isHidden = false
                }
                
                self.totalPrice()
            }
        }
    }
    internal var hermaasPricedTickets: [PricedTicket]? {
        didSet {
            DispatchQueue.main.async {
                if self.hermaasPricedTickets != nil {
                    self.loadingView.alpha = 0
                    self.loadingView.isHidden = true
                    self.isLoaded = true
                } else if !self.isLoaded {
                    self.loadingView.alpha = 0.7
                    self.loadingView.isHidden = false
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
        arrowLabel.attributedText = NSMutableAttributedString().icon("arrow-right", color: Configuration.Color.secondary, size: 15)
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
            // No tickets found
            if isPriceMissing && isLoaded {
                priceView.isHidden = false
                fromLabel.isHidden = true
                priceLabel.isHidden = true
                PriceUnavailableLabel.isHidden = false
                
                // Only free sections like walking
            } else {
                priceView.isHidden = true
            }
        } else {
            priceView.isHidden = false
            priceLabel.isHidden = false
            priceLabel.text = String(format: "price".localized(), totalPrice)
            
            // Uncompleted price
            if isPriceMissing {
                fromLabel.text = "from".localized()
                fromLabel.isHidden = false
                priceLabelCenterYConstraint.priority = UILayoutPriority.init(rawValue: 250)
                
                // completed price
            } else {
                fromLabel.isHidden = true
                priceLabelCenterYConstraint.priority = UILayoutPriority.init(rawValue: 999)
            }
        }
        updateJourneySummaryView()
    }
    
    internal func updateJourneySummaryView() {
        var updatedFriezeSections: [FriezePresenter.FriezeSection] = []
        var errorTicketIdList: [String] = []
        
        if isLoaded {
            if let unexpectedErrorTicketIdList = unexpectedErrorTicketIdList {
                errorTicketIdList.append(contentsOf: unexpectedErrorTicketIdList)
            }
            
            for ticket in (ticketInputs ?? []) {
                if !(hermaasPricedTickets ?? []).contains(where: { (hermaasTicket) -> Bool in
                    return hermaasTicket.ticketId == ticket.ride.ticketId
                }) {
                    errorTicketIdList.append(ticket.ride.ticketId)
                }
            }
        }
        print()
        print("Friiiiieze")
        for friezeSection in friezeSections {
            var updatedFriezeSection = friezeSection
            if errorTicketIdList.contains(friezeSection.ticketId ??  "") {
                updatedFriezeSection.hasBadge = true
            }
            
            updatedFriezeSections.append(updatedFriezeSection)
        }
        print("ticketInputs \(ticketInputs)")
        print("hermaasPricedTickets \(hermaasPricedTickets)")
        print("errorTicketIdList \(errorTicketIdList)")
        print("unexpectedErrorTicketIdList \(unexpectedErrorTicketIdList)")
        friezeView.addSection(friezeSections: updatedFriezeSections)
    }
}
