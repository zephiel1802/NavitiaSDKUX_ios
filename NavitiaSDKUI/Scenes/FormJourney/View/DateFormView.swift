//
//  DateFormView.swift
//  NavitiaSDKUI
//
//  Copyright © 2019 kisio. All rights reserved.
//

import UIKit

protocol DateFormViewDelegate: class {
    
    func datePicker()
}

class DateFormView: UIView {
    
    enum DatetimeRepresents: String {
        case arrival = "arrival"
        case departure = "departure"
    }
    
    @IBOutlet weak var departureArrivalSegmentedControl: UISegmentedControl!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var arrowIconImageVIew: UIImageView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var dateTextField: UITextField!
    
    private var datePicker: UIDatePicker?
    private var contraintHegiht: NSLayoutConstraint?
    private var backback: UIView?
    internal weak var delegate: DateFormViewDelegate?
    internal var dateTimeRepresentsSegmentedControl: String? {
        get {
            return departureArrivalSegmentedControl.selectedSegmentIndex == 0 ? DatetimeRepresents.departure.rawValue : DatetimeRepresents.arrival.rawValue
        }
        set {
            guard let newValue = newValue,
                let datetimeRepresents = DatetimeRepresents(rawValue: newValue) else {
                return
            }
            
            departureArrivalSegmentedControl.selectedSegmentIndex = datetimeRepresents == .departure ? 0 : 1
        }
    }
    internal var date: Date? {
        get {
            return datePicker?.date
        }
        set {
            guard let newValue = newValue,
                let datePicker = datePicker else {
                return
            }
            
            let dateFormmatter = DateFormatter()
            
            datePicker.date = newValue
            dateFormmatter.dateFormat = "EEEE d MMMM 'à' HH:mm"
            
            dateTextField.text = dateFormmatter.string(from: datePicker.date)
        }
    }
    internal var isInverted: Bool = false {
        didSet {
            departureArrivalSegmentedControl.tintColor = isInverted ? Configuration.Color.white : Configuration.Color.main
            departureArrivalSegmentedControl.backgroundColor = isInverted ? Configuration.Color.main : Configuration.Color.white
            iconImageView.tintColor = isInverted ? Configuration.Color.white : Configuration.Color.main
            arrowIconImageVIew.tintColor = isInverted ? Configuration.Color.white : Configuration.Color.black
            lineView.backgroundColor = isInverted ? Configuration.Color.white : Configuration.Color.black
            dateTextField.textColor = isInverted ? Configuration.Color.white : Configuration.Color.black
        }
    }
    
    // MARK: - UINib
    
    static var identifier: String {
        return String(describing: self)
    }
    
    class func instanceFromNib() -> DateFormView {
        return UINib(nibName: identifier, bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: nil, options: nil)[0] as! DateFormView
    }
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    // MARK: - Function
    
    private func setup() {
        initIconImageView()
        initArrowImageView()
        initSegmentedControl()
        initDatePicker()
        initToolbar()
        initConstraint()
    }
    
    private func initIconImageView() {
        iconImageView.image = UIImage(named: "calendar", in: NavitiaSDKUI.shared.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = Configuration.Color.main
    }
    
    private func initArrowImageView() {
        arrowIconImageVIew.image = UIImage(named: "arrow_down", in: NavitiaSDKUI.shared.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        arrowIconImageVIew.tintColor = Configuration.Color.black
    }
    
    private func initSegmentedControl() {
        departureArrivalSegmentedControl.tintColor = Configuration.Color.main
    }
    
    private func initDatePicker() {
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .dateAndTime
        datePicker?.addTarget(self, action: #selector(DateFormView.dateChanged(datePicker:)), for: .valueChanged)
        datePicker?.backgroundColor = Configuration.Color.white
        dateTextField.inputView = datePicker
    }
    
    private func initToolbar() {
        let toolbar = UIToolbar();
        let doneButton = UIBarButtonItem(title: "Now", style: UIBarButtonItem.Style.plain, target: self, action: #selector(DateFormView.nowDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(DateFormView.doneDatePicker))
        
        toolbar.sizeToFit()
        doneButton.tintColor = Configuration.Color.main
        cancelButton.tintColor = Configuration.Color.main
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

        dateTextField.inputAccessoryView = toolbar
    }
    
    private func initConstraint() {
        contraintHegiht = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.height, relatedBy: .equal,
                                             toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 93)
        contraintHegiht?.isActive = true
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        date = datePicker.date
    }
    
    @objc func nowDatePicker() {
        date = Date()
    }
    
    @objc func doneDatePicker() {
        endEditing(true)
    }
}
