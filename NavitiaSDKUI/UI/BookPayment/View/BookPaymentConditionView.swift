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
    func onConditionButtonClicked(_ bookPaymentConditionView: BookPaymentConditionView)
}

open class BookPaymentConditionView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var acceptLabel: UILabel!
    @IBOutlet weak var conditionButton: UIButton!
    @IBOutlet weak var conditionSwitch: UISwitch!
    @IBOutlet weak var conditionTapView: UIView!
    
    var delegate: BookPaymentConditionViewDelegate?
    
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
        
        conditionSwitch.onTintColor = Configuration.Color.main
        conditionSwitch.isEnabled = false
        state(false)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(BookPaymentConditionView.onConditionSwitchClicked))
        conditionTapView.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(BookPaymentConditionView.text))
        acceptLabel.addGestureRecognizer(tap2)
        acceptLabel.isUserInteractionEnabled = true
    }

    @objc func onConditionSwitchClicked() {
        delegate?.onConditionSwitchClicked(self)
    }
    
    
    @IBAction func onConditionSwitchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            state(false)
        }
        delegate?.onConditionSwitchValueChanged(self)
    }
    
    @IBAction func onConditionButtonClicked(_ sender: UIButton) {
        delegate?.onConditionButtonClicked(self)
    }
    
    @objc func text() {
        delegate?.onConditionButtonClicked(self)
    }
    
    func state(_ bool: Bool) {
        if bool {
            acceptLabel.attributedText = NSMutableAttributedString()
                .semiBold(String(format: "%@ ", "J'accepte les".localized(withComment: "J'accepte les", bundle: NavitiaSDKUI.shared.bundle)),
                        color: Configuration.Color.red,
                        size: 10.5)
                .bold(String(format: "%@.", "Conditions Générales".localized(withComment: "Conditions Générales", bundle: NavitiaSDKUI.shared.bundle)),
                      color: Configuration.Color.red,
                      size: 11)
        } else {
            acceptLabel.attributedText = NSMutableAttributedString()
                .normal(String(format: "%@ ", "J'accepte les".localized(withComment: "J'accepte les", bundle: NavitiaSDKUI.shared.bundle)),
                        color: Configuration.Color.gray,
                        size: 10.5,
                        underline: false)
                .semiBold(String(format: "%@.", "Conditions Générales".localized(withComment: "Conditions Générales", bundle: NavitiaSDKUI.shared.bundle)),
                          color: Configuration.Color.gray,
                          size: 11)
        }
    }
    
}
