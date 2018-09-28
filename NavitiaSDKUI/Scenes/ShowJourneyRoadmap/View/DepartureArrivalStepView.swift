//
//  DepartureArrivalStepView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class DepartureArrivalStepView: UIView {
    
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var calorieContainerView: UIView!
    @IBOutlet weak var calorieImageView: UIImageView!
    @IBOutlet weak var calorieLabel: UILabel!
    
    var type: ShowJourneyRoadmap.GetRoadmap.ViewModel.DepartureArrival.Mode = .departure {
        didSet {
            if type == .departure {
                backgroundColor = Configuration.Color.origin
                title = String(format: "%@ :", "departure".localized(bundle: NavitiaSDKUI.shared.bundle))
            } else {
                backgroundColor = Configuration.Color.destination
                title = String(format: "%@ :", "arrival".localized(bundle: NavitiaSDKUI.shared.bundle))
            }
        }
    }
    
    var title: String? {
        didSet {
            guard let title = title else {
                return
            }
            
            titleLabel.text = title
        }
    }
    
    var information: String? {
        didSet {
            guard let information = information else {
                return
            }
            
            informationLabel.text = information
        }
    }
    
    var time: String? {
        didSet {
            guard let time = time else {
                return
            }
            
            hourLabel.attributedText = NSMutableAttributedString().normal(time, color: UIColor.white,size: 12)
        }
    }
    
    var calorie: String? {
        didSet {
            guard let calorie = calorie else {
                return
            }
            
            calorieContainerView.isHidden = false
            calorieLabel.attributedText = NSMutableAttributedString().normal(String(format: "calorie_unit".localized(bundle: NavitiaSDKUI.shared.bundle), calorie), color: UIColor.white, size: 12)
        }
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    class func instanceFromNib() -> DepartureArrivalStepView {
        return UINib(nibName: identifier, bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: nil, options: nil)[0] as! DepartureArrivalStepView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupIcon()
        addShadow(opacity: 0.28)
    }

    override func layoutSubviews() {
        titleLabel.sizeToFit()
        informationLabel.sizeToFit()
        
        if calorieContainerView.isHidden {
            frame.size.height = stackView.frame.size.height + stackView.frame.origin.y + 10
        } else {
            frame.size.height = calorieContainerView.frame.size.height + calorieContainerView.frame.origin.y + 10
        }
    }
    
    private func setupIcon() {
        iconLabel.attributedText = NSMutableAttributedString().icon("location-pin", color:UIColor.white, size: 22)
        
        calorieImageView.image = UIImage(named: "calorie", in: NavitiaSDKUI.shared.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        calorieImageView.tintColor = Configuration.Color.white
    }
}
