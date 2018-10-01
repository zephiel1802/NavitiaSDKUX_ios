//
//  JourneyPartView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class JourneySummaryPartView: UIView {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var transportLabel: UILabel!
    @IBOutlet weak var tagTransportView: UIView!
    @IBOutlet weak var tagTransportLabel: UILabel!
    @IBOutlet weak var lineTransportView: UIView!
    @IBOutlet weak var disruptionLabel: UILabel!
    @IBOutlet weak var circleLabel: UILabel!
    
    var width = 1.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: 0.0)
    }
    
    private func setup() {
        UINib(nibName: "JourneySummaryPartView", bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: self, options: nil)
        view.frame = self.bounds
        addSubview(view)
        setupDisruption()
        
        tagTransportView.isHidden = true
        tagTransportLabel.isHidden = true
    }
    
    private func setupDisruption() {
        circleLabel.attributedText = NSMutableAttributedString()
            .icon("circle-filled",
                  color: UIColor.white,
                  size: 15)
        circleLabel.isHidden = true
        disruptionLabel.isHidden = true
    }
    
    func displayDisruption(_ iconName: String, color: String?) {
        disruptionLabel.attributedText = NSMutableAttributedString()
            .icon(iconName,
                  color: color?.toUIColor() ?? Configuration.Color.red,
                  size: 14)
        disruptionLabel.isHidden = false
        circleLabel.isHidden = false
    }
    
}

extension JourneySummaryPartView {
    
    var color: UIColor? {
        get {
            return tagTransportView.backgroundColor
        }
        set {
            tagTransportView.backgroundColor = newValue
            lineTransportView.backgroundColor = newValue
        }
    }
    
    var name: String? {
        get {
            return tagTransportLabel.text
        }
        set {
            if let newValue = newValue {
                tagTransportView.isHidden = false
                tagTransportLabel.isHidden = false
                let tagBackgroundColor = tagTransportView.backgroundColor ?? .black
                tagTransportLabel.attributedText = NSMutableAttributedString()
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

