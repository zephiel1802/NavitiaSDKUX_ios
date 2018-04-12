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

    private func _setup() {
        UINib(nibName: "TransferStepView", bundle: bundle).instantiate(withOwner: self, options: nil)
        _view.frame = self.bounds
        addSubview(_view)
    }
    
    private func setHeight() {
        frame.size.height = timeLabel.frame.size.height + timeLabel.frame.origin.y + 10
    }
}

extension TransferStepView {
    
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
                    .normal("Vers ", size: 15)
                    .bold(newValue, size: 15)
                directionLabel.attributedText = formattedString
                directionLabel.sizeToFit()
                setHeight()
            }
        }
    }
    
    var time: String? {
        get {
            return timeLabel.text
        }
        set {
            if let newValue = newValue {
                let formattedString = NSMutableAttributedString()
                formattedString
                    .normal(newValue, size: 15)
                timeLabel.attributedText = formattedString
                timeLabel.sizeToFit()
                setHeight()
            }
        }
    }
    
}
