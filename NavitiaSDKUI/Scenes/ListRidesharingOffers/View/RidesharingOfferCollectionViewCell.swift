//
//  JourneyRidesharingCollectionViewCell.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

protocol RidesharingOfferCollectionViewCellDelegate {
    
    func onBookButtonClicked(_ ridesharingOfferCollectionViewCell: RidesharingOfferCollectionViewCell)
}

class RidesharingOfferCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var networkLabel: UILabel!
    @IBOutlet weak var departureDateLabel: UILabel!
    @IBOutlet weak var driverImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var floatRatingView: FloatRatingView!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var seatsCountLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var roadmapButton: UIButton!
    
    var delegate: RidesharingOfferCollectionViewCellDelegate?
    var row: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addShadow()
        roadmapButton.setTitle("view_on_the_map".localized(withComment: "View on the map", bundle: NavitiaSDKUI.shared.bundle), for: .normal)
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
            driverImageView.loadImageFromURL(urlString: url)
        }
    }
    
    func setDriverRating(_ count: Int32?) {
        if let count = count {
            var template = "rating_plural".localized(withComment: "ratings", bundle: NavitiaSDKUI.shared.bundle)
            if count == 1 {
                template = "rating".localized(withComment: "rating", bundle: NavitiaSDKUI.shared.bundle)
            }
            ratingCountLabel.attributedText = NSMutableAttributedString()
                .normal(String(format: template, count), color: Configuration.Color.gray, size: 10)
        }
    }
    
    func setFullStar(_ count: Float?) {
        if let count = count {
            floatRatingView.backgroundColor = UIColor.clear
            floatRatingView.contentMode = UIViewContentMode.scaleAspectFit
            floatRatingView.emptyImage = UIImage(named: "star_empty", in: NavitiaSDKUI.shared.bundle, compatibleWith: nil)
            floatRatingView.fullImage = UIImage(named: "star_full", in: NavitiaSDKUI.shared.bundle, compatibleWith: nil)
            floatRatingView.type = .floatRatings
            floatRatingView.editable = false
            floatRatingView.rating = Double(count)
            floatRatingView.starsInterspace = 2
        }
    }
    
    func setSeatsCount(_ count: Int32?) {
        if let count = count {
            let template = "available_seats".localized(withComment: "Available seats: 4", bundle: NavitiaSDKUI.shared.bundle)
            seatsCountLabel.attributedText = NSMutableAttributedString()
                .semiBold(String(format: template, count), size: 12.5)
        } else {
            seatsCountLabel.attributedText = NSMutableAttributedString()
                .semiBold("no_available_seats".localized(withComment: "Available seats: N/A", bundle: NavitiaSDKUI.shared.bundle), size: 12.5)
        }
    }
}

extension RidesharingOfferCollectionViewCell {
    
    var network: String? {
        get {
            return networkLabel.text
        }
        set {
            if let newValue = newValue {
                networkLabel.attributedText = NSMutableAttributedString()
                    .bold(newValue, size: 14)
            }
        }
    }
    
    var departureDate: String? {
        get {
            return departureDateLabel.text
        }
        set {
            if let newValue = newValue {
                departureDateLabel.attributedText = NSMutableAttributedString()
                    .semiBold("departure".localized(withComment: "departure: ", bundle: NavitiaSDKUI.shared.bundle), color: Configuration.Color.main, size: 8.5)
                    .semiBold(": ", color: Configuration.Color.main, size: 8.5)
                    .bold(newValue, color: Configuration.Color.main, size: 14)
            }
        }
    }
    
    var driverNickname: String? {
        get {
            return nicknameLabel.text
        }
        set {
            if let newValue = newValue {
                nicknameLabel.attributedText = NSMutableAttributedString()
                    .semiBold(newValue, size: 12.5)
            }
        }
    }
    
    var driverGender: String? {
        get {
            return genderLabel.text
        }
        set {
            if let newValue = newValue {
                if newValue == "" {
                    genderLabel.text = ""
                } else {
                    genderLabel.attributedText = NSMutableAttributedString()
                        .normal(String(format: "(%@)", newValue.localized(withComment: "Gender", bundle: NavitiaSDKUI.shared.bundle)), color: Configuration.Color.gray, size: 12)
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
                if Float(newValue) == 0.0 {
                    priceLabel.attributedText = NSMutableAttributedString()
                        .semiBold("free".localized(withComment: "Free", bundle: NavitiaSDKUI.shared.bundle), color: Configuration.Color.orange,size: 10)
                } else {
                    priceLabel.attributedText = NSMutableAttributedString()
                        .semiBold(newValue, color: Configuration.Color.orange, size: 10)
                }
            } else {
                priceLabel.attributedText = NSMutableAttributedString()
                    .semiBold("price_not_available".localized(withComment: "Price not available", bundle: NavitiaSDKUI.shared.bundle), color: Configuration.Color.orange,size: 10)
            }
        }
    }
}
