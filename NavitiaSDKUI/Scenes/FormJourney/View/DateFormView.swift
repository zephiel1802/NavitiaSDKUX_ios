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
    @IBOutlet weak var dateTextField: UITextField!
    private var datePicker: UIDatePicker?
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        frame.size.height = contentContainerView.frame.size.height
//        if let superview = superview as? StackScrollView {
//            superview.reloadStack()
//        }
    }
    
    // MARK: - Function
    
    private func setup() {
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .dateAndTime
        datePicker?.addTarget(self, action: #selector(DateFormView.dateChanged(datePicker:)), for: .valueChanged)
        
        dateTextField.inputView = datePicker
        departureArrivalSegmentedControl.tintColor = Configuration.Color.main
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormmatter = DateFormatter()
        dateFormmatter.dateFormat = "MM/dd/yyyy"
        
        dateTextField.text = dateFormmatter.string(from: datePicker.date)
    }
}
