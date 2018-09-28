//
//  JourneySolutionView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class JourneySolutionView: UIView {
    
    @IBOutlet var _view: UIView!
    
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var durationCenterContraint: NSLayoutConstraint!
    @IBOutlet weak var journeySummaryView: JourneySummaryView!
    @IBOutlet weak var durationWalkerLabel: UILabel!

    var disruptions: [Disruption]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        UINib(nibName: "JourneySolutionView", bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: self, options: nil)
        _view.frame = self.bounds
        addSubview(_view)
        addShadow()
        journeySummaryView.disruptions = disruptions
    }

    func setData(_ journey: Journey) {
        aboutLabel.isHidden = true
        durationCenterContraint.constant = 0
        
        if let durationInt = journey.duration {
            formattedDuration(durationInt)
        }
        if let sections = journey.sections {
            journeySummaryView.disruptions = disruptions
            journeySummaryView.addSections(sections)
        }
    }
    
    func setRidesharingData(duration: Int32, sections: [Section]) {
        aboutLabel.isHidden = false
        durationCenterContraint.constant = 7
        
        aboutLabel.attributedText = NSMutableAttributedString()
            .semiBold("about".localized(withComment: "about", bundle: NavitiaSDKUI.shared.bundle), color: Configuration.Color.main)
        formattedDuration(duration)
        journeySummaryView.disruptions = disruptions
        journeySummaryView.addSections(sections)
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
    
}
