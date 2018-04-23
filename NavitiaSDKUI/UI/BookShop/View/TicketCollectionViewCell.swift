//
//  TicketCollectionViewCell.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 23/04/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class TicketCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        _setup()
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    private func _setup() {
        
    }

    
}
