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
    
    static var identifier: String {
        return String(describing: self)
    }
    
    class func instanceFromNib() -> PublicTransportWaitingBlocView {
        return UINib(nibName: identifier, bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: nil, options: nil)[0] as! PublicTransportWaitingBlocView
    }
    
    var waitingTime: String? {
        get {
            return waitingTimeLabel.text
        }
        set {
            if let newValue = newValue {
                waitingIconLabel.attributedText = NSMutableAttributedString()
                    .icon("clock", color: Configuration.Color.darkerGray, size: 15)
                waitingTimeLabel.attributedText = NSMutableAttributedString()
                    .normal(newValue, color: Configuration.Color.darkerGray, size: 12)
            }
        }
    }
}
