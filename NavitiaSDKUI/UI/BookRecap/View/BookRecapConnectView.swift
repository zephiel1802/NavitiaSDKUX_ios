//
//  BookRecapConnectView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

protocol BookRecapConnectViewDelegate {
    
    func onConnectionPressedButton(_ bookRecapConnectView: BookRecapConnectView)
    
}

open class BookRecapConnectView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var descriptionButton: UILabel!
    @IBOutlet weak var connectButton: UIButton!
    
    var delegate: BookRecapConnectViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        _setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open var frame: CGRect {
        willSet {
            if let _view = view {
                _view.frame.size = newValue.size
            }
        }
    }
    
    private func _setup() {
        UINib(nibName: "BookRecapConnectView", bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: self, options: nil)
        view.frame = self.bounds
        addSubview(view)
        
        descriptionButton.attributedText = NSMutableAttributedString().bold("save_time_when_buying_tickets".localized(withComment: "Save time when buying tickets", bundle: NavitiaSDKUI.shared.bundle), color: Configuration.Color.darkGray, size: 11)
        connectButton.backgroundColor = UIColor.clear
        connectButton.layer.borderWidth = 1
        connectButton.layer.borderColor = Configuration.Color.main.cgColor
        connectButton.setAttributedTitle(NSMutableAttributedString()
            .icon("user", color: Configuration.Color.main, size: 17)
            .bold(String(format: "   %@", "create_my_account".localized(withComment: "Create my account", bundle: NavitiaSDKUI.shared.bundle)), color: Configuration.Color.main, size: 12),
                                        for: .normal)
    }
    
    @IBAction func onConnectionPressedButton(_ sender: Any) {
        delegate?.onConnectionPressedButton(self)
    }
    
}
