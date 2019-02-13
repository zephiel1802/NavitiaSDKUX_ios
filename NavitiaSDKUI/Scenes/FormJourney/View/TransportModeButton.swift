//
//  TransportModeButton.swift
//  NavitiaSDKUI
//
//  Created by Valentin COUSIEN on 11/02/2019.
//

import Foundation

class TransportModeButton: UIButton {
    
    var mode: ModeButtonModel? {
        didSet {
            guard let mode = mode else {
                return
            }
            
            icon = mode.icon
            isSelected = mode.selected
            
        }
    }
    
    var icon: String? {
        didSet {
            updateIcon()
        }
    }
    
    override public var isSelected: Bool {
        didSet {
            if isSelected {
                layer.borderColor = Configuration.Color.main.cgColor
            } else {
                layer.borderColor = Configuration.Color.shadow.cgColor
            }
            updateIcon()
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderWidth = 1
        backgroundColor = Configuration.Color.white

        self.isSelected = true
        self.addTarget(self, action: #selector(self.buttonAction(_:)), for: UIControl.Event.touchUpInside)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func updateIcon() {
        guard let icon = icon else {
            return
        }
        
        if isSelected {
            setAttributedTitle(NSMutableAttributedString().icon(icon, color: Configuration.Color.main, size: 25), for: .normal)
        } else {
            setAttributedTitle(NSMutableAttributedString().icon(icon, color: Configuration.Color.shadow, size: 25), for: .normal)
        }
    }
        
    @objc func buttonAction(_ sender:UIButton!) {
        isSelected = !isSelected
    }
}
