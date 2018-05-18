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
    
    public enum State {
        case valid
        case invalid
        case error
        case none
    }
    
    var delegate: BookPaymentMailFormViewDelegate?
    var stateIndicator: State = .none {
        didSet {
            switch stateIndicator {
            case .valid:
                indicatorIconLabel.attributedText = NSMutableAttributedString()
                    .icon("check-circled", color: Configuration.Color.green, size: 15)
                indicatorView.backgroundColor = UIColor.clear
            case .invalid:
                indicatorIconLabel.attributedText = NSMutableAttributedString()
                    .icon("cross-circled", color: Configuration.Color.red, size: 15)
                indicatorView.backgroundColor = UIColor.clear
            case .error:
                indicatorIconLabel.attributedText = NSMutableAttributedString()
                    .icon("cross-circled", color: Configuration.Color.red, size: 15)
                indicatorView.backgroundColor = UIColor.red
            case .none:
                indicatorIconLabel.text = ""
                indicatorView.backgroundColor = UIColor.clear
            }
        }
    }
    
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
    
    private func _setup() {
        UINib(nibName: "BookPaymentMailFormView", bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: self, options: nil)
        view.frame = self.bounds
        addSubview(view)
        
        textFieldContainerView.layer.masksToBounds = true
        stateIndicator = .none
    }
    
    @IBAction func mailTextFieldEditingChanged(_ sender: UITextField) {
        if let text = sender.text {
            if text.isEmpty {
                stateIndicator = .none
                delegate?.valueChangedTextField(false, self)
            } else if text.isValidEmail() {
                stateIndicator = .valid
                delegate?.valueChangedTextField(true, self)
            } else {
                stateIndicator = .invalid
                delegate?.valueChangedTextField(false, self)
            }
        }
    }
    
    @IBAction func mailTextFieldPrimaryAction(_ sender: UITextField) {
        if let text = sender.text {
            if text.isEmpty || !text.isValidEmail() {
                stateIndicator = .error
            } else {
                stateIndicator = .valid
                self.delegate?.onReturnButtonClicked(self)
            }
        }
    }

    public func checkValidation(_ invalidType: State = .invalid) {
        if isEmpty || !isValid {
            stateIndicator = invalidType
        } else {
            stateIndicator = .valid
        }
    }
    
}

extension BookPaymentMailFormView {
    
    var isValid: Bool {
        get {
            if let text = mailTextField.text {
                return text.isValidEmail()
            }
            return false
        }
    }
    
    var isEmpty: Bool {
        get {
            if let text = mailTextField.text {
                return text.isEmpty
            }
            return false
        }
    }
    
}
