//
//  BookPaymentProfilView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

open class BookPaymentProfilView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var iconProfilLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        _setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        _setup()
    }
    
    override open var frame: CGRect {
        willSet {
            if let _view = view {
                _view.frame.size = newValue.size
            }
        }
    }
    
    private func _setup() {
        UINib(nibName: "BookPaymentProfilView", bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: self, options: nil)
        view.frame = self.bounds
        addSubview(view)
        
        _setupIcon()
    }
    
    private func _setupIcon() {
        iconProfilLabel.attributedText = NSMutableAttributedString()
            .icon("user", color: Configuration.Color.main, size: 35)
    }
    
}

extension BookPaymentProfilView {
    
    var name: String? {
        get {
            return nameLabel.text
        }
        set {
            if let newValue = newValue {
                nameLabel.attributedText = NSMutableAttributedString()
                    .bold(newValue,
                          color: Configuration.Color.main,
                          size: 14)
            }
        }
    }
    
}

