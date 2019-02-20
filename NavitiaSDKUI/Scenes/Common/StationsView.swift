//
//  StationsView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class StationsView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var stationView: UIView!
    @IBOutlet weak var stationLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var frame: CGRect {
        willSet {
            if let view = view {
                view.frame.size = newValue.size
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func setup() {
        UINib(nibName: "StationsView", bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: self, options: nil)
        view.frame = self.bounds
        addSubview(view)
    }
}

extension StationsView {
    
    var stationColor: UIColor? {
        get {
            return stationView.backgroundColor
        }
        set {
            stationView.backgroundColor = newValue
        }
    }
    
    var stationName: String? {
        get {
            return stationLabel.text
        }
        set {
            if let newValue = newValue {
                stationLabel.attributedText = NSMutableAttributedString()
                    .bold(newValue, size: 12)
            }
        }
    }
}
