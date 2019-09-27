//
//  BuyTicketButtonView.swift
//  NavitiaSDKUI
//
//  Created by Adeline Hirsch on 25/09/2019.
//  Copyright © 2019 kisio. All rights reserved.
//

import Foundation

protocol BuyTicketButtonViewDelegate {
    func didTapOnBuyTicketButton()
}

class BuyTicketButtonView: UIView {
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    
    internal var delegate: BuyTicketButtonViewDelegate?
    internal var price: Double? {
        didSet {
            if let price = price, price > 0 {
                buttonView.backgroundColor = Configuration.Color.secondary
                
                let text = String(format: "buy_tickets_with_price".localized(), price).uppercased()
                let attributedString = NSMutableAttributedString(string: text, attributes: [
                    .font: UIFont.systemFont(ofSize: 14.0, weight: .regular),
                    .foregroundColor: UIColor(white: 1.0, alpha: 1.0)
                    ])
                attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14.0, weight: .bold), range: NSRange(location: 0, length: 12))
                textLabel.attributedText = attributedString
                
            } else {
                buttonView.backgroundColor = Configuration.Color.shadow
                textLabel.text = "buy_tickets".localized().uppercased()
            }
        }
    }
    
    static var identifier: String {
        return String(describing: self)
    }

    class func instanceFromNib() -> BuyTicketButtonView {
        return UINib(nibName: identifier, bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: nil, options: nil)[0] as! BuyTicketButtonView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        price = nil
        buttonView.setShadow(opacity: 0.2, radius: 5)
        textLabel.textColor = Configuration.Color.white
    }
    
    @IBAction func buyButtonViewAction(_ sender: Any) {
        if let delegate = delegate, let price = price, price > 0 {
            delegate.didTapOnBuyTicketButton()
        }
    }
}
