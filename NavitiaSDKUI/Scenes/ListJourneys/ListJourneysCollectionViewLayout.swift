//
//  ListJourneysCollectionViewLayout.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

protocol ListJourneysCollectionViewLayoutDelegate: class {
    
    func collectionView(_ collectionView:UICollectionView, heightForCellAtIndexPath indexPath:IndexPath, width: CGFloat) -> CGFloat
}

class ListJourneysCollectionViewLayout: UICollectionViewLayout {
    
    weak var delegate: ListJourneysCollectionViewLayoutDelegate!
    
    private var numberOfColumns = 1
    private var cellPadding: CGFloat = 5
    private var cache = [UICollectionViewLayoutAttributes]()
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        
        let insets = collectionView.contentInset
        let content = collectionView.bounds.width - (insets.left + insets.right)
        
        if #available(iOS 11.0, *) {
            let safeAreaInsets = collectionView.safeAreaInsets
            return content - (safeAreaInsets.left + safeAreaInsets.right)
        }
        
        return content
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard cache.isEmpty == true, let collectionView = collectionView else {
            return
        }
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        
        contentHeight = 0
        
        for numberOfSection in 0 ..< collectionView.numberOfSections {
            for item in 0 ..< collectionView.numberOfItems(inSection: numberOfSection) {
                if item == 0 && numberOfSection == 1 {
                    let height = cellPadding * 2 + 30
                    let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                    let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                    
                    let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(item: 0, section: numberOfSection))
                    attributes.frame = insetFrame
                    cache.append(attributes)
                    
                    contentHeight = max(contentHeight, frame.maxY)
                    yOffset[column] = yOffset[column] + height
                    
                    column = column < (numberOfColumns - 1) ? (column + 1) : 0
                }
                
                let indexPath = IndexPath(item: item, section: numberOfSection)
                let contentCellHeight = delegate.collectionView(collectionView, heightForCellAtIndexPath: indexPath, width: columnWidth)
                
                let height = cellPadding * 2 + contentCellHeight
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = insetFrame
                cache.append(attributes)
                
                contentHeight = max(contentHeight, frame.maxY)
                yOffset[column] = yOffset[column] + height
                
                column = column < (numberOfColumns - 1) ? (column + 1) : 0
            }
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
    public override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        attributes.frame = CGRect(x: 0, y: 0, width: 0, height: 30)
        
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    private func updateFriezeSectionViewForVisibleCells() {
        guard let visibleCells = collectionView?.visibleCells else {
            return
        }
        
        for visibleCell in visibleCells {
            if let cell = visibleCell as? JourneySolutionCollectionViewCell {
                cell.friezeView.updatePositionFriezeSectionView()
            }
        }
    }
    
    internal func reloadLayout() {
        cache.removeAll(keepingCapacity: false)
        
        updateFriezeSectionViewForVisibleCells()
    }
}
