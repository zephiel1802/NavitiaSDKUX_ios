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
    @IBOutlet weak var lineOneLabel: UILabel!
    @IBOutlet weak var lineTwoLabel: UILabel!
    
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
    
    var lineOne: String? {
        get {
            return lineOneLabel.text
        }
        set {
            if let newValue = newValue {
                let formattedString = NSMutableAttributedString()
                formattedString
                    .normal("Vers ", size: 15)
                    .bold(newValue, size: 15)
                lineOneLabel.attributedText = formattedString
                lineOneLabel.sizeToFit()
                setHeight()
            }
        }
    }
    
    var lineTwo: String? {
        get {
            return lineTwoLabel.text
        }
        set {
            if let newValue = newValue {
                let formattedString = NSMutableAttributedString()
                formattedString
                    .normal(newValue, size: 15)
                lineTwoLabel.attributedText = formattedString
                lineTwoLabel.sizeToFit()
                setHeight()
            }
        }
    }
    
    private func setHeight() {
        frame.size.height = lineTwoLabel.frame.size.height + lineTwoLabel.frame.origin.y + 10
    }
}

class DepartureArrivalStepView: UIView {
    
    @IBOutlet var _view: UIView!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var informationLabel: UILabel!
    
    enum TypeStep: String {
        case departure
        case arrival
    }
    
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
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        print("Je me suis update \(self.stackView.frame.size)")
//        self.frame.size.height = self.stackView.frame.size.height - 20
//        // in this method, the frame has been set.
//    }
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        _setup()
    }
    
    private func _setup() {
        UINib(nibName: "DepartureArrivalStepView", bundle: bundle).instantiate(withOwner: self, options: nil)
        _view.frame = self.bounds
        addSubview(_view)
        
        iconLabel.text = Icon("location-pin").iconFontCode
        iconLabel.font = UIFont(name: "SDKIcons", size: 22)
        iconLabel.textColor = UIColor.white
    }

    
    var title: String? {
        get {
            return titleLabel.text
        }
        set {
            if let newValue = newValue {
                titleLabel.text = newValue
                self.layoutIfNeeded()
            }
        }
    }

    var information: String? {
        get {
            return informationLabel.text
        }
        set {
            if let newValue = newValue {
                informationLabel.text = newValue
            }
        }
    }
    
    var type: TypeStep {
        get {
            return .departure
        }
        set {
            if newValue == .departure {
                self._view.backgroundColor = UIColor(red:0, green:0.73, blue:0.46, alpha:1.0)
            } else {
                self._view.backgroundColor = UIColor(red:0.69, green:0.01, blue:0.33, alpha:1.0)
            }
        }
    }
    
    private func setHeight() {
        //frame.size.height = stackView.frame.size.height + 20
    }
}
