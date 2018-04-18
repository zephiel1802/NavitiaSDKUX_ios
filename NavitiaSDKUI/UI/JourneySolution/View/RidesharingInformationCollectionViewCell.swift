//
//  RidesharingInformationCollectionViewCell.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class RidesharingInformationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var messageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        _setup()
        addShadow()
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    private func _setup() {
         messageLabel.text = "carpool_highlight_message".localized(withComment: "Share a car with someone going the same way.", bundle: NavitiaSDKUIConfig.shared.bundle)
    }
    
}
