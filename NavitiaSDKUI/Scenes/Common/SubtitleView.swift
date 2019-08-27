//
//  SubtitleView.swift
//  NavitiaSDKUI
//
//  Created by Adeline Hirsch on 27/08/2019.
//

import Foundation
import UIKit

class SubtitleView: UIView {
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    internal var subtitle: String? {
        didSet {
            if let subtitle = subtitle {
                subtitleLabel.attributedText = NSMutableAttributedString().bold(subtitle, size: 13)
            }
        }
    }
    
    internal var isColorInverted: Bool = false {
        didSet {
            subtitleLabel.textColor = isColorInverted ? .white : NavitiaSDKUI.shared.mainColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        subtitleLabel.textColor = isColorInverted ? .white : NavitiaSDKUI.shared.mainColor
    }
    
    class func instanceFromNib() -> SubtitleView {
        
        return UINib(nibName: String(describing: self), bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: nil, options: nil)[0] as! SubtitleView
    }
}
