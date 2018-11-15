//
//  JourneySolutionCollectionViewCell.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class JourneySolutionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet var durationWalkerLabel: UILabel!
    @IBOutlet weak var journeySummaryView: JourneySummaryView!
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addShadow()
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
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
    }
    
    private func setArrow() {
        arrowLabel.attributedText = NSMutableAttributedString()
            .icon("arrow-right",
                  color: Configuration.Color.main,
                  size: 15)
    }
    
    private func setJourneySummaryView(displayedJourney: ListJourneys.FetchJourneys.ViewModel.DisplayedJourney) {
        journeySummaryView.addSection(sectionsClean: displayedJourney.friezeSections)
    }
    
    public var dateTime: String? {
        didSet {
            guard let dateTime = dateTime else {
                return
            }
            
            let attributedText = NSMutableAttributedString().bold(dateTime)
            
            dateTimeLabel.attributedText = attributedText
        }
    }
}
