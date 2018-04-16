//
//  JourneyEmptySolutionCollectionViewCell.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 29/03/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class JourneyEmptySolutionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var noJourneyView: UIView!
    @IBOutlet weak var noJourneyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        noJourneyLabel.text = "no_journey_found".localized(withComment: "No journey found", bundle: bundle)
        noJourneyView.backgroundColor = UIColor(red:0.85, green:0.93, blue:0.97, alpha:1.0)
        noJourneyView.layer.borderWidth = 1
        noJourneyView.layer.borderColor = UIColor(red:0.20, green:0.44, blue:0.56, alpha:1.0).cgColor
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
}
