//
//  StepByStepItemVIew.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

class StepByStepItemView: UIView {
    
    @IBOutlet weak var directionIconImageView: UIImageView!
    @IBOutlet weak var directionInstructionLabel: UILabel!
    
    static var identifier: String {
        return String(describing: self)
    }
    
    class func instanceFromNib() -> StepByStepItemView {
        return UINib(nibName: identifier, bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: nil, options: nil)[0] as! StepByStepItemView
    }
    
    var icon: String? {
        didSet {
            guard let icon = icon else {
                return
            }
            
            directionIconImageView.image = UIImage(named: icon, in: NavitiaSDKUI.shared.bundle, compatibleWith: nil)
        }
    }
    
    var instruction: String? {
        didSet {
            directionInstructionLabel.text = instruction
        }
    }
}
