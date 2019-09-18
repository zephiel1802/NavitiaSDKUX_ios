//
//  TravelerTypeView.swift
//  NavitiaSDKUI
//
//  Created by Adeline Hirsch on 26/08/2019.
//

import Foundation
import UIKit

protocol TravelerTypeDelegate {
    func didTouch(travelerTypeView: TravelerTypeView)
}

class TravelerTypeView: UIView {
    
    @IBOutlet weak var typeName: UILabel!
    @IBOutlet weak var pictoImageView: UIImageView!
    @IBOutlet weak var pictoView: UIView!
    
    internal var delegate: TravelerTypeDelegate?
    
    internal var name: String? {
        didSet {
            if let name = name {
                typeName.attributedText = NSMutableAttributedString().normal(name, size: 12)
            }
        }
    }
    
    internal var image: UIImage? {
        didSet {
            if let image = image {
                pictoImageView.image = image
            }
        }
    }
    
    internal var isOn: Bool = false {
        didSet {
            pictoImageView.tintColor = isOn ? Configuration.Color.main : Configuration.Color.shadow
            if !isColorInverted {
                pictoView.layer.borderColor = isOn ? Configuration.Color.main.cgColor : Configuration.Color.shadow.cgColor
            }
        }
    }
    
    internal var isColorInverted: Bool = false {
        didSet {
            typeName.textColor = isColorInverted ? .white : .black
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        typeName.textColor = isColorInverted ? .white : .black
        isOn = false
    }
    
    class func instanceFromNib() -> TravelerTypeView {
        return UINib(nibName: String(describing: self), bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: nil, options: nil)[0] as! TravelerTypeView
    }
    
    @IBAction func selectPictoAction(_ sender: Any) {
        isOn = !isOn
        delegate?.didTouch(travelerTypeView: self)
    }
}
