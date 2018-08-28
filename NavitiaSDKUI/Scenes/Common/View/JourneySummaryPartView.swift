//
//  JourneyPartView.swift
//  NavitiaSDKUI
//
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
        UINib(nibName: "JourneySummaryPartView", bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: self, options: nil)
        _view.frame = self.bounds
        addSubview(_view)
        _setupDisruption()
        
        _tagTransportView.isHidden = true
        _tagTransportLabel.isHidden = true
    }
    
    private func _setupDisruption() {
        _circleLabel.attributedText = NSMutableAttributedString()
            .icon("circle-filled",
                  color: UIColor.white,
                  size: 15)
        _circleLabel.isHidden = true
        _disruptionLabel.isHidden = true
    }
    
    func displayDisruption(_ iconName: String, color: String?) {
        _disruptionLabel.attributedText = NSMutableAttributedString()
            .icon(iconName,
                  color: color?.toUIColor() ?? Configuration.Color.red,
                  size: 14)
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
            if let newValue = newValue {
                _tagTransportView.isHidden = false
                _tagTransportLabel.isHidden = false
                let tagBackgroundColor = _tagTransportView.backgroundColor ?? .black
                _tagTransportLabel.attributedText = NSMutableAttributedString()
                    .bold(newValue, color: tagBackgroundColor.contrastColor(), size: 9)
            }
        }
    }
    
    var icon: String? {
        get {
            return transportLabel.text
        }
        set {
            if let newValue = newValue {
                transportLabel.attributedText = NSMutableAttributedString()
                    .icon(newValue, size: 20)
            }
        }
    }
    
}

