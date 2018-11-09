//
//  StepView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

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
    @IBOutlet weak var bssStationStateView: UIView!
    @IBOutlet weak var bssStationStateIconLabel: UILabel!
    @IBOutlet weak var bssStationStateLabel: UILabel!
    @IBOutlet var detailsView: UIView!
    @IBOutlet weak var directionsContainer: UIView!
    @IBOutlet weak var directionsContainerHeightConstraint: NSLayoutConstraint!
    
    var directionsStackView: UIStackView!

    static var identifier: String {
        return String(describing: self)
    }
    
    class func instanceFromNib() -> StepView {
        return UINib(nibName: identifier, bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: nil, options: nil)[0] as! StepView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initBssState()
        initRealTime()
        initDetails()
        initDirection()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        frame.size.height = stackView.frame.origin.y + stackView.frame.size.height
        if let superview = superview as? StackScrollView {
            superview.reloadStack()
        }
    }
    
    private func initRealTime() {
        realTimeView.isHidden = true
        realTimeIconLabel.isHidden = true
        realTimeImage.image = UIImage(named: "real_time", in: NavitiaSDKUI.shared.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        realTimeImage.tintColor = Configuration.Color.main
    }
    
    private func initDetails() {
        detailsView.isHidden = true
        detailsLabel.text = "details".localized(bundle: NavitiaSDKUI.shared.bundle)
        detailsArrowLabel.attributedText = NSMutableAttributedString().icon("arrow-details-down", color: Configuration.Color.gray, size: 13)
    }
    
    private func initDirection() {
        directionsHidden = true
    }
    
    private func initBssState() {
        bssStationStateView.isHidden = true
        bssStationStateIconLabel.attributedText = NSMutableAttributedString().icon("disruption-information", color: Configuration.Color.main, size: 17)
    }
    
    var enableBackground: Bool = false {
        didSet {
            if enableBackground {
                backgroundColor = Configuration.Color.white
                layer.cornerRadius = 5
                addShadow(opacity: 0.28)
            } else {
                backgroundColor = UIColor.clear
                layer.cornerRadius = 0
                removeShadow()
            }
        }
    }
    
    var iconInformations: String? {
        didSet {
            guard let iconInformations = iconInformations else {
                return
            }
            
            informationsIconLabel.attributedText = NSMutableAttributedString().icon(iconInformations, size: 20)
        }
    }
    
    var informationsAttributedString: NSAttributedString? {
        didSet {
            informationsLabel.attributedText = informationsAttributedString
            informationsLabel.sizeToFit()
        }
    }
    
    var stands: ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel.Stands? {
        didSet {
            guard let stands = stands else {
                return
            }

            if let bssStationStatus = stands.status {
                if !realTimeView.isHidden {
                    realTimeView.isHidden = true
                }
                
                bssStationStateView.isHidden = false
                bssStationStateLabel.attributedText = NSMutableAttributedString().bold(bssStationStatus, color: Configuration.Color.main, size: 13)
            } else if let realTimeValue = stands.availability {
                if !bssStationStateView.isHidden {
                    bssStationStateView.isHidden = true
                }
                
                realTimeView.isHidden = false
                realTimeLabel.attributedText = NSMutableAttributedString().semiBold(realTimeValue, color: Configuration.Color.main, size: 13)
                
                if let realTimeIcon = stands.icon {
                    realTimeIconLabel.isHidden = false
                    realTimeIconLabel.attributedText = NSMutableAttributedString().icon(realTimeIcon, size: 17)
                }
            }
        }
    }
    
    var realTimeAnimation: Bool = false {
        didSet {
            guard let _ = realTimeImage else {
                return
            }
            
            if realTimeAnimation {
                realTimeImage.alpha = 1
                UIView.animate(withDuration: 1.0, delay: 0, options: [.autoreverse], animations: {
                    self.realTimeImage.alpha = 0
                }, completion: nil)
            } else {
                realTimeImage.alpha = 1
                realTimeImage.layer.removeAllAnimations()
            }
        }
    }
    
    var availablePath: String? {
        didSet {
            detailsView.isHidden = false
        }
    }
    
    var paths: [ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel.Path]? {
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
        directionsStackView = UIStackView(frame: CGRect(x: 50,
                                                        y: directionsContainer.bounds.origin.y,
                                                        width: directionsContainer.bounds.size.width - 50,
                                                        height: directionsContainer.bounds.size.height))
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
                let view = StepByStepItemView.instanceFromNib()
                
                view.icon = path.directionIcon
                view.instruction = path.instruction
                directionsStackView.addArrangedSubview(view)
            }
        }
    }
    
    @IBAction func manageDirectionsDisplay(_ sender: Any) {
        directionsHidden = !directionsHidden
    }
    
    var directionsHidden: Bool = true {
        didSet {
            if directionsHidden {
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
