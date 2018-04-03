//
//  JourneySolutionCollectionViewCell.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 26/03/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class JourneySolutionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var durationWalkerLabel: UILabel!
    @IBOutlet weak var journeySummaryView: JourneySummaryView!
    @IBOutlet weak var arrowLabel: UILabel!
    
    public var height = 130
    
    var dateTime: NSAttributedString? {
        get {
            return dateTimeLabel.attributedText
        }
        set {
            dateTimeLabel.attributedText = newValue
        }
    }
    
    var duration: NSAttributedString? {
        get {
            return durationLabel.attributedText
        }
        set {
            durationLabel.attributedText = newValue
        }
    }
    
    var durationWalker: NSAttributedString? {
        get {
            return durationWalkerLabel.attributedText
        }
        set {
            durationWalkerLabel.attributedText = newValue
        }
    }
    
//    var durationWalker: String {
//        get {
//            return durationWalkerLabel.text ?? ""
//        }
//        set {
//            durationWalkerLabel.text = newValue
//        }
//    }
    
    var testJourney: Int {
        get {
            return 2
        }
//        set {
//
//        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        arrowLabel.text = "\u{ea08}"
//        if let font = UIFont(name: "SDKIcons", size: 14) {
//            print("djfkqdsfjkdsjfksdjf")
//            arrowLabel.font = UIFont(name: "SDKIcons", size: 14)
//        }
        

    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    
    
}
