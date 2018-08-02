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
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var realTimeContainer: UIView!
    @IBOutlet weak var realTimeImage: UIImageView!
    @IBOutlet weak var realTimeLabel: UILabel!
    
    var _mode: ModeTransport?
    var type: Section.ModelType?
    
    var takeName: String = "" {
        didSet {
            _updateInformation()
        }
    }

    var origin: String = "" {
        didSet {
            _updateInformation()
        }
    }
    var address: String = "" {
        didSet {
            _updateInformation()
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
                setHeight()
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
        guard let informationLabel = informationLabel, let realTimeContainer = realTimeContainer else {
            return
        }
        
        let takeLabelSize = informationLabel.attributedText?.boundingRect(with: CGSize(width: frame.size.width - 60, height: 9990), options: .usesLineFragmentOrigin, context: nil)
       // frame.size.height = (takeLabelSize?.height)! + 20
        
        if realTimeContainer.isHidden {
            let takeLabelSize = informationLabel.attributedText?.boundingRect(with: CGSize(width: frame.size.width - 60, height: 9990), options: .usesLineFragmentOrigin, context: nil)
            frame.size.height = (takeLabelSize?.height)! + 20
        } else {
            let takeLabelSize = informationLabel.attributedText?.boundingRect(with: CGSize(width: frame.size.width - 60, height: 9990), options: .usesLineFragmentOrigin, context: nil)
            frame.size.height = (takeLabelSize?.height)! + realTimeContainer.frame.size.height + 30
        }
    }
    
    private func _updateInformation() {
        guard let type = type else {
            return
        }
        
        if type == Section.ModelType.bssRent {
            informationLabel.attributedText = NSMutableAttributedString()
                .normal(String(format: "take_a_bike_at".localized(bundle: NavitiaSDKUI.shared.bundle), takeName), size: 15)
                .normal(" ", size: 15)
                .bold(origin, size: 15)
                .normal("\n", size: 15)
                .bold(address, size: 13)
        } else if type == Section.ModelType.bssPutBack {
            informationLabel.attributedText = NSMutableAttributedString()
                .normal(String(format: "dock_bike_at".localized(bundle: NavitiaSDKUI.shared.bundle), takeName), size: 15)
                .normal(" ", size: 15)
                .bold(origin, size: 15)
                .normal("\n", size: 15)
                .bold(address, size: 13)
        }
        setHeight()
    }
    
    public func updateStands(stands: Stands?) {
        guard let type = type, let stands = stands else {
            return
        }
        
        realTimeContainer.isHidden = false
        
        realTimeImage.image = UIImage(named: "real_time", in: NavitiaSDKUI.shared.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        realTimeImage.tintColor = Configuration.Color.main
        
        if type == Section.ModelType.bssRent {
            realTimeLabel.attributedText = NSMutableAttributedString()
                .semiBold(String(format: "bss_bikes_available".localized(bundle: NavitiaSDKUI.shared.bundle), stands.availableBikes ?? ""),
                          color: Configuration.Color.main,
                          size: 13)
        } else if type == Section.ModelType.bssPutBack {
            realTimeLabel.attributedText = NSMutableAttributedString()
                .semiBold(String(format: "bss_spaces_available".localized(bundle: NavitiaSDKUI.shared.bundle), stands.availablePlaces ?? ""),
                          color: Configuration.Color.main,
                          size: 13)
        }
        setHeight()
        
    }

    public func animateRealTime(run: Bool = true) {
        if run {
            UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse], animations: {
                self.realTimeImage.alpha = 0
            }, completion: nil)
        } else {
            realTimeImage.layer.removeAllAnimations()
        }
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

            updateStands(stands: newValue?.stands)
        }
    }
    
}
