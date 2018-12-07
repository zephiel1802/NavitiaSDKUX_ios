//
//  JourneyHeaderCollectionReusableView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class JourneyHeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    // MARK: - Function
    
    internal var title: String = "" {
        didSet {
            titleLabel.text = title.uppercased()
        }
    }
}
