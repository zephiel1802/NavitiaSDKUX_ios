//
//  FriezeSectionView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class FriezeSectionView: UIView {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var separatorImage: UIImageView!
    @IBOutlet var separatorTransportConstraint: NSLayoutConstraint!
    @IBOutlet weak var modeIconImageView: UIImageView!
    @IBOutlet weak var tagTransportView: UIView!
    @IBOutlet weak var tagTransportLabel: UILabel!
    @IBOutlet weak var disruptionImage: UIImageView!
    
    var height: CGFloat = 27
    
    var separator: Bool = true {
        didSet {
            separatorImage.isHidden = !separator
            separatorTransportConstraint.isActive = separator
            updateWidth()
        }
    }
    var borderColor: UIColor? {
        didSet {
            guard let color = borderColor?.cgColor else {
                tagTransportView.layer.borderWidth = 0
                
                return
            }
            
            tagTransportView.layer.borderWidth = 1
            tagTransportView.layer.borderColor = color
        }
    }
    var hasBadge: Bool = false {
        didSet {
            setupDisruption()
        }
    }
    var icon: String? {
        didSet {
            if let icon = self.icon {
                modeIconImageView.image = icon.getIcon(prefix: "journey_mode_", renderingMode: .alwaysOriginal, customizable: true)
                updateWidth()
            }
        }
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        UINib(nibName: FriezeSectionView.identifier, bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: self, options: nil)
        view.frame = self.bounds
        addSubview(view)
        frame.size.height = height
        
        setupDisruption()
        setupTag()
        
        updateWidth()
    }
    
    private func setupTag() {
        tagTransportView.isHidden = true
        tagTransportLabel.isHidden = true
    }
    
    private func setupDisruption() {
        disruptionImage.isHidden = !hasBadge
        updateWidth()
    }
    
    func displayDisruption(_ iconName: String?, color: String?) {
        if let name = hasBadge ? "nonblocking" : iconName,
        let image = Disruption().levelImage(name: name) {
            disruptionImage.isHidden = false
            disruptionImage.image = image
            updateWidth()
        } else {
            disruptionImage.isHidden = true
        }
    }
}

extension FriezeSectionView {
    
    var color: UIColor? {
        get {
            return tagTransportView.backgroundColor
        }
        set {
            tagTransportView.backgroundColor = newValue
            updateWidth()
        }
    }
    
    var textColor: UIColor? {
        get {
            return tagTransportLabel.textColor
        }
        set {
            tagTransportLabel.textColor = newValue
        }
    }
    
    var name: String? {
        get {
            return tagTransportLabel.text
        }
        set {
            if let newValue = newValue {
                let tagBackgroundColor = tagTransportView.backgroundColor ?? Configuration.Color.white
                let tagTextColor = tagTransportLabel.textColor ?? tagBackgroundColor.contrastColor()

                tagTransportView.isHidden = false
                tagTransportLabel.isHidden = false
                tagTransportLabel.attributedText = NSMutableAttributedString()
                    .bold(newValue, color: tagTextColor, size: 9)
                updateWidth()
            } else {
                tagTransportView.isHidden = true
                tagTransportLabel.isHidden = true
                updateWidth()
            }
        }
    }
    
    func updateWidth() {
        let marginSeparator = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 2)
        let marginTransportTag = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        let paddingTransportTag = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        var width: CGFloat = 20
        
        if !separatorImage.isHidden {
            width = width + separatorImage.frame.size.width + marginSeparator.right
        }
        
        if !tagTransportView.isHidden {
            if let widthPart = tagTransportLabel.attributedText?.boundingRect(with: CGSize(width: 0, height: 0), options: .usesLineFragmentOrigin, context: nil).width {
                width = width + marginTransportTag.left + marginTransportTag.right + widthPart + paddingTransportTag.right
            }
        }
        
        frame.size.width = width
    }
}

