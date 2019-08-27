//
//  TravelerTypeView.swift
//  NavitiaSDKUI
//
//  Created by Adeline Hirsch on 26/08/2019.
//

import Foundation
import UIKit

class TravelerTypeView: UIView {
    
    @IBOutlet weak var typeName: UILabel!
    @IBOutlet weak var typeIsOnSwitch: UISwitch!
    
    internal var name: String? {
        didSet {
            if let name = name {
                typeName.attributedText = NSMutableAttributedString().normal(name, size: 12)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        typeIsOnSwitch.onTintColor = NavitiaSDKUI.shared.mainColor
    }
    
    class func instanceFromNib() -> TravelerTypeView {
        return UINib(nibName: String(describing: self), bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: nil, options: nil)[0] as! TravelerTypeView
    }
}
