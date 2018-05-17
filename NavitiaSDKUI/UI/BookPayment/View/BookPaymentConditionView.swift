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
                    .semiBold(String(format: "%@ ", "J'accepte les".localized(withComment: "J'accepte les", bundle: NavitiaSDKUI.shared.bundle)),
                              color: Configuration.Color.red,
                              size: 10.5)
                    .bold(String(format: "%@.", "Conditions Générales".localized(withComment: "Conditions Générales", bundle: NavitiaSDKUI.shared.bundle)),
                          color: Configuration.Color.red,
                          size: 11)
            case .none:
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
        _setupGesture()
        _setupSwitch()
    }
    
    private func _setupSwitch() {
        conditionSwitch.onTintColor = Configuration.Color.main
        conditionSwitch.isEnabled = false
    }
    
    private func _setupGesture() {
        let conditionTapViewGesture = UITapGestureRecognizer(target: self,
                                                             action: #selector(BookPaymentConditionView.onConditionSwitchClicked))
        conditionTapView.addGestureRecognizer(conditionTapViewGesture)
        
        let acceptLabelGesture = UITapGestureRecognizer(target: self,
                                                        action: #selector(BookPaymentConditionView.onConditionLabelClicked))
        acceptLabel.addGestureRecognizer(acceptLabelGesture)
        acceptLabel.isUserInteractionEnabled = true
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
    
}
