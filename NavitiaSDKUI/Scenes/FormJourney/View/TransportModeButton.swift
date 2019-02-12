//
//  TransportModeButton.swift
//  NavitiaSDKUI
//
//  Created by Valentin COUSIEN on 11/02/2019.
//

import Foundation

class TransportModeButton: UIButton {
    
    public enum ModeType: String {
        case bike = "bike"
        case bss = "bss"
        case car = "car"
        case ridesharing = "ridesharing"
        case walking = "walking"
    }
    
    public struct ModeForm {
        var title: String
        var icon: String
        var selected: Bool
        var mode: ModeType // bike // bss // car // ridesharing // walking
        var physicalMode: [String]?
    }
    
    var mode: ModeForm? {
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
    override var isSelected: Bool {
        didSet {
            if isSelected {
                layer.borderColor = Configuration.Color.main.cgColor
            } else {
                layer.borderColor = Configuration.Color.shadow.cgColor
            }
            updateIcon()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderWidth = 1
        backgroundColor = Configuration.Color.white

        self.isSelected = true
        self.addTarget(self, action: #selector(self.buttonAction(_:)), for: UIControl.Event.touchUpInside)
    }
    
    override required init?(coder aDecoder: NSCoder) {
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
