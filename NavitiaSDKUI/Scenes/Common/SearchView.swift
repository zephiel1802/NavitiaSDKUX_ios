//
//  SearchView.swift
//  NavitiaSDKUI
//
//  Copyright © 2019 kisio. All rights reserved.
//

import UIKit

@objc protocol SearchViewDelegate: class {
    
    func switchDepartureArrivalCoordinates()
    @objc optional func togglePreferences()
    @objc optional func singleSearchFieldClicked(query: String?)
    @objc optional func fromFieldClicked(query: String?)
    @objc optional func toFieldClicked(query: String?)
    @objc optional func singleSearchFieldChange(query: String?)
    @objc optional func fromFieldDidChange(query: String?)
    @objc optional func toFieldDidChange(query: String?)
    @objc optional func singleSearchFieldClearButtonClicked()
    @objc optional func fromFieldClearButtonClicked()
    @objc optional func toFieldClearButtonClicked()
}

class SearchView: UIView, UITextFieldDelegate {
    
    // MARK: IBOutlet
    @IBOutlet weak var toClearButton: UIButton!
    @IBOutlet weak var fromClearButton: UIButton!
    @IBOutlet weak var searchFieldsContainer: UIView!
    @IBOutlet weak var singleSearchFieldsContainer: UIView!
    @IBOutlet weak var singleSearchView: UIView!
    @IBOutlet weak var singleSearchTextField: UITextField!
    @IBOutlet weak var singleSearchPinImageView: UIImageView!
    @IBOutlet weak var singleSearchClearButton: UIButton!
    @IBOutlet weak var fromView: UIView!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var originPinImageView: UIImageView!
    @IBOutlet weak var toView: UIView!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var destinationPinImageView: UIImageView!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var switchDepartureArrivalImageView: UIImageView!
    @IBOutlet weak var switchDepartureArrivalButton: UIButton!
    @IBOutlet weak var separatorTopContraint: NSLayoutConstraint!
    @IBOutlet weak var separatorBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var datePreferenceView: UIView!
    @IBOutlet weak var dateIconImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateArrowIconImageView: UIImageView!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var preferencesIconImageView: UIImageView!
    @IBOutlet weak var preferencesLabel: UILabel!
    @IBOutlet weak var preferencesArrowIconImageView: UIImageView!
    @IBOutlet weak var preferenceButton: UIButton!
    @IBOutlet weak var switchButtonWidthConstraint: NSLayoutConstraint!
    
    // MARK: var
    var dateFormView: DateFormView!
    var searchButtonView: SearchButtonView!
    var fromTextFieldClear = false
    var toTextFieldClear = false
    var isClearButtonAccessible = true
    var switchDepartureArrivalButtonWidth: CGFloat = 0
    
    internal var lockSwitch = false
    internal var isPreferencesShown = false
    internal var isDateShown = false
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
            managePreferencesButtonVisibility(lock)
        }
    }
    internal var singleFieldConfiguration: Bool = false {
        didSet {
            switchIsHidden = true
            searchFieldsContainer.isHidden = singleFieldConfiguration
            singleSearchFieldsContainer.isHidden = !singleFieldConfiguration
            separatorView.isHidden = singleFieldConfiguration
        }
    }
    
    internal var singleFieldCustomPlaceholder: String? {
        didSet {
            guard let singleFieldPlaceholder = singleFieldCustomPlaceholder else {
                return
            }
            
           singleSearchTextField.placeholder = singleFieldPlaceholder
        }
    }
    internal var singleFieldCustomIcon: UIImage? {
        didSet {
            guard let singleFieldCustomIcon = singleFieldCustomIcon else {
                return
            }
            
            singleSearchPinImageView.image = singleFieldCustomIcon
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
        setupDateFormView()
        setupSearchButtonView()
        setPreferencesButton()
        setDateButton()
        setupClearButtons()
    }
    
    private func managePreferencesButtonVisibility(_ isHidden: Bool) {
        preferencesIconImageView.isHidden = isHidden
        preferencesLabel.isHidden = isHidden
        preferencesArrowIconImageView.isHidden = isHidden
        preferenceButton.isHidden = isHidden
    }
    
    private func setupClearButtons() {
        fromClearButton.isHidden = true
        fromClearButton.accessibilityLabel = "clear_departure".localized()
        toClearButton.isHidden = true
        toClearButton.accessibilityLabel = "clear_arrival".localized()
    }
    
    private func setupPin() {
        originPinImageView.image = "journey_departure".getIcon(renderingMode: .alwaysOriginal, customizable: true)
        originPinImageView.tintColor = Configuration.Color.origin
        
        destinationPinImageView.image = "journey_arrival".getIcon(renderingMode: .alwaysOriginal, customizable: true)
        destinationPinImageView.tintColor = Configuration.Color.destination
    }
    
    private func setupSwitchButton() {
        switchDepartureArrivalButton.setImage("switch".getIcon(customizable: true), for: .normal)
        switchDepartureArrivalButton.tintColor = Configuration.Color.main
        switchDepartureArrivalButton.accessibilityLabel = "reverse_departure_and_arrival".localized()
        switchDepartureArrivalButtonWidth = switchDepartureArrivalButton.frame.width
    }
    
    private func setupTextField() {
        fromTextField.isAccessibilityElement = true
        fromTextField.placeholder = "place_of_departure".localized()
        toTextField.isAccessibilityElement = true
        toTextField.placeholder = "place_of_arrival".localized()
        singleSearchTextField.isAccessibilityElement = true
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
        
        dateIconImageView.image = "calendar".getIcon()
        dateIconImageView.tintColor = Configuration.Color.main.contrastColor()
        dateLabel.text = dateTime
        dateLabel.textColor = Configuration.Color.main.contrastColor()
        
        if NavitiaSDKUI.shared.advancedSearchMode {
            dateArrowIconImageView.image = isDateShown ? "arrow_up".getIcon() : "arrow_down".getIcon()
            dateArrowIconImageView.tintColor = Configuration.Color.main.contrastColor()
        } else {
            dateArrowIconImageView.isHidden = true
        }
    }
    
    internal func setPreferencesButton() {
        isPreferencesShown = !isPreferencesShown
        preferencesIconImageView.image = "preferences".getIcon()
        preferencesIconImageView.tintColor = Configuration.Color.main.contrastColor()
        preferencesLabel.text = "preferences".localized()
        preferencesLabel.textColor = Configuration.Color.main.contrastColor()
        preferencesArrowIconImageView.image = isPreferencesShown ? "arrow_up".getIcon() : "arrow_down".getIcon()
        preferencesArrowIconImageView.tintColor = Configuration.Color.main.contrastColor()
    }
    
    func unstickTextFields(superview: UIView) {
        UIView.animate(withDuration: 0.15, animations: {
            self.separatorView.isHidden = true
            self.separatorTopContraint.constant = 3
            self.separatorBottomContraint.constant = 3
            superview.layoutIfNeeded()
        })
    }
    
    func stickTextFields(superview: UIView) {
        UIView.animate(withDuration: 0.15, animations: {
            self.separatorTopContraint.constant = 0
            self.separatorBottomContraint.constant = 0
            superview.layoutIfNeeded()
        }) { (_) in
            self.separatorView.isHidden = false
        }
    }
    
    internal func focusField(_ value: SearchFieldType? = .from) {
        switch value {
        case .from?:
            fromTextField.becomeFirstResponder()
            fromView.backgroundColor = Configuration.Color.white.withAlphaComponent(0.9)
        case .to?:
            toTextField.becomeFirstResponder()
            toView.backgroundColor = Configuration.Color.white.withAlphaComponent(0.9)
        case .single?:
            singleSearchTextField.becomeFirstResponder()
            singleSearchView.backgroundColor = Configuration.Color.white.withAlphaComponent(0.9)
        case nil:
            fromView.backgroundColor = Configuration.Color.white
            toView.backgroundColor = Configuration.Color.white
            singleSearchView.backgroundColor = Configuration.Color.white
            fromTextField.resignFirstResponder()
            toTextField.resignFirstResponder()
            singleSearchTextField.resignFirstResponder()
        }
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
            delegate?.togglePreferences?()
        } else {
            if self.isDateShown {
                hideDate()
            }
            delegate?.togglePreferences?()
        }
        setPreferencesButton()
    }
    
    @IBAction func toggleDate(_ sender: Any) {
        if isDateShown {
            hideDate()
        } else {
            if self.isPreferencesShown {
                delegate?.togglePreferences?()
                setPreferencesButton()
            }
            showDate()
        }
    }
    
    @IBAction func fromClearButtonClicked(_ sender: Any) {
        fromTextField.text!.removeAll()
        fromTextField.becomeFirstResponder()
        delegate?.fromFieldClearButtonClicked?()
    }
    
    @IBAction func toClearButtonClicked(_ sender: Any) {
        toTextField.text!.removeAll()
        toTextField.becomeFirstResponder()
        delegate?.toFieldClearButtonClicked?()
    }
    
    @IBAction func singleSearchClearButtonClicked(_ sender: Any) {
        singleSearchTextField.text!.removeAll()
        singleSearchTextField.becomeFirstResponder()
        delegate?.singleSearchFieldClearButtonClicked?()
    }

    // MARK: Textfield delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == fromTextField {
            delegate?.fromFieldClicked?(query: textField.text)
            if let text = textField.text, !text.isEmpty, isClearButtonAccessible {
                fromClearButton.isHidden = false
            } else {
                fromClearButton.isHidden = true
            }
        } else if textField == toTextField {
            delegate?.toFieldClicked?(query: textField.text)
            if let text = textField.text, !text.isEmpty, isClearButtonAccessible {
                toClearButton.isHidden = false
            } else {
                toClearButton.isHidden = true
            }
        } else if textField == singleSearchTextField {
            delegate?.singleSearchFieldClicked?(query: textField.text)
            if let text = textField.text, !text.isEmpty, isClearButtonAccessible {
                singleSearchClearButton.isHidden = false
            } else {
                singleSearchClearButton.isHidden = true
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            
            if textField == fromTextField {
                delegate?.fromFieldDidChange?(query: updatedText)
                if !updatedText.isEmpty && isClearButtonAccessible {
                    fromClearButton.isHidden = false
                } else {
                    fromClearButton.isHidden = true
                }
            } else if textField == toTextField {
                delegate?.toFieldDidChange?(query: updatedText)
                if !updatedText.isEmpty && isClearButtonAccessible {
                    toClearButton.isHidden = false
                } else {
                    toClearButton.isHidden = true
                }
            } else if textField == singleSearchTextField {
                delegate?.singleSearchFieldChange?(query: updatedText)
                if !updatedText.isEmpty && isClearButtonAccessible {
                    singleSearchClearButton.isHidden = false
                } else {
                    singleSearchClearButton.isHidden = true
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
        singleSearchClearButton.isHidden = true
    }    
}
