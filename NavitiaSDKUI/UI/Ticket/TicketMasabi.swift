//
//  TicketMasabi.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit
import JustRideSDK

@objc public protocol TicketMasabiDelegate {
    
    func onDismissTicket()
    
}

@objc open class TicketMasabi: UIViewController {
    
    @objc public var delegate: TicketMasabiDelegate?
    
    var pop: UIViewController?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalPresentationStyle = .overCurrentContext
        
       // NavitiaSDKUI.shared.bundle = self.nibBundle
        UIFont.registerFontWithFilenameString(filenameString: "SDKIcons.ttf", bundle: NavitiaSDKUI.shared.bundle)
        
        (NavitiaSDKPartners.shared.getTicketManagement() as! MasabiTicketManagement).syncWalletWithErrorOnDeviceChange(callbackSuccess: {
            print("Success syncWalletWithErrorOnDeviceChange")
            self._showTicketMasabi()
        }, callbackError: { (statusCode, data) in
            self.pop = self.popInT()
            self.add(asChildViewController: self.pop!)
            print("Error syncWalletWithErrorOnDeviceChange \(statusCode, data)")
        })
        
        (NavitiaSDKPartners.shared.getTicketManagement() as! MasabiTicketManagement).syncWallet(callbackSuccess: {
            print("Success syncWalletWithErrorOnDeviceChange")
            self._showTicketMasabi()
        }, callbackError: { (statusCode, data) in
            self.pop = self.popInT()
            self.add(asChildViewController: self.pop!)
            print("Error syncWalletWithErrorOnDeviceChange \(statusCode, data)")
        })
//
//        view.backgroundColor = UIColor.clear
//        view.isOpaque = true
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
        }) { (statusCode, data) in
            print("voillllal MASABI \(statusCode) \(data!)")
            self.pop = self.popInT()
            self.add(asChildViewController: self.pop!)
        }

       // return viewController
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChildViewController(viewController)
        
        // Add Child View as Subview
        view.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }

    open func popInT() -> UIViewController {
        
        let informationViewController = InformationViewController(nibName: "InformationView", bundle: NavitiaSDKUI.shared.bundle)
        informationViewController.modalTransitionStyle = .crossDissolve
        informationViewController.modalPresentationStyle = .overCurrentContext
        informationViewController.titleButton = ["understood", "jjj"]
        informationViewController.delegate = self
        informationViewController.information =  "your_payment_has_been_refused"
        informationViewController.iconName = "paiement-denied"
        return informationViewController
    }
    
    
}

extension TicketMasabi: InformationViewDelegate {
    
    func onFirstButtonClicked(_ informationViewController: InformationViewController) {
        if informationViewController.titleButton.count == 1 {
            delegate?.onDismissTicket()
        } else {
            
        }
    }
    
    func onSecondButtonClicked(_ informationViewController: InformationViewController) {
        delegate?.onDismissTicket()
    }
    
}
