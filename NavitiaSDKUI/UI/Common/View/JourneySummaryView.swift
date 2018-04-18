//
//  JourneySummaryView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

extension UIStackView {
    
    func removeAllArrangedSubviews() {
        
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}

class JourneySummaryView: UIView {

    @IBOutlet weak var _view: UIView!
    @IBOutlet weak var _stackView: UIStackView!
    
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
    
    func addSections(_ sections: [Section]) {
        var durationAllSections:Int32 = 0
        var sectionCount = 0.0
        
        _stackView.removeAllArrangedSubviews()
        for section in sections {
            if validDisplaySection(section) {
                if let duration = section.duration {
                    durationAllSections += duration
                    sectionCount += 1
                }
            }
        }
        for section in sections {
            if validDisplaySection(section) {
                if let duration = section.duration {
                    if section.mode == "walking" && duration <= 180 {
                        continue
                    }
                    let journeySummaryPartView = JourneySummaryPartView()
                    journeySummaryPartView.width = widthJourneySummaryPartView(sectionCount: sectionCount,
                                                                               durationAllSections: durationAllSections,
                                                                               duration: duration)
                    journeySummaryPartView.name = section.displayInformations?.label
                    journeySummaryPartView.color = section.displayInformations?.color?.toUIColor() ?? UIColor.black
                    journeySummaryPartView.icon = Modes().getModeIcon(section: section)
                    //journeySummaryPartView.displayDisruption("disruption-information")
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
        if section.type == "street_network" && section.mode == "walking" ||
            section.type != "transfer" &&
            section.type != "waiting" &&
            section.type != "leave_parking" &&
            section.type != "bss_rent" &&
            section.type != "bss_put_back" {
            return true
        }
        return false
    }
    
    private func widthJourneySummaryPartView(sectionCount: Double, durationAllSections: Int32, duration: Int32) -> Double {
        return max(sectionCount * 17, Double(duration) * sectionCount * 100 / Double(durationAllSections))
    }

}
