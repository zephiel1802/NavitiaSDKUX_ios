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

class SearchView: UIView, UITextFieldDelegate {
    // MARK: enum
    enum Focus: String {
        case from = "from"
        case to = "to"
    }
    
    // MARK: IBOutlet
    @IBOutlet weak var toClearButton: UIButton!
    @IBOutlet weak var fromClearButton: UIButton!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var fromView: UIView!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var originPinImageView: UIImageView!
    @IBOutlet weak var toView: UIView!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var destinationPinImageView: UIImageView!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var switchDepartureArrivalButton: UIButton!
    @IBOutlet weak var separatorTopContraint: NSLayoutConstraint!
    @IBOutlet weak var separatorBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var datePreferenceView: UIView!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var preferenceButton: UIButton!
    @IBOutlet weak var switchButtonWidthConstraint: NSLayoutConstraint!
    
    // MARK: var
    var dateFormView: DateFormView!
    var transportModeView: TransportModeView!
    var searchButtonView: SearchButtonView!
    var fromTextFieldClear = false
    var toTextFieldClear = false
    var isClearButtonAccessible = true
    var switchDepartureArrivalButtonWidth: CGFloat = 0
    
    internal var lockSwitch = false
    internal var isPreferencesShown = false
    internal var isDateShown = false
    internal var focus: Focus?
    internal weak var delegate: SearchViewDelegate? {
        didSet {
            searchButtonView.delegate = delegate as? SearchButtonViewDelegate
        }
    }
    internal var origin: String? {
        didSet {
            guard let origin = origin else {
                return
            }
            
            fromTextField.text = origin
        }
    }
    internal var destination: String? {
        didSet {
            guard let destination = destination else {
                return
            }
            
            toTextField.text = destination
        }
    }
    internal var dateTime: String? {
        didSet {
            setDateButton()
        }
    }
    internal var detailsViewIsHidden: Bool = false {
        didSet {
            datePreferenceView.isHidden = detailsViewIsHidden
        }
    }
    internal var switchIsHidden: Bool = false {
        didSet {
            switchButtonWidthConstraint.constant = switchIsHidden ? 0 : switchDepartureArrivalButtonWidth
        }
    }
    internal var lock: Bool = false {
        didSet {
            fromTextField.isEnabled = !lock
            toTextField.isEnabled = !lock
            dateButton.isEnabled = !lock
            preferenceButton.isHidden = lock
        }
    }
    internal var singleFieldConfiguration: Bool = false {
        didSet {
            switchIsHidden = true
            toView.isHidden = singleFieldConfiguration
            fromTextField.placeholder = singleFieldConfiguration ? "Type an address" : "place_of_departure".localized()
        }
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
    
    // MARK: - Function (setup)
    
    private func setup() {
        backgroundColor = Configuration.Color.main
        
        setupPin()
        setupSwitchButton()
        setupTextField()
        setupTransportModeView()
        setupDateFormView()
        setupSearchButtonView()
        setPreferencesButton()
        setDateButton()
        setupClearButtons()
    }
    
    private func setupClearButtons() {
        fromClearButton.isHidden = true
        fromClearButton.accessibilityLabel = "clear_departure".localized()
        toClearButton.isHidden = true
        toClearButton.accessibilityLabel = "clear_arrival".localized()
    }
    
    private func setupPin() {
        if let image = Configuration.customIcons["origin"] {
            originPinImageView.image = image
        } else {
            originPinImageView.image = UIImage(named: "origin-icon", in: NavitiaSDKUI.shared.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        }
        originPinImageView.tintColor = Configuration.Color.origin
        
        if let image = Configuration.customIcons["destination"] {
            destinationPinImageView.image = image
        } else {
            destinationPinImageView.image = UIImage(named: "origin-icon", in: NavitiaSDKUI.shared.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        }
        destinationPinImageView.tintColor = Configuration.Color.destination
    }
    
    private func setupSwitchButton() {
        switchDepartureArrivalButton.setImage(UIImage(named: "switch",
                                                      in: NavitiaSDKUI.shared.bundle,
                                                      compatibleWith: nil)?.withRenderingMode(.alwaysTemplate),
                                              for: .normal)
        switchDepartureArrivalButton.tintColor = Configuration.Color.main
        switchDepartureArrivalButton.accessibilityLabel = "reverse_departure_and_arrival".localized()
        switchDepartureArrivalButtonWidth = switchDepartureArrivalButton.frame.width
    }
    
    private func setupTextField() {
        fromTextField.isAccessibilityElement = true
        fromTextField.placeholder = "place_of_departure".localized()
        toTextField.isAccessibilityElement = true
        toTextField.placeholder = "place_of_arrival".localized()
    }
    
    private func setupTransportModeView() {
        transportModeView = TransportModeView(frame: CGRect(x: 0, y: 0, width: stackView.frame.size.width, height: 0))
        stackView.addArrangedSubview(transportModeView)
        transportModeView.isHidden = true
    }
    
    private func setupDateFormView() {
        dateFormView = DateFormView.instanceFromNib()
        dateFormView.isInverted = true
        stackView.addArrangedSubview(dateFormView)
        dateFormView.isHidden = true
    }
    
    private func setupSearchButtonView() {
        searchButtonView = SearchButtonView.instanceFromNib()
        stackView.addArrangedSubview(searchButtonView)
        searchButtonView.isHidden = true
    }
    
    internal func setDateButton() {
        guard let dateTime = dateTime else {
            return
        }
        
        if NavitiaSDKUI.shared.formJourney {
            dateButton.setAttributedTitle(NSMutableAttributedString()
                .icon("calendar", color: Configuration.Color.white, size: 10)
                .medium(String(format: "  %@  ", dateTime), color: Configuration.Color.white, size: 11)
                .icon((isDateShown ? "arrow-details-up" : "arrow-details-down"), color: Configuration.Color.white, size: 10), for: .normal)
        } else {
            dateButton.setAttributedTitle(NSMutableAttributedString()
                .icon("calendar", color: Configuration.Color.white, size: 10)
                .medium(String(format: "  %@  ", dateTime), color: Configuration.Color.white, size: 10), for: .normal)
        }
    }
    
    internal func setPreferencesButton() {
        preferenceButton.setAttributedTitle(NSMutableAttributedString()
            .icon("option", color: Configuration.Color.white, size: 10)
            .medium(String(format: "  %@  ", "preferences".localized()), color: Configuration.Color.white, size: 11)
            .icon((isPreferencesShown ? "arrow-details-up" : "arrow-details-down"), color: Configuration.Color.white, size: 10), for: .normal)
    }
    
    // MARK: public func
    func unstickTextFields() {
        self.separatorTopContraint.constant = 3
        self.separatorBottomContraint.constant = 3
    }
    
    func stickTextFields() {
        self.separatorTopContraint.constant = 0
        self.separatorBottomContraint.constant = 0
    }
    
    internal func focusFromField(_ value: Bool = true) {
        if value {
            fromTextField.becomeFirstResponder()
            fromView.backgroundColor = Configuration.Color.white.withAlphaComponent(0.9)
        } else {
            fromView.backgroundColor = Configuration.Color.white
        }
    }
    
    internal func focusToField(_ value: Bool = true) {
        if value {
            toTextField.becomeFirstResponder()
            toView.backgroundColor = Configuration.Color.white.withAlphaComponent(0.9)
        } else {
            toView.backgroundColor = Configuration.Color.white
        }
    }
    
    internal func hidePreferences() {
        isPreferencesShown = false
        setPreferencesButton()
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.transportModeView.isHidden = true
            self.transportModeView.alpha = 0
            self.searchButtonView.isHidden = true
            self.searchButtonView.alpha = 0
        }, completion: nil)
    }
    
    internal func hideDate() {
        isDateShown = false
        setDateButton()
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.dateFormView.isHidden = true
            self.dateFormView.alpha = 0
            self.searchButtonView.isHidden = true
            self.searchButtonView.alpha = 0
        }, completion: nil)
    }
    
    internal func showPreferences() {
        isPreferencesShown = true
        setPreferencesButton()
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.transportModeView.isHidden = false
            self.transportModeView.alpha = 1
            self.searchButtonView.isHidden = false
            self.searchButtonView.alpha = 1
        }, completion: nil)
    }

    internal func showDate() {
        isDateShown = true
        setDateButton()
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.dateFormView.isHidden = false
            self.dateFormView.alpha = 1
            self.searchButtonView.isHidden = false
            self.searchButtonView.alpha = 1
        }, completion: nil)
    }
    
    internal func switchDepartureArrivalAnimate(_ sender: UIButton) {
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
    }
    
    // MARK: IBAction
    @IBAction func switchDepartureArrivalCoordinates(_ sender: UIButton) {
        if !lockSwitch {
            switchDepartureArrivalAnimate(sender)
            delegate?.switchDepartureArrivalCoordinates()
        }
    }
    
    @IBAction func togglePreferences(_ sender: Any) {
        if isPreferencesShown {
            hidePreferences()
        } else {
            if self.isDateShown {
                hideDate()
            }
            showPreferences()
        }
    }
    
    @IBAction func toggleDate(_ sender: Any) {
        if isDateShown {
            hideDate()
        } else {
            if self.isPreferencesShown {
                hidePreferences()
            }
            showDate()
        }
    }
    
    @IBAction func fromClearButtonClicked(_ sender: Any) {
        fromTextField.text!.removeAll()
        fromTextFieldClear = true
        fromClearButton.becomeFirstResponder()
    }
    
    @IBAction func toClearButtonClicked(_ sender: Any) {
        toTextField.text!.removeAll()
        toTextFieldClear = true
        toTextField.becomeFirstResponder()
    }

    // MARK: Textfield delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == fromTextField {
            if fromTextFieldClear {
                fromTextFieldClear = false
            } else {
                delegate?.fromFieldClicked?(q: textField.text)
            }
            if !(textField.text ?? "").isEmpty && isClearButtonAccessible {
                fromClearButton.isHidden = false
            } else {
                fromClearButton.isHidden = true
            }
        } else if textField == toTextField {
            if toTextFieldClear {
                toTextFieldClear = false
            } else {
                delegate?.toFieldClicked?(q: textField.text)
            }
            if !(textField.text ?? "").isEmpty && isClearButtonAccessible {
                toClearButton.isHidden = false
            } else {
                toClearButton.isHidden = true
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            
            if textField == fromTextField {
                delegate?.fromFieldDidChange?(q: updatedText)
                if !updatedText.isEmpty && isClearButtonAccessible {
                    fromClearButton.isHidden = false
                } else {
                    fromClearButton.isHidden = true
                }
            } else if textField == toTextField {
                delegate?.toFieldDidChange?(q: updatedText)
                if !updatedText.isEmpty && isClearButtonAccessible {
                    toClearButton.isHidden = false
                } else {
                    toClearButton.isHidden = true
                }
            } else {
                
                return false
            }
            
            return true
        }
        
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        endEditing(true)
        fromClearButton.isHidden = true
        toClearButton.isHidden = true
    }
    
}
