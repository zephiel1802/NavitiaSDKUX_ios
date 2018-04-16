//
//  TransferStepView.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 10/04/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class TransferStepView: UIView {
    
    @IBOutlet var _view: UIView!
    
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var _type: TypeTransport?
    
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
        UINib(nibName: "TransferStepView", bundle: bundle).instantiate(withOwner: self, options: nil)
        _view.frame = self.bounds
        addSubview(_view)
    }
    
}

extension TransferStepView {
    
    var typeString: String? {
        get {
            return _type?.rawValue
        }
        set {
            if let newValue = newValue {
                _type = TypeTransport(rawValue: newValue)
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
                iconLabel.text = Icon(newValue).iconFontCode
                iconLabel.font = UIFont(name: "SDKIcons", size: 20)
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
                    .normal("to".localized(withComment: "to", bundle: bundle), size: 15)
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
                var duration = newValue + " " + "units_minutes".localized(withComment: "units_minutes", bundle: bundle)
                if time == "1" {
                    duration = newValue + " " + "unit_minutes".localized(withComment: "unit_minutes", bundle: bundle)
                }
                var template = ""
                if let type = _type {
                    switch type {
                    case .walking:
                        template = "a_time_walk".localized(withComment: "a_time_walk", bundle: bundle)
                    case .car:
                        template = "a_time_drive".localized(withComment: "a_time_drive", bundle: bundle)
                    case .bike:
                        template = "a_time_ride".localized(withComment: "a_time_ride", bundle: bundle)
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
