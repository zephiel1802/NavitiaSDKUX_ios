//
//  TicketCollectionViewCell.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 23/04/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

protocol TicketCollectionViewCellDelegate {
    
    func onInformationPressedButton(_ ticketCollectionViewCell: TicketCollectionViewCell)
    func onAddBasketPressedButton(_ ticketCollectionViewCell: TicketCollectionViewCell)
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
    var amount: Int = 0 {
        didSet {
            if amount > 0 {
                amountView.isHidden = false
                addBasketButton.isHidden = true
                amountLabel.attributedText = NSMutableAttributedString()
                    .bold(String(amount),
                          size: 18)
            } else {
                amountView.isHidden = true
                addBasketButton.isHidden = false
            }
        }
    }
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        _setup()
        addShadow(opacity: 0.28)
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    private func _setup() {
        addBasketButton.setAttributedTitle(NSMutableAttributedString()
            .icon("disruption-information",
                  color: Configuration.Color.main,
                  size: 12)
            .bold(" Ajouter au panier".localized(withComment: " Ajouter au panier", bundle: NavitiaSDKUIConfig.shared.bundle),
                  color: Configuration.Color.main,
                  size: 12),
                                           for: .normal)
        
        informationButton.setAttributedTitle(NSMutableAttributedString()
            .icon("disruption-information",
                  color: Configuration.Color.main,
                  size: 15),
                                             for: .normal)
        lessAmountButton.setAttributedTitle(NSMutableAttributedString()
//            .icon("disruption-information",
            .bold("-",
                  color: Configuration.Color.main,
                  size: 30),
                                            for: .normal)
        moreAmountButton.setAttributedTitle(NSMutableAttributedString()
//            .icon("disruption-information",
            .bold("+",
                  color: Configuration.Color.main,
                  size: 30),
                                            for: .normal)
        amountView.isHidden = true
    }
    
    @IBAction func onInformationPressedButton(_ sender: Any) {
        
        delegate?.onInformationPressedButton(self)
    }
    
    @IBAction func onAddBasketPressedButton(_ sender: Any) {
        delegate?.onAddBasketPressedButton(self)
    }
    
    @IBAction func onLessAmountPressedButton(_ sender: Any) {
        delegate?.onLessAmountPressedButton(self)
    }
    
    @IBAction func onMoreAmountPressendButton(_ sender: Any) {
        delegate?.onMoreAmountPressendButton(self)
    }
    
    func setPrice(_ price: Float, currency: String) {
        let priceComponent = String(price).components(separatedBy :".")
        
        priceLabel.attributedText = NSMutableAttributedString()
            .bold(priceComponent[0],
                  color: Configuration.Color.darkGray,
                  size: 15)
        centimeLabel.attributedText = NSMutableAttributedString()
            .bold(String(format: "%@%@", currency, priceComponent[1]),
                  color: Configuration.Color.darkGray,
                  size: 10)
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
