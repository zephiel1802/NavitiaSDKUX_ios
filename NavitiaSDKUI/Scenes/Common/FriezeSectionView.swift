//
//  FriezeSectionView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class FriezeSectionView: UIView {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var transportLabel: UILabel!
    @IBOutlet weak var tagTransportView: UIView!
    @IBOutlet weak var tagTransportLabel: UILabel!
    @IBOutlet weak var disruptionLabel: UILabel!
    @IBOutlet weak var circleLabel: UILabel!
    
    var height: CGFloat = 27
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override public var intrinsicContentSize: CGSize {
//        return CGSize(width: width, height: 0.0)
//    }
    
    private func setup() {
        UINib(nibName: "JourneySummaryPartView", bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: self, options: nil)
        view.frame = self.bounds
        addSubview(view)
        setupDisruption()
        
        frame.size.height = height
        
        tagTransportView.isHidden = true
        tagTransportLabel.isHidden = true
    }
    
    private func setupDisruption() {
        circleLabel.attributedText = NSMutableAttributedString()
            .icon("circle-filled",
                  color: UIColor.white,
                  size: 15)
        circleLabel.isHidden = true
        disruptionLabel.isHidden = true
    }
    
    func displayDisruption(_ iconName: String?, color: String?) {
        guard let iconName = iconName else {
            disruptionLabel.isHidden = true
            circleLabel.isHidden = true
            
            return
        }
        
        disruptionLabel.attributedText = NSMutableAttributedString()
            .icon(iconName,
                  color: color?.toUIColor() ?? Configuration.Color.red,
                  size: 14)
        disruptionLabel.isHidden = false
        circleLabel.isHidden = false
    }
    
}

extension FriezeSectionView {
    
    var color: UIColor? {
        get {
            return tagTransportView.backgroundColor
        }
        set {
            tagTransportView.backgroundColor = newValue
        }
    }
    
    var name: String? {
        get {
            return tagTransportLabel.text
        }
        set {
            if let newValue = newValue {
                tagTransportView.isHidden = false
                tagTransportLabel.isHidden = false
                let tagBackgroundColor = tagTransportView.backgroundColor ?? .black
                tagTransportLabel.attributedText = NSMutableAttributedString()
                    .bold(newValue, color: tagBackgroundColor.contrastColor(), size: 9)
            } else {
                tagTransportView.isHidden = true
                tagTransportLabel.isHidden = true
            }
        }
    }
    
    var icon: String? {
        get {
            return transportLabel.text
        }
        set {
            if let newValue = newValue {
                transportLabel.attributedText = NSMutableAttributedString()
                    .icon(newValue, size: 20)
            }
        }
    }
    
    func witdhJourney() -> CGFloat {
        let marginLeft: CGFloat = 4
        let marginRight: CGFloat = 3
        let sizeDisruption: CGFloat = 8
        var width: CGFloat = 25
        
        if !tagTransportView.isHidden {
            if let widthPart = tagTransportLabel.attributedText?.boundingRect(with: CGSize(width: frame.size.width - 60, height: 0), options: .usesLineFragmentOrigin, context: nil).width {
                width += marginLeft + marginRight + widthPart
            }
            
            if !circleLabel.isHidden {
                width += sizeDisruption
            }
        }
        
        return width
    }
    
}

