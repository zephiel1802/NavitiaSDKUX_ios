//
//  ModeTransportView.swift
//  NavitiaSDKUI
//
//  Copyright © 2019 kisio. All rights reserved.
//

import UIKit

class ModeTransportView: UIView {
    
    private let verticalMargin: Int = 10
    private let iconSize: Int = 62
    private let minMargin: Int = 10
    private let textVerticalMargin = 0
    private let textSize = 25
    
    var transportModeView: UIView?
    var transportModeLabel: UILabel!
    var isColorInverted: Bool = false {
        didSet {
            transportModeLabel.textColor = (isColorInverted ? NavitiaSDKUI.shared.mainColor : UIColor.white)
        }
    }
    var buttonsSaved: [TransportModeButton] = []
    
    var contraintHegiht: NSLayoutConstraint?
    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        drawLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if contraintHegiht == nil {
            contraintHegiht = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.height, relatedBy: .equal,
                                                 toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        }
        if let superview = superview as? StackScrollView {
            superview.reloadStack()
        }
        
        contraintHegiht?.constant = ModeTransportView.getViewHeight(by: self.frame.width)
        contraintHegiht?.isActive = true

        self.frame.size = CGSize(width: self.frame.width, height: ModeTransportView.getViewHeight(by: self.frame.width))
        if buttonsSaved.count == 0 {
            initButtons()
        }
     //   self.drawLabel()
        self.drawIcons()
//

    }
    
    // MARK: - Function
    
    class func getViewHeight(by width : CGFloat) -> CGFloat {
        let verticalMargin: Int = 10
        let iconSize: Int = 62
        let minMargin: Int = 10
        let textVerticalMargin = 0
        let textSize = 20
        let maxIconForWidth = ( Int(width) + minMargin ) / ( iconSize + minMargin )
        let numberOfLines = Configuration.modeForm.count / Int(maxIconForWidth) + ( Configuration.modeForm.count %
            maxIconForWidth == 0 ? 0 : 1 )
        
        return CGFloat((iconSize + verticalMargin + textSize + textVerticalMargin) * numberOfLines + 30 - verticalMargin)
    }
    
    private func initButtons() {
        for mode in Configuration.modeForm {
            let newButton = TransportModeButton(frame: CGRect(x: 0, y: 0, width: iconSize, height: iconSize))
            newButton.mode = mode
            newButton.delegate = self

            buttonsSaved.append(newButton)
        }
    }
    
    private func drawLabel() {
        transportModeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: 30))
        transportModeLabel.attributedText = NSMutableAttributedString().bold("Mode de transport",
                                                                             color: isColorInverted ? NavitiaSDKUI.shared.mainColor : UIColor.white,
                                                                             size: 13)
        
        addSubview(transportModeLabel)
    }

    private func drawIcons() {
        let maxIconForWidth = ( Int(self.frame.width) + minMargin ) / ( iconSize + minMargin )
        let margin = Configuration.modeForm.count < maxIconForWidth ? minMargin : ( Int(self.frame.width) - ( maxIconForWidth * iconSize ) ) / ( maxIconForWidth - 1 )
        let numberOfLines = Configuration.modeForm.count / Int(maxIconForWidth) +
            ( Configuration.modeForm.count % maxIconForWidth == 0 ? 0 : 1 )
        var transportMode = UIView(frame: CGRect(x: 0, y: 30, width: self.frame.width, height: CGFloat((iconSize + verticalMargin + textSize + textVerticalMargin) * numberOfLines - verticalMargin)))
        
        var countIconsToDisplay = Configuration.modeForm.count
        var y = 0
        for i in 0..<numberOfLines {
            var x = 0
            for j in 0..<maxIconForWidth {
                if countIconsToDisplay <= 0 {
                    if self.transportModeView != nil {
                        self.transportModeView?.removeFromSuperview()
                        self.transportModeView = nil
                    }
                    self.addSubview(transportMode)
                    self.transportModeView = transportMode
                    
                    return
                }
                
                let newButton = buttonsSaved[i * maxIconForWidth + j]
                newButton.frame.origin = CGPoint(x: x, y: y)

                newButton.layer.cornerRadius = 5
                newButton.removeFromSuperview()
                
                let newLabel = UILabel(frame: CGRect(x: x, y: y + textVerticalMargin + iconSize, width: iconSize, height: textSize))
                newLabel.text = newButton.mode?.title
                newLabel.textAlignment = .center
                newLabel.numberOfLines = 2
                newLabel.font = UIFont.systemFont(ofSize: 8)
                newLabel.textColor = (isColorInverted ? UIColor.black : UIColor.white)
                
                transportMode.addSubview(newButton)
                transportMode.addSubview(newLabel)
                
                countIconsToDisplay = countIconsToDisplay - 1
                x = x + margin + iconSize
            }
            y = y + iconSize + verticalMargin + textSize + textVerticalMargin
        }
        
        if self.transportModeView != nil {
            self.transportModeView?.removeFromSuperview()
            self.transportModeView = nil
        }
        self.addSubview(transportMode)
        self.transportModeView = transportMode
    }
    
    internal func getPhysicalModes() -> [String]? {
        var physicalModes = [String]()
        
        for button in buttonsSaved {
            if button.isSelected, let physicalMode = button.mode?.physicalMode {
                physicalModes += physicalMode
            }
        }
        
        if physicalModes.count == 0 {
            return nil
        }
        
        return physicalModes
    }
    
    internal func getModes() -> [String] {
        var modes = [String]()
        
        for button in buttonsSaved {
            if button.isSelected, let mode = button.mode?.mode.rawValue {
                modes.append(mode)
            }
        }
        
        return modes
    }
    
    internal func getNumberButtonIsSelected() -> Int {
        var count = 0
        
        for button in buttonsSaved {
            if button.isSelected {
                count = count + 1
            }
        }
        
        return count
    }
}

extension ModeTransportView: TransportModeButtonDelegate {
    
    func touchButton(sender: TransportModeButton) {
        if !sender.isSelected || (getNumberButtonIsSelected() > 1) {
            sender.isSelected = !sender.isSelected
        }
    }
}
