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
        
        addShadow()
        roadmapButton.setTitle("view_on_the_map".localized(withComment: "View on the map", bundle: NavitiaSDKUIConfig.shared.bundle), for: .normal)
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
            var template = "rating_plural".localized(withComment: "ratings", bundle: NavitiaSDKUIConfig.shared.bundle)
            if count == 1 {
                template = "rating".localized(withComment: "rating", bundle: NavitiaSDKUIConfig.shared.bundle)
            }
            notationLabel.attributedText = NSMutableAttributedString()
                .normal(String(format: template, count), color: Configuration.Color.gray, size: 10)
        }
    }
    
    func setFullStar(_ count: Float?) {
        if let count = count {
            floatRatingView.backgroundColor = UIColor.clear
            floatRatingView.contentMode = UIViewContentMode.scaleAspectFit
            floatRatingView.emptyImage = UIImage(named: "star_empty", in: NavitiaSDKUIConfig.shared.bundle, compatibleWith: nil)
            floatRatingView.fullImage = UIImage(named: "star_full", in: NavitiaSDKUIConfig.shared.bundle, compatibleWith: nil)
            floatRatingView.type = .floatRatings
            floatRatingView.editable = false
            floatRatingView.rating = Double(count)
            floatRatingView.starsInterspace = 2
        }
    }
    
    func seatCount(_ count: Int32?) {
        if let count = count {
            let template = "available_seats".localized(withComment: "Available seats: 4", bundle: NavitiaSDKUIConfig.shared.bundle)
            seatCountLabel.attributedText = NSMutableAttributedString()
                .semiBold(String(format: template, count), size: 12.5)
        } else {
            seatCountLabel.attributedText = NSMutableAttributedString()
                .semiBold("no_available_seats".localized(withComment: "Available seats: N/A", bundle: NavitiaSDKUIConfig.shared.bundle), size: 12.5)
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
                    .semiBold("departure".localized(withComment: "departure: ", bundle: NavitiaSDKUIConfig.shared.bundle), color: Configuration.Color.main, size: 8.5)
                    .semiBold(": ", color: Configuration.Color.main, size: 8.5)
                    .bold(newValue, color: Configuration.Color.main, size: 14)
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
                    .semiBold(newValue, size: 12.5)
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
                        .normal(String(format: "(%@)", newValue.localized(withComment: "Gender", bundle: NavitiaSDKUIConfig.shared.bundle)), color: Configuration.Color.gray, size: 12)
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
                        .semiBold("free".localized(withComment: "Free", bundle: NavitiaSDKUIConfig.shared.bundle), color: Configuration.Color.orange,size: 10)
                } else {
                    priceLabel.attributedText = NSMutableAttributedString()
                        .semiBold(newValue, color: Configuration.Color.orange, size: 10)
                }
            } else {
                priceLabel.attributedText = NSMutableAttributedString()
                    .semiBold("price_not_available".localized(withComment: "Price not available", bundle: NavitiaSDKUIConfig.shared.bundle), color: Configuration.Color.orange,size: 10)
            }
        }
    }
    
}
