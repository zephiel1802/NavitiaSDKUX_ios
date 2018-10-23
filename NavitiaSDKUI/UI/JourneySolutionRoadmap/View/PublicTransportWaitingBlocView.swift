//
//  PublicTransportWaitingBlocView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation
import UIKit

class PublicTransportWaitingBlocView: UIView {
    
    @IBOutlet weak var waitingIconLabel: UILabel!
    @IBOutlet weak var waitingTimeLabel: UILabel!
    
    class func instanceFromNib() -> PublicTransportWaitingBlocView {
        return UINib(nibName: "PublicTransportWaitingBlocView", bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: nil, options: nil)[0] as! PublicTransportWaitingBlocView
    }
    
    var waitingTime: String? {
        get {
            return waitingTimeLabel.text
        }
        set {
            if let newValue = newValue {
                var unit = "units_minutes".localized(withComment: "minutes", bundle: NavitiaSDKUI.shared.bundle)
                if newValue == "1" {
                    unit = "units_minute".localized(withComment: "minute", bundle: NavitiaSDKUI.shared.bundle)
                }
                waitingIconLabel.attributedText = NSMutableAttributedString()
                    .icon("clock", color: Configuration.Color.darkerGray, size: 15)
                waitingTimeLabel.attributedText = NSMutableAttributedString()
                    .normal("wait".localized(withComment: "wait", bundle: NavitiaSDKUI.shared.bundle), color: Configuration.Color.darkerGray, size: 12)
                    .normal(" ", color: Configuration.Color.darkerGray, size: 12)
                    .normal(newValue, color: Configuration.Color.darkerGray, size: 12)
                    .normal(" ", color: Configuration.Color.darkerGray, size: 12)
                    .normal(unit, color: Configuration.Color.darkerGray, size: 12)
            }
        }
    }
}
