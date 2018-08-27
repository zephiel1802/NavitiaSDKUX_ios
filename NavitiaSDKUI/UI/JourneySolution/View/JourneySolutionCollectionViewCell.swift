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
    
    func setup(displayedJourney: JourneySolution.FetchJourneys.ViewModel.DisplayedJourney,
                displayedDisruptions: [Disruption]) {
        
        // 1
        arrowLabel.attributedText = NSMutableAttributedString()
            .icon("arrow-right",
                  color: Configuration.Color.main,
                  size: 15)
        // 2
        addShadow()
        
        // 3
        dateTimeLabel.attributedText = displayedJourney.dateTime
        durationLabel.attributedText = displayedJourney.duration
        
        // 4
        if let walkingInformation = displayedJourney.walkingInformation {
            durationWalkerLabel.attributedText = walkingInformation
        } else {
            durationWalkerLabel.isHidden = true
            durationTopContraint.isActive = false
            durationBottomContraint.isActive = false
            durationLeadingContraint.isActive = false
        }
        
        // 5
        journeySummaryView.disruptions = displayedDisruptions
        journeySummaryView.addSections(displayedJourney.sections)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }

}
