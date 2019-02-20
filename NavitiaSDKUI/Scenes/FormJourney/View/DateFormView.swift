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
    
    @IBOutlet weak var departureArrivalSegmentedControl: UISegmentedControl!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var arrowIconImageVIew: UIImageView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var dateTextField: UITextField!
    
    private var datePicker: UIDatePicker?
    private var contraintHegiht: NSLayoutConstraint?
    
    internal var date: Date? {
        didSet {
            guard let date = date else {
                return
            }
            
            datePicker?.date = date
        }
    }
    
    internal var isInverted: Bool = false {
        didSet {
            if isInverted {
                departureArrivalSegmentedControl.tintColor = Configuration.Color.white
                departureArrivalSegmentedControl.backgroundColor = Configuration.Color.main
                
                iconImageView.tintColor = Configuration.Color.white
                arrowIconImageVIew.tintColor = Configuration.Color.white
                lineView.backgroundColor = Configuration.Color.white
                
                dateTextField.textColor = Configuration.Color.white

            } else {
                departureArrivalSegmentedControl.tintColor = Configuration.Color.main
                departureArrivalSegmentedControl.backgroundColor = Configuration.Color.white
                
                iconImageView.tintColor = Configuration.Color.main
                arrowIconImageVIew.tintColor = Configuration.Color.black
                lineView.backgroundColor = Configuration.Color.black

                dateTextField.textColor = Configuration.Color.black
            }
        }
    }
    weak var delegate: DateFormViewDelegate?
    
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
        iconImageView.image = UIImage(named: "calendar", in: NavitiaSDKUI.shared.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = Configuration.Color.main
        
        arrowIconImageVIew.image = UIImage(named: "arrow_down", in: NavitiaSDKUI.shared.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        arrowIconImageVIew.tintColor = Configuration.Color.black
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .dateAndTime
        datePicker?.addTarget(self, action: #selector(DateFormView.dateChanged(datePicker:)), for: .valueChanged)
        
        dateTextField.inputView = datePicker
        departureArrivalSegmentedControl.tintColor = Configuration.Color.main
        
        contraintHegiht = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.height, relatedBy: .equal,
                                             toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 93)
        contraintHegiht?.isActive = true
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormmatter = DateFormatter()
        dateFormmatter.dateFormat = "EEEE d MMMM 'à' HH:mm"
        
        date = datePicker.date
        dateTextField.text = dateFormmatter.string(from: datePicker.date)
    }
}
