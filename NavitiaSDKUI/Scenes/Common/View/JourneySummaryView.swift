//
//  JourneySummaryView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class JourneySummaryView: UIView {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    var disruptions: [Disruption]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func addSections(_ sections: [Section]) {
        var allDurationSections:Int32 = 0
        var sectionCount = 0.0
        
        stackView.removeAllArrangedSubviews()
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
                    if section.mode == .walking && duration <= 180 && sections.count > 1 {
                        continue
                    }
                    
                    let journeySummaryPartView = JourneySummaryPartView()
                    journeySummaryPartView.color = section.displayInformations?.color?.toUIColor() ?? UIColor.black
                    if let code = section.displayInformations?.code, !code.isEmpty {
                        journeySummaryPartView.name = section.displayInformations?.code
                    } else {
                        journeySummaryPartView.name = section.displayInformations?.commercialMode
                    }
                    journeySummaryPartView.icon = Modes().getMode(section: section)
                    if let disruptions = disruptions, disruptions.count > 0 {
                        let sectionDisruptions = section.disruptions(disruptions: disruptions)
                        if sectionDisruptions.count > 0 {
                            let highestDisruption = Disruption.highestLevelDisruption(disruptions: sectionDisruptions)
                            journeySummaryPartView.displayDisruption(Disruption.iconName(of: highestDisruption.level), color: highestDisruption.color)
                        }
                    }
                    journeySummaryPartView.width = widthJourneySummaryPartView(sectionCount: sectionCount,
                                                                               allDurationSections: allDurationSections,
                                                                               duration: duration,
                                                                               journeySummaryPartView: journeySummaryPartView)
                    
                    stackView.addArrangedSubview(journeySummaryPartView)
                }
            }
        }
    }
    
    private func setup() {
        UINib(nibName: "JourneySummaryView", bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: self, options: nil)
        view.frame = self.bounds
        addSubview(view)
        
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func validDisplaySection(_ section: Section) -> Bool {
        if (section.type == .streetNetwork && (section.mode == .walking || section.mode == .car || section.mode == .bike)) ||
           (section.type != .transfer &&
            section.type != .waiting &&
            section.type != .leaveParking &&
            section.type != .bssRent &&
            section.type != .bssPutBack &&
            section.type != .park &&
            section.type != .alighting &&
            section.type != .crowFly) {
            return true
        }
        
        return false
    }
    
    private func widthJourneySummaryPartView(sectionCount: Double, allDurationSections: Int32, duration: Int32, journeySummaryPartView: JourneySummaryPartView) -> Double {
        var priority = 65.0
        var minValue = 75.0
        if var widthPart = journeySummaryPartView.tagTransportLabel.attributedText?.boundingRect(with: CGSize(width: frame.size.width - 60, height: 0), options: .usesLineFragmentOrigin, context: nil).width {
            if !journeySummaryPartView.circleLabel.isHidden {
                widthPart += 14
            }
            if !journeySummaryPartView.tagTransportView.isHidden {
                minValue = Double(widthPart + 75)
                priority = 100
            }
        }
        
        return max(minValue, Double(duration) * sectionCount * priority / Double(allDurationSections))
    }

}
