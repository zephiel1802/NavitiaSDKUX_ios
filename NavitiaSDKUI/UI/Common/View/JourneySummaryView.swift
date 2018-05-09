//
//  JourneySummaryView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class JourneySummaryView: UIView {

    @IBOutlet weak var _view: UIView!
    @IBOutlet weak var _stackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        _setup()
    }
    
    func addSections(_ sections: [Section]) {
        var allDurationSections:Int32 = 0
        var sectionCount = 0.0
        
        _stackView.removeAllArrangedSubviews()
        for section in sections {
            if validDisplaySection(section) {
                if let duration = section.duration {
                    allDurationSections += duration
                    sectionCount += 1
                }
            }
        }
        for section in sections {
            if validDisplaySection(section) {
                if let duration = section.duration {
                    if section.mode == ModeTransport.walking.rawValue && duration <= 180 {
                        continue
                    }
                    let journeySummaryPartView = JourneySummaryPartView()
                    
                    journeySummaryPartView.name = section.displayInformations?.label
                    journeySummaryPartView.icon = Modes().getModeIcon(section: section)
                    journeySummaryPartView.color = section.displayInformations?.color?.toUIColor() ?? UIColor.black
                    journeySummaryPartView.width = widthJourneySummaryPartView(sectionCount: sectionCount,
                                                                               allDurationSections: allDurationSections,
                                                                               duration: duration,
                                                                               journeySummaryPartView: journeySummaryPartView)
                    _stackView.addArrangedSubview(journeySummaryPartView)
                }
            }
        }
    }
    
    private func _setup() {
        UINib(nibName: "JourneySummaryView", bundle: NavitiaSDKUIConfig.shared.bundle).instantiate(withOwner: self, options: nil)
        _view.frame = self.bounds
        addSubview(_view)
        
        _stackView.distribution = .fillProportionally
        _stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func validDisplaySection(_ section: Section) -> Bool {
        if (section.type == TypeTransport.streetNetwork.rawValue && section.mode == ModeTransport.walking.rawValue) ||
           (section.type != TypeTransport.transfer.rawValue &&
            section.type != TypeTransport.waiting.rawValue &&
            section.type != TypeTransport.leaveParking.rawValue &&
            section.type != TypeTransport.bssRent.rawValue &&
            section.type != TypeTransport.bssPutBack.rawValue) {
            return true
        }
        return false
    }
    
    private func widthJourneySummaryPartView(sectionCount: Double, allDurationSections: Int32, duration: Int32, journeySummaryPartView: JourneySummaryPartView) -> Double {
        var priority = 65.0
        var minValue = 5.0
        if let widthPart = journeySummaryPartView._tagTransportLabel.attributedText?.boundingRect(with: CGSize(width: frame.size.width - 60, height: 9990), options: .usesLineFragmentOrigin, context: nil).width {
            if !journeySummaryPartView._tagTransportView.isHidden {
                minValue = Double(widthPart + 25)
                priority = 100
            }
        }
        return max(minValue, Double(duration) * sectionCount * priority / Double(allDurationSections))
    }

}
