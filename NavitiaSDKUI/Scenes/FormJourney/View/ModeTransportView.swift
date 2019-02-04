//
//  ModeTransportView.swift
//  NavitiaSDKUI
//
//  Copyright © 2019 kisio. All rights reserved.
//

import UIKit

class ModeTransportView: UIView {

    @IBOutlet weak var stackView: UIStackView!
    // MARK: - UINib
    
    static var identifier: String {
        return String(describing: self)
    }
    
    class func instanceFromNib() -> ModeTransportView {
        return UINib(nibName: identifier, bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: nil, options: nil)[0] as! ModeTransportView
    }
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    var count = 7
    var elem = [UIButton]()
    
    // MARK: - Function
    
    private func setup() {
        
        let viewContainer = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 65))
        viewContainer.backgroundColor = .blue
        
        
        let size:CGFloat = 65
        let margeVertical:CGFloat = 10
        
        var padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 0)
        var position = CGPoint(x: 5, y: 0)
        
        
        var posX:CGFloat = -margeVertical
        var nb:CGFloat = 0
        
        while posX < viewContainer.frame.size.width {
            nb = nb + 1
            posX = posX + size + margeVertical
        }
        
        print(nb, posX)
        padding.right = (viewContainer.frame.size.width - posX) / (nb - 1)
        padding.right = padding.right + margeVertical
        
        
        for _ in 0...count - 1 {
            let innerView = UIButton(frame: CGRect(x: 0, y: 0, width: size, height: size))
            innerView.layer.borderWidth = 2
            innerView.layer.borderColor = Configuration.Color.main.cgColor
            innerView.layer.cornerRadius = 5
            innerView.backgroundColor = .white
            
            if position.x + CGFloat(innerView.frame.size.width) > viewContainer.frame.size.width {
                position.x = padding.left
                position.y = position.y + innerView.frame.size.height + padding.top
                viewContainer.frame.size.height = viewContainer.frame.size.height + innerView.frame.size.height + padding.top + padding.bottom
            }
            
            innerView.frame.origin = position
            position.x = position.x + CGFloat(innerView.frame.size.width) + padding.left + padding.right
            
            elem.append(innerView)
            viewContainer.addSubview(innerView)
        }
        
        stackView.addArrangedSubview(viewContainer)
    }
}
