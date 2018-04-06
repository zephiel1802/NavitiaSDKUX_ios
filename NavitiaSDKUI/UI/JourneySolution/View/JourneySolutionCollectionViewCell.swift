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
    
    func setup(_ journey: Journey) {
        arrowLabel.text = "\u{ea0c}"
        arrowLabel.font = UIFont(name: "SDKIcons", size: 15)
        
        let formattedStringDateTime = NSMutableAttributedString()
        formattedStringDateTime
            .bold((journey.departureDateTime?.toDate(format: "yyyyMMdd'T'HHmmss")?.toString(format: "HH:mm"))!)
            .bold(" - ")
            .bold((journey.arrivalDateTime?.toDate(format: "yyyyMMdd'T'HHmmss")?.toString(format: "HH:mm"))!)
        
        
        dateTime = formattedStringDateTime
        
        let formattedStringDuration = NSMutableAttributedString()
        formattedStringDuration
            .bold((journey.duration?.toString(allowedUnits: [ .hour, .minute ])!)!)
        duration = formattedStringDuration
        
        let formattedString = NSMutableAttributedString()
        formattedString
            .normal("Dont ")
            .bold((journey.durations?.walking?.toString(allowedUnits: [ .hour, .minute ])!)!)
            .normal(" à pied (")
            .normal((journey.distances?.walking?.toString())!)
            .normal(" mètres)")
        durationWalker = formattedString
        
        if let sections = journey.sections {
            journeySummaryView.addSections(sections)
        }
    }
    
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
