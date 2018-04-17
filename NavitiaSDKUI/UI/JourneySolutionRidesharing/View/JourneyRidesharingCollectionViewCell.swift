//
//  JourneyRidesharingCollectionViewCell.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 13/04/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class JourneyRidesharingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var pictureImage: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var starStack: UIStackView!
    @IBOutlet weak var notationLabel: UILabel!
    @IBOutlet weak var seatCountLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var roadmapButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        roadmapButton.setTitle("view_on_the_map".localized(withComment: "view_on_the_map", bundle: NavitiaSDKUIConfig.shared.bundle), for: .normal)
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    @IBAction func actionRoadmapButton(_ sender: Any) {
        
    }
    
    func setPicture(url: String?) {
        if let url = url {
            pictureImage.loadImageFromURL(urlString: url)
        }
    }
    
    func setNotation(_ count: Int32?) {
        if let count = count {
            var template = "rating_plural".localized(withComment: "rating_plural", bundle: NavitiaSDKUIConfig.shared.bundle)
            if count == 0 || count == 1 {
                template = "rating".localized(withComment: "rating", bundle: NavitiaSDKUIConfig.shared.bundle)
            }
            notationLabel.attributedText = NSMutableAttributedString()
                .normal(String(format: template, count), size: 10)
        }
    }
    
    func setFullStar(_ count: Float?) {
        if count != nil {
            var count = Int(count ?? 0)
            if count < 0 {
                count = 0
            }
            if count > 5 {
                count = 5
            }
            let full = count - 1
            if full >= 0 {
                for _ in 0...full {
                    let myView = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
                    myView.image = UIImage(named: "star_full", in: NavitiaSDKUIConfig.shared.bundle, compatibleWith: nil)
                    starStack.addArrangedSubview(myView)
                }
            }
            let empty = 4 - count
            if empty >= 0 {
                for _ in 0...empty {
                    let myView = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
                    myView.image = UIImage(named: "star_empty", in: NavitiaSDKUIConfig.shared.bundle, compatibleWith: nil)
                    starStack.addArrangedSubview(myView)
                }
            }
        }
    }
    
    func seatCount(_ count: Int32?) {
        if let count = count {
            let template = "available_seats".localized(withComment: "available_seats", bundle: NavitiaSDKUIConfig.shared.bundle)
            seatCountLabel.attributedText = NSMutableAttributedString()
                .normal(String(format: template, count), size: 12.5)
        } else {
            seatCountLabel.attributedText = NSMutableAttributedString()
                .normal("no_available_seats".localized(withComment: "no_available_seats", bundle: NavitiaSDKUIConfig.shared.bundle), size: 12.5)
        }
    }
    
}

extension JourneyRidesharingCollectionViewCell {
    
    var title: String? {
        get {
            return titleLabel.text
        }
        set {
            if let newValue = newValue {
                titleLabel.attributedText = NSMutableAttributedString()
                    .bold(newValue, size: 14)
            }
        }
    }
    
    var startDate: String? {
        get {
            return startLabel.text
        }
        set {
            if let newValue = newValue {
                startLabel.attributedText = NSMutableAttributedString()
                    .normal("departure".localized(withComment: "departure", bundle: NavitiaSDKUIConfig.shared.bundle), color: NavitiaSDKUIConfig.shared.color.tertiary, size: 8.5)
                    .normal(": ", color: NavitiaSDKUIConfig.shared.color.tertiary, size: 8.5)
                    .bold(newValue, color: NavitiaSDKUIConfig.shared.color.tertiary, size: 14)
            }
        }
    }
    
    var login: String? {
        get {
            return loginLabel.text
        }
        set {
            if let newValue = newValue {
                loginLabel.attributedText = NSMutableAttributedString()
                    .normal(newValue, size: 12.5)
            }
        }
    }
    
    var gender: String? {
        get {
            return genderLabel.text
        }
        set {
            if let newValue = newValue {
                if newValue == "" {
                    genderLabel.text = ""
                } else {
                    genderLabel.attributedText = NSMutableAttributedString()
                        .normal("(", size: 12)
                        .normal(newValue, size: 12)
                        .normal(")", size: 12)
                }
            }
        }
    }
    
    var price: String? {
        get {
            return priceLabel.text
        }
        set {
            if let newValue = newValue {
                if newValue == "0.0" {
                    priceLabel.attributedText = NSMutableAttributedString()
                        .normal("free".localized(withComment: "free", bundle: NavitiaSDKUIConfig.shared.bundle), color: NavitiaSDKUIConfig.shared.color.orange,size: 8.5)
                } else {
                    priceLabel.attributedText = NSMutableAttributedString()
                        .normal(newValue, color: NavitiaSDKUIConfig.shared.color.orange, size: 8.5)
                }
            } else {
                priceLabel.attributedText = NSMutableAttributedString()
                    .normal("price_not_available".localized(withComment: "price_not_available", bundle: NavitiaSDKUIConfig.shared.bundle), color: NavitiaSDKUIConfig.shared.color.orange,size: 8.5)
            }
        }
    }
    
}
