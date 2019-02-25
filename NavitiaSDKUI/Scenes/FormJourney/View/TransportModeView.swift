//
//  TransportModeView.swift
//  NavitiaSDKUI
//
//  Copyright © 2019 kisio. All rights reserved.
//

import UIKit

class TransportModeView: UIView {
    
    private let verticalMargin: Int = 10
    private let iconSize: Int = 61
    private let minMargin: Int = 8
    private let textVerticalMargin = 0
    private let textSize = 25
    private var maxIconForWidth = 0
    private var margin = 0
    private var numberOfLines = 0
    private var transportModeView: UIView?
    private var transportModeLabel: UILabel!
    private var buttonsSaved: [TransportModeButton] = []
    private var labelsSaved: [UILabel] = []
    private var contraintHegiht: NSLayoutConstraint?
    
    public var isColorInverted: Bool = false {
        didSet {
            transportModeLabel.textColor = (isColorInverted ? NavitiaSDKUI.shared.mainColor : Configuration.Color.white)
        }
    }
    
    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initItems()
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
            contraintHegiht?.isActive = true
        }
        
        frame.size = CGSize(width: frame.width, height: getViewHeight(by: frame.width))
        contraintHegiht?.constant = frame.size.height
        drawIcons()
        
        if let superview = superview as? StackScrollView {
            superview.reloadStack()
        }
    }
    
    // MARK: - Function
    
    internal func getViewHeight(by width : CGFloat) -> CGFloat {
        calculateOptimization()
        
        return CGFloat((iconSize + verticalMargin + textSize + textVerticalMargin) * numberOfLines + 23 - verticalMargin)
    }
    
    internal func initItems() {
        for mode in Configuration.modeForm {
            let newButton = TransportModeButton(frame: CGRect(x: 0, y: 0, width: iconSize, height: iconSize))
            newButton.mode = mode
            newButton.delegate = self

            buttonsSaved.append(newButton)
            
            let newLabel = UILabel(frame: CGRect(x: 0, y: 0, width: iconSize, height: textSize))
            newLabel.text = newButton.mode?.title
            newLabel.textAlignment = .center
            newLabel.numberOfLines = 2
            newLabel.font = UIFont.systemFont(ofSize: 8)
            newLabel.textColor = (isColorInverted ? NavitiaSDKUI.shared.mainColor : Configuration.Color.white)
            
            labelsSaved.append(newLabel)
        }
    }
    
    internal func drawLabel() {
        transportModeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: 18))
        transportModeLabel.attributedText = NSMutableAttributedString().bold("transport_modes".localized(), color: isColorInverted ? NavitiaSDKUI.shared.mainColor : Configuration.Color.white, size: 13)
        addSubview(transportModeLabel)
    }
    
    internal func drawLine(to transportMode: UIView, y: Int, line: Int) {
        var x = 0
        
        for column in 0..<maxIconForWidth {
            guard let newButton = buttonsSaved[safe: line * maxIconForWidth + column], let newLabel = labelsSaved[safe: line * maxIconForWidth + column] else {
                showIcons(transportMode: transportMode)
                
                return
            }
            newButton.frame.origin = CGPoint(x: x, y: y)
            newLabel.frame.origin = CGPoint(x: x, y: y + textVerticalMargin + iconSize)
            if isColorInverted {
                newLabel.textColor = Configuration.Color.black
            } else {
                newLabel.textColor = Configuration.Color.white
            }
            
            transportMode.addSubview(newButton)
            transportMode.addSubview(newLabel)
            
            x = x + margin + iconSize
        }
    }

    internal func calculateOptimization() {
        maxIconForWidth = ( Int(self.frame.width) + minMargin ) / ( iconSize + minMargin )
        
        if maxIconForWidth == 0 {
            print("NavitiaSDKUI: Icons size too large to be displayed for transport mode")
            
            return
        } else if maxIconForWidth == 1 {
            margin = minMargin
        } else {
            margin = Configuration.modeForm.count < maxIconForWidth ? minMargin : ( Int(self.frame.width) - ( maxIconForWidth * iconSize ) ) / ( maxIconForWidth - 1 )
        }
        
        numberOfLines = Configuration.modeForm.count / Int(maxIconForWidth) + ( Configuration.modeForm.count % maxIconForWidth == 0 ? 0 : 1 )
    }
    
    internal func drawIcons() {
        if maxIconForWidth == 0 {
            return
        }
        let transportMode = UIView(frame: CGRect(x: 0, y: transportModeLabel.frame.size.height + 5, width: self.frame.width, height: CGFloat((iconSize + verticalMargin + textSize + textVerticalMargin) * numberOfLines - verticalMargin)))
        
        var y = 0
        for line in 0..<numberOfLines {
            drawLine(to: transportMode, y: y, line: line)
            y = y + iconSize + verticalMargin + textSize + textVerticalMargin
        }
        showIcons(transportMode: transportMode)
    }
    
    internal func showIcons(transportMode: UIView) {
        if transportModeView != nil {
            transportModeView?.removeFromSuperview()
            transportModeView = nil
        }
        addSubview(transportMode)
        transportModeView = transportMode
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
    
    internal func getRealTimeModes() -> [String] {
        var modes = [String]()
        
        for button in buttonsSaved {
            if button.isSelected, let realTime = button.mode?.realTime, realTime, let mode = button.mode?.mode.rawValue {
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

extension TransportModeView: TransportModeButtonDelegate {
    
    func touchButton(sender: TransportModeButton) {
        if !sender.isSelected || (getNumberButtonIsSelected() > 1) {
            sender.isSelected = !sender.isSelected
        }
    }
}
