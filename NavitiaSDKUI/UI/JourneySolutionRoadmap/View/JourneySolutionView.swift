//
//  JourneySolutionView.swift
//  NavitiaSDKUI
//
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
        UINib(nibName: "JourneySolutionView", bundle: NavitiaSDKUIConfig.shared.bundle).instantiate(withOwner: self, options: nil)
        _view.frame = self.bounds
        addSubview(_view)
        addShadow()
    }

    func setData(_ journey: Journey) {
        if let departureDateTime = journey.departureDateTime?.toDate(format: FormatConfiguration.date),
            let arrivalDateTime = journey.arrivalDateTime?.toDate(format: FormatConfiguration.date) {
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
    
    func setDataRidesharing(_ journey: Journey) {
        if let departureDateTime = journey.departureDateTime?.toDate(format: FormatConfiguration.date),
            let arrivalDateTime = journey.arrivalDateTime?.toDate(format: FormatConfiguration.date) {
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
    
    private func formattedDateTime(_ departureDateTime: Date,_ arrivalDateTime: Date) {
        dateTime = NSMutableAttributedString()
            .bold(String(format: "%@ - %@",
                         departureDateTime.toString(format: FormatConfiguration.time),
                         arrivalDateTime.toString(format: FormatConfiguration.time)))
    }
    
    private func formattedDuration(prefix: String = "", _ duration: Int32) {
        let formattedStringDuration = NSMutableAttributedString()
            .semiBold(prefix, color: NavitiaSDKUIConfig.shared.color.tertiary)
        formattedStringDuration.append(duration.toAttributedStringTime())
        self.duration = formattedStringDuration
    }
    
    private func formattedDurationWalker(_ durationWalking: String,
                                         _ distanceWalking: String,
                                         _ unitDistance: String = "units_meters".localized(withComment: "units_meters", bundle: NavitiaSDKUIConfig.shared.bundle)) {
        
        durationWalker = NSMutableAttributedString()
            .normal(String(format: "%@ ",
                           "with".localized(withComment: "with", bundle: NavitiaSDKUIConfig.shared.bundle)),
                    color: NavitiaSDKUIConfig.shared.color.gray)
            .bold(durationWalking, color: NavitiaSDKUIConfig.shared.color.gray)
            .normal(String(format: " %@ (%@ %@)",
                           "walking".localized(withComment: "walking", bundle: NavitiaSDKUIConfig.shared.bundle),
                           distanceWalking,
                           unitDistance),
                    color: NavitiaSDKUIConfig.shared.color.gray)
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
