//
//  TransportModeButton.swift
//  NavitiaSDKUI
//
//  Copyright © 2019 kisio. All rights reserved.
//

import Foundation

protocol TransportModeButtonDelegate: class {
    
    func touchButton(sender: TransportModeButton)
}

class TransportModeButton: UIButton {
    
    weak var delegate: TransportModeButtonDelegate?
    var mode: ModeButtonModel? {
        didSet {
            guard let mode = mode else {
                return
            }
            
            type = mode.type
            isSelected = mode.selected
        }
    }
    
    var type: String? {
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
        layer.cornerRadius = 5
        backgroundColor = Configuration.Color.white

        self.isSelected = true
        self.addTarget(self, action: #selector(self.buttonAction(_:)), for: UIControl.Event.touchUpInside)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func updateIcon() {
        guard let type = type else {
            return
        }
        
        setImage(type.getIcon(), for: .normal)
        subviews.first?.contentMode = .scaleAspectFit
        imageEdgeInsets = UIEdgeInsets(top: 18,left: 18,bottom: 18,right: 18)
        imageView?.tintColor = isSelected ? Configuration.Color.main : Configuration.Color.shadow
    }
    
    @objc func buttonAction(_ sender:UIButton!) {
        delegate?.touchButton(sender: self)
    }
}
