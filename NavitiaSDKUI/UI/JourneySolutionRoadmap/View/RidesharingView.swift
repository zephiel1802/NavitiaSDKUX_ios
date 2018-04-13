//
//  RidesharingView.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 12/04/2018.
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
    @IBOutlet weak var starStack: UIStackView!
    @IBOutlet weak var notationLabel: UILabel!
    @IBOutlet weak var addressFromLabel: UILabel!
    @IBOutlet weak var addressToLabel: UILabel!
    @IBOutlet weak var seatCountLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var _type: TypeTransport?
    var _parent: UIViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
//    override var frame: CGRect {
////        willSet {
////            if let _view = _view {
////                _view.frame.size = newValue.size
////            }
////        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        _setup()
    }
    
    private func _setup() {
        UINib(nibName: "RidesharingView", bundle: bundle).instantiate(withOwner: self, options: nil)
        _view.frame = self.bounds
        addSubview(_view)
        
//        for _ in 0...4 {
//            let myView = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
//            myView.image = UIImage(named: "start_full", in: bundle, compatibleWith: nil)
//            starStack.addArrangedSubview(myView)
//        }

    }
    
    func setPicture(url: String?) {
        if let url = url {
            pictureImage.loadImageFromURL(urlString: url)
        }
    }
    
    func setNotation(_ count: Int32?) {
        if let count = count {
            notationLabel.attributedText = NSMutableAttributedString()
                .normal(String(count), size: 10)
                .normal(" notes", size: 10)
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
                    myView.image = UIImage(named: "star_full", in: bundle, compatibleWith: nil)
                    starStack.addArrangedSubview(myView)
                }
            }
            let empty = 4 - count
            if empty >= 0 {
                for _ in 0...empty {
                    let myView = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
                    myView.image = UIImage(named: "star_empty", in: bundle, compatibleWith: nil)
                    starStack.addArrangedSubview(myView)
                }
            }
        }
    }
    
    @IBAction func actionBookButton(_ sender: Any) {
        if let parentViewController = _parent {
            let alertController = AlertViewController(nibName: "AlertView", bundle: bundle)
            alertController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            //alertController.stateKey = //NavitiaSDKUserDefaultsManager.SHOW_REDIRECTION_DIALOG_PREF_KEY
            alertController.alertMessage = NSLocalizedString("redirection_message", bundle: bundle, comment: "Redirection Message")
            alertController.checkBoxText = NSLocalizedString("dont_show_this_message_again", bundle: bundle, comment: "Don't show this message again")
            alertController.negativeButtonText = NSLocalizedString("cancel", bundle: bundle, comment: "Cancel").uppercased()
            alertController.positiveButtonText = NSLocalizedString("proceed", bundle: bundle, comment: "Continue").uppercased()
            alertController.alertViewDelegate = parentViewController as! JourneySolutionRoadmapViewController
            parentViewController.navigationController?.visibleViewController?.present(alertController, animated: false, completion: nil)
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
                    .normal("Départ: ", color: NavitiaSDKUIConfig.shared.color.tertiary, size: 8.5)
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
                genderLabel.attributedText = NSMutableAttributedString()
                    .normal("(", size: 12)
                    .normal(newValue, size: 12)
                    .normal(")", size: 12)
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
                    .normal(newValue, size: 11)
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
                    .normal(newValue, size: 11)
            }
        }
    }
    
    var seatCount: String? {
        get {
            return seatCountLabel.text
        }
        set {
            if let newValue = newValue {
                seatCountLabel.attributedText = NSMutableAttributedString()
                    .normal("Places disponibles : ", size: 12.5)
                    .normal(newValue, size: 12.5)
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
                        .normal("Gratuit", color: NavitiaSDKUIConfig.shared.color.orange,size: 8.5)
                } else {
                    priceLabel.attributedText = NSMutableAttributedString()
                        .normal(newValue, color: NavitiaSDKUIConfig.shared.color.orange, size: 8.5)
                }
            }
        }
    }

}
