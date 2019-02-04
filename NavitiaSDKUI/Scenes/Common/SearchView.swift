//
//  SearchView.swift
//  NavitiaSDKUI
//
//  Copyright © 2019 kisio. All rights reserved.
//

import UIKit

@objc protocol SearchViewDelegate: class {
    
    func switchDepartureArrivalCoordinates()
    @objc optional func fromFieldClicked(q: String?)
    @objc optional func toFieldClicked(q: String?)
    @objc optional func fromFieldDidChange(q: String?)
    @objc optional func toFieldDidChange(q: String?)
}

class SearchView: UIView {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var fromView: UIView!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var originPinImageView: UIImageView!
    @IBOutlet weak var toView: UIView!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var destinationPinImageView: UIImageView!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var dateTimeTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var dateTimeBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var switchContraint: NSLayoutConstraint!
    @IBOutlet weak var switchDepartureArrivalButton: UIButton!
    
    @IBOutlet weak var backgroundTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var separatorTopContraint: NSLayoutConstraint!
    
    
    internal weak var delegate: SearchViewDelegate?
    internal var lockSwitch = false
    internal var origin: String? {
        didSet {
            guard let origin = origin else {
                return
            }
            
            fromTextField.text = origin
            //fromTextField.attributedText = NSMutableAttributedString().bold(origin, color: Configuration.Color.headerTitle, size: 11)
        }
    }
    internal var destination: String? {
        didSet {
            guard let destination = destination else {
                return
            }
            
            toTextField.text = destination
            //toTextField.attributedText = NSMutableAttributedString().bold(destination, color: Configuration.Color.headerTitle, size: 11)
        }
    }
    internal var dateTime: String? {
        didSet {
            guard let dateTime = dateTime else {
                return
            }
            
            dateTimeLabel.attributedText = NSMutableAttributedString().bold(dateTime, color: Configuration.Color.white, size: 12)
        }
    }
    internal var dateTimeIsHidden: Bool = false {
        didSet {
            dateTimeLabel.isHidden = dateTimeIsHidden
            dateTimeTopConstraint.isActive = !dateTimeIsHidden
            dateTimeBottomConstraint.isActive = !dateTimeIsHidden
        }
    }
    
    internal var switchIsHidden: Bool = false {
        didSet {
            switchDepartureArrivalButton.isHidden = switchIsHidden
            switchContraint.isActive = !switchIsHidden
        }
    }
    
    func animatedd() {
        //self.backgroundTopConstraint.constant = 5
        self.separatorTopContraint.constant = 5
    }
    
    func animateddFalse() {
       // self.backgroundTopConstraint.constant = 10
        self.separatorTopContraint.constant = 0
    }
    
    // MARK: - UINib
    
    static var identifier: String {
        return String(describing: self)
    }
    
    class func instanceFromNib() -> SearchView {
        return UINib(nibName: identifier, bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: nil, options: nil)[0] as! SearchView
    }
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    override func awakeAfter(using aDecoder: NSCoder) -> Any? {
        guard subviews.isEmpty else {
            return self
        }
        
        let searchView = SearchView.instanceFromNib()
        
        searchView.translatesAutoresizingMaskIntoConstraints = false
        searchView.frame = self.bounds
        
        return searchView
    }
    
    // MARK: - Function
    
    private func setup() {
        backgroundColor = Configuration.Color.main
        
        setupPin()
        setupSwitchButton()
    }
    
    private func setupPin() {
        originPinImageView.image = UIImage(named: "origin-icon", in: NavitiaSDKUI.shared.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        originPinImageView.tintColor = Configuration.Color.origin
        
        destinationPinImageView.image = UIImage(named: "origin-icon", in: NavitiaSDKUI.shared.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        destinationPinImageView.tintColor = Configuration.Color.destination
    }
    
    private func setupSwitchButton() {
        switchDepartureArrivalButton.setImage(UIImage(named: "switch", in: NavitiaSDKUI.shared.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate), for: .normal)
        switchDepartureArrivalButton.tintColor = Configuration.Color.main
    }
    
    @IBAction func switchDepartureArrivalCoordinates(_ sender: UIButton) {
        if !lockSwitch {
            delegate?.switchDepartureArrivalCoordinates()
        }
    }
    
    private func switchDepartureArrivalAnimate(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            if  sender.transform == .identity {
                sender.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 0.999))
            } else {
                sender.transform = .identity
            }
        }, completion: nil)
    }
    
    internal func animate() {
        switchDepartureArrivalButton.isHidden = true
       // separatorView.isHidden = true
    }
    
    @IBAction func fromFieldClicked(_ sender: UITextField) {
        delegate?.fromFieldClicked?(q: sender.text)
    }
    
    @IBAction func toFieldClicked(_ sender: UITextField) {
        delegate?.toFieldClicked?(q: sender.text)
    }
    
    @IBAction func fromFieldDidChange(_ sender: UITextField) {
        delegate?.fromFieldDidChange?(q: sender.text)
    }
    
    @IBAction func toFieldDidChange(_ sender: UITextField) {
        delegate?.toFieldDidChange?(q: sender.text)
    }
}
