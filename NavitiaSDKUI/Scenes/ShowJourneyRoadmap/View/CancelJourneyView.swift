//
//  CancelJourneyView.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 22/03/2019.
//

import UIKit

class CancelJourneyView: UIView {
    
    // MARK: - UINib
    
    static var identifier: String {
        return String(describing: self)
    }
    
    class func instanceFromNib() -> CancelJourneyView {
        return UINib(nibName: identifier, bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: nil, options: nil)[0] as! CancelJourneyView
    }
}
