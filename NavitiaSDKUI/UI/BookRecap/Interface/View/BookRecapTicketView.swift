//
//  BookRecapTicketView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

protocol BookRecapTicketViewDelegate {
    
    func onDisplayTicketsPressedButton(_ bookRecapTicketView: BookRecapTicketView)
    
}

open class BookRecapTicketView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var ticketButton: UIButton!
    
    var delegate: BookRecapTicketViewDelegate?
    
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
        UINib(nibName: "BookRecapTicketView", bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: self, options: nil)
        view.frame = self.bounds
        addSubview(view)
        
        ticketButton.backgroundColor = Configuration.Color.main
        ticketButton.setAttributedTitle(NSMutableAttributedString().bold("Voir mes titres", color: Configuration.Color.white, size: 12),
                                        for: .normal)
    }
    
    @IBAction func onDisplayTicketsPressedButton(_ sender: Any) {
        delegate?.onDisplayTicketsPressedButton(self)
    }
    
}
