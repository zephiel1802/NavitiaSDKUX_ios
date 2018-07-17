//
//  ValidateBasketView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

protocol ValidateBasketViewDelegate {
    
    func onValidateButtonClicked(_ validateBasketView: ValidateBasketView)
    
}

open class ValidateBasketView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var iconTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconAmoutLabel: UILabel!
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
            if let _view = view {
                _view.frame.size = newValue.size
            }
        }
    }
    
    override open func layoutSubviews() {}
    
    private func _setup() {
        UINib(nibName: "ValidateBasketView", bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: self, options: nil)
        view.frame = self.bounds
        view.backgroundColor = Configuration.Color.main
        addSubview(view)
        
        _setupIcon()
        _setupGesture()
    }
    
    private func _setupIcon() {
        iconTitleLabel.attributedText = NSMutableAttributedString()
            .icon("basket", color: Configuration.Color.white, size: 22)
        titleLabel.attributedText = NSMutableAttributedString()
            .bold(String(format: "  %@","proceed_to_checkout".localized(withComment: "proceed_to_checkout", bundle: NavitiaSDKUI.shared.bundle)), color: Configuration.Color.white, size: 14)
        iconAmoutLabel.attributedText = NSMutableAttributedString()
            .icon("arrow-right", color: Configuration.Color.white, size: 15)
    }
    
    private func _setupGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.onValidateButtonClicked))
        view.addGestureRecognizer(gesture)
    }
    
    func setAmount(_ amout: Float, currency: String) {
        amoutLabel.attributedText = NSMutableAttributedString()
            .bold(String(format: "%.2f%@", amout, currency),
                  color: Configuration.Color.white,
                  size: 15)
    }
    
    @objc func onValidateButtonClicked(sender : UITapGestureRecognizer) {
        delegate?.onValidateButtonClicked(self)
    }

}
