//
//  JourneyPartView.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 27/03/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class JourneySummaryPartView: UIView {
    
    @IBOutlet weak var _view: UIView!
    @IBOutlet weak var transportLabel: UILabel!
    @IBOutlet weak var _tagTransportView: UIView!
    @IBOutlet weak var _tagTransportLabel: UILabel!
    @IBOutlet weak var _lineTransportView: UIView!
    @IBOutlet weak var _disruptionLabel: UILabel!
    @IBOutlet weak var _circleLabel: UILabel!
    
    var _type: TypeTransport?
    var width = 1.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        _setup()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: 0.0)
    }
    
    private func _setup() {
        UINib(nibName: "JourneySummaryPartView", bundle:  bundle).instantiate(withOwner: self, options: nil)
        _view.frame = self.bounds
        addSubview(_view)
        
        _setupDisruption()
    }
    
    private func _setupDisruption() {
        _circleLabel.text = Icon("circle-filled").iconFontCode
        _circleLabel.textColor = UIColor.white
        _circleLabel.font = UIFont(name: "SDKIcons", size: 15)
        _circleLabel.isHidden = true
        
        _disruptionLabel.textColor = UIColor.red
        _disruptionLabel.font = UIFont(name: "SDKIcons", size: 14)
        _disruptionLabel.isHidden = true
    }
    
    func displayDisruption(_ iconName: String) {
        _disruptionLabel.text = Icon(iconName).iconFontCode
        _disruptionLabel.isHidden = false
        _circleLabel.isHidden = false
    }
    
}

extension JourneySummaryPartView {
    
    var color: UIColor? {
        get {
            return _tagTransportView.backgroundColor
        }
        set {
            _tagTransportView.backgroundColor = newValue
            _lineTransportView.backgroundColor = newValue
        }
    }
    
    var name: String? {
        get {
            return _tagTransportLabel.text
        }
        set {
            _tagTransportLabel.text = newValue
        }
    }
    
    var icon: String? {
        get {
            return transportLabel.text
        }
        set {
            if let newValue = newValue {
                if newValue == "walking" || newValue == "bss" || newValue == "car" {
                    _tagTransportView.isHidden = true
                    _tagTransportLabel.isHidden = true
                }
                transportLabel.text = Icon(newValue).iconFontCode
                transportLabel.font = UIFont(name: "SDKIcons", size: 20)
            }
        }
    }
    
}

