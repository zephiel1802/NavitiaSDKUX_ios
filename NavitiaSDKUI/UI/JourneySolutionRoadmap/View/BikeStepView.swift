//
//  BikeStepView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class BikeStepView: UIView {
    
    @IBOutlet var _view: UIView!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var takeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var _mode: ModeTransport?
    
    var takeName: String = "" {
        didSet {
            _updateTakeLabel()
        }
    }

    var origin: String = "" {
        didSet {
            _updateTakeLabel()
        }
    }
    var destination: String = "" {
        didSet {
            _updateTakeLabel()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        _setup()
        addShadow(opacity: 0.28)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var frame: CGRect {
        didSet {
            if let _view = _view {
                _view.frame.size = frame.size
                
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        _setup()
    }
    
    private func _setup() {
        UINib(nibName: "BikeStepView", bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: self, options: nil)
        _view.frame = self.bounds
        addSubview(_view)
    }
    
    func setHeight() {
        let timeLabelSize = timeLabel.attributedText?.boundingRect(with: CGSize(width: frame.size.width - 60, height: 9990), options: .usesLineFragmentOrigin, context: nil)
        let takeLabelSize = takeLabel.attributedText?.boundingRect(with: CGSize(width: frame.size.width - 60, height: 9990), options: .usesLineFragmentOrigin, context: nil)
        frame.size.height = (timeLabelSize?.height)! + (takeLabelSize?.height)! + 20
    }
    
    private func _updateTakeLabel() {
        takeLabel.attributedText = NSMutableAttributedString()
            .normal(String(format: "take_a_bike_at".localized(withComment: "take_a_bike_at", bundle: NavitiaSDKUI.shared.bundle), takeName), size: 15)
            .normal(" ", size: 15)
            .bold(origin, size: 15)
            .normal(" ", size: 15)
            .normal("in_the_direction_of".localized(withComment: "in_the_direction_of", bundle: NavitiaSDKUI.shared.bundle), size: 15)
            .normal(" ", size: 15)
            .bold(destination, size: 15)
        setHeight()
    }

}

extension BikeStepView {
    
    var mode: ModeTransport? {
        get {
            return _mode
        }
        set {
            if let mode = newValue {
                _mode = mode
                icon = mode.rawValue
            }
        }
    }
    
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
    
    var time:String? {
        get {
            return timeLabel.text
        }
        set {
            if let newValue = newValue {
                var duration = newValue + " " + "units_minutes".localized(withComment: "minutes", bundle: NavitiaSDKUI.shared.bundle)
                if time == "1" {
                    duration = newValue + " " + "unit_minutes".localized(withComment: "minute", bundle: NavitiaSDKUI.shared.bundle)
                }
                var template = ""
                if let mode = _mode {
                    switch mode {
                    case .walking:
                        template = "a_time_walk".localized(withComment: "A time walk", bundle: NavitiaSDKUI.shared.bundle)
                    case .car:
                        template = "a_time_drive".localized(withComment: "A time drive", bundle: NavitiaSDKUI.shared.bundle)
                    case .ridesharing:
                        template = "a_time_drive".localized(withComment: "A time drive", bundle: NavitiaSDKUI.shared.bundle)
                    case .bike:
                        template = "a_time_ride".localized(withComment: "A time ride", bundle: NavitiaSDKUI.shared.bundle)
                    case .bss:
                        template = "a_time_ride".localized(withComment: "A time ride", bundle: NavitiaSDKUI.shared.bundle)
                    default:
                        break
                    }
                }
                timeLabel.attributedText = NSMutableAttributedString()
                    .normal(String(format: template, duration), size: 15)
            }
        }
    }
    
}
