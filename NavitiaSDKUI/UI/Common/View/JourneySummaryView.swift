//
//  JourneySummaryView.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 27/03/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

var bundle: Bundle!

extension UIStackView {
    
    func removeAllArrangedSubviews() {
        
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        // Remove the views from self
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
      //  fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        _setup()
        //custom logic goes here
    }
    
    
    func addSections(_ sections: [Section]) {
        _stackView.removeAllArrangedSubviews()
        var test:Double = 0
        var nb:Double = 0
        for section in sections {
            if section.type == "street_network" && section.mode == "walking" ||// et aussi != 0 et size- 1
                section.type != "transfer" && section.type != "waiting" && section.type != "leave_parking" {
                test += Double(section.duration ?? 0)
                nb += 1
            }
        }
        for section in sections {
            if section.type == "street_network" && section.mode == "walking" ||// et aussi != 0 et size- 1
                section.type != "transfer" && section.type != "waiting" && section.type != "leave_parking" && section.type != "bss_rent" && section.type != "bss_put_back" {
                let journeySummaryPartView = JourneySummaryPartView()
                journeySummaryPartView.width = max(nb * 17, Double(section.duration ?? 0) * nb * 100 / test)
                print("LOL \(journeySummaryPartView.width)")
                journeySummaryPartView.color = UIColor.red
                
               // print(section.displayInformations)
                journeySummaryPartView.name = section.displayInformations?.label
                journeySummaryPartView.color = section.displayInformations?.color?.toUIColor() ?? UIColor.black
                journeySummaryPartView.icon = Modes().getModeIcon(section: section)
                print(section.duration ?? "--")
                _stackView.addArrangedSubview(journeySummaryPartView)
            }// et aussi != 0 et size- 1

        }
    }
    
    func getIconMode() {
        
    }
    
    private func _setup() {
        
        UINib(nibName: "JourneySummaryView", bundle: bundle).instantiate(withOwner: self, options: nil)
        self.addSubview(_view)
        _view.frame = self.bounds
        
        _stackView.distribution = .fillProportionally
        _stackView.translatesAutoresizingMaskIntoConstraints = false
    }

    func nbTest(nb: Double, pourcent: Double) -> Double {
        return pourcent * nb * 100
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
