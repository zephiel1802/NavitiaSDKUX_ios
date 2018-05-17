//
//  BookPaymentMailFormView.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 02/05/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

protocol BookPaymentMailFormViewDelegate {
    
    func onReturnButtonClicked(_ bookPaymentMailFormView: BookPaymentMailFormView)
    func valueChangedTextField(_ value: Bool,_ bookPaymentMailFormView: BookPaymentMailFormView)
}

open class BookPaymentMailFormView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textFieldContainerView: UIView!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var indicatorIconLabel: UILabel!
    @IBOutlet weak var indicatorView: UIView!
    
    var delegate: BookPaymentMailFormViewDelegate?
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
    
    override open func layoutSubviews() {
        //textFieldContainerView.addInnerShadow(topColor: Configuration.Color.gray)
    }
    
    private func _setup() {
        UINib(nibName: "BookPaymentMailFormView", bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: self, options: nil)
        view.frame = self.bounds
        addSubview(view)
        
        textFieldContainerView.layer.masksToBounds = true
        
        indicatorIconLabel.text = ""
        indicatorView.backgroundColor = UIColor.clear
    }
    
    @IBAction func mailTextFieldEditingChanged(_ sender: UITextField) {
        if let text = sender.text {
            if text == "" {
                setIndicatorLabel(nil)
                setIndicatorView(false)
                delegate?.valueChangedTextField(false, self)
            } else if text.isValidEmail() {
                setIndicatorLabel(false)
                setIndicatorView(false)
                delegate?.valueChangedTextField(true, self)
            } else {
                setIndicatorLabel(true)
                delegate?.valueChangedTextField(false, self)
            }
        }
    }
    
    @IBAction func mailTextFieldPrimaryAction(_ sender: UITextField) {
        if let text = sender.text {
            if text == "" || !text.isValidEmail() {
                setIndicatorLabel(true)
                setIndicatorView(true)
            } else {
                setIndicatorLabel(false)
                setIndicatorView(false)
                self.delegate?.onReturnButtonClicked(self)
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
    
    func setIndicatorView(_ bool: Bool) {
        if bool {
            indicatorView.backgroundColor = UIColor.red
        } else {
            indicatorView.backgroundColor = UIColor.clear
        }
    }
    
    func setIndicatorLabel(_ bool: Bool?) {
        if let bool = bool {
            if bool {
                indicatorIconLabel.attributedText = NSMutableAttributedString()
                    .icon("cross-circled", color: Configuration.Color.red, size: 15)
            } else {
                indicatorIconLabel.attributedText = NSMutableAttributedString()
                    .icon("check-circled", color: Configuration.Color.green, size: 15)
            }
        } else {
            indicatorIconLabel.text = ""
        }
    }
    
}
