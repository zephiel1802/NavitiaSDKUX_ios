//
//  TicketCollectionViewCell.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 23/04/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class TicketCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var informationButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var centimeLabel: UILabel!
    @IBOutlet weak var addBasketButton: UIButton!
    
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
            .icon("",
                  color: Configuration.Color.main,
                  size: 12)
            .bold("".localized(withComment: "", bundle: NavitiaSDKUIConfig.shared.bundle),
                  color: Configuration.Color.main,
                  size: 12),
                                           for: .normal)
        
        informationButton.setAttributedTitle(NSMutableAttributedString()
            .icon("",
                  color: Configuration.Color.main,
                  size: 12),
                                             for: .normal)
    }
    
    @IBAction func onAddBasketPressedButton(_ sender: Any) {
        print("Oui je veux rajouter un ticket")
    }
    
    @IBAction func onInformationPressedButton(_ sender: Any) {
        print("Oui je veux une information sur le titre")
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
