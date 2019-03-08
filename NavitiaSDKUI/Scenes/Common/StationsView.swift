//
//  StationsView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class StationsView: UIView {
    
    @IBOutlet weak var stationView: UIView!
    @IBOutlet weak var stationLabel: UILabel!
    
    internal var color: UIColor? {
        didSet {
            stationView.backgroundColor = color
        }
    }
    internal var name: String? {
        didSet {
            if let name = name {
                stationLabel.attributedText = NSMutableAttributedString().bold(name, size: 12)
            }
        }
    }
    
    // MARK: - UINib
    
    static var identifier: String {
        return String(describing: self)
    }
    
    class func instanceFromNib() -> StationsView {
        return UINib(nibName: identifier, bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: nil, options: nil)[0] as! StationsView
    }
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
