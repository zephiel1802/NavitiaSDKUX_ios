//
//  TransferStepView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class TransferStepView: UIView {
    
    @IBOutlet var _view: UIView!
    
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var _mode: ModeTransport?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var frame: CGRect {
        willSet {
            if let _view = _view {
                _view.frame.size = newValue.size
            }
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        _setup()
    }
    
    override func layoutSubviews() {
        directionLabel.sizeToFit()
        timeLabel.sizeToFit()
        timeLabel.frame.origin.y = directionLabel.frame.origin.y + directionLabel.frame.size.height
        frame.size.height = timeLabel.frame.size.height + timeLabel.frame.origin.y + 10
    }

    private func _setup() {
        UINib(nibName: "TransferStepView", bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: self, options: nil)
        _view.frame = self.bounds
        addSubview(_view)
    }
    
}

extension TransferStepView {
    
    var modeString: String? {
        get {
            return _mode?.rawValue
        }
        set {
            if let newValue = newValue {
                _mode = ModeTransport(rawValue: newValue)
                icon = newValue
            }
        }
    }
    
    var icon: String? {
        get {
            return iconLabel.text
        }
        set {
            if let newValue = newValue {
                iconLabel.attributedText = NSMutableAttributedString()
                    .icon(newValue, size: 20)
            }
        }
    }
    
    var direction: String? {
        get {
            return directionLabel.text
        }
        set {
            if let newValue = newValue {
                let formattedString = NSMutableAttributedString()
                formattedString
                    .normal("to_with_uppercase".localized(withComment: "To", bundle: NavitiaSDKUI.shared.bundle), size: 15)
                    .normal(" ", size: 15)
                    .bold(newValue, size: 15)
                directionLabel.attributedText = formattedString
            }
        }
    }

    var time: String? {
        get {
            return timeLabel.text
        }
        set {
            if let newValue = newValue {
                var duration = newValue + " " + "units_minutes".localized(withComment: "minutes", bundle: NavitiaSDKUI.shared.bundle)
                if Int(newValue) == 1 {
                    duration = newValue + " " + "units_minute".localized(withComment: "minute", bundle: NavitiaSDKUI.shared.bundle)
                } else if Int(newValue) == 0 {
                    duration = "less_than_a".localized(withComment: "less than a", bundle: NavitiaSDKUI.shared.bundle) + " " + "units_minute".localized(withComment: "minute", bundle: NavitiaSDKUI.shared.bundle)
                }
                
                var template = ""
                if let mode = _mode {
                    switch mode {
                        case .walking:
                            template = "a_time_walk".localized(withComment: "A time walk", bundle: NavitiaSDKUI.shared.bundle)
                            break
                        case .car:
                            template = "a_time_drive".localized(withComment: "A time drive", bundle: NavitiaSDKUI.shared.bundle)
                            break
                        case .bike:
                            template = "a_time_ride".localized(withComment: "A time ride", bundle: NavitiaSDKUI.shared.bundle)
                            break
                        default:
                            break
                    }
                }
                
                let formattedString = NSMutableAttributedString()
                formattedString
                    .normal(String(format: template, duration), size: 15)
                timeLabel.attributedText = formattedString
            }
        }
    }
    
}
