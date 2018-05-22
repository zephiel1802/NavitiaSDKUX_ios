//
//  ViewController.swift
//  NavitiaSDKUI-Example
//
//  Copyright © 2018 kisio. All rights reserved.
//
import UIKit
import NavitiaSDKUI

class ViewController: UIViewController {
    
    var bookShopViewController: BookShopViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Journey
    @IBAction func onSDKJourneyButtonClicked(_ sender: Any) {
        let journeySolutionViewController = getJourneySolutionViewController()
        navigationController?.pushViewController(journeySolutionViewController, animated: true)
    }
    
    private func getJourneySolutionViewController() -> JourneySolutionViewController {
        let bundle = Bundle(identifier: "org.cocoapods.NavitiaSDKUI")
        let storyboard = UIStoryboard(name: "Journey", bundle: bundle)
        let journeyResultsViewController = storyboard.instantiateInitialViewController() as! JourneySolutionViewController
        var params: JourneySolutionViewController.InParameters = JourneySolutionViewController.InParameters(originId: "2.3665844;48.8465337", destinationId: "2.2979169;48.8848719")
        params.originLabel = "Chez moi"
        params.destinationLabel = "Au travail"
        params.datetime = Date()
        params.datetime!.addTimeInterval(2000)
        params.datetimeRepresents = .departure
        params.forbiddenUris = ["physical_mode:Bus"]
        params.firstSectionModes = [.bss]
        params.lastSectionModes = [.car]
        params.count = 5
        journeyResultsViewController.inParameters = params
        return journeyResultsViewController
    }
    
    // Book
    @IBAction func onSDKBookButtonClicked(_ sender: Any) {
        let bundle = Bundle(identifier: "org.cocoapods.NavitiaSDKUI")
        let storyboard = UIStoryboard(name: "Book", bundle: bundle)
        bookShopViewController = storyboard.instantiateInitialViewController() as? BookShopViewController
        
        let anonymousAction = UIAlertAction(title: "Anonymous", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if let bookShopViewController = self.bookShopViewController {
                if let userInfo = NavitiaSDKPartners.shared.userInfo as? KeolisUserInfo {
                    bookShopViewController.bookTicketDelegate = self
                    if userInfo.accountStatus != .anonymous {
                        NavitiaSDKPartners.shared.logOut(callbackSuccess: {
                            self.present(bookShopViewController, animated: true, completion: nil)
                        }, callbackError: { (_, _) in })
                    } else {
                        self.present(bookShopViewController, animated: true, completion: nil)
                    }
                }
            }
        })

        let connectedAction = UIAlertAction(title: "Connected", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if let bookShopViewController = self.bookShopViewController {
                NavitiaSDKPartners.shared.authenticate(username: "flavien.sicard@gmail.com", password: "toto42sh", callbackSuccess: {
                    bookShopViewController.bookTicketDelegate = self
                    self.present(bookShopViewController, animated: true, completion: nil)
                }, callbackError: { (_, _) in })
            }
            
        })
        
        let alertController = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        alertController.addAction(anonymousAction)
        alertController.addAction(connectedAction)

        present(alertController, animated: true, completion: nil)
    }
    
}

extension ViewController: BookTicketDelegate {
    
    func onDisplayCreateAccount() {
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            rootViewController.dismiss(animated: false, completion: nil)
        }
    }
    
    func onDisplayConnectionAccount() {
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            rootViewController.dismiss(animated: false, completion: nil)
        }
    }
    
    func onDisplayTicket() {
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            rootViewController.dismiss(animated: false, completion: nil)
        }
    }
    
    func onDismissBookTicket() {
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            rootViewController.dismiss(animated: true, completion: nil)
        }
    }
    
}
