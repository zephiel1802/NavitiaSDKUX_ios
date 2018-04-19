//
//  RidesharingView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

import UIKit

class RidesharingView: UIView {
    
    @IBOutlet var _view: UIView!
    
    @IBOutlet weak var bookButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var pictureImage: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var floatRatingView: FloatRatingView!
    @IBOutlet weak var notationLabel: UILabel!
    @IBOutlet weak var addressFromLabel: UILabel!
    @IBOutlet weak var addressToLabel: UILabel!
    @IBOutlet weak var seatCountLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var parentViewController: JourneySolutionRoadmapViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        _setup()
        addShadow()
    }
    
    private func _setup() {
        UINib(nibName: "RidesharingView", bundle: NavitiaSDKUIConfig.shared.bundle).instantiate(withOwner: self, options: nil)
        _view.frame = self.bounds
        addSubview(_view)
        
        bookButton.setTitle("book".localized(withComment: "Book", bundle: NavitiaSDKUIConfig.shared.bundle), for: .normal)
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
    
    @IBAction func actionBookButton(_ sender: Any) {
        if let parentViewController = parentViewController {
            if !UserDefaults.standard.bool(forKey: NavitiaSDKUserDefaultsManager.SHOW_REDIRECTION_DIALOG_PREF_KEY) {
                let alertController = AlertViewController(nibName: "AlertView", bundle: NavitiaSDKUIConfig.shared.bundle)
                alertController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                alertController.stateKey = NavitiaSDKUserDefaultsManager.SHOW_REDIRECTION_DIALOG_PREF_KEY
                alertController.alertMessage = "redirection_message".localized(withComment: "Redirection Message", bundle: NavitiaSDKUIConfig.shared.bundle)
                alertController.checkBoxText = "dont_show_this_message_again".localized(withComment: "Don't show this message again", bundle: NavitiaSDKUIConfig.shared.bundle)
                alertController.negativeButtonText = "cancel".localized(withComment: "Cancel", bundle: NavitiaSDKUIConfig.shared.bundle).uppercased()
                alertController.positiveButtonText = "proceed".localized(withComment: "Continue", bundle: NavitiaSDKUIConfig.shared.bundle).uppercased()
                alertController.alertViewDelegate = parentViewController
                parentViewController.navigationController?.visibleViewController?.present(alertController, animated: false, completion: nil)
            } else {
                parentViewController.openDeepLink()
            }
        }
    }
    
    func seatCount(_ count: Int32?) {
        if let count = count {
            let template = "available_seats".localized(withComment: "Available seats : 3", bundle: NavitiaSDKUIConfig.shared.bundle)
            seatCountLabel.attributedText = NSMutableAttributedString()
                .normal(String(format: template, count), size: 12.5)
        } else {
            seatCountLabel.attributedText = NSMutableAttributedString()
                .normal("no_available_seats".localized(withComment: "Available seats : N/A", bundle: NavitiaSDKUIConfig.shared.bundle), size: 12.5)
        }
    }
    
}

extension RidesharingView {

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
                    .semiBold("departure".localized(withComment: "Departure: ", bundle: NavitiaSDKUIConfig.shared.bundle), color: Configuration.Color.tertiary, size: 8.5)
                    .semiBold(": ", color: Configuration.Color.tertiary, size: 8.5)
                    .bold(newValue, color: Configuration.Color.tertiary, size: 14)
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
                        .normal(String(format: "(%@)", newValue), color: Configuration.Color.gray, size: 12)
                }
            }
        }
    }
    
    var addressFrom: String? {
        get {
            return addressFromLabel.text
        }
        set {
            if let newValue = newValue {
                addressFromLabel.attributedText = NSMutableAttributedString()
                    .normal(newValue, color: Configuration.Color.gray, size: 11)
            }
        }
    }
    
    var addressTo: String? {
        get {
            return addressToLabel.text
        }
        set {
            if let newValue = newValue {
                addressToLabel.attributedText = NSMutableAttributedString()
                    .normal(newValue, color: Configuration.Color.gray, size: 11)
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
                        .normal("free".localized(withComment: "Free", bundle: NavitiaSDKUIConfig.shared.bundle), color: Configuration.Color.orange,size: 10)
                } else {
                    priceLabel.attributedText = NSMutableAttributedString()
                        .normal(newValue, color: Configuration.Color.orange, size: 10)
                }
            } else {
                priceLabel.attributedText = NSMutableAttributedString()
                    .normal("price_not_available".localized(withComment: "Price not available", bundle: NavitiaSDKUIConfig.shared.bundle), color: Configuration.Color.orange,size: 10)
            }
        }
    }

}
