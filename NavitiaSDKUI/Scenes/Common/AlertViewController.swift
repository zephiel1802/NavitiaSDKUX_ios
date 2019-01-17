//
//  AlertViewController.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

protocol AlertViewControllerProtocol {
    
    func onNegativeButtonClicked(_ alertViewController: AlertViewController)
    func onPositiveButtonClicked(_ alertViewController: AlertViewController)
}

class AlertViewController: UIViewController, CheckboxDelegate {
    
    var stateKey: String = ""
    var alertMessage: String = ""
    var checkBoxText: String = ""
    var negativeButtonText: String = ""
    var positiveButtonText: String = ""
    var alertViewDelegate: AlertViewControllerProtocol?
    
    @IBOutlet weak var alertBackgroundView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var negativeButton: UIButton!
    @IBOutlet weak var positiveButton: UIButton!
    @IBOutlet weak var checkbox: Checkbox!
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var checkBoxMessageLabel: UILabel!
    @IBOutlet weak var checkBoxContentWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var checkBoxTextLeadingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.alertBackgroundView.backgroundColor = Configuration.Color.main.withAlphaComponent(0.7)
        self.headerView.backgroundColor = Configuration.Color.main
        
        self.checkbox.layer.borderWidth = 1
        self.checkbox.layer.borderColor = UIColor.gray.cgColor
        self.checkbox.layer.cornerRadius = 2
        self.checkbox.borderStyle = .square
        self.checkbox.checkmarkStyle = .tick
        self.checkbox.checkmarkColor = Configuration.Color.main
        self.checkbox.delegate = self
        
        self.message.text = self.alertMessage
        self.checkBoxMessageLabel.text = self.checkBoxText
        self.negativeButton.setTitle(self.negativeButtonText, for: UIControl.State.normal)
        self.positiveButton.setTitle(self.positiveButtonText, for: UIControl.State.normal)
        self.positiveButton.setTitleColor(Configuration.Color.main, for: UIControl.State.normal)
        
        checkboxButton.accessibilityLabel = checkBoxText
        
        let newCheckBoxTextSize = self.checkBoxMessageLabel.sizeThatFits(CGSize(width: self.checkBoxMessageLabel.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        self.checkBoxContentWidthConstraint.constant = self.checkBoxMessageLabel.frame.size.width + self.checkBoxTextLeadingConstraint.constant + newCheckBoxTextSize.width
    }
    
    @IBAction func negativeButtonClicked(_ sender: Any) {
        self.alertViewDelegate?.onNegativeButtonClicked(self)
    }
    
    @IBAction func positiveButtonClicked(_ sender: Any) {
        self.alertViewDelegate?.onPositiveButtonClicked(self)
    }
    
    @IBAction func switchCheckBoxState(_ sender: Any) {
        self.checkbox.isChecked = !self.checkbox.isChecked
    }
    
    @IBAction func dismissAlertController(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func checkboxStateDidChange(checkbox: Checkbox) {
        NavitiaSDKUserDefaultsManager.saveUserDefault(key: self.stateKey, value: checkbox.isChecked)
    }
}
