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
    
    internal var journeyCarbon: (value: Double, unit: String)? {
        didSet {
            if let journeyCarbon = journeyCarbon {
                journeyCarbonAutoFilledLabel.autofillLeftText = "carbon_journey".localized()
                journeyCarbonAutoFilledLabel.autofillRightText = String(format: "%.1f %@", journeyCarbon.value, journeyCarbon.unit)
                journeyCarbonAutoFilledLabel.autofillPattern = "."
                journeyCarbonAutoFilledLabel.delegate = self
            }
        }
    }
    
    internal var carCarbon: (value: Double, unit: String)? {
        didSet {
            if let journeyCarbon = journeyCarbon, let carCarbon = carCarbon, carCarbon.value != journeyCarbon.value {
                carCarbonAutoFilledLabel.autofillLeftText = "carbon_car".localized()
                carCarbonAutoFilledLabel.autofillRightText = String(format: "%.1f %@", carCarbon.value, carCarbon.unit)
                carCarbonAutoFilledLabel.autofillPattern = "."
                carCarbonAutoFilledLabel.delegate = self
            } else {
                hideCarCarbonSummary()
            }
        }
    }
    
    // MARK: - UINib
    
    static var identifier: String {
        return String(describing: self)
    }
    
    class func instanceFromNib() -> EmissionView {
        return UINib(nibName: identifier, bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: nil, options: nil)[0] as! EmissionView
    }
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    // MARK: - Function
    
    private func setup() {
        backgroundColor = Configuration.Color.main
        setShadow(opacity: 0.28)
    }
    
    private func hideCarCarbonSummary() {
        carCarbonAutoFilledLabel.isHidden = true
        journeyLabelBottomConstraint.isActive = false
        journeyLabelCenterVerticallyConstraint.isActive = true
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
