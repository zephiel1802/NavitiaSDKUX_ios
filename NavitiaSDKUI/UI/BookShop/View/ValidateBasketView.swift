//
//  ValidateBasketView.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 25/04/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

protocol ValidateBasketViewDelegate {
    
    func onValidateButtonClicked(_ validateBasketView: ValidateBasketView)
    
}

open class ValidateBasketView: UIView {
    
    @IBOutlet var _view: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amoutLabel: UILabel!
    
    var delegate: ValidateBasketViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        _setup()
    }
    
    override open var frame: CGRect {
        willSet {
            if let _view = _view {
                _view.frame.size = newValue.size
            }
        }
    }
    
    override open func layoutSubviews() {}
    
    private func _setup() {
        UINib(nibName: "ValidateBasketView", bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: self, options: nil)
        _view.frame = self.bounds
        _view.backgroundColor = Configuration.Color.main
        addSubview(_view)
        
        titleLabel.attributedText = NSMutableAttributedString()
            .icon("arrow-direction-left", color: Configuration.Color.white, size: 15)
            .bold(String(format: " %@","shop".localized(withComment: "SHOP", bundle: NavitiaSDKUI.shared.bundle)), color: Configuration.Color.white, size: 15)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.onValidateButtonClicked))
        _view.addGestureRecognizer(gesture)
    }
    
    @objc func onValidateButtonClicked(sender : UITapGestureRecognizer) {
        delegate?.onValidateButtonClicked(self)
        // Do what you want
    }

    func setAmount(_ amout: Float, currency: String) {
        amoutLabel.attributedText = NSMutableAttributedString()
            .bold(String(format: "%.2f %@", amout, currency),
                  color: Configuration.Color.white,
                  size: 15)
            .icon("arrow-right", color: Configuration.Color.white, size: 15)
    }
    
}
