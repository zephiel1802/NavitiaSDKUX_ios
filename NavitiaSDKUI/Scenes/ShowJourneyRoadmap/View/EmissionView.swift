//
//  EmissionView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class EmissionView: UIView {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var journeyCarbonAutoFilledLabel: UIAutoFilledLabel!
    @IBOutlet weak var carCarbonAutoFilledLabel: UIAutoFilledLabel!
    @IBOutlet weak var journeyLabelCenterVerticallyConstraint: NSLayoutConstraint!
    @IBOutlet weak var journeyLabelBottomConstraint: NSLayoutConstraint!
    
    static var identifier: String {
        return String(describing: self)
    }
    
    class func instanceFromNib() -> EmissionView {
        return UINib(nibName: identifier, bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: nil, options: nil)[0] as! EmissionView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        backgroundColor = Configuration.Color.main
        addShadow(opacity: 0.28)
    }
    
    var journeyCarbon: (value: Double, unit: String)? {
        didSet {
            if let journeyCarbon = journeyCarbon {
                journeyCarbonAutoFilledLabel.autofillLeftText = "carbon_journey".localized()
                journeyCarbonAutoFilledLabel.autofillRightText = String(format: "%.1f %@", journeyCarbon.value, journeyCarbon.unit)
                journeyCarbonAutoFilledLabel.autofillPattern = "."
                journeyCarbonAutoFilledLabel.delegate = self
            }
        }
    }
    
    var carCarbon: (value: Double, unit: String)? {
        didSet {
            if let journeyCarbon = journeyCarbon, let carCarbon = carCarbon, carCarbon.value != journeyCarbon.value {
                carCarbonAutoFilledLabel.autofillLeftText = "carbon_car".localized()
                carCarbonAutoFilledLabel.autofillRightText = String(format: "%.1f %@", carCarbon.value, carCarbon.unit)
                carCarbonAutoFilledLabel.autofillPattern = "."
                carCarbonAutoFilledLabel.delegate = self
            } else {
                self.carCarbonAutoFilledLabel.isHidden = true
                self.journeyLabelBottomConstraint.isActive = false
                self.journeyLabelCenterVerticallyConstraint.isActive = true
            }
        }
    }
    
    func hideCarCarbonSummary() {
        self.carCarbonAutoFilledLabel.isHidden = true
        self.journeyLabelBottomConstraint.isActive = false
        self.journeyLabelCenterVerticallyConstraint.isActive = true
    }
}

extension EmissionView: UIAutoFilledLabelDelegate {
    
    func autofillDidFinish(_ target: UIAutoFilledLabel) {
        guard let autofillText = target.text, autofillText.count > 0 else {
            return
        }
        
        let mutableText = NSMutableAttributedString(string: autofillText)
        mutableText.addAttributes([.font : UIFont.systemFont(ofSize: 7.0, weight: .semibold)], range: NSMakeRange(autofillText.count - 1, 1))
        target.attributedText = mutableText
    }
}
