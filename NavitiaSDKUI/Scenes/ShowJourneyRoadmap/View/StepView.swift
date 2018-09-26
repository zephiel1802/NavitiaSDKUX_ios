//
//  StepView.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 26/09/2018.
//

import Foundation
import UIKit

class StepView: UIView {
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var informationsIconLabel: UILabel!
    @IBOutlet var informationsLabel: UILabel!
    
    @IBOutlet var realTimeView: UIView!
    @IBOutlet weak var realTimeIconLabel: UILabel!
    @IBOutlet weak var realTimeImage: UIImageView!
    @IBOutlet weak var realTimeLabel: UILabel!
    
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var detailsArrowLabel: UILabel!
    
    @IBOutlet var detailsView: UIView!

    @IBOutlet weak var directionsContainer: UIView!
    @IBOutlet weak var directionsContainerHeightConstraint: NSLayoutConstraint!
    
    var directionsStackView: UIStackView!

    class func instanceFromNib() -> StepView {
        return UINib(nibName: "StepView", bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: nil, options: nil)[0] as! StepView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Real Time
        realTimeView.isHidden = true
        realTimeIconLabel.isHidden = true
        realTimeImage.image = UIImage(named: "real_time", in: NavitiaSDKUI.shared.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        realTimeImage.tintColor = Configuration.Color.main
        
        // Details
        detailsView.isHidden = true
        detailsLabel.text = "details".localized(bundle: NavitiaSDKUI.shared.bundle)
        detailsArrowLabel.attributedText = NSMutableAttributedString().icon("arrow-details-down", color: Configuration.Color.gray, size: 13)
        
        // Direction Path
        directionsHidden = true
        // Les trucs à faire avant :)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let position: CGFloat = stackView.frame.origin.y
        let height: CGFloat = stackView.frame.size.height
        frame.size.height = position + height
    }
    
    var iconInformations: String? {
        didSet {
            guard let iconInformations = iconInformations else {
                return
            }
            
            informationsIconLabel.attributedText = NSMutableAttributedString()
                .icon(iconInformations, size: 20)
        }
    }
    
    var informationsAttributedString: NSMutableAttributedString? {
        didSet {
            informationsLabel.attributedText = informationsAttributedString
            informationsLabel.sizeToFit()
        }
    }
    
    var realTimeIcon: String? {
        didSet {
            guard let realTimeIcon = realTimeIcon else {
                return
            }
            
            realTimeIconLabel.isHidden = false
            realTimeIconLabel.attributedText = NSMutableAttributedString()
                .icon(realTimeIcon, size: 20)
        }
    }
    
    var realTimeValue: String? {
        didSet {
            guard let realTimeValue = realTimeValue else {
                return
            }
            
            realTimeView.isHidden = false
            realTimeLabel.attributedText = NSMutableAttributedString()
                .normal(realTimeValue, size: 15)
        }
    }
    
    var availablePath: String? {
        didSet {
            detailsView.isHidden = false
        }
    }
    
    var paths: [ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.Path]? {
        didSet {
            guard let paths = paths, paths.count > 0 else {
                return
            }
            
            if directionsStackView == nil {
                setupDirectionsStackView()
            }
            
            detailsView.isHidden = false
            updateDirectionsStack()
        }
    }
    
    private func setupDirectionsStackView() {
        directionsStackView = UIStackView(frame: directionsContainer.bounds)
        directionsStackView.frame.origin.x = 50
        directionsStackView.frame.size.width -= 50
        directionsStackView.axis = .vertical
        directionsStackView.distribution = .fillEqually
        directionsStackView.alignment = .fill
        directionsStackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        directionsContainer.addSubview(directionsStackView)
    }
    
    private func updateDirectionsStack() {
        if let paths = paths {
            directionsContainerHeightConstraint.constant = CGFloat(paths.count) * 45 // Height 45px

            for path in paths {
                let view = StepByStepItemView()
                view.pathDirection = path.direction
                view.pathLength = path.length
                view.pathInstruction = path.name

                directionsStackView.addArrangedSubview(view)
            }
        }
    }
    
    @IBAction func manageDirectionsDisplay(_ sender: Any) {
        directionsHidden = !directionsHidden
    }
    
    var directionsHidden: Bool {
        get {
            return directionsContainer.isHidden
        }
        set {
            if newValue {
                directionsContainer.isHidden = true
                detailsArrowLabel.attributedText = NSMutableAttributedString().icon("arrow-details-down", color: Configuration.Color.gray, size: 13)
                frame.size.height -= directionsContainer.frame.size.height
            } else {
                directionsContainer.isHidden = false
                detailsArrowLabel.attributedText = NSMutableAttributedString().icon("arrow-details-up", color: Configuration.Color.gray, size: 13)
                frame.size.height += directionsContainer.frame.size.height
            }
        }
    }
    
}
