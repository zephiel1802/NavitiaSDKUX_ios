//
//  JourneySummaryView.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 27/03/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

var bundle: Bundle!

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
        print("coucouc toi")
        _setup()
        //custom logic goes here
    }
    
    private func _setup() {
        
        UINib(nibName: "JourneySummaryView", bundle: bundle).instantiate(withOwner: self, options: nil)
        self.addSubview(_view)
        _view.frame = self.bounds
        
        //_stackView.distribution = .fillProportionally
        
        let test1 = JourneySummaryPartView()
        test1.widthAnchor.constraint(equalToConstant: (frame.size.width - 20) * 0.12).isActive = true
        test1.color = UIColor.red
        test1.name = "A"
        
        let test2 = JourneySummaryPartView()
        test2.widthAnchor.constraint(equalToConstant: (frame.size.width - 20) * 0.51).isActive = true
        test2.color = UIColor.blue
        test2.name = "C1"

        let test3 = JourneySummaryPartView()
        test3.widthAnchor.constraint(equalToConstant: (frame.size.width - 20) * 0.37).isActive = true
        test3.color = UIColor.green
        test3.name = "2"
        
        _stackView.addArrangedSubview(test1)
        _stackView.addArrangedSubview(test2)
        _stackView.addArrangedSubview(test3)
    }

    func calcul(pourcent: CGFloat) -> CGFloat {
        print("\(self._view.frame.size) \(self._stackView.frame.size)")
        return pourcent * (self._stackView.frame.size.width - self._stackView.spacing * 3)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
