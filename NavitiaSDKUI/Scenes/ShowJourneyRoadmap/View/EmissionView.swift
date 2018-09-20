//
//  EmissionView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class EmissionView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var journeyCarbonAutoFilledLabel: UIAutoFilledLabel!
    @IBOutlet weak var carCarbonAutoFilledLabel: UIAutoFilledLabel!
    @IBOutlet weak var journeyLabelCenterVerticallyConstraint: NSLayoutConstraint!
    @IBOutlet weak var journeyLabelBottomConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var frame: CGRect {
        willSet {
            if let view = view {
                view.frame.size = newValue.size
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        UINib(nibName: "EmissionView", bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: self, options: nil)
        view.frame = self.bounds
        addSubview(view)
        
        addShadow(opacity: 0.28)
    }
    
    var journeyCarbon: Double = 0.0 {
        didSet {
            if journeyCarbon > 1000 {
                journeyCarbonAutoFilledLabel.autofillRightText = String(format: "%.1f %@ %@", journeyCarbon / 1000, "units_kg".localized(bundle: NavitiaSDKUI.shared.bundle), "carbon".localized(bundle: NavitiaSDKUI.shared.bundle))
            } else {
                journeyCarbonAutoFilledLabel.autofillRightText = String(format: "%.1f %@ %@", journeyCarbon, "units_g".localized(bundle: NavitiaSDKUI.shared.bundle), "carbon".localized(bundle: NavitiaSDKUI.shared.bundle))
            }
            
            journeyCarbonAutoFilledLabel.autofillLeftText = "carbon_journey".localized(bundle: NavitiaSDKUI.shared.bundle)
            journeyCarbonAutoFilledLabel.autofillPattern = "."
            journeyCarbonAutoFilledLabel.delegate = self
        }
    }
    
    var carCarbon: Double = 0.0 {
        didSet {
            if carCarbon != journeyCarbon {
                if carCarbon > 1000 {
                    carCarbonAutoFilledLabel.autofillRightText = String(format: "%.1f %@ %@", carCarbon / 1000, "units_kg".localized(bundle: NavitiaSDKUI.shared.bundle), "carbon".localized(bundle: NavitiaSDKUI.shared.bundle))
                } else {
                    carCarbonAutoFilledLabel.autofillRightText = String(format: "%.1f %@ %@", carCarbon, "units_g".localized(bundle: NavitiaSDKUI.shared.bundle), "carbon".localized(bundle: NavitiaSDKUI.shared.bundle))
                }
                
                carCarbonAutoFilledLabel.autofillLeftText = "carbon_car".localized(bundle: NavitiaSDKUI.shared.bundle)
                carCarbonAutoFilledLabel.autofillPattern = "."
                carCarbonAutoFilledLabel.delegate = self
            } else {
                self.carCarbonAutoFilledLabel.isHidden = true
                self.journeyLabelBottomConstraint.isActive = false
                self.journeyLabelCenterVerticallyConstraint.isActive = true
            }
        }
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
