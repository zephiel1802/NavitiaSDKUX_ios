//
//  BookPaymentConditionView.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 02/05/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

protocol BookPaymentConditionViewDelegate {
    
    func onConditionSwitchClicked(_ bookPaymentConditionView: BookPaymentConditionView)
    func onConditionSwitchValueChanged(_ bookPaymentConditionView: BookPaymentConditionView)
    func onConditionLabelClicked(_ bookPaymentConditionView: BookPaymentConditionView)
    
}

open class BookPaymentConditionView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var acceptLabel: UILabel!
    @IBOutlet weak var cguLabel: UILabel!
    @IBOutlet weak var conditionButton: UIButton!
    @IBOutlet weak var conditionSwitch: UISwitch!
    @IBOutlet weak var conditionTapView: UIView!
    
    enum State {
        case error
        case none
    }
    
    var delegate: BookPaymentConditionViewDelegate?
    var state: State = .none {
        didSet {
            switch state {
            case .error:
                acceptLabel.attributedText = NSMutableAttributedString()
                    .normal(String(format: "%@ ", "i_accept_the".localized(withComment: "I accept the", bundle: NavitiaSDKUI.shared.bundle)),
                              color: Configuration.Color.red,
                              size: 10.5)
                cguLabel.attributedText = NSMutableAttributedString()
                    .semiBold(String(format: "%@.", "terms_and_conditions".localized(withComment: "Terms and Conditions", bundle: NavitiaSDKUI.shared.bundle)),
                          color: Configuration.Color.red,
                          size: 11,
                          underline: true)
            case .none:
                acceptLabel.attributedText = NSMutableAttributedString()
                    .normal(String(format: "%@ ", "i_accept_the".localized(withComment: "I accept the", bundle: NavitiaSDKUI.shared.bundle)),
                            color: Configuration.Color.gray,
                            size: 10.5)
                cguLabel.attributedText = NSMutableAttributedString()
                    .semiBold(String(format: "%@.", "terms_and_conditions".localized(withComment: "Terms and Conditions", bundle: NavitiaSDKUI.shared.bundle)),
                              color: Configuration.Color.gray,
                              size: 11,
                              underline: true)
            }
        }
    }
    var isEnable: Bool = true {
        didSet {
            conditionSwitch.isEnabled = isEnable
            conditionTapView.isHidden = isEnable
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
    
    override open func layoutSubviews() {}
    
    private func _setup() {
        UINib(nibName: "BookPaymentConditionView", bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: self, options: nil)
        view.frame = self.bounds
        addSubview(view)
        
        
        state = .none
        isEnable = false
        _setupGesture()
        _setupSwitch()
    }
    
    private func _setupSwitch() {
        conditionSwitch.onTintColor = Configuration.Color.main
    }
    
    private func _setupGesture() {
        let conditionTapViewGesture = UITapGestureRecognizer(target: self,
                                                             action: #selector(BookPaymentConditionView.onConditionSwitchClicked))
        conditionTapView.addGestureRecognizer(conditionTapViewGesture)
        
        let acceptLabelGesture = UITapGestureRecognizer(target: self,
                                                        action: #selector(BookPaymentConditionView.onConditionLabelClicked))
        acceptLabel.addGestureRecognizer(acceptLabelGesture)
        acceptLabel.isUserInteractionEnabled = true
        
        let cguLabelGesture = UITapGestureRecognizer(target: self,
                                                        action: #selector(BookPaymentConditionView.onConditionLabelClicked))
        cguLabel.addGestureRecognizer(cguLabelGesture)
        cguLabel.isUserInteractionEnabled = true
    }
    
    @objc func onConditionLabelClicked() {
        delegate?.onConditionLabelClicked(self)
    }
    
    @objc func onConditionSwitchClicked() {
        delegate?.onConditionSwitchClicked(self)
    }
    
    @IBAction func onConditionSwitchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            state = .none
        }
        delegate?.onConditionSwitchValueChanged(self)
    }
    
    public func checkValidation() {
        if conditionSwitch.isOn {
            state = .none
        } else {
            state = .error
        }
    }
}
