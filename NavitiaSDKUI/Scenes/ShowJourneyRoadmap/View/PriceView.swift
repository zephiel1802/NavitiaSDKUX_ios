//
//  PriceView.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 22/03/2019.
//

import UIKit

class PriceView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    var title: String? {
        get {
            return titleLabel.text
        }
        set {
            if let newValue = newValue {
                titleLabel.text = newValue
            }
        }
    }
    var price: String? {
        get {
            return priceLabel.text
        }
        set {
            if let newValue = newValue {
                priceLabel.text = newValue
            }
        }
    }
    
    // MARK: - UINib
    
    static var identifier: String {
        return String(describing: self)
    }
    
    class func instanceFromNib() -> PriceView {
        return UINib(nibName: identifier, bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: nil, options: nil)[0] as! PriceView
    }
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        priceView.backgroundColor = Configuration.Color.secondary
    }
}
