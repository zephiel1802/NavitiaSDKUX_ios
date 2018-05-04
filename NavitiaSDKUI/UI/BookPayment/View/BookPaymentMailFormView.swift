//
//  BookPaymentMailFormView.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 02/05/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

open class BookPaymentMailFormView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textFieldContainerView: UIView!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var indicatorIconLabel: UILabel!
    
    //    var delegate: ValidateBasketViewDelegate?
    
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
            if let _view = view {
                _view.frame.size = newValue.size
            }
        }
    }
    
    override open func layoutSubviews() {}
    
    private func _setup() {
        UINib(nibName: "BookPaymentMailFormView", bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: self, options: nil)
        view.frame = self.bounds
        addSubview(view)
        
        indicatorIconLabel.text = ""
    }
    
    @IBAction func mailTextFieldEditingChanged(_ sender: UITextField) {
        if let text = sender.text {
            if text == "" {
                indicatorIconLabel.text = ""
            } else if text.isValidEmail() {
                indicatorIconLabel.attributedText = NSMutableAttributedString()
                .icon("check-circled", color: Configuration.Color.green, size: 15)
            } else {
                indicatorIconLabel.attributedText = NSMutableAttributedString()
                    .icon("cross-circled", color: Configuration.Color.red, size: 15)
            }
        }
    }
    
    var isValid: Bool {
        get {
            if let text = mailTextField.text {
                return text.isValidEmail()
            }
            return false
        }
    }
    
}
