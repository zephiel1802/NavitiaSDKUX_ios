//
//  BookPaymentWebViewController.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class BookPaymentWebViewController: UIViewController {

    @IBOutlet weak var statusBarView: UIView!
    @IBOutlet weak var breadcrumbContainerView: UIView!
    @IBOutlet var webView: UIWebView!
    
    private var _breadcrumbView: BreadcrumbView!
    var request: URLRequest?
    var viewModel: BookPaymentViewModel?
    var bookTicketDelegate: BookTicketDelegate?
    var transactionID: String = ""
    var customerID: String = ""
        
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        _setupBreadcrumbView()
        _setupWebView()
        statusBarView.backgroundColor = Configuration.Color.main
        view.customActivityIndicatory(startAnimate: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    private func _setupWebView() {
        webView.delegate = self
        webView.scrollView.bounces = false
        guard let request = request else {
            return
        }
        webView.loadRequest(request)
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

extension BookPaymentWebViewController: BreadcrumbViewDelegate {
    
    func onDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension BookPaymentWebViewController: UIWebViewDelegate {
    
    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        view.customActivityIndicatory(startAnimate: false)
        
        let informationViewController = self.informationViewController(information: "an_error_occurred".localized(bundle: NavitiaSDKUI.shared.bundle))
        informationViewController.delegate = self
        self.present(informationViewController, animated: true, completion: nil)
    }
    
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        view.customActivityIndicatory(startAnimate: false)
        let html = webView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('html')[0].innerHTML")
        
        if let transactionSogenActif = html?.extractTransactionSogenActif() {
            transactionID = transactionSogenActif
        }
        
        if let customerSogenActif = html?.extractCustomerSogenActif() {
            customerID = customerSogenActif
        }
    }
    
    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let url = request.url?.absoluteString {
            switch NavitiaSDKPartnersSogenActif.getReturnValue(url: url) {
            case .success:
                let viewController = storyboard?.instantiateViewController(withIdentifier: BookRecapViewController.identifier) as! BookRecapViewController
                viewController.modalTransitionStyle = .crossDissolve
                viewController.modalPresentationStyle = .overCurrentContext
                viewController.customerID = customerID
                viewController.transactionID = transactionID
                viewController.bookTicketDelegate = bookTicketDelegate
                
                present(viewController, animated: true, completion: nil)
            case .error:
                dismiss(animated: true) {
                    if let returnPayment = self.viewModel?.returnPayment { returnPayment() }
                }
            case .cancel:
                dismiss(animated: true) {}
            case .unknown:
                break
            }
        }
        
        return true
    }
    
}

extension BookPaymentWebViewController: InformationViewDelegate {
    
    func onFirstButtonClicked(_ informationViewController: InformationViewController) {
        informationViewController.dismiss(animated: true) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
