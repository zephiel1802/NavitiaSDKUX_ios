//
//  BookPaymentView.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 03/05/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

protocol BookPaymentViewDelegate {
    
    func onClickFilter(_ bookPaymentView: BookPaymentView)
    func onClickPayment(_ request: URLRequest, _ baseURL: String, _ bookPaymentView: BookPaymentView)
    
}

open class BookPaymentView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var paymentWebView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var filterView: UIView!
    
    var delegate: BookPaymentViewDelegate?
    
    
    var mail: String?
    // C'est à enlever
    var log: Bool!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        _setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        _setup()
    }
    
    override open func layoutSubviews() {}
    
    private func _setup() {
        UINib(nibName: "BookPaymentView", bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: self, options: nil)
        view.frame = self.bounds
        addSubview(view)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(BookPaymentView.clickFilter))
        view.addGestureRecognizer(tap)
        
        paymentWebView.scrollView.bounces = false
        paymentWebView.delegate = self
        paymentWebView.isOpaque = false
        paymentWebView.backgroundColor = UIColor.clear
        hidden(true)
        activityIndicator.color = Configuration.Color.darkGray
        activityIndicator.isHidden = true
    }
    
    func loadHTML() {
        
        paymentWebView.stringByEvaluatingJavaScript(from: "document.open();document.close()")
        paymentWebView.isHidden = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        if log {
            NavitiaSDKPartners.shared.launchPayment(email: "flavien.sicard@gmail.com",
                                                    color: UIColor(red: 238/255, green: 238/255, blue: 242/255, alpha: 1),
                                                    callbackSuccess: { (html) in
                                                        self.paymentWebView.loadHTMLString(html, baseURL: URL(string: NavitiaSDKPartners.shared.paymentBaseUrl))
            }) { (statusCode, data) in
                
            }
        } else {
            
            NavitiaSDKPartners.shared.launchPayment(email: "flavien.sicard@gmail.com",
                                                    color: UIColor(red: 238/255, green: 238/255, blue: 242/255, alpha: 1),
                                                    callbackSuccess: { (html) in
                                                        self.paymentWebView.loadHTMLString(html, baseURL: URL(string: NavitiaSDKPartners.shared.paymentBaseUrl))
            }) { (statusCode, data) in
                
            }
        }
        
    }
    
    func dismissHTML() {
        paymentWebView.isHidden = true
        activityIndicator.isHidden = true
    }
    
    func hidden(_ state: Bool) {
        if state {
            filterView.layer.opacity = 0.75
            paymentWebView.isUserInteractionEnabled = false
            filterView.isUserInteractionEnabled = false
            
        } else {
            filterView.layer.opacity = 0
            paymentWebView.isUserInteractionEnabled = true
            filterView.isUserInteractionEnabled = true
        }
    }
    
    @objc func clickFilter() {
        self.delegate?.onClickFilter(self)
    }
    
}

extension BookPaymentView: UIWebViewDelegate {
    
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if request.url?.absoluteString.starts(with: NavitiaSDKPartners.shared.paymentBaseUrl) ?? true {
            return true
        }
        delegate?.onClickPayment(request, NavitiaSDKPartners.shared.paymentBaseUrl, self)
        return false
    }
    
}
