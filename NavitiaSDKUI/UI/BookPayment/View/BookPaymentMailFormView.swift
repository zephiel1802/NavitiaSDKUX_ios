//
//  BookPaymentMailFormView.swift
//  NavitiaSDKUI
//
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
    @IBOutlet weak var indicatorButton: UIButton!
    @IBOutlet weak var indicatorLabel: UILabel!
    @IBOutlet weak var indicatorView: UIView!
    
    public enum State {
        case valid
        case invalid
        case error
        case clear
        case none
    }
    
    var delegate: BookPaymentMailFormViewDelegate?
    var stateIndicator: State = .none {
        didSet {
            switch stateIndicator {
            case .valid:
                indicatorButton.setAttributedTitle(NSMutableAttributedString()
                    .icon("cross-circled", color: Configuration.Color.lightGray, size: 15),
                                                   for: .normal)
                indicatorView.backgroundColor = UIColor.clear
                indicatorLabel.text = ""
            case .invalid:
                indicatorButton.setAttributedTitle(NSMutableAttributedString()
                    .icon("cross-circled", color: Configuration.Color.red, size: 15),
                                                   for: .normal)
                indicatorView.backgroundColor = UIColor.clear
                indicatorLabel.text = ""
            case .error:
                indicatorButton.setAttributedTitle(NSMutableAttributedString()
                    .icon("cross-circled", color: Configuration.Color.red, size: 15),
                                                   for: .normal)
                indicatorView.backgroundColor = UIColor.red
                indicatorLabel.attributedText = NSMutableAttributedString()
                    .normal("not_a_valid_email_address".localized(bundle: NavitiaSDKUI.shared.bundle), color: Configuration.Color.gray, size: 8)
            case .clear:
                indicatorButton.setAttributedTitle(NSMutableAttributedString()
                    .icon("cross-circled", color: Configuration.Color.lightGray, size: 15),
                                                   for: .normal)
                indicatorView.backgroundColor = UIColor.clear
                indicatorLabel.text = ""
            case .none:
                indicatorButton.setTitle("", for: .normal)
                indicatorView.backgroundColor = UIColor.clear
                indicatorLabel.text = ""
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
        
        titleLabel.attributedText = NSMutableAttributedString()
            .bold("to_receive_your_receipt".localized(withComment: "To receive your receipt :", bundle: NavitiaSDKUI.shared.bundle),
                  size: 12)
        mailTextField.placeholder = "e_mail_address".localized(withComment: "e-mail address", bundle: NavitiaSDKUI.shared.bundle)
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
                stateIndicator = .clear
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
    
    @IBAction func clearButton(_ sender: Any) {
        if stateIndicator == .clear || stateIndicator == .valid {
            mailTextField.text = ""
            stateIndicator = .clear
            delegate?.valueChangedTextField(false, self)
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
