//
//  TicketCollectionViewCell.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

protocol TicketCollectionViewCellDelegate {
    
    func onInformationPressedButton(_ ticketCollectionViewCell: TicketCollectionViewCell)
    func onLessAmountPressedButton(_ ticketCollectionViewCell: TicketCollectionViewCell)
    func onMoreAmountPressendButton(_ ticketCollectionViewCell: TicketCollectionViewCell)
    
}

class TicketCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var informationButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var centimeLabel: UILabel!
    @IBOutlet weak var addBasketButton: UIButton!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var lessAmountButton: UIButton!
    @IBOutlet weak var moreAmountButton: UIButton!
    
    var delegate: TicketCollectionViewCellDelegate?
    var indexPath: IndexPath?
    var id: String?
    var maxQuantity: Int = 999
    var quantity: Int = 0 {
        didSet {
            if quantity > 0 {
                
                amountLabel.attributedText = NSMutableAttributedString()
                    .bold(String(quantity),
                          size: 18)
                if quantity == maxQuantity {
                    _moreAmountButtonSetColor(color: Configuration.Color.gray)
                } else {
                    _moreAmountButtonSetColor()
                }
     
                amountView.isHidden = false
                addBasketButton.isHidden = true
            } else {
                amountView.isHidden = true
                addBasketButton.isHidden = false
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        _setup()
        addShadow(opacity: 0.1)
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    private func _setup() {
        _setupIcon()
        amountView.isHidden = true
    }
    
    private func _setupIcon() {
        addBasketButton.setAttributedTitle(NSMutableAttributedString()
            .icon("add",
                  color: Configuration.Color.main,
                  size: 12)
            .bold(String(format: "  %@", "add_to_cart".localized(withComment: "Add to cart", bundle: NavitiaSDKUI.shared.bundle)),
                  color: Configuration.Color.main,
                  size: 12),
                                           for: .normal)
        informationButton.setAttributedTitle(NSMutableAttributedString()
            .icon("disruption-information",
                  color: Configuration.Color.main,
                  size: 13),
                                             for: .normal)
        lessAmountButton.setAttributedTitle(NSMutableAttributedString()
            .icon("less",
                  color: Configuration.Color.main,
                  size: 25),
                                            for: .normal)
        moreAmountButton.setAttributedTitle(NSMutableAttributedString()
            .icon("more",
                  color: Configuration.Color.main,
                  size: 25),
                                            for: .normal)
    }
    
    @IBAction func onInformationPressedButton(_ sender: Any) {
        delegate?.onInformationPressedButton(self)
    }
    
    @IBAction func onAddBasketPressedButton(_ sender: Any) {
        delegate?.onMoreAmountPressendButton(self)
    }
    
    @IBAction func onLessAmountPressedButton(_ sender: Any) {
        delegate?.onLessAmountPressedButton(self)
    }
    
    @IBAction func onMoreAmountPressendButton(_ sender: Any) {
        delegate?.onMoreAmountPressendButton(self)
    }
    
    func setPrice(_ price: Float, currency: String) {
        var priceComponent = String(price).components(separatedBy :".")
        priceLabel.attributedText = NSMutableAttributedString()
            .bold(priceComponent[0],
                  color: Configuration.Color.darkGray,
                  size: 15)
        if priceComponent[1].count == 1 {
            priceComponent[1].append("0")
        }
        centimeLabel.attributedText = NSMutableAttributedString()
            .bold(String(format: "%@%@", currency, priceComponent[1]),
                  color: Configuration.Color.darkGray,
                  size: 10)
    }
    
    private func _moreAmountButtonSetColor(color: UIColor = Configuration.Color.main) {
        moreAmountButton.setAttributedTitle(NSMutableAttributedString()
            .icon("more",
                  color: color,
                  size: 25),
                                            for: .normal)
    }
    
}

extension TicketCollectionViewCell {
    
    var title: String? {
        get {
            return titleLabel.text
        }
        set {
            if let newValue = newValue {
                titleLabel.attributedText = NSMutableAttributedString()
                    .bold(newValue, color: Configuration.Color.darkGray, size: 12)
            }
        }
    }
    
    var descript: String? {
        get {
            return descriptionLabel.text
        }
        set {
            if let newValue = newValue {
                descriptionLabel.attributedText = NSMutableAttributedString()
                    .bold(newValue, color: Configuration.Color.gray, size: 10)
            }
        }
    }
    
}
