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
        if let durationWalkingStr = journey.durations?.walking?.toStringTime(),
            let distanceWalking = journey.distances?.walking {
            if distanceWalking > 999 {
                formattedDurationWalker(durationWalkingStr, distanceWalking.toString(format: "%.01f"), "units_km".localized(withComment: "units_km", bundle: NavitiaSDKUIConfig.shared.bundle))
            } else {
                formattedDurationWalker(durationWalkingStr, distanceWalking.toString())
            }
        }
        if let sections = journey.sections {
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
            formattedDuration(prefix: "about".localized(withComment: "about", bundle: NavitiaSDKUIConfig.shared.bundle) + " ", durationInt)
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
                  color: Configuration.Color.tertiary,
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
            .semiBold(prefix, color: Configuration.Color.tertiary)
        formattedStringDuration.append(duration.toAttributedStringTime(sizeBold: 14, sizeNormal: 10.5))
        self.duration = formattedStringDuration
    }
    
    private func formattedDurationWalker(_ durationWalking: String,
                                         _ distanceWalking: String,
                                         _ unitDistance: String = "units_meters".localized(withComment: "meters", bundle: NavitiaSDKUIConfig.shared.bundle)) {
        
        durationWalker = NSMutableAttributedString()
            .normal(String(format: "%@ ",
                           "with".localized(withComment: "with", bundle: NavitiaSDKUIConfig.shared.bundle)),
                    color: Configuration.Color.gray)
            .bold(durationWalking, color: Configuration.Color.gray)
            .normal(String(format: " %@ (%@ %@)",
                           "walking".localized(withComment: "walking", bundle: NavitiaSDKUIConfig.shared.bundle),
                           distanceWalking,
                           unitDistance),
                    color: Configuration.Color.gray)
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
