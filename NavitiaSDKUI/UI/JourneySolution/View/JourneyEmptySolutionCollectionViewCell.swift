//
//  JourneyEmptySolutionCollectionViewCell.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 29/03/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class JourneyEmptySolutionCollectionViewCell: UICollectionViewCell {
    
    public var height = 40
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
}
