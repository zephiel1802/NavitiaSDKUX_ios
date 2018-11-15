//
//  FriezeView.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 15/11/2018.
//

import UIKit

class FriezeView: UIView {

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    func addSection(sectionsClean: [FriezePresenter.FriezeSection]) {
        for tempView in subviews {
            if tempView.tag != 0 {
                tempView.removeFromSuperview()
            }
        }
        
        let paddingRight: CGFloat = 3
        let firstAlign: CGFloat = 0
        var xPos:CGFloat = firstAlign

        for section in sectionsClean {
            let journeySummaryPartView = setupJourneySummaryPartView(section: section)
            let width = witdhJourney(journeySummaryPartView: journeySummaryPartView)
            
            journeySummaryPartView.frame = CGRect(x: xPos, y: 0, width: width, height: 27)
            xPos = CGFloat(xPos) + CGFloat(width) + CGFloat(paddingRight)
            
            addSubview(journeySummaryPartView)
        }
    }
    
    private func setupJourneySummaryPartView(section: FriezePresenter.FriezeSection) -> FriezeSectionView {
        let journeySummaryPartView = FriezeSectionView()
        let tag = 1
        
        journeySummaryPartView.color = section.color
        journeySummaryPartView.name = section.name
        journeySummaryPartView.icon = section.icon
        journeySummaryPartView.displayDisruption(section.disruptionIcon, color: section.disruptionColor)
        journeySummaryPartView.tag = tag
        
        return journeySummaryPartView
    }
    
    private func witdhJourney(journeySummaryPartView: FriezeSectionView) -> CGFloat {
        let marginLeft: CGFloat = 4
        let marginRight: CGFloat = 3
        let sizeDisruption: CGFloat = 8
        var width: CGFloat = 25
        
        if !journeySummaryPartView.tagTransportView.isHidden {
            if let widthPart = journeySummaryPartView.tagTransportLabel.attributedText?.boundingRect(with: CGSize(width: frame.size.width - 60, height: 0), options: .usesLineFragmentOrigin, context: nil).width {
                width += marginLeft + marginRight + widthPart
            }
            
            if !journeySummaryPartView.circleLabel.isHidden {
                width += sizeDisruption
            }
        }
        
        return width
    }
}
