//
//  TicketEmptyCollectionViewCell.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 27/04/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class TicketLoadCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addShadow(opacity: 0.28)
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
        
}

