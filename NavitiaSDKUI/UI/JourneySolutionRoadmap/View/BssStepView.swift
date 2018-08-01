//
//  BssStepView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class BssStepView: UIView {
    
    @IBOutlet var _view: UIView!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var takeLabel: UILabel!
    
    var _mode: ModeTransport?
    var type: Section.ModelType?
    
    var takeName: String = "" {
        didSet {
            _updateTakeLabel()
        }
    }

    var origin: String = "" {
        didSet {
            _updateTakeLabel()
        }
    }
    var address: String = "" {
        didSet {
            _updateTakeLabel()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        _setup()
        addShadow(opacity: 0.28)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var frame: CGRect {
        didSet {
            if let _view = _view {
                _view.frame.size = frame.size
                
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        _setup()
    }
    
    private func _setup() {
        UINib(nibName: "BssStepView", bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: self, options: nil)
        _view.frame = self.bounds
        addSubview(_view)
    }
    
    func setHeight() {
        let takeLabelSize = takeLabel.attributedText?.boundingRect(with: CGSize(width: frame.size.width - 60, height: 9990), options: .usesLineFragmentOrigin, context: nil)
        frame.size.height = (takeLabelSize?.height)! + 20
    }
    
    private func _updateTakeLabel() {
        guard let type = type else {
            return
        }
        
        if type == Section.ModelType.bssRent {
            takeLabel.attributedText = NSMutableAttributedString()
                .normal(String(format: "take_a_bike_at".localized(bundle: NavitiaSDKUI.shared.bundle), takeName), size: 15)
                .normal(" ", size: 15)
                .bold(origin, size: 15)
                .normal("\n", size: 15)
                .bold(address, size: 13)
        } else if type == Section.ModelType.bssPutBack {
            takeLabel.attributedText = NSMutableAttributedString()
                .normal(String(format: "dock_bike_at".localized(bundle: NavitiaSDKUI.shared.bundle), takeName), size: 15)
                .normal(" ", size: 15)
                .bold(origin, size: 15)
                .normal("\n", size: 15)
                .bold(address, size: 13)
        }
        setHeight()
    }

}

extension BssStepView {
    
    var modeString: String? {
        get {
            return _mode?.rawValue
        }
        set {
            if let newValue = newValue {
                _mode = ModeTransport(rawValue: newValue)
                icon = newValue
            }
        }
    }
    
    var icon: String? {
        get {
            return iconLabel.text
        }
        set {
            if let newValue = newValue {
                iconLabel.attributedText = NSMutableAttributedString()
                    .icon(newValue, size: 20)
            }
        }
    }
    
    var poi: Poi? {
        get {
            return self.poi
        }
        set {
            takeName = newValue?.properties?["network"] ?? ""
            origin = newValue?.name ?? ""
            address = newValue?.address?.name ?? ""
     //       print(newValue?.name, newValue?.address?.name, newValue?.properties?["network"])
        }
    }
    
}
