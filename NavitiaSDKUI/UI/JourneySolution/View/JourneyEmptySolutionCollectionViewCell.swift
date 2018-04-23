//
//  JourneyEmptySolutionCollectionViewCell.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class JourneyEmptySolutionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var noJourneyView: UIView!
    @IBOutlet weak var noJourneyLabel: UILabel!
    
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
        noJourneyLabel.text = "no_journey_found".localized(withComment: "No journey found", bundle: NavitiaSDKUIConfig.shared.bundle)
        noJourneyLabel.textColor = Configuration.Color.alertInfoDarker
        noJourneyView.backgroundColor = Configuration.Color.alertView
        noJourneyView.layer.borderWidth = 1
        noJourneyView.layer.borderColor = Configuration.Color.alertInfoDarker.cgColor
    }
    
    var text: String? {
        get {
            return noJourneyLabel.text
        }
        set {
            noJourneyLabel.text = newValue
        }
    }
    
}
