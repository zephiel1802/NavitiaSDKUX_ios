//
//  PlacesHeaderView.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 30/01/2019.
//

import UIKit

class PlacesHeaderView: UIView {
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    internal var title: String = "" {
        didSet {
            titleLabel.attributedText = NSMutableAttributedString().bold(title, color: Configuration.Color.main, size: 11)
        }
    }
    
    // MARK: - UINib
    
    static var identifier: String {
        return String(describing: self)
    }
    
    class func instanceFromNib() -> PlacesHeaderView {
        return UINib(nibName: identifier, bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: nil, options: nil)[0] as! PlacesHeaderView
    }
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    // MARK: - Function
    
    private func setup() {
        //backgroundColor = UIColor.blue
    }
}
