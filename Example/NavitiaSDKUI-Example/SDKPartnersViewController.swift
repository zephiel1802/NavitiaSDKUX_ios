//
//  SDKPartnersViewController.swift
//  NavitiaSDKUI-Example
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit
import NavitiaSDKUI

class SDKPartnersViewController: UIViewController {

    @IBOutlet weak var acccountStatus: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self._displayAccountStatus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func _displayAccountStatus() {
        if let userInfo = NavitiaSDKPartners.shared.userInfo as? KeolisUserInfo {
            if userInfo.accountStatus != .anonymous {
                acccountStatus.text = "Connected"
            } else {
                acccountStatus.text = "Anonymous"
            }
        }
    }
    
    @IBAction func onConnectionButtonClicked(_ sender: Any) {
        if let username = emailTextField.text, let password = passwordTextField.text {
            NavitiaSDKPartners.shared.authenticate(username: username, password: password, callbackSuccess: {
                let alert = UIAlertController(title: "Connected", message: "You are well connected", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                self._displayAccountStatus()
            }, callbackError: { (statusCode, data) in
                let alert = UIAlertController(title: String(statusCode), message: "\(String(describing: data))", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                self._displayAccountStatus()
            })
        }
    }

}
