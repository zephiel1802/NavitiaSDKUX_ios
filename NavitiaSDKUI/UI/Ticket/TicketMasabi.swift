//
//  TicketMasabi.swift
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
    
    var pop: UIViewController?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        UIFont.registerFontWithFilenameString(filenameString: "SDKIcons.ttf", bundle: NavitiaSDKUI.shared.bundle)
        
        (NavitiaSDKPartners.shared.getTicketManagement() as! MasabiTicketManagement).syncWalletWithErrorOnDeviceChange(callbackSuccess: {
            self._showTicketMasabi()
        }, callbackError: { (statusCode, data) in
            print(statusCode, data)
            switch statusCode {
            case NavitiaSDKPartnersReturnCode.masabiNoDeviceChangeCredit.getCode():
                self.add(asChildViewController: self._setupInformationViewController(titleButton: ["OK"], information: "Je suis un appel service client"))
            case NavitiaSDKPartnersReturnCode.masabiDeviceChangeError.getCode():
                self.add(asChildViewController: self._setupInformationViewController(titleButton: ["Je sync", "OK"], information: "Je suis un swicth"))
            default:
                self.add(asChildViewController: self._setupInformationViewController(titleButton: ["OK"], information: "Je suis une erreur"))
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
            let viewController2 = UINavigationController(rootViewController: walletViewController)
            walletViewController.navigationItem.setLeftBarButton(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target: self.delegate, action: #selector(self.delegate?.onDismissTicket)), animated: false)
            walletViewController.navigationController?.navigationBar.tintColor = Configuration.Color.main
            walletViewController.navigationController?.navigationBar.barTintColor = Configuration.Color.white
            walletViewController.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : Configuration.Color.black]
            walletViewController.view.backgroundColor = Configuration.Color.main
            self.add(asChildViewController: viewController2)
        }) { (statusCode, data) in }
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        addChildViewController(viewController)
        view.addSubview(viewController.view)
        
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParentViewController: self)
    }

    private func _setupInformationViewController(titleButton: [String], information: String, iconName: String = "warning") -> UIViewController {
        let informationViewController = InformationViewController(nibName: "InformationView", bundle: self.nibBundle)
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
            }) { (statusCode, data) in }
        }
    }
    
    func onSecondButtonClicked(_ informationViewController: InformationViewController) {
        delegate?.onDismissTicket()
    }
    
}
