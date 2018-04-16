//
//  JourneySolutionView.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 13/04/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class JourneySolutionView: UIView {
    
    @IBOutlet var _view: UIView!
    
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var journeySummaryView: JourneySummaryView!
    @IBOutlet weak var durationWalkerLabel: UILabel!
    
    @IBOutlet weak var durationTopContraint: NSLayoutConstraint!
    @IBOutlet weak var durationBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var durationLeadingContraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        _setup()
    }
    
    private func _setup() {
        UINib(nibName: "JourneySolutionView", bundle: bundle).instantiate(withOwner: self, options: nil)
        _view.frame = self.bounds
        addSubview(_view)
        
    }
    
    func setData(_ journey: Journey) {
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
                formattedDurationWalker(durationWalkingStr, distanceWalking.toString(format: "%.01f"), "units_km".localized(withComment: "units_km", bundle: bundle))
            } else {
                formattedDurationWalker(durationWalkingStr, distanceWalking.toString())
            }
        }
        if let sections = journey.sections {
            journeySummaryView.addSections(sections)
        }
    }
    
    func setDataRidesharing(_ journey: Journey) {
        if let departureDateTime = journey.departureDateTime?.toDate(format: "yyyyMMdd'T'HHmmss"),
            let arrivalDateTime = journey.arrivalDateTime?.toDate(format: "yyyyMMdd'T'HHmmss") {
            formattedDateTime(departureDateTime, arrivalDateTime)
        }
        if let durationStr = journey.duration?.toString(allowedUnits: [.hour, .minute]) {
            formattedDuration("about".localized(withComment: "about", bundle: bundle) + " " + durationStr)
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
    
    func formattedDateTime(_ departureDateTime: Date,_ arrivalDateTime: Date) {
        let formattedStringDateTime = NSMutableAttributedString()
        formattedStringDateTime
            .bold(departureDateTime.toString(format: "HH:mm"))
            .bold(" - ")
            .bold(arrivalDateTime.toString(format: "HH:mm"))
        dateTime = formattedStringDateTime
    }
    
    func formattedDuration(_ durationStr: String) {
        let formattedStringDuration = NSMutableAttributedString()
        formattedStringDuration
            .bold(durationStr, color: NavitiaSDKUIConfig.shared.color.tertiary)
        duration = formattedStringDuration
    }
    
    private func formattedDurationWalker(_ durationWalking: String,
                                         _ distanceWalking: String,
                                         _ unitDistance: String = "units_meters".localized(withComment: "units_meters", bundle: bundle)) {
        let formattedString = NSMutableAttributedString()
        
        formattedString
            .normal("with".localized(withComment: "with", bundle: bundle), color: NavitiaSDKUIConfig.shared.color.gray)
            .normal(" ", color: NavitiaSDKUIConfig.shared.color.gray)
            .bold(durationWalking, color: NavitiaSDKUIConfig.shared.color.gray)
            .normal(" ", color: NavitiaSDKUIConfig.shared.color.gray)
            .normal("walking".localized(withComment: "walking", bundle: bundle), color: NavitiaSDKUIConfig.shared.color.gray)
            .normal(" (", color: NavitiaSDKUIConfig.shared.color.gray)
            .normal(distanceWalking, color: NavitiaSDKUIConfig.shared.color.gray)
            .normal(" ", color: NavitiaSDKUIConfig.shared.color.gray)
            .normal(unitDistance, color: NavitiaSDKUIConfig.shared.color.gray)
            .normal(")", color: NavitiaSDKUIConfig.shared.color.gray)
        durationWalker = formattedString
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
}

extension JourneySolutionView {
    
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
            durationWalkerLabel.attributedText = newValue
        }
    }
    
}
