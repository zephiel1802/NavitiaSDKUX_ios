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
    
    var disruptions: [Disruption]!
    
    func setup(_ journey: Journey) {
        _setupArrowIcon()
        addShadow()
        
        if let departureDateTime = journey.departureDateTime?.toDate(format: Configuration.date),
            let arrivalDateTime = journey.arrivalDateTime?.toDate(format: Configuration.date) {
            formattedDateTime(departureDateTime, arrivalDateTime)
        }
        if let durationInt = journey.duration {
            formattedDuration(durationInt)
        }
        if let walkingDuration = journey.durations?.walking {
            if walkingDuration > 0 {
                let durationWalkingStr = walkingDuration.toStringTime()
                if let distanceWalking = journey.distances?.walking {
                    if distanceWalking > 999 {
                        formattedDurationWalker(walkingDuration, durationWalkingStr, distanceWalking.toString(format: "%.01f"), "units_km".localized(withComment: "units_km", bundle: NavitiaSDKUI.shared.bundle))
                    } else {
                        formattedDurationWalker(walkingDuration, durationWalkingStr, distanceWalking.toString())
                    }
                }
            } else {
                durationWalkerLabel.isHidden = true
                durationTopContraint.isActive = false
                durationBottomContraint.isActive = false
                durationLeadingContraint.isActive = false
            }
        }
        if let sections = journey.sections {
            journeySummaryView.disruption = disruptions
            journeySummaryView.addSections(sections)
        }
    }
    
    func setupRidesharing(_ journey: Journey) {
        _setupArrowIcon()
        addShadow()
        
        if let departureDateTime = journey.departureDateTime?.toDate(format: Configuration.date),
            let arrivalDateTime = journey.arrivalDateTime?.toDate(format: Configuration.date) {
            formattedDateTime(departureDateTime, arrivalDateTime)
        }
        if let durationInt = journey.duration {
            formattedDuration(prefix: "about".localized(withComment: "about", bundle: NavitiaSDKUI.shared.bundle) + " ", durationInt)
        }
        if let sections = journey.sections {
            journeySummaryView.addSections(sections)
        }
        if durationWalkerLabel != nil {
            durationWalkerLabel.isHidden = true
        }
        durationTopContraint.isActive = false
        durationBottomContraint.isActive = false
        durationLeadingContraint.isActive = false
    }
    
    private func _setupArrowIcon() {
        arrowLabel.attributedText = NSMutableAttributedString()
            .icon("arrow-right",
                  color: Configuration.Color.main,
                  size: 15)
    }
    
    private func formattedDateTime(_ departureDateTime: Date,_ arrivalDateTime: Date) {
        dateTime = NSMutableAttributedString()
            .bold(String(format: "%@ - %@",
                         departureDateTime.toString(format: Configuration.time),
                         arrivalDateTime.toString(format: Configuration.time)))
    }
    
    private func formattedDuration(prefix: String = "", _ duration: Int32) {
        let formattedStringDuration = NSMutableAttributedString()
            .semiBold(prefix, color: Configuration.Color.main)
        formattedStringDuration.append(duration.toAttributedStringTime(sizeBold: 12.5, sizeNormal: 12.5))
        self.duration = formattedStringDuration
    }
    
    private func formattedDurationWalker(_ duration: Int32,
                                         _ durationWalking: String,
                                         _ distanceWalking: String,
                                         _ unitDistance: String = "units_meters".localized(withComment: "meters", bundle: NavitiaSDKUI.shared.bundle)) {
        durationWalkerLabel.isHidden = false
        durationTopContraint.isActive = true
        durationBottomContraint.isActive = true
        durationLeadingContraint.isActive = true
        
        if duration < 60 {
            durationWalker = NSMutableAttributedString()
                .normal(String(format: "%@ %@",
                               "less_than_a".localized(withComment: "less than a", bundle: NavitiaSDKUI.shared.bundle),
                               "units_minute".localized(withComment: "minute", bundle: NavitiaSDKUI.shared.bundle)),
                        color: Configuration.Color.gray)
                .bold(durationWalking, color: Configuration.Color.gray)
                .normal(String(format: " %@ (%@ %@)",
                               "walking".localized(withComment: "walking", bundle: NavitiaSDKUI.shared.bundle),
                               distanceWalking,
                               unitDistance),
                        color: Configuration.Color.gray)
        } else {
            durationWalker = NSMutableAttributedString()
                .normal(String(format: "%@ ",
                               "with".localized(withComment: "with", bundle: NavitiaSDKUI.shared.bundle)),
                        color: Configuration.Color.gray)
                .bold(durationWalking, color: Configuration.Color.gray)
                .normal(String(format: " %@ (%@ %@)",
                               "walking".localized(withComment: "walking", bundle: NavitiaSDKUI.shared.bundle),
                               distanceWalking,
                               unitDistance),
                        color: Configuration.Color.gray)
        }
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

extension JourneySolutionCollectionViewCell {
    
    var dateTime: NSAttributedString? {
        get {
            return dateTimeLabel.attributedText
        }
        set {
            dateTimeLabel.attributedText = newValue
        }
    }
    
    var duration: NSAttributedString? {
        get {
            return durationLabel.attributedText
        }
        set {
            durationLabel.attributedText = newValue
        }
    }
    
    var durationWalker: NSAttributedString? {
        get {
            return durationWalkerLabel.attributedText
        }
        set {
            durationWalkerLabel.isHidden = false
            durationTopContraint.isActive = true
            durationBottomContraint.isActive = true
            durationLeadingContraint.isActive = true
            durationWalkerLabel.attributedText = newValue
        }
    }
    
}
