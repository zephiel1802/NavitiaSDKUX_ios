//
//  AlertViewController.swift
//  NavitiaSDKUX
//

import Foundation

protocol AlertViewControllerProtocol {
    func onNegativeButtonClicked(_ alertViewController: AlertViewController)
    func onPositiveButtonClicked(_ alertViewController: AlertViewController)
}

class AlertViewController: UIViewController {
    var keyState: String = ""
    var alertMessage: String = ""
    var checkBoxText: String = ""
    var negativeButtonText: String = ""
    var positiveButtonText: String = ""
    var alertViewDelegate: AlertViewControllerProtocol?

    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var negativeButton: UIButton!
    @IBOutlet weak var positiveButton: UIButton!
    @IBOutlet weak var checkbox: Checkbox!
    @IBOutlet weak var checkBoxMessageLabel: UILabel!
    @IBOutlet weak var checkBoxContentWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var checkBoxTextLeadingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.checkbox.layer.borderWidth = 1
        self.checkbox.layer.borderColor = UIColor.gray.cgColor
        self.checkbox.layer.cornerRadius = 2
        self.checkbox.borderStyle = .square
        self.checkbox.checkmarkStyle = .tick
        self.checkbox.checkmarkColor = config.colors.tertiary
        
        self.message.text = self.alertMessage
        self.checkBoxMessageLabel.text = self.checkBoxText
        self.negativeButton.setTitle(self.negativeButtonText, for: UIControlState.normal)
        self.positiveButton.setTitle(self.positiveButtonText, for: UIControlState.normal)
        
        let newCheckBoxTextSize = self.checkBoxMessageLabel.sizeThatFits(CGSize(width: self.checkBoxMessageLabel.frame.size.width, height: CGFloat.max))
        self.checkBoxContentWidthConstraint.constant = self.checkBoxMessageLabel.frame.size.width + self.checkBoxTextLeadingConstraint.constant + newCheckBoxTextSize.width
    }
    
    @IBAction func negativeButtonClicked(_ sender: Any) {
        self.alertViewDelegate?.onNegativeButtonClicked(self)
        
        saveCheckBoxState()
    }
    
    @IBAction func positiveButtonClicked(_ sender: Any) {
        self.alertViewDelegate?.onPositiveButtonClicked(self)
        
        saveCheckBoxState()
    }
    
    @IBAction func switchCheckBoxState(_ sender: Any) {
        self.checkbox.isChecked = !self.checkbox.isChecked
    }
    
    @IBAction func dismissAlertController(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func saveCheckBoxState() {
        if self.checkbox.isChecked {
            UserDefaults.standard.set(false, forKey: self.keyState)
        }
    }
}
