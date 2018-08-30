//
//  DisruptionItemView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class OnDemandeItemView: UIView {
    
    @IBOutlet weak var phoneIconLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var informationLabel: UILabel!
    
    class func instanceFromNib() -> OnDemandeItemView {
        return UINib(nibName: "OnDemandeItemView", bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: nil, options: nil)[0] as! OnDemandeItemView
    }
}

extension OnDemandeItemView {
    
    
    
    func setIcon() {
        phoneIconLabel.attributedText = NSMutableAttributedString().icon("phone-tad", size: 15)
        phoneIconLabel.textColor = Configuration.Color.main
    }
    
    func setTitle() {
        titleLabel.attributedText = NSMutableAttributedString().bold("mandatory_reservation".localized(bundle: NavitiaSDKUI.shared.bundle), color: Configuration.Color.main, size: 12)
    }
    
    func setInformation(text: String) {
        informationLabel.attributedText = NSMutableAttributedString().normal(text, color: Configuration.Color.darkerGray, size: 11)
        
        let types: NSTextCheckingResult.CheckingType = [.phoneNumber, .address]
        do {
            let detector = try NSDataDetector(types: types.rawValue)
            detector.enumerateMatches(in: text, options: [], range: NSMakeRange(0, text.count)) { (resul, _, _) in


                print(resul?.range.location)
            }
        } catch {
            
        }

        informationLabel.attributedText = NSMutableAttributedString().normal(text, color: Configuration.Color.darkerGray, size: 11)
    }
    
}
