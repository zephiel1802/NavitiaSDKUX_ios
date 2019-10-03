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
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var informationBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var calorieContainerView: UIView!
    @IBOutlet weak var calorieContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var calorieImageView: UIImageView!
    @IBOutlet weak var calorieLabel: UILabel!
    
    internal var type: ShowJourneyRoadmap.GetRoadmap.ViewModel.DepartureArrival.Mode = .departure {
        didSet {
            contentContainerView.backgroundColor = type == .departure ? Configuration.Color.origin : Configuration.Color.destination
            iconImageView.image = type == .departure ?
                "journey_departure".getIcon(renderingMode: .alwaysOriginal, customizable: true) :
                "journey_arrival".getIcon(renderingMode: .alwaysOriginal, customizable: true)
            hourLabel.textColor = type == .departure ? Configuration.Color.origin.contrastColor() : Configuration.Color.destination.contrastColor()
            informationLabel.textColor = type == .departure ? Configuration.Color.origin.contrastColor() : Configuration.Color.destination.contrastColor()
        }
    }
    
    internal var information: (String, String)? {
        didSet {
            guard let information = information else {
                return
            }
            
            informationLabel.attributedText = NSMutableAttributedString()
                .bold(information.0,
                      color: type == .departure ? Configuration.Color.origin.contrastColor() : Configuration.Color.destination.contrastColor(),
                      size: 15.0)
                .normal(information.1,
                        color: type == .departure ? Configuration.Color.origin.contrastColor() : Configuration.Color.destination.contrastColor(),
                        size: 15.0)
        }
    }
    
    internal var time: String? {
        didSet {
            guard let time = time else {
                return
            }
            
            hourLabel.attributedText = NSMutableAttributedString().normal(time, color: type == .departure ? Configuration.Color.origin.contrastColor() : Configuration.Color.destination.contrastColor(),size: 12)
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
            calorieLabel.attributedText = NSMutableAttributedString().normal(String(format: "calorie_unit".localized(), calorie), color: type == .departure ? Configuration.Color.origin.contrastColor() : Configuration.Color.destination.contrastColor(), size: 12)
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
        calorieImageView.image = "calorie".getIcon()
        calorieImageView.tintColor = type == .departure ? Configuration.Color.origin.contrastColor() : Configuration.Color.destination.contrastColor()
    }
}
