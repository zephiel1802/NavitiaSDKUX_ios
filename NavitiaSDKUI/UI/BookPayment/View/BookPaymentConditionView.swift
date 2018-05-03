//
//  BookPaymentConditionView.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 02/05/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

protocol BookPaymentConditionViewDelegate {
    
    func onConditionSwitchValueChanged(_ state: Bool, _ bookPaymentConditionView: BookPaymentConditionView)
    func onConditionButtonClicked(_ bookPaymentConditionView: BookPaymentConditionView)
}

open class BookPaymentConditionView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var acceptLabel: UILabel!
    @IBOutlet weak var conditionButton: UIButton!
    @IBOutlet weak var conditionSwitch: UISwitch!
    
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

        acceptLabel.attributedText = NSMutableAttributedString()
            .normal(String(format: "%@ ", "J'accepte les".localized(withComment: "J'accepte les", bundle: NavitiaSDKUI.shared.bundle)),
                    color: Configuration.Color.gray,
                    size: 10.5)
        conditionButton.setAttributedTitle(NSMutableAttributedString()
            .semiBold(String(format: "%@.", "Conditions Générales".localized(withComment: "Conditions Générales", bundle: NavitiaSDKUI.shared.bundle)),
                      color: Configuration.Color.gray,
                      size: 10.5,
                      underline: true),
                                            for: .normal)
    }
    
    @IBAction func onConditionSwitchValueChanged(_ sender: UISwitch) {
        delegate?.onConditionSwitchValueChanged(sender.isOn, self)
    }
    
    @IBAction func onConditionButtonClicked(_ sender: UIButton) {
        delegate?.onConditionButtonClicked(self)
    }
    
}
