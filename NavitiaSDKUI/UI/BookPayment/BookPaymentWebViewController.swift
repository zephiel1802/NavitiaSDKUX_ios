//
//  BookPaymentWebViewController.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 03/05/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class BookPaymentWebViewController: UIViewController {

    @IBOutlet weak var statusBarView: UIView!
    @IBOutlet weak var breadcrumbContainerView: UIView!
    @IBOutlet var webView: UIWebView!
    
    private var _breadcrumbView: BreadcrumbView!
    var request: URLRequest?
    var baseURL: String?
    var viewModel: BookPaymentViewModel?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        _setupInterface()
        
        webView.delegate = self
        webView.scrollView.bounces = false
        if let request = request {
            webView.loadRequest(request)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {

    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    private func _setupInterface() {
        statusBarView.backgroundColor = Configuration.Color.main
        
        _setupBreadcrumbView()
    }
    
    private func _setupBreadcrumbView() {
        _breadcrumbView = BreadcrumbView()
        _breadcrumbView.delegate = self
        _breadcrumbView.stateBreadcrumb = .payment
        _breadcrumbView.translatesAutoresizingMaskIntoConstraints = false
        breadcrumbContainerView.addSubview(_breadcrumbView)
        
        NSLayoutConstraint(item: _breadcrumbView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: breadcrumbContainerView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: _breadcrumbView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: breadcrumbContainerView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: _breadcrumbView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: breadcrumbContainerView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: _breadcrumbView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: breadcrumbContainerView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0).isActive = true
    }

}

extension BookPaymentWebViewController: BreadcrumbViewProtocol {
    
    func onDismissButtonClicked(_ BreadcrumbView: BreadcrumbView) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension BookPaymentWebViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let html = webView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('html')[0].innerHTML")
        if let transactionSogenActif = html?.extractTransactionSogenActif() {
            print("ID : \(transactionSogenActif)")
        }
        if let customerSogenActif = html?.extractCustomerSogenActif() {
            print("ID : \(customerSogenActif)")
        }
    }
    
    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let url = request.url?.absoluteString {
            print("URL Callback \(url)")
            switch test(baseURL: baseURL!, url: url) {
            case .success:
                print("Result : ✅ Success")
            case .error:
                print("Result : ❌ Error")
                dismiss(animated: true) {
                    if let returnPayment = self.viewModel?.returnPayment { returnPayment() }
                }
            case .cancel:
                print("Result : ⚠️ Cancel")
                dismiss(animated: true) {}
            case .unknown:
                break
            }
        }
        return true
    }
    
}

enum test2 {
    case error
    case cancel
    case success
    case unknown
}

func test(baseURL: String, url: String) -> test2 {
    if url.range(of: baseURL) != nil && url.range(of: "commandes") != nil {
        if url.range(of: "payment?oid=") != nil {
            if url.range(of: "payst=cancel") != nil {
                return .cancel
            } else if url.range(of: "payst=error") != nil {
                return .error
            }
        } else if url.range(of: "recap?oid=") != nil {
            return .success
        }
    }
    return .unknown
}

