//
//  TicketPriceView.swift
//  NavitiaSDKUI
//
//  Created by PAR-MAC001 on 24/09/2019.
//

import Foundation
import UIKit

class TicketPriceView: UIView {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var unavailableImageView: UIImageView!
    
    // MARK: - UINib
    
    static var identifier: String {
        return String(describing: self)
    }
    
    class func instanceFromNib() -> TicketPriceView {
        return UINib(nibName: identifier, bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: nil, options: nil)[0] as! TicketPriceView
    }
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func awakeAfter(using aDecoder: NSCoder) -> Any? {
        guard subviews.isEmpty else {
            return self
        }
        
        let ticketPriceView = TicketPriceView.instanceFromNib()
        
        ticketPriceView.translatesAutoresizingMaskIntoConstraints = false
        ticketPriceView.frame = self.bounds
        
        return ticketPriceView
    }
    
    //MARK: - Public methods
    func updatePrice(state: PricesModel.PriceState?, price: Double?) {
        switch state {
        case .no_price?, .none:
            isHidden = true
        case .full_price?:
            unavailableImageView.isHidden = true
            priceLabel.isHidden = false
            
            if let price = price {
                isHidden = false
                priceLabel.text = String(format: "price".localized(), price)
            } else {
                updatePrice(state: .unavailable_price, price: nil)
            }
        case .incomplete_price?:
            unavailableImageView.isHidden = true
            priceLabel.isHidden = false
            
            if let price = price {
                isHidden = false
                let priceText = String(format: "price".localized(), price)
                priceLabel.text = String(format: "%@\n%@", "from".localized(), priceText)
            } else {
                updatePrice(state: .unavailable_price, price: nil)
            }
        case .unavailable_price?:
            unavailableImageView.isHidden = true
            isHidden = false
            priceLabel.isHidden = false
            priceLabel.text = "price_unavailable".localized()
        case .unbookable?:
            isHidden = false
            priceLabel.isHidden = true
            unavailableImageView.isHidden = false
        }
    }
}
