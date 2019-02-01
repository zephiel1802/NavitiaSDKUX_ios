//
//  ModeTransportView.swift
//  NavitiaSDKUI
//
//  Copyright © 2019 kisio. All rights reserved.
//

import UIKit

class ModeTransportView: UIView {

    // MARK: - UINib
    
    static var identifier: String {
        return String(describing: self)
    }
    
    class func instanceFromNib() -> ModeTransportView {
        return UINib(nibName: identifier, bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: nil, options: nil)[0] as! ModeTransportView
    }
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    // MARK: - Function
    
    private func setup() {
        
    }
}
