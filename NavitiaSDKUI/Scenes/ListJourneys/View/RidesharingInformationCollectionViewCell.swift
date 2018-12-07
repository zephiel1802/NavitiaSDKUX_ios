//
//  RidesharingInformationCollectionViewCell.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class RidesharingInformationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var messageLabel: UILabel!
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    // MARK: - Function
    
    private func setup() {
         messageLabel.text = "carpool_highlight_message".localized()
        
        addShadow()
    }
}
