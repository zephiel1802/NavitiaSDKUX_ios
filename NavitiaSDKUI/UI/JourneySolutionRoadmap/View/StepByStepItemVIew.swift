//
//  StepByStepItemVIew.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

class StepByStepItemView: UIView {
    
    @IBOutlet var _view: UIView!
    @IBOutlet weak var directionIconImageView: UIImageView!
    @IBOutlet weak var directionInstructionLabel: UILabel!
    
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
    }
    
    private func _setup() {
        UINib(nibName: "StepByStepItemView", bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: self, options: nil)
        _view.frame = self.bounds
        addSubview(_view)
    }
    
    var pathDirection: Int32 = 0 {
        didSet {
            directionIconImageView.image = _getDirectionIcon()
        }
    }
    
    var pathInstruction: String = "" {
        didSet {
            directionInstructionLabel.text = _getDirectionInstruction()
        }
    }
    
    var pathLength: Int32 = 0 {
        didSet {
            directionInstructionLabel.text = String(format: "%@ %@", pathInstruction, String(format: "walking_duration".localized(bundle: NavitiaSDKUI.shared.bundle), pathLength))
        }
    }
    
}

extension StepByStepItemView {
    
    private func _getDirectionIcon() -> UIImage? {
        if pathDirection == 0 {
            return UIImage(named: "arrow_straight", in: NavitiaSDKUI.shared.bundle, compatibleWith: nil)
        } else if pathDirection < 0 {
            return UIImage(named: "arrow_left", in: NavitiaSDKUI.shared.bundle, compatibleWith: nil)
        } else {
            return UIImage(named: "arrow_right", in: NavitiaSDKUI.shared.bundle, compatibleWith: nil)
        }
    }
    
    private func _getDirectionInstruction() -> String {
        if pathDirection == 0 {
            return pathInstruction == "" ? String(format: "%@ %@", "carry_straight_on".localized(bundle: NavitiaSDKUI.shared.bundle), String(format: "for_meter".localized(bundle: NavitiaSDKUI.shared.bundle), pathLength)) : String(format: "%@ %@ %@", "continue_on".localized(bundle: NavitiaSDKUI.shared.bundle), pathInstruction, String(format: "for_meter".localized(bundle: NavitiaSDKUI.shared.bundle), pathLength))
        } else if pathDirection < 0 {
            return pathInstruction == "" ? String(format: "%@ %@", "turn_left".localized(bundle: NavitiaSDKUI.shared.bundle), String(format: "in_meter".localized(bundle: NavitiaSDKUI.shared.bundle), pathLength)) : String(format: "%@ %@ %@", "turn_left_on".localized(bundle: NavitiaSDKUI.shared.bundle), pathInstruction, String(format: "in_meter".localized(bundle: NavitiaSDKUI.shared.bundle), pathLength))
        } else {
            return self.pathInstruction == "" ? String(format: "%@ %@", "turn_right".localized(bundle: NavitiaSDKUI.shared.bundle), String(format: "in_meter".localized(bundle: NavitiaSDKUI.shared.bundle), pathLength)) : String(format: "%@ %@ %@", "turn_right_on".localized(bundle: NavitiaSDKUI.shared.bundle), pathInstruction, String(format: "in_meter".localized(bundle: NavitiaSDKUI.shared.bundle), pathLength))
        }
    }
    
}
