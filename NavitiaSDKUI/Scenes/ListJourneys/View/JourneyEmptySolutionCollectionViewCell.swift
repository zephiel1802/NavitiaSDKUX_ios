//
//  JourneyEmptySolutionCollectionViewCell.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class JourneyEmptySolutionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    internal var descriptionText: String? {
        didSet {
            descriptionLabel.text = descriptionText
        }
    }
    
    // MARK: - UINib
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    // MARK: - Function
    
    private func setup() {
        setShadow()
        setView()
        setDescriptionLabel()
    }
    
    private func setDescriptionLabel() {
        descriptionLabel.text = "no_journey_found".localized()
        descriptionLabel.textColor = Configuration.Color.alertInfoDarker
    }
    
    private func setView() {
        backgroundColor = Configuration.Color.alertView
        layer.borderWidth = 1
        layer.borderColor = Configuration.Color.alertInfoDarker.cgColor
    }
}
