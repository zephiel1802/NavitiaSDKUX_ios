//
//  BikeStepView.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 12/04/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class BikeStepView: UIView {
    
    @IBOutlet var _view: UIView!
    
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var takeLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
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
    
    private func _setup() {
        UINib(nibName: "BikeStepView", bundle: bundle).instantiate(withOwner: self, options: nil)
        _view.frame = self.bounds
        addSubview(_view)
        
    }
    
    private func setHeight() {
        frame.size.height = timeLabel.frame.size.height + timeLabel.frame.origin.y + 10
    }

}

extension BikeStepView {
    
    var type: TypeTransport? {
        get {
            return _type
        }
        set {
            if let type = newValue {
                _type = type
                icon = type.rawValue
            }
        }
    }
    
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
    
    var takeName:String? {
        get {
            return takeLabel.text
        }
        set {
            if let newValue = newValue {
                var typeString = ""
                if let type = _type {
                    typeString = type.rawValue + " "
                }
                takeLabel.attributedText = NSMutableAttributedString()
                    .normal("Prendre un ", size: 15)
                    .normal(typeString, size: 15)
                    .normal(newValue, size: 15)
                takeLabel.sizeToFit()
                setHeight()
            }
        }
    }
    
    var origin:String? {
        get {
            return originLabel.text
        }
        set {
            if let newValue = newValue {
                originLabel.attributedText = NSMutableAttributedString()
                    .normal("à ", size: 15)
                    .bold(newValue, size: 15)
                originLabel.sizeToFit()
                setHeight()
            }
        }
    }
    
    var destination:String? {
        get {
            return destinationLabel.text
        }
        set {
            if let newValue = newValue {
                destinationLabel.attributedText = NSMutableAttributedString()
                    .normal("vers ", size: 15)
                    .bold(newValue, size: 15)
                destinationLabel.sizeToFit()
                setHeight()
            }
        }
    }
    
    var time:String? {
        get {
            return timeLabel.text
        }
        set {
            if let newValue = newValue {
                var typeString = ""
                if let type = _type {
                    typeString = " de " + type.rawValue
                }
                timeLabel.attributedText = NSMutableAttributedString()
                    .normal(newValue, size: 15)
                    .normal(" minutes", size: 15)
                    .normal(typeString, size: 15)
                timeLabel.sizeToFit()
                setHeight()
            }
        }
    }
}
