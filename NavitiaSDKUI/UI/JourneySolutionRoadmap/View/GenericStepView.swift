//
//  TransferStepView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class GenericStepView: UIView {
    
    @IBOutlet var _view: UIView!
    
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var detailsButtonContainer: UIView!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var detailsArrowLabel: UILabel!
    @IBOutlet weak var directionsContainer: UIView!
    @IBOutlet weak var directionsContainerHeightConstraint: NSLayoutConstraint!
    
    var _mode: ModeTransport?
    var directionsStackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var frame: CGRect {
        willSet {
            if let _view = _view {
                _view.frame.size = newValue.size
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        _setup()
    }
    
    override func layoutSubviews() {
        directionLabel.sizeToFit()
        timeLabel.sizeToFit()
        timeLabel.frame.origin.y = directionLabel.frame.origin.y + directionLabel.frame.size.height
        
        if !detailsButtonHidden {
            detailsButtonContainer.sizeToFit()
            detailsButtonContainer.frame.origin.y = timeLabel.frame.origin.y + timeLabel.frame.size.height
        }
        
        if directionsHidden {
            frame.size.height = detailsButtonHidden ? timeLabel.frame.origin.y + timeLabel.frame.size.height + 10 : detailsButtonContainer.frame.origin.y + detailsButtonContainer.frame.size.height
        } else {
            directionsContainer.sizeToFit()
            directionsContainer.frame.origin.y = detailsButtonContainer.frame.origin.y + detailsButtonContainer.frame.size.height
            
            frame.size.height = directionsContainer.frame.origin.y + directionsContainer.frame.size.height
        }
    }
    
    private func _setHeight() {
        let directionLabelSize = directionLabel.attributedText?.boundingRect(with: CGSize(width: frame.size.width - 60, height: 9990), options: .usesLineFragmentOrigin, context: nil)
        let timeLabelSize = timeLabel.attributedText?.boundingRect(with: CGSize(width: frame.size.width - 60, height: 9990), options: .usesLineFragmentOrigin, context: nil)
        frame.size.height = (directionLabelSize?.height)! + (timeLabelSize?.height)! + 20
    }

    private func _setup() {
        UINib(nibName: "GenericStepView", bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: self, options: nil)
        _view.frame = self.bounds
        addSubview(_view)
        
        detailsButtonHidden = true
        detailsLabel.attributedText = NSMutableAttributedString().semiBold("details".localized(bundle: NavitiaSDKUI.shared.bundle), color: Configuration.Color.gray, size: 15)
        detailsArrowLabel.attributedText = NSMutableAttributedString().icon("arrow-details-down", color: Configuration.Color.gray, size: 14)
        
        directionsHidden = true
        _setupDirectionsStackView()
    }
    
    var paths: [Path]? {
        didSet {
            if let paths = paths, paths.count > 0 {
                detailsButtonHidden = false
                _updateDirectionsStack()
            }
        }
    }
    
    @IBAction func manageDirectionsDisplay(_ sender: Any) {
        directionsHidden = !directionsHidden
    }
    
}

extension GenericStepView {
    
    var detailsButtonHidden: Bool {
        get {
            return detailsButtonContainer.isHidden
        }
        set {
            if newValue {
                detailsButtonContainer.isHidden = true
                frame.size.height -= detailsButtonContainer.frame.size.height
            } else {
                detailsButtonContainer.isHidden = false
                frame.size.height += detailsButtonContainer.frame.size.height
            }
        }
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
    
    var modeString: String? {
        get {
            return _mode?.rawValue
        }
        set {
            if let newValue = newValue {
                _mode = ModeTransport(rawValue: newValue)
                icon = newValue
            }
        }
    }
    
    var icon: String? {
        get {
            return iconLabel.text
        }
        set {
            if let newValue = newValue {
                iconLabel.attributedText = NSMutableAttributedString()
                    .icon(newValue, size: 20)
            }
        }
    }
    
    var direction: String? {
        get {
            return directionLabel.text
        }
        set {
            if let newValue = newValue {
                directionLabel.attributedText = NSMutableAttributedString()
                    .normal("to_with_uppercase".localized(withComment: "To", bundle: NavitiaSDKUI.shared.bundle), size: 15)
                    .normal(" ", size: 15)
                    .bold(newValue, size: 15)
                
                _setHeight()
            }
        }
    }

    var time: String? {
        get {
            return timeLabel.text
        }
        set {
            if let newValue = newValue {
                var duration = newValue + " " + "units_minutes".localized(withComment: "minutes", bundle: NavitiaSDKUI.shared.bundle)
                if Int(newValue) == 1 {
                    duration = newValue + " " + "units_minute".localized(withComment: "minute", bundle: NavitiaSDKUI.shared.bundle)
                } else if Int(newValue) == 0 {
                    duration = "less_than_a".localized(withComment: "less than a", bundle: NavitiaSDKUI.shared.bundle) + " " + "units_minute".localized(withComment: "minute", bundle: NavitiaSDKUI.shared.bundle)
                }
                
                var template = ""
                if let mode = _mode {
                    switch mode {
                        case .walking:
                            template = "a_time_walk".localized(withComment: "A time walk", bundle: NavitiaSDKUI.shared.bundle)
                            break
                        case .car:
                            template = "a_time_drive".localized(withComment: "A time drive", bundle: NavitiaSDKUI.shared.bundle)
                            break
                        case .bike, .bss:
                            template = "a_time_ride".localized(withComment: "A time ride", bundle: NavitiaSDKUI.shared.bundle)
                            break
                        default:
                            break
                    }
                }
                
                let formattedString = NSMutableAttributedString()
                formattedString
                    .normal(String(format: template, duration), size: 15)
                timeLabel.attributedText = formattedString
            }
            
            _setHeight()
        }
    }
    
    private func _setupDirectionsStackView() {
        directionsStackView = UIStackView(frame: directionsContainer.bounds)
        directionsStackView.axis = .vertical
        directionsStackView.distribution = .fillEqually
        directionsStackView.alignment = .fill
        directionsStackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        directionsContainer.addSubview(directionsStackView)
    }
    
    private func _updateDirectionsStack() {
        if let paths = paths {
            directionsContainerHeightConstraint.constant = CGFloat(paths.count) * 45
            
            for path in paths {
                let view = StepByStepItemView()
                view.pathDirection = path.direction ?? 0
                view.pathLength = path.length ?? 0
                view.pathInstruction = path.name ?? ""
                
                directionsStackView.addArrangedSubview(view)
            }
        }
    }
    
}
