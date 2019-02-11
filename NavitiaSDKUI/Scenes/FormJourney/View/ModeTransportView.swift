//
//  ModeTransportView.swift
//  NavitiaSDKUI
//
//  Copyright © 2019 kisio. All rights reserved.
//

import UIKit

class ModeTransportView: UIView {
    
    var transportModeView: UIView? = nil
    var transportModeLabel: UILabel? = nil
    var isColorInverted: Bool = false
    
    // MARK: - Initialization
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.frame.size = CGSize(width: self.frame.width, height: ModeTransportView.getViewHeight(by: self.frame.width))
        self.drawLabel()
        self.drawIcons()
    }
    
    class func getViewHeight(by width : CGFloat) -> CGFloat {
        let verticalMargin: Int = 10
        let iconSize: Int = 52
        let minMargin: Int = 10
        let textVerticalMargin = 0
        let textSize = 20
        let maxIconForWidth = ( Int(width) + minMargin ) / ( iconSize + minMargin )
        let numberOfLines = Configuration.nbOfTransportMode / Int(maxIconForWidth) + ( Configuration.nbOfTransportMode %
            maxIconForWidth == 0 ? 0 : 1 )
        
        return CGFloat((iconSize + verticalMargin + textSize + textVerticalMargin) * numberOfLines + 30 - verticalMargin)
    }
    
    // MARK: - Function
    
    private func drawLabel() {
        let transportLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 30))
        
        transportLabel.text = "Mode de transport"
        transportLabel.font = UIFont.boldSystemFont(ofSize: 13)
        transportLabel.textColor = (isColorInverted ? NavitiaSDKUI.shared.mainColor : UIColor.white)
        self.addSubview(transportLabel)
        self.transportModeLabel = transportLabel
    }
    
    private func drawIcons() {
        let verticalMargin: Int = 10
        let iconSize: Int = 52
        let minMargin: Int = 10
        let textVerticalMargin = 0
        let textSize = 20
        let maxIconForWidth = ( Int(self.frame.width) + minMargin ) / ( iconSize + minMargin )
        let margin = Configuration.nbOfTransportMode < maxIconForWidth ? minMargin : ( Int(self.frame.width) - ( maxIconForWidth * iconSize ) ) / ( maxIconForWidth - 1 )
        let numberOfLines = Configuration.nbOfTransportMode / Int(maxIconForWidth) +
            ( Configuration.nbOfTransportMode % maxIconForWidth == 0 ? 0 : 1 )
        var transportMode = UIView(frame: CGRect(x: 0, y: 30, width: self.frame.width, height: CGFloat((iconSize + verticalMargin + textSize + textVerticalMargin) * numberOfLines - verticalMargin)))
        
        var countIconsToDisplay = Configuration.nbOfTransportMode
        var y = 0
        for _ in 0..<numberOfLines {
            var x = 0
            for _ in 0..<maxIconForWidth {
                if countIconsToDisplay <= 0 {
                    if self.transportModeView != nil {
                        self.transportModeView?.removeFromSuperview()
                        self.transportModeView = nil
                    }
                    self.addSubview(transportMode)
                    self.transportModeView = transportMode
                    
                    return
                }
                
                let newButton = UIButton(frame: CGRect(x: x, y: y, width: iconSize, height: iconSize))
                let newLabel = UILabel(frame: CGRect(x: x, y: y + textVerticalMargin + iconSize, width: iconSize, height: textSize))
                
                newLabel.text = "Xxxxxxx"
                newLabel.textAlignment = .center
                newLabel.font = UIFont.systemFont(ofSize: 8)
                newLabel.textColor = (isColorInverted ? NavitiaSDKUI.shared.mainColor : UIColor.white)
                if isColorInverted {
                    newButton.layer.borderColor = NavitiaSDKUI.shared.mainColor.cgColor
                    newButton.layer.borderWidth = 1
                }
                newButton.backgroundColor = UIColor.white
                newButton.layer.cornerRadius = 5
                
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
}
