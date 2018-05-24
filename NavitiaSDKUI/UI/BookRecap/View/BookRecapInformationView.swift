//
//  BookRecapInformationView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

open class BookRecapInformationView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var lineLabel: UIView!
    @IBOutlet weak var customerTitleLabel: UILabel!
    @IBOutlet weak var customerLabel: UILabel!
    @IBOutlet weak var transactionTitleLabel: UILabel!
    @IBOutlet weak var transactionLabel: UILabel!
    @IBOutlet weak var amountTitleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
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
        UINib(nibName: "BookRecapInformationView", bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: self, options: nil)
        view.frame = self.bounds
        addSubview(view)
        
        addShadow(opacity: 0.1)
        _setupIcon()
        _setupDescription()
    }
    
    private func _setupIcon() {
        iconLabel.attributedText = NSMutableAttributedString()
            .icon("check-circled", color: Configuration.Color.green, size: 25)
    }
    
    private func _setupDescription() {
        descriptionLabel.attributedText = NSMutableAttributedString()
            .normal(String(format: "%@", "thank_you_for_your_purchase".localized(withComment: "Thank you for your purchase ! Your order is complete, a confirmation email has been sent to you.", bundle: NavitiaSDKUI.shared.bundle)), color: Configuration.Color.gray, size: 12.5)
    }
    
    func setCustomer(str: String) {
        customerTitleLabel.attributedText = NSMutableAttributedString()
            .bold(String(format: "%@\r", "merchant_identifier".localized(withComment: "Merchant identifier", bundle: NavitiaSDKUI.shared.bundle)), color: Configuration.Color.darkGray, size: 12)
        customerLabel.attributedText = NSMutableAttributedString()
            .normal(str, color: Configuration.Color.darkGray, size: 12)
    }
    
    func setTransaction(str: String) {
        transactionTitleLabel.attributedText = NSMutableAttributedString()
            .bold(String(format: "%@\r", "transaction_reference".localized(withComment: "Transaction reference", bundle: NavitiaSDKUI.shared.bundle)), color: Configuration.Color.darkGray, size: 12)
        transactionLabel.attributedText = NSMutableAttributedString()
            .normal(str, color: Configuration.Color.darkGray, size: 12)
    }
    
    func setAmount(str: String) {
        amountTitleLabel.attributedText = NSMutableAttributedString()
            .bold(String(format: "%@\r", "transaction_amount".localized(withComment: "Transaction amount", bundle: NavitiaSDKUI.shared.bundle)), color: Configuration.Color.darkGray, size: 12)
        amountLabel.attributedText = NSMutableAttributedString()
            .normal(str, color: Configuration.Color.darkGray, size: 12)
    }
    
}
