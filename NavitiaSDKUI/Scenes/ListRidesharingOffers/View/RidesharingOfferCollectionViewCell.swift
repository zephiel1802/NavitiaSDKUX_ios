//
//  JourneyRidesharingCollectionViewCell.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

protocol RidesharingOfferCollectionViewCellDelegate: class {
    
    func onBookButtonClicked(_ ridesharingOfferCollectionViewCell: RidesharingOfferCollectionViewCell)
}

class RidesharingOfferCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var accessibilityView: UIView!
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
    
    internal weak var delegate: RidesharingOfferCollectionViewCellDelegate?
    internal var row: Int?
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    // MARK: - Function
    
    private func setup() {
        roadmapButton.setTitle("view_on_the_map".localized(), for: .normal)
        roadmapButton.accessibilityElementsHidden = true
        
        setShadow()
    }
    
    internal func setPicture(url: String?) {
        if let url = url {
            driverImageView.loadImageFromURL(urlString: url)
        }
    }
    
    internal func setDriverRating(_ count: Int32?) {
        if let count = count {
            var template = "rating_plural".localized()
            if count == 1 {
                template = "rating".localized()
            }
            ratingCountLabel.attributedText = NSMutableAttributedString()
                .normal(String(format: template, count), color: Configuration.Color.gray, size: 10)
        }
    }
    
    internal func setFullStar(_ count: Float?) {
        if let count = count {
            floatRatingView.backgroundColor = UIColor.clear
            floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
            floatRatingView.emptyImage = UIImage(named: "star_empty", in: NavitiaSDKUI.shared.bundle, compatibleWith: nil)
            floatRatingView.fullImage = UIImage(named: "star_full", in: NavitiaSDKUI.shared.bundle, compatibleWith: nil)
            floatRatingView.type = .floatRatings
            floatRatingView.editable = false
            floatRatingView.rating = Double(count)
            floatRatingView.starsInterspace = 2
        }
    }
    
    internal func setSeatsCount(_ count: Int32?) {
        if let count = count {
            let template = "available_seats".localized()
            seatsCountLabel.attributedText = NSMutableAttributedString()
                .semiBold(String(format: template, count), size: 12.5)
        } else {
            seatsCountLabel.attributedText = NSMutableAttributedString()
                .semiBold("no_available_seats".localized(), size: 12.5)
        }
    }
    
    // MARK: - Action
    
    @IBAction func actionRoadmapButton(_ sender: Any) {
        delegate?.onBookButtonClicked(self)
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
                    .semiBold("departure".localized(), color: Configuration.Color.main, size: 8.5)
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
                        .normal(String(format: "(%@)", newValue.localized()), color: Configuration.Color.gray, size: 12)
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
                priceLabel.attributedText = NSMutableAttributedString()
                    .semiBold(newValue, color: Configuration.Color.orange, size: 10)
            }
        }
    }
}
