//
//  BreadcrumbView.swift
//  
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

open class BreadcrumbView: UIView {
    
    enum State {
        case shop
        case payment
        case tickets
    }

    @IBOutlet var _view: UIView!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var firstIconLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondIconLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdIconLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var firstLineView: UIView!
    @IBOutlet weak var secondLineView: UIView!
    
    private var _activeFirstIcon: Bool = false {
        didSet {
            if _activeFirstIcon {
                firstIconLabel.textColor = Configuration.Color.white.withAlphaComponent(1)
                firstLabel.textColor = Configuration.Color.white.withAlphaComponent(1)
                _activeSecondIcon = false
                _activeThirdIcon = false
            } else {
                firstIconLabel.textColor = Configuration.Color.white.withAlphaComponent(0.5)
                firstLabel.textColor = Configuration.Color.white.withAlphaComponent(0.5)
                _activeSecondIcon = false
                _activeThirdIcon = false
            }
        }
    }
    private var _activeSecondIcon: Bool = false {
        didSet {
            if _activeSecondIcon {
                _activeFirstIcon = true
                secondIconLabel.textColor = Configuration.Color.white.withAlphaComponent(1)
                secondLabel.textColor = Configuration.Color.white.withAlphaComponent(1)
                firstLineView.backgroundColor = Configuration.Color.white.withAlphaComponent(1)
                _activeThirdIcon = false
            } else {
                secondIconLabel.textColor = Configuration.Color.white.withAlphaComponent(0.5)
                secondLabel.textColor = Configuration.Color.white.withAlphaComponent(0.5)
                firstLineView.backgroundColor = Configuration.Color.white.withAlphaComponent(0.5)
                _activeThirdIcon = false
            }
        }
    }
    
    private var _activeThirdIcon: Bool = false {
        didSet {
            if _activeThirdIcon {
                _activeFirstIcon = true
                _activeSecondIcon = true
                thirdIconLabel.textColor = Configuration.Color.white.withAlphaComponent(1)
                thirdLabel.textColor = Configuration.Color.white.withAlphaComponent(1)
                secondLineView.backgroundColor = Configuration.Color.white.withAlphaComponent(1)
            } else {
                thirdIconLabel.textColor = Configuration.Color.white.withAlphaComponent(0.5)
                thirdLabel.textColor = Configuration.Color.white.withAlphaComponent(0.5)
                secondLineView.backgroundColor = Configuration.Color.white.withAlphaComponent(0.5)
            }
        }
    }
    
    var delegate: BookShopViewControllerDelegate?
    var stateBreadcrumb: State? {
        didSet {
            if let stateBreadcrumb = stateBreadcrumb {
                switch stateBreadcrumb {
                    case .shop:
                        _activeFirstIcon = true
                    case .payment:
                        _activeSecondIcon = true
                    case .tickets:
                        _activeThirdIcon = true
                }
            }
        }
    }
    var isHiddenReturnButton: Bool {
        get {
            return self.returnButton.isHidden
        }
        set {
            self.returnButton.isHidden = newValue
        }
    }
    
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
            if let _view = _view {
                _view.frame.size = newValue.size
            }
        }
    }
    
    override open func layoutSubviews() {}
    
    private func _setup() {
        UINib(nibName: "BreadcrumbView", bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: self, options: nil)
        _view.frame = self.bounds
        _view.backgroundColor = Configuration.Color.main
        addSubview(_view)
        
//        returnButton.setAttributedTitle(NSMutableAttributedString().icon("arrow-direction-left", color: Configuration.Color.white, size: 20), for: .normal)
        
//        returnButton.setImage(UIImage(named: "UINavigationBarBackIndicatorDefault")?.withRenderingMode(.alwaysTemplate), for: .normal)
//        returnButton.tintColor = UIColor.white
        firstIconLabel.attributedText = NSMutableAttributedString().icon("tickets",
                                                                         color: Configuration.Color.white,
                                                                         size: 22)
        firstLabel.attributedText = NSMutableAttributedString().bold("shop".localized(withComment: "SHOP", bundle: NavitiaSDKUI.shared.bundle).uppercased(),
                                                                     color: Configuration.Color.white,
                                                                     size: 9)
        secondIconLabel.attributedText = NSMutableAttributedString().icon("basket",
                                                                          color: Configuration.Color.white,
                                                                          size: 22)
        secondLabel.attributedText = NSMutableAttributedString().bold("payment".localized(withComment: "PAYMENT", bundle: NavitiaSDKUI.shared.bundle).uppercased(),
                                                                      color: Configuration.Color.white,
                                                                      size: 9)
        thirdIconLabel.attributedText = NSMutableAttributedString().icon("ticket",
                                                                         color: Configuration.Color.white,
                                                                         size: 22)
        thirdLabel.attributedText = NSMutableAttributedString().bold("tickets".localized(withComment: "TICKETS",bundle: NavitiaSDKUI.shared.bundle).uppercased(),
                                                                     color: Configuration.Color.white,
                                                                     size: 9)
    }
    
    @IBAction func onDismissButtonClicked(_ sender: Any) {
        delegate?.onDismissBookShopViewController()
    }
    
}
