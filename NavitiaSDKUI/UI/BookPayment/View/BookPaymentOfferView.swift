//
//  BookPaymentOfferView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

open class BookPaymentOfferView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var titleLabel: UILabel!
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
    
    override open func layoutSubviews() {}
    
    private func _setup() {
        UINib(nibName: "BookPaymentOfferView", bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: self, options: nil)
        view.frame = self.bounds
        addSubview(view)
    }
    
    func setTitle(_ title: String, quantity: Int) {
        titleLabel.attributedText = NSMutableAttributedString()
            .bold(String(format: "%d x ", quantity), color: Configuration.Color.gray, size: 12)
            .bold(title, color: Configuration.Color.black, size: 12)
    }
    
    func setPrice(_ price: Float, currency: String) {
        amountLabel.attributedText = NSMutableAttributedString()
            .bold(String(format: "%0.2f%@", price, currency),
                  color: Configuration.Color.black,
                  size: 12)
    }
    
}
