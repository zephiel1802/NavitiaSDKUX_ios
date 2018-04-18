//
//  JourneyRidesharingCollectionViewCell.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

protocol JourneyRidesharingCollectionViewCellDelegate {
    func onBookButtonClicked(_ journeyRidesharingCollectionViewCell: JourneyRidesharingCollectionViewCell)
}

class JourneyRidesharingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var pictureImage: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var floatRatingView: FloatRatingView!
    @IBOutlet weak var notationLabel: UILabel!
    @IBOutlet weak var seatCountLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var roadmapButton: UIButton!
    
    var delegate: JourneyRidesharingCollectionViewCellDelegate?
    var row: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        _setupShadow()
        roadmapButton.setTitle("view_on_the_map".localized(withComment: "view_on_the_map", bundle: NavitiaSDKUIConfig.shared.bundle), for: .normal)
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    @IBAction func actionRoadmapButton(_ sender: Any) {
        delegate?.onBookButtonClicked(self)
    }
    
    func setPicture(url: String?) {
        if let url = url {
            pictureImage.loadImageFromURL(urlString: url)
        }
    }
    
    func setNotation(_ count: Int32?) {
        if let count = count {
            var template = "rating_plural".localized(withComment: "rating_plural", bundle: NavitiaSDKUIConfig.shared.bundle)
            if count == 1 {
                template = "rating".localized(withComment: "rating", bundle: NavitiaSDKUIConfig.shared.bundle)
            }
            notationLabel.attributedText = NSMutableAttributedString()
                .normal(String(format: template, count), color: NavitiaSDKUIConfig.shared.color.gray, size: 10)
        }
    }
    
    func setFullStar(_ count: Float?) {
        if count != nil {
            floatRatingView.backgroundColor = UIColor.clear
            floatRatingView.contentMode = UIViewContentMode.scaleAspectFit
            floatRatingView.emptyImage = UIImage(named: "star_empty", in: NavitiaSDKUIConfig.shared.bundle, compatibleWith: nil)
            floatRatingView.fullImage = UIImage(named: "star_full", in: NavitiaSDKUIConfig.shared.bundle, compatibleWith: nil)
            floatRatingView.type = .floatRatings
            floatRatingView.editable = false
            floatRatingView.rating = Double(count!)
            floatRatingView.starsInterspace = 2
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
    
    private func _setupShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 5
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
                        .normal(String(format: "(%@)", newValue), color: NavitiaSDKUIConfig.shared.color.gray, size: 12)
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
                        .normal("free".localized(withComment: "free", bundle: NavitiaSDKUIConfig.shared.bundle), color: NavitiaSDKUIConfig.shared.color.orange,size: 10)
                } else {
                    priceLabel.attributedText = NSMutableAttributedString()
                        .normal(newValue, color: NavitiaSDKUIConfig.shared.color.orange, size: 10)
                }
            } else {
                priceLabel.attributedText = NSMutableAttributedString()
                    .normal("price_not_available".localized(withComment: "price_not_available", bundle: NavitiaSDKUIConfig.shared.bundle), color: NavitiaSDKUIConfig.shared.color.orange,size: 10)
            }
        }
    }
    
}
