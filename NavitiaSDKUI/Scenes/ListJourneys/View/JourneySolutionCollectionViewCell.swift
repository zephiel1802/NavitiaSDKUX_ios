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
    
    internal func setup(displayedJourney: ListJourneys.FetchJourneys.ViewModel.DisplayedJourney,
                        displayedDisruptions: [Disruption]) {
        setArrow()
        
        dateTime = displayedJourney.dateTime
        
        //durationJourney = ""
        durationLabel.attributedText = displayedJourney.duration
        
        //durationWalker = ""
        if let walkingInformation = displayedJourney.walkingInformation {
            durationWalkerLabel.attributedText = walkingInformation
            durationWalkerLabel.isHidden = false
            durationTopContraint.isActive = true
            durationBottomContraint.isActive = true
            durationLeadingContraint.isActive = true
        } else {
            durationWalkerLabel.isHidden = true
            durationTopContraint.isActive = false
            durationBottomContraint.isActive = false
            durationLeadingContraint.isActive = false
        }
        
        setJourneySummaryView(displayedJourney: displayedJourney, displayedDisruptions: displayedDisruptions)
    }
    
    private func setArrow() {
        arrowLabel.attributedText = NSMutableAttributedString()
            .icon("arrow-right",
                  color: Configuration.Color.main,
                  size: 15)
    }
    
    private func setJourneySummaryView(displayedJourney: ListJourneys.FetchJourneys.ViewModel.DisplayedJourney,
                                       displayedDisruptions: [Disruption]) {
        journeySummaryView.disruptions = displayedDisruptions
        journeySummaryView.addSections(displayedJourney.sections)
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
    
    public var durationJourney: String? {
        didSet {
//            guard let durationJourney = durationJourney else {
//                return
//            }
//
//            let attributedText = NSMutableAttributedString().bold(durationJourney)
            // durationLabel.attributedText =
        }
    }
    
    public var durationWalker: String? {
        didSet {
            if let durationWalker = durationWalker {
                // durationWalkerLabel.attributedText
                durationWalkerLabel.isHidden = false
                durationTopContraint.isActive = true
                durationBottomContraint.isActive = true
                durationLeadingContraint.isActive = true
            } else {
                durationWalkerLabel.isHidden = true
                durationTopContraint.isActive = false
                durationBottomContraint.isActive = false
                durationLeadingContraint.isActive = false
            }
        }
    }
}
