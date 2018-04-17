//
//  RidesharingInformationCollectionViewCell.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 27/03/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class RidesharingInformationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var messageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        _setupShadow()
        messageLabel.text = "carpool_highlight_message".localized(withComment: "carpool_highlight_message", bundle: NavitiaSDKUIConfig.shared.bundle)
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    private func _setupShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 5
    }
    
}
