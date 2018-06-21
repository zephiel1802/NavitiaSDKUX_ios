//
//  TicketViewController.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit
import JustRideSDK

@objc public protocol TicketViewDelegate {
    
    func onDismissTicket()
    
}

@objc open class TicketViewController: UIViewController {
    
    @objc public var delegate: TicketViewDelegate?
    private var masabiViewController: UIViewController!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        UIFont.registerFontWithFilenameString(filenameString: "SDKIcons.ttf", bundle: NavitiaSDKUI.shared.bundle)
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        view.viewWithTag(999)?.removeFromSuperview()
        masabiViewController.removeFromParentViewController()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        (NavitiaSDKPartners.shared.getTicketManagement() as! MasabiTicketManagement).syncWalletWithErrorOnDeviceChange(callbackSuccess: {
            self._showTicketMasabi()
            self.masabiViewController.view.tag = 999
            self.addChildView(childViewController: self.masabiViewController)
        }, callbackError: { (statusCode, data) in
            switch statusCode {
            case NavitiaSDKPartnersReturnCode.masabiNoDeviceChangeCredit.getCode():
                self.addChildView(childViewController: self._setupInformationViewController(information: "you_have_reached_the_allowed_number_of_device_switches".localized(bundle: NavitiaSDKUI.shared.bundle)))
            case NavitiaSDKPartnersReturnCode.masabiDeviceChangeError.getCode():
                self.addChildView(childViewController: self._setupInformationViewController(titleButton: ["yes".localized(bundle: NavitiaSDKUI.shared.bundle),
                                                                                                          "cancel".localized(bundle: NavitiaSDKUI.shared.bundle)],
                                                                                            information: "your_wallet_is_bound_to_another_device".localized(bundle: NavitiaSDKUI.shared.bundle)))
            default:
                self.addChildView(childViewController: self._setupInformationViewController(information: "an_error_occurred".localized(bundle: NavitiaSDKUI.shared.bundle)))
            }
        })
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func _showTicketMasabi() {
        NavitiaSDKPartners.shared.showWallet(callbackSuccess: { (walletViewController) in
            guard let walletViewController = walletViewController as? MJRWalletViewController else {
                return
            }
            self.masabiViewController = UINavigationController(rootViewController: walletViewController)
            
            walletViewController.navigationItem.setLeftBarButton(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop,
                                                                                 target: self.delegate,
                                                                                 action: #selector(self.delegate?.onDismissTicket)),
                                                                 animated: false)
            walletViewController.navigationController?.navigationBar.tintColor = Configuration.Color.main
            walletViewController.navigationController?.navigationBar.barTintColor = Configuration.Color.white
            walletViewController.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : Configuration.Color.black]
        }) { (_, _) in }
    }

    private func _setupInformationViewController(titleButton: [String] = ["close".localized(bundle: NavitiaSDKUI.shared.bundle)],
                                                 information: String,
                                                 iconName: String = "warning-circled") -> UIViewController {
        let informationViewController = InformationViewController(nibName: "InformationView", bundle: NavitiaSDKUI.shared.bundle)
        informationViewController.modalTransitionStyle = .crossDissolve
        informationViewController.modalPresentationStyle = .overCurrentContext
        informationViewController.titleButton = titleButton
        informationViewController.delegate = self
        informationViewController.information = information
        informationViewController.iconName = iconName
        
        return informationViewController
    }
    
}

extension TicketViewController: InformationViewDelegate {
    
    func onFirstButtonClicked(_ informationViewController: InformationViewController) {
        if informationViewController.titleButton.count == 1 {
            delegate?.onDismissTicket()
        } else {
            (NavitiaSDKPartners.shared.getTicketManagement() as! MasabiTicketManagement).syncWallet(callbackSuccess: {
                self._showTicketMasabi()
            }) { (_, _) in }
        }
    }
    
    func onSecondButtonClicked(_ informationViewController: InformationViewController) {
        delegate?.onDismissTicket()
    }
    
}
