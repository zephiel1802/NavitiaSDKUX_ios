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
    
    var disruption: [Disruption]?
    
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
                    if section.mode == .walking && duration <= 180 {
                        continue
                    }
                    let journeySummaryPartView = JourneySummaryPartView()
                    journeySummaryPartView.color = section.displayInformations?.color?.toUIColor() ?? UIColor.black
                    journeySummaryPartView.name = section.displayInformations?.label
                    journeySummaryPartView.icon = Modes().getModeIcon(section: section)
                    if let links = section.displayInformations?.links {
                        for link in links {
                            if let type = link.type, let id = link.id, let disruption = disruption {
                                if type == "disruption" {
                                    for i in disruption {
                                        if i.id == id {
                                            journeySummaryPartView.displayDisruption(Disruption.getIconName(of: i.level), color: i.severity?.color)
                                        }
                                    }
                                }
                            }
                        }
                    }
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
        UINib(nibName: "JourneySummaryView", bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: self, options: nil)
        _view.frame = self.bounds
        addSubview(_view)
        
        _stackView.distribution = .fillProportionally
        _stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func validDisplaySection(_ section: Section) -> Bool {
        if (section.type == .streetNetwork && section.mode == .walking) ||
           (section.type != .transfer &&
            section.type != .waiting &&
            section.type != .leaveParking &&
            section.type != .bssRent &&
            section.type != .bssPutBack) {
            return true
        }
        return false
    }
    
    private func widthJourneySummaryPartView(sectionCount: Double, allDurationSections: Int32, duration: Int32, journeySummaryPartView: JourneySummaryPartView) -> Double {
        var priority = 65.0
        var minValue = 75.0
        if var widthPart = journeySummaryPartView._tagTransportLabel.attributedText?.boundingRect(with: CGSize(width: frame.size.width - 60, height: 0), options: .usesLineFragmentOrigin, context: nil).width {
            if !journeySummaryPartView._circleLabel.isHidden {
                widthPart += 14
            }
            if !journeySummaryPartView._tagTransportView.isHidden {
                minValue = Double(widthPart + 75)
                priority = 100
            }
        }
        return max(minValue, Double(duration) * sectionCount * priority / Double(allDurationSections))
    }

}
