//
//  BuyTicketButtonView.swift
//  NavitiaSDKUI
//
//  Created by Adeline Hirsch on 25/09/2019.
//  Copyright © 2019 kisio. All rights reserved.
//

import Foundation

class BuyTicketButtonView: UIView {
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    
    internal var price: Double? {
        didSet {
            if let price = price, price > 0 {
                buttonView.backgroundColor = Configuration.Color.secondary
                let boldText = "BUY TICKETS"
                let regularText = " - € \(price)"
                textLabel.text = boldText + regularText
            } else {
                buttonView.backgroundColor = Configuration.Color.shadow
                let boldText = "BUY TICKETS"
                textLabel.text = boldText
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
}
