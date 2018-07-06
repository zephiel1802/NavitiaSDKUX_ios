//
//  MessageCVView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

open class MessageCVView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
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
        UINib(nibName: "MessageCVView", bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: self, options: nil)
        view.frame = self.bounds
        addSubview(view)
        
        setIcon()
    }
    
    public func setIcon(_ str: String = "warning") {
        logoLabel.attributedText = NSMutableAttributedString()
            .icon(str, color: Configuration.Color.lightGray, size: 80)
    }
    
    public func setTitle(_ str: String) {
        titleLabel.attributedText = NSMutableAttributedString()
            .semiBold(str, color: Configuration.Color.gray, size: 17)
    }
    
    public func setDescription(_ str: String) {
        descriptionLabel.attributedText = NSMutableAttributedString()
            .semiBold(str, color: Configuration.Color.gray, size: 12)
    }
    
}
