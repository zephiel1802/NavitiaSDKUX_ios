//
//  BikeStepView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class RidesharingStepView: UIView {
    
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
        UINib(nibName: "RidesharingStepView", bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: self, options: nil)
        _view.frame = self.bounds
        addSubview(_view)
        
        _setIcon()
    }
    
    private func _setIcon() {
        iconLabel.attributedText = NSMutableAttributedString()
            .icon("ridesharing", size: 20)
    }
    
    func setHeight() {
        let timeLabelSize = timeLabel.attributedText?.boundingRect(with: CGSize(width: frame.size.width - 60, height: 9990), options: .usesLineFragmentOrigin, context: nil)
        let takeLabelSize = takeLabel.attributedText?.boundingRect(with: CGSize(width: frame.size.width - 60, height: 9990), options: .usesLineFragmentOrigin, context: nil)
        frame.size.height = (timeLabelSize?.height)! + (takeLabelSize?.height)! + 20
    }
    
    private func _updateTakeLabel() {
        takeLabel.attributedText = NSMutableAttributedString()
            .normal("take_the_ridesharing".localized(withComment: "Take the ridesharing at", bundle: NavitiaSDKUI.shared.bundle), size: 15)
            .normal(" ", size: 15)
            .bold(origin, size: 15)
            .normal(" ", size: 15)
            .normal("to".localized(withComment: "to", bundle: NavitiaSDKUI.shared.bundle), size: 15)
            .normal(" ", size: 15)
            .bold(destination, size: 15)
        setHeight()
    }

}

extension RidesharingStepView {
    
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
                timeLabel.attributedText = NSMutableAttributedString()
                    .normal(String(format: "about".localized(withComment: "About", bundle: NavitiaSDKUI.shared.bundle), ""), size: 15)
                    .normal(" ", size: 15)
                    .normal(String(format: "a_time_drive".localized(withComment: "A time drive", bundle: NavitiaSDKUI.shared.bundle), duration), size: 15)
            }
        }
    }
    
}
