//
//  JourneySolutionCollectionViewCell.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

protocol JourneySolutionCollectionViewCellDelegate {
    
    func getPrice(ticketsInputList: [TicketInput], indexPath: IndexPath?)
}

class JourneySolutionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var accessiblityView: UIView!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet var durationWalkerLabel: UILabel!
    @IBOutlet weak var friezeView: FriezeView!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet var durationTopContraint: NSLayoutConstraint!
    @IBOutlet var durationBottomContraint: NSLayoutConstraint!
    @IBOutlet var durationLeadingContraint: NSLayoutConstraint!
    @IBOutlet weak var priceView: TicketPriceView!
    @IBOutlet weak var loadingActivityIndicatorView: UIActivityIndicatorView!
    
    internal var isLoaded = false
    internal var indexPath: IndexPath?
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
            friezeView.addSection(friezeSections: friezeSections)
        }
    }

    internal func configurePrice(ticketInputs: [TicketInput]?, priceModel: PricesModel?) {
        // Reset UI before any action due to reusable cell
        load(false)
        priceView.updatePrice(state: .no_price, price: nil)
        
        if let priceModel = priceModel, priceModel.hermaasPricedTickets != nil {
            load(false)
            priceView.updatePrice(state: priceModel.state, price: priceModel.totalPrice)
        } else {
            if let ticketInputList = ticketInputs, ticketInputList.count > 0 {
                load(true)
                journeySolutionDelegate?.getPrice(ticketsInputList: ticketInputList, indexPath: indexPath)
            }
        }
        
        updateJourneySummaryView(ticketInputs: ticketInputs,
                                 hermaasPricedTickets: priceModel?.hermaasPricedTickets,
                                 unexpectedErrorTicketIdList: priceModel?.unexpectedErrorTicketIdList)
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
    
    private func load(_ startAnimating: Bool) {
        if startAnimating {
            loadingActivityIndicatorView.startAnimating()
        } else {
            loadingActivityIndicatorView.stopAnimating()
        }
        loadingActivityIndicatorView.color = Configuration.Color.main
        loadingActivityIndicatorView.isHidden = !startAnimating
        isLoaded = !startAnimating
    }
    
    private func updateJourneySummaryView(ticketInputs: [TicketInput]?,
                                           hermaasPricedTickets: [PricedTicket]?,
                                           unexpectedErrorTicketIdList: [String]?) {
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
}
