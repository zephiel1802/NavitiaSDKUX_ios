//
//  TransportModeButton.swift
//  NavitiaSDKUI
//
//  Created by Valentin COUSIEN on 11/02/2019.
//

import Foundation

class TransportModeButton: UIButton {
    
    var mode: String?
    var isColorInverted: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.isSelected = true
        self.addTarget(self, action: #selector(self.buttonAction(_:)), for: UIControl.Event.touchUpInside)
    }
    
    override required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func buttonAction(_ sender:UIButton!) {
        isSelected = !isSelected
        
        if isSelected {
            self.backgroundColor = NavitiaSDKUI.shared.mainColor
        } else {
            self.backgroundColor = UIColor.gray
        }
    }
}
