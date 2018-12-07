//
//  JourneySolutionCollectionViewCell.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

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
    
    private var walkingInformationIsHidden: Bool = false {
        didSet {
            durationWalkerLabel.isHidden = walkingInformationIsHidden
            durationTopContraint.isActive = !walkingInformationIsHidden
            durationBottomContraint.isActive = !walkingInformationIsHidden
            durationLeadingContraint.isActive = !walkingInformationIsHidden
        }
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    // MARK: - Function
    
    private func setup() {
        addShadow()
    }
    
    private func setArrow() {
        arrowLabel.attributedText = NSMutableAttributedString()
            .icon("arrow-right",
                  color: Configuration.Color.main,
                  size: 15)
    }
    
    private func setJourneySummaryView(displayedJourney: ListJourneys.FetchJourneys.ViewModel.DisplayedJourney) {
        friezeView.addSection(friezeSections: displayedJourney.friezeSections)
    }
    
    internal func setup(displayedJourney: ListJourneys.FetchJourneys.ViewModel.DisplayedJourney) {
        setArrow()
        
        dateTime = displayedJourney.dateTime
        
        durationLabel.attributedText = displayedJourney.duration

        if let walkingInformation = displayedJourney.walkingInformation {
            durationWalkerLabel.attributedText = walkingInformation
            walkingInformationIsHidden = false
        } else {
            walkingInformationIsHidden = true
        }
        
        setJourneySummaryView(displayedJourney: displayedJourney)
        accessiblityView.accessibilityLabel = displayedJourney.accessibility
    }
    
    internal var dateTime: String? {
        didSet {
            guard let dateTime = dateTime else {
                return
            }
            
            let attributedText = NSMutableAttributedString().bold(dateTime)
            
            dateTimeLabel.attributedText = attributedText
        }
    }
}
