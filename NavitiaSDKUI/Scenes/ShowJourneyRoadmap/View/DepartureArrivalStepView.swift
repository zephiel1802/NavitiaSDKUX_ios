//
//  DepartureArrivalStepView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class DepartureArrivalStepView: UIView {
    
    @IBOutlet weak var contentContainerView: UIView!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var informationBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var calorieContainerView: UIView!
    @IBOutlet weak var calorieContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var calorieImageView: UIImageView!
    @IBOutlet weak var calorieLabel: UILabel!
    
    internal var type: ShowJourneyRoadmap.GetRoadmap.ViewModel.DepartureArrival.Mode = .departure {
        didSet {
            if type == .departure {
                contentContainerView.backgroundColor = Configuration.Color.origin
            } else {
                contentContainerView.backgroundColor = Configuration.Color.destination
            }
        }
    }
    
    internal var information: (String, String)? {
        didSet {
            guard let information = information else {
                return
            }
            
            informationLabel.attributedText = NSMutableAttributedString()
                .bold(information.0, color: Configuration.Color.white, size: 15.0)
                .normal(information.1, color: Configuration.Color.white, size: 15.0)
        }
    }
    
    internal var time: String? {
        didSet {
            guard let time = time else {
                return
            }
            
            hourLabel.attributedText = NSMutableAttributedString().normal(time, color: UIColor.white,size: 12)
        }
    }
    
    internal var calorie: String? {
        didSet {
            guard let calorie = calorie else {
                return
            }
            
            calorieContainerView.isHidden = false
            informationBottomConstraint.isActive = false
            calorieContainerBottomConstraint.isActive = true
            calorieLabel.attributedText = NSMutableAttributedString().normal(String(format: "calorie_unit".localized(), calorie), color: UIColor.white, size: 12)
        }
    }
    
    // MARK: - UINib
    
    static var identifier: String {
        return String(describing: self)
    }
    
    class func instanceFromNib() -> DepartureArrivalStepView {
        return UINib(nibName: identifier, bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: nil, options: nil)[0] as! DepartureArrivalStepView
    }
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        frame.size.height = contentContainerView.frame.size.height
        if let superview = superview as? StackScrollView {
            superview.reloadStack()
        }
    }
    
    // MARK: - Function
    
    private func setup() {
        setupIcon()
        setShadow(opacity: 0.28)
    }
    
    private func setupIcon() {
        iconLabel.attributedText = NSMutableAttributedString().icon("location-pin", color:UIColor.white, size: 22)
        
        calorieImageView.image = UIImage(named: "calorie", in: NavitiaSDKUI.shared.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        calorieImageView.tintColor = Configuration.Color.white
    }
}
