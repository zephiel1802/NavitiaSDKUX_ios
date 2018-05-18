//
//  BookPaymentCartView.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 02/05/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

open class BookPaymentCartView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var offerStackView: UIStackView!
    @IBOutlet weak var titleAmountLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var titleTaxLabel: UILabel!
    @IBOutlet weak var amountTaxLabel: UILabel!
    
    var heightCart:CGFloat = 35
    
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
        UINib(nibName: "BookPaymentCartView", bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: self, options: nil)
        view.frame = self.bounds
        addSubview(view)
        
        addShadow(opacity: 0.28)
        _setupIcon()
    }
    
    private func _setupIcon() {
        titleLabel.attributedText = NSMutableAttributedString()
            .bold("Mon panier".localized(withComment: "", bundle: NavitiaSDKUI.shared.bundle).uppercased(),
                  color: Configuration.Color.gray, size: 10)
        titleAmountLabel.attributedText = NSMutableAttributedString()
            .bold("Total".localized(withComment: "", bundle: NavitiaSDKUI.shared.bundle),
                  color: Configuration.Color.main, size: 12)
        titleTaxLabel.attributedText = NSMutableAttributedString()
            .semiBold("Dont TVA".localized(withComment: "", bundle: NavitiaSDKUI.shared.bundle),
                      color: Configuration.Color.gray, size: 10)
    }
    
    public func setPrice(_ price: Float, currency: String) {
        amountLabel.attributedText = NSMutableAttributedString()
            .bold(String(format: "%0.2f%@", price, currency),
                  color: Configuration.Color.main,
                  size: 12)
    }
    
    public func setVAT(_ VAT: Float, currency: String) {
        amountTaxLabel.attributedText = NSMutableAttributedString()
            .bold(String(format: "%0.2f%@", VAT, currency),
                  color: Configuration.Color.gray,
                  size: 10)
    }
    
    public func addOffer(_ cartItem: NavitiaBookCartItem) {
        let bookPaymentOfferView = BookPaymentOfferView(frame: CGRect(x: 0, y: 0, width: offerStackView.frame.size.width, height: heightCart))
        bookPaymentOfferView.setTitle(cartItem.bookOffer.title, quantity: cartItem.quantity)
        bookPaymentOfferView.setPrice(cartItem.itemPrice, currency: cartItem.bookOffer.currency)
        offerStackView.addArrangedSubview(bookPaymentOfferView)
        frame.size.height += heightCart
    }
    
}
