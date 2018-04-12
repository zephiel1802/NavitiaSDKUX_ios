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
    @IBOutlet weak var addressFromLabel: UILabel!
    @IBOutlet weak var addressToLabel: UILabel!
    @IBOutlet weak var seatCountLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var _type: TypeTransport?
    
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
        
    }
    
//    private func setHeight() {
//        frame.size.height = timeLabel.frame.size.height + timeLabel.frame.origin.y + 10
//    }
    
}

//@IBOutlet weak var titleLabel: UILabel!
//@IBOutlet weak var startLabel: UILabel!
//@IBOutlet weak var pictureImage: UIImageView!
//@IBOutlet weak var loginLabel: UILabel!
//@IBOutlet weak var genderLabel: UILabel!
//@IBOutlet weak var addressFromLabel: UILabel!
//@IBOutlet weak var addressToLabel: UILabel!
//@IBOutlet weak var seatCountLabel: UILabel!
//@IBOutlet weak var priceLabel: UILabel!

extension RidesharingView {
    
//    var d: String? {
//        get {
//            return
//        }
//        set {
//            if let newValue = newValue {
//                titleLabel.attributedText = NSMutableAttributedString()
//            }
//        }
//    }

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
                    .normal("Départ: ", size: 8.5)
                    .bold(newValue, size: 14)
            }
        }
    }
    
    var picture: UIImage? {
        get {
            return pictureImage.image
        }
        set {
            if let newValue = newValue {
                pictureImage.image = newValue
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
                        .normal("Gratuit", size: 8.5)
                } else {
                    priceLabel.attributedText = NSMutableAttributedString()
                        .normal(newValue, size: 8.5)
                }
            }
        }
    }
    
//    timeLabel.attributedText = NSMutableAttributedString()
//    .normal(newValue, size: 15)
//    .normal(" minutes", size: 15)
//    .normal(typeString, size: 15)
    
}
