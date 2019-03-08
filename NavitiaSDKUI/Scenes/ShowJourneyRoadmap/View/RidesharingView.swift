//
//  RidesharingView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class RidesharingView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var accessibilityButton: UIButton!
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
    
    internal var parentViewController: ShowJourneyRoadmapViewController?
    
    internal var accessiblity: String? {
        didSet {
            guard let accessiblity = accessiblity else {
                return
            }
            
            accessibilityButton.accessibilityLabel = accessiblity
        }
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    // MARK: - Function
    
    private func setup() {
        UINib(nibName: "RidesharingView", bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: self, options: nil)
        view.frame = self.bounds
        addSubview(view)
        
        setShadow()
        
        bookButton.setTitle("send_request".localized(), for: .normal)
        bookButton.accessibilityElementsHidden = true
    }
    
    private func bookRidesharing() {
        if let parentViewController = parentViewController {
            if !UserDefaults.standard.bool(forKey: NavitiaSDKUserDefaultsManager.SHOW_REDIRECTION_DIALOG_PREF_KEY) {
                let alertController = AlertViewController(nibName: "AlertView", bundle: NavitiaSDKUI.shared.bundle)
                alertController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                alertController.stateKey = NavitiaSDKUserDefaultsManager.SHOW_REDIRECTION_DIALOG_PREF_KEY
                alertController.alertMessage = "redirection_message".localized()
                alertController.checkBoxText = "dont_show_this_message_again".localized()
                alertController.negativeButtonText = "cancel".localized().uppercased()
                alertController.positiveButtonText = "proceed".localized().uppercased()
                alertController.alertViewDelegate = parentViewController
                parentViewController.navigationController?.visibleViewController?.present(alertController, animated: false, completion: nil)
            } else {
                parentViewController.openDeepLink()
            }
        }
    }
    
    internal func setDriverPictureURL(url: String?) {
        if let url = url {
            pictureImage.loadImageFromURL(urlString: url)
        }
    }
    
    internal func setRatingCount(_ count: Int32?) {
        if let count = count {
            var template = "rating_plural".localized()
            if count == 1 {
                template = "rating".localized()
            }
            notationLabel.attributedText = NSMutableAttributedString()
                .normal(String(format: template, count), color: Configuration.Color.gray, size: 10)
        }
    }
    
    internal func setRating(_ count: Float?) {
        if count != nil {
            floatRatingView.backgroundColor = UIColor.clear
            floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
            floatRatingView.emptyImage = UIImage(named: "star_empty", in: NavitiaSDKUI.shared.bundle, compatibleWith: nil)
            floatRatingView.fullImage = UIImage(named: "star_full", in: NavitiaSDKUI.shared.bundle, compatibleWith: nil)
            floatRatingView.type = .floatRatings
            floatRatingView.editable = false
            floatRatingView.rating = Double(count!)
            floatRatingView.starsInterspace = 2
        }
    }
    
    internal func setSeatsCount(_ count: Int32?) {
        if let count = count {
            let template = "available_seats".localized()
            seatCountLabel.attributedText = NSMutableAttributedString()
                .semiBold(String(format: template, count), size: 12.5)
        } else {
            seatCountLabel.attributedText = NSMutableAttributedString()
                .semiBold("no_available_seats".localized(), size: 12.5)
        }
    }
    
    // MARK: - Action
    
    @IBAction func actionBookButton(_ sender: Any) {
        bookRidesharing()
    }
    
    @IBAction func actionAccessibilityButton(_ sender: Any) {
        guard UIAccessibility.isVoiceOverRunning else {
            return
        }
        
        bookRidesharing()
    }
}

extension RidesharingView {
    
    var network: String? {
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
    
    var departure: String? {
        get {
            return startLabel.text
        }
        set {
            if let newValue = newValue {
                startLabel.attributedText = NSMutableAttributedString()
                    .semiBold("departure".localized(), color: Configuration.Color.main, size: 8.5)
                    .semiBold(": ", color: Configuration.Color.main, size: 8.5)
                    .bold(newValue, color: Configuration.Color.main, size: 14)
            }
        }
    }
    
    var driverNickname: String? {
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
    
    var departureAddress: String? {
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
    
    var arrivalAddress: String? {
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
                        .semiBold("free".localized(), color: Configuration.Color.orange,size: 10)
                } else {
                    priceLabel.attributedText = NSMutableAttributedString()
                        .semiBold(newValue, color: Configuration.Color.orange, size: 10)
                }
            } else {
                priceLabel.attributedText = NSMutableAttributedString()
                    .semiBold("price_not_available".localized(), color: Configuration.Color.orange,size: 10)
            }
        }
    }

}
