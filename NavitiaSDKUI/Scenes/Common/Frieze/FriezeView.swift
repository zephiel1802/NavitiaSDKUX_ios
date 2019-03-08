//
//  FriezeView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class FriezeView: UIView {

    enum Alignment {
        case left
        case center
        case right
    }

    private var friezeSectionsView = [FriezeSectionView]()

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    internal func addSection(friezeSections: [FriezePresenter.FriezeSection]) {
        releaseUnusedSectionView(sectionsCount: friezeSections.count)
        parseFriezeSectionView(friezeSections: friezeSections)
        updatePositionFriezeSectionView()
    }
    
    private func releaseUnusedSectionView(sectionsCount: Int) {
        if friezeSectionsView.count > sectionsCount {
            while friezeSectionsView.count > sectionsCount {
                friezeSectionsView[sectionsCount].removeFromSuperview()
                friezeSectionsView.remove(at: sectionsCount)
            }
        }
    }
    
    private func parseFriezeSectionView(friezeSections: [FriezePresenter.FriezeSection]) {
        for (index, section) in friezeSections.enumerated() {
            if index < friezeSectionsView.count {
                let friezeSectionView = friezeSectionsView[index]
                
                reuseFriezeSectionView(index: index, friezeSection: section, friezeSectionView: friezeSectionView)
            } else {
                let friezeSectionView = FriezeSectionView()
                
                reuseFriezeSectionView(index: index, friezeSection: section, friezeSectionView: friezeSectionView)
                friezeSectionsView.append(friezeSectionView)
                addSubview(friezeSectionView)
            }
        }
    }

    private func reuseFriezeSectionView(index: Int, friezeSection: FriezePresenter.FriezeSection, friezeSectionView: FriezeSectionView) {
        friezeSectionView.color = friezeSection.color
        friezeSectionView.textColor = friezeSection.textColor
        friezeSectionView.name = friezeSection.name
        friezeSectionView.icon = friezeSection.icon
        friezeSectionView.displayDisruption(friezeSection.disruptionIcon, color: friezeSection.disruptionColor)
        friezeSectionView.borderColor = friezeSection.color == Configuration.Color.white ? friezeSection.textColor : nil
        
        friezeSectionView.separator = index == 0 ? false : true
    }
    
    internal func updatePositionFriezeSectionView() {
        let padding = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        var position = CGPoint(x: 0, y: 0)

        for friezeSectionView in friezeSectionsView {
            if position.x + CGFloat(friezeSectionView.frame.size.width) > frame.size.width {
                position.x = 0
                position.y = position.y + friezeSectionView.frame.size.height + padding.top
                frame.size.height = frame.size.height + friezeSectionView.frame.size.height + padding.top
            }
            
            friezeSectionView.frame.origin = position
            position.x = position.x + CGFloat(friezeSectionView.frame.size.width) + padding.right
        }
    }
    
    func getCenter() {
        var indexFrieze = 0
        for (index, view) in friezeSectionsView.enumerated() {
            if view.frame.origin.x == 0 {
                if index - 1 > 0 {
                    let marge = frame.size.width - (friezeSectionsView[index - 1].frame.size.width + friezeSectionsView[index - 1].frame.origin.x)
                    while indexFrieze < index {
                        friezeSectionsView[indexFrieze].frame.origin.x = friezeSectionsView[indexFrieze].frame.origin.x + marge / 2
                        indexFrieze = indexFrieze + 1
                    }
                }
            }
            
            if index + 1 == friezeSectionsView.count {
                let marge = frame.size.width - (friezeSectionsView[index].frame.size.width + friezeSectionsView[index].frame.origin.x)
                while indexFrieze <= index {
                    friezeSectionsView[indexFrieze].frame.origin.x = friezeSectionsView[indexFrieze].frame.origin.x + marge / 2
                    indexFrieze = indexFrieze + 1
                }
            }
        }
    }
}
