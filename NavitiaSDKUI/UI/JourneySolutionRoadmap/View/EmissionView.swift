//
//  EmissionView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class EmissionView: UIView {
    
    @IBOutlet var _view: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var carbonLabel: UILabel!
    
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
        UINib(nibName: "EmissionView", bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: self, options: nil)
        _view.frame = self.bounds
        addSubview(_view)
        
        _setupLabel()
        
        addShadow(opacity: 0.28)
    }
    
    private func _setupLabel() {
        descriptionLabel.attributedText = NSMutableAttributedString().semiBold("carbon".localized(bundle: NavitiaSDKUI.shared.bundle),
                                                                               color: Configuration.Color.white,
                                                                               size: 10)
    }
    
}

extension EmissionView {
    
    var carbonAmount: Amount? {
        get {
            return self.carbonAmount
        }
        set {
            if let carbonValue = newValue?.value {
                if carbonValue > 1000 {
                    carbonLabel.attributedText = NSMutableAttributedString()
                        .normal(String(format: "%.1f %@", carbonValue / 1000, "carbon_kgec".localized(bundle: NavitiaSDKUI.shared.bundle)),
                                color: UIColor.white,
                                size: 10)
                } else {
                    carbonLabel.attributedText = NSMutableAttributedString()
                        .normal(String(format: "%.1f %@", carbonValue, "carbon_gec".localized(bundle: NavitiaSDKUI.shared.bundle)),
                                color: UIColor.white,
                                size: 10)
                }
            }
        }
    }
    
}
