//
//  JourneySolutionCollectionViewCell.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 26/03/2018.
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
        
        if let departureDateTime = journey.departureDateTime?.toDate(format: "yyyyMMdd'T'HHmmss"),
            let arrivalDateTime = journey.arrivalDateTime?.toDate(format: "yyyyMMdd'T'HHmmss") {
            formattedDateTime(departureDateTime, arrivalDateTime)
        }
        if let durationStr = journey.duration?.toString(allowedUnits: [.hour, .minute]) {
            formattedDuration(durationStr)
        }
        if let durationWalkingStr = journey.durations?.walking?.toString(allowedUnits: [ .hour, .minute ]),
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
        
        if let departureDateTime = journey.departureDateTime?.toDate(format: "yyyyMMdd'T'HHmmss"),
            let arrivalDateTime = journey.arrivalDateTime?.toDate(format: "yyyyMMdd'T'HHmmss") {
            formattedDateTime(departureDateTime, arrivalDateTime)
        }
        if let durationStr = journey.duration?.toString(allowedUnits: [.hour, .minute]) {
            formattedDuration("about".localized(withComment: "about", bundle: NavitiaSDKUIConfig.shared.bundle) + " " + durationStr)
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
        arrowLabel.text = Icon("arrow-right").iconFontCode
        arrowLabel.textColor = NavitiaSDKUIConfig.shared.color.tertiary
        arrowLabel.font = UIFont(name: "SDKIcons", size: 15)
    }
    
    private func formattedDateTime(_ departureDateTime: Date,_ arrivalDateTime: Date) {
        let formattedStringDateTime = NSMutableAttributedString()
        formattedStringDateTime
            .bold(departureDateTime.toString(format: "HH:mm"))
            .bold(" - ")
            .bold(arrivalDateTime.toString(format: "HH:mm"))
        dateTime = formattedStringDateTime
    }
    
    private func formattedDuration(_ durationStr: String) {
        let formattedStringDuration = NSMutableAttributedString()
        formattedStringDuration
            .bold(durationStr, color: NavitiaSDKUIConfig.shared.color.tertiary)
        duration = formattedStringDuration
    }
    
    private func formattedDurationWalker(_ durationWalking: String,
                                         _ distanceWalking: String,
                                         _ unitDistance: String = "units_meters".localized(withComment: "units_meters", bundle: NavitiaSDKUIConfig.shared.bundle)) {
        let formattedString = NSMutableAttributedString()
        
        formattedString
            .normal("with".localized(withComment: "with", bundle: NavitiaSDKUIConfig.shared.bundle), color: NavitiaSDKUIConfig.shared.color.gray)
            .normal(" ", color: NavitiaSDKUIConfig.shared.color.gray)
            .bold(durationWalking, color: NavitiaSDKUIConfig.shared.color.gray)
            .normal(" ", color: NavitiaSDKUIConfig.shared.color.gray)
            .normal("walking".localized(withComment: "walking", bundle: NavitiaSDKUIConfig.shared.bundle), color: NavitiaSDKUIConfig.shared.color.gray)
            .normal(" (", color: NavitiaSDKUIConfig.shared.color.gray)
            .normal(distanceWalking, color: NavitiaSDKUIConfig.shared.color.gray)
            .normal(" ", color: NavitiaSDKUIConfig.shared.color.gray)
            .normal(unitDistance, color: NavitiaSDKUIConfig.shared.color.gray)
            .normal(")", color: NavitiaSDKUIConfig.shared.color.gray)
        durationWalker = formattedString
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
