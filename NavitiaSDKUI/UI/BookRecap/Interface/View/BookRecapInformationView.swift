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
    @IBOutlet weak var customerLabel: UILabel!
    @IBOutlet weak var transactionLabel: UILabel!
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
        lineLabel.backgroundColor = Configuration.Color.lightGray
    }
    
    private func _setupIcon() {
        iconLabel.attributedText = NSMutableAttributedString()
            .icon("check-circled", color: Configuration.Color.green, size: 25)
    }
    
    private func _setupDescription() {
        descriptionLabel.attributedText = NSMutableAttributedString()
            .normal("Votre commande est terminée, un email de confirmation vous a été envoyé.", color: Configuration.Color.gray, size: 12.5)
    }
    
    func setCustomer(str: String) {
        customerLabel.attributedText = NSMutableAttributedString()
            .bold(String(format: "%@\r", "Identifiant commerçant"), color: Configuration.Color.darkGray, size: 12)
            .normal(str, color: Configuration.Color.darkGray, size: 12)
    }
    
    func setTransaction(str: String) {
        transactionLabel.attributedText = NSMutableAttributedString()
            .bold(String(format: "%@\r", "Référence de la transaction"), color: Configuration.Color.darkGray, size: 12)
            .normal(str, color: Configuration.Color.darkGray, size: 12)
    }
    
    func setAmount(str: String) {
        amountLabel.attributedText = NSMutableAttributedString()
            .bold(String(format: "%@\r", "Montant de la transaction"), color: Configuration.Color.darkGray, size: 12)
            .normal(str, color: Configuration.Color.darkGray, size: 12)
    }
    
}
