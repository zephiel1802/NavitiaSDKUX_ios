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
    
    private var _masabiViewController: UIViewController!
    private var _informationViewController: UIViewController!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        UIFont.registerFontWithFilenameString(filenameString: "SDKIcons.ttf", bundle: NavitiaSDKUI.shared.bundle)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        view.customActivityIndicatory(startAnimate: true)
        
        (NavitiaSDKPartners.shared.getTicketManagement() as! MasabiTicketManagement).syncWalletWithErrorOnDeviceChange(callbackSuccess: {
            self.view.customActivityIndicatory(startAnimate: false)
            self._showTicketMasabi()
            self._displayMasabiViewController()
        }, callbackError: { (statusCode, data) in
            self.view.customActivityIndicatory(startAnimate: false)
            
            switch statusCode {
            case NavitiaSDKPartnersReturnCode.masabiNoDeviceChangeCredit.getCode():
                self._informationViewController = self._setupInformationViewController(information: "you_have_reached_the_allowed_number_of_device_switches".localized(bundle: NavitiaSDKUI.shared.bundle))
                self._displayInformationViewController()
            case NavitiaSDKPartnersReturnCode.masabiDeviceChangeError.getCode():
                self._informationViewController = self._setupInformationViewController(titleButton: ["yes".localized(bundle: NavitiaSDKUI.shared.bundle),
                                                                                                     "cancel".localized(bundle: NavitiaSDKUI.shared.bundle)],
                                                                                       information: "your_wallet_is_bound_to_another_device".localized(bundle: NavitiaSDKUI.shared.bundle))
                self._displayInformationViewController()
            case NavitiaSDKPartnersReturnCode.notConnected.getCode():
                self._showTicketMasabi()
                self._displayMasabiViewController()
            case NavitiaSDKPartnersReturnCode.masabiAuthenticateError.getCode():
                self._informationViewController = self._setupInformationViewController(information:
                    String(format: "%@\n\n%@ 200\nUnderlying network error\n",
                           "please_contact_the_customer_service_with_the_following_information".localized(bundle: NavitiaSDKUI.shared.bundle),
                           "code".localized(bundle: NavitiaSDKUI.shared.bundle)))
                self._displayInformationViewController()
            default:
                self._informationViewController = self._setupInformationViewController(information: "an_error_occurred".localized(bundle: NavitiaSDKUI.shared.bundle))
                self._displayInformationViewController()
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
            self._masabiViewController = UINavigationController(rootViewController: walletViewController)
            
            walletViewController.navigationItem.setLeftBarButton(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop,
                                                                                 target: self,
                                                                                 action: #selector(self.dismissView)),
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
    
    private func _displayMasabiViewController() {
        self._masabiViewController.view.tag = 999
        self.addChildView(childViewController: self._masabiViewController)
    }
    
    private func _displayInformationViewController() {
        self._informationViewController.view.tag = 998
        self.addChildView(childViewController: self._informationViewController)
    }
    
    private func _removeMasabiViewControler() {
        view.viewWithTag(999)?.removeFromSuperview()
        if let masabiViewController = _masabiViewController {
            masabiViewController.removeFromParentViewController()
        }
    }
    
    private func _removeInformationViewControler() {
        view.viewWithTag(998)?.removeFromSuperview()
        if let informationViewController = _informationViewController {
            informationViewController.removeFromParentViewController()
        }
    }
    
    @objc func dismissView() {
        _removeMasabiViewControler()
        _removeInformationViewControler()
        delegate?.onDismissTicket()
    }
    
}

extension TicketViewController: InformationViewDelegate {
    
    func onFirstButtonClicked(_ informationViewController: InformationViewController) {
        if informationViewController.titleButton.count == 1 {
            delegate?.onDismissTicket()
        } else {
            self._removeInformationViewControler()
            self.view.customActivityIndicatory(startAnimate: true)
            (NavitiaSDKPartners.shared.getTicketManagement() as! MasabiTicketManagement).syncWallet(callbackSuccess: {
                self.view.customActivityIndicatory(startAnimate: false)
                self._showTicketMasabi()
                self._displayMasabiViewController()
            }) { (_, _) in
                self.view.customActivityIndicatory(startAnimate: false)
                self._informationViewController = self._setupInformationViewController(information: "an_error_occurred".localized(bundle: NavitiaSDKUI.shared.bundle))
                self._displayInformationViewController()
            }
        }
    }
    
    func onSecondButtonClicked(_ informationViewController: InformationViewController) {
        delegate?.onDismissTicket()
    }
    
}
