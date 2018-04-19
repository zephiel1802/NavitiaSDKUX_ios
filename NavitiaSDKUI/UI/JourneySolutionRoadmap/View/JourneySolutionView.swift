//
//  JourneySolutionView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class JourneySolutionView: UIView {
    
    @IBOutlet var _view: UIView!
    
 //   @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var durationCenterContraint: NSLayoutConstraint!
    @IBOutlet weak var journeySummaryView: JourneySummaryView!
    @IBOutlet weak var durationWalkerLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        _setup()
    }
    
    private func _setup() {
        UINib(nibName: "JourneySolutionView", bundle: NavitiaSDKUIConfig.shared.bundle).instantiate(withOwner: self, options: nil)
        _view.frame = self.bounds
        addSubview(_view)
        addShadow()
    }

    func setData(_ journey: Journey) {
        aboutLabel.isHidden = true
        durationCenterContraint.constant = 0
        if let durationInt = journey.duration {
            formattedDuration(durationInt)
        }
        if let sections = journey.sections {
            journeySummaryView.addSections(sections)
        }
    }
    
    func setDataRidesharing(_ journey: Journey) {
        aboutLabel.isHidden = false
        durationCenterContraint.constant = 7
        aboutLabel.attributedText = NSMutableAttributedString()
            .semiBold("about".localized(withComment: "about", bundle: NavitiaSDKUIConfig.shared.bundle), color: Configuration.Color.main)
        
        if let durationInt = journey.duration {
            formattedDuration(durationInt)
        }
        if let sections = journey.sections {
            journeySummaryView.addSections(sections)
        }
        if durationWalkerLabel != nil {
            durationWalkerLabel.isHidden = true
        }

    }
    
    private func formattedDuration(prefix: String = "", _ duration: Int32) {
        let formattedStringDuration = NSMutableAttributedString()
            .semiBold(prefix, color: Configuration.Color.main)
        formattedStringDuration.append(duration.toAttributedStringTime(sizeBold: 14, sizeNormal: 10.5))
        self.duration = formattedStringDuration
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
}

extension JourneySolutionView {
    
    var duration: NSAttributedString? {
        get {
            return durationLabel.attributedText
        }
        set {
            durationLabel.attributedText = newValue
        }
    }
    
//    var durationWalker: NSAttributedString? {
//        get {
//            return durationWalkerLabel.attributedText
//        }
//        set {
//            durationWalkerLabel.isHidden = false
//            durationWalkerLabel.attributedText = newValue
//        }
//    }
    
}
