//
//  BookPaymentView.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 03/05/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

protocol BookPaymentViewDelegate {
    
    func onFilterClicked(_ bookPaymentView: BookPaymentView)
    func onPaymentClicked(_ request: URLRequest, _ baseURL: String, _ bookPaymentView: BookPaymentView)
    
}

open class BookPaymentView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var paymentWebView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var filterView: UIView!
    
    var delegate: BookPaymentViewDelegate?
    var email: String?

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

        _setupGesture()
        _setupWebView()
        _setupActivityIndicator()
        
        enableFilter = true
        enablePaymentView = false
    }
    
    private func _setupGesture() {
        let viewGesture = UITapGestureRecognizer(target: self, action: #selector(BookPaymentView.clickFilter))
        view.addGestureRecognizer(viewGesture)
    }
    
    private func _setupWebView() {
        paymentWebView.scrollView.bounces = false
        paymentWebView.delegate = self
        paymentWebView.isOpaque = false
        paymentWebView.backgroundColor = UIColor.clear
    }
    
    private func _setupActivityIndicator() {
        activityIndicator.color = Configuration.Color.darkGray
    }
    
    func launchPayment() {
        guard let email = email else {
            return
        }
        enablePaymentView = true
        activityIndicator.startAnimating()
        NavitiaSDKPartners.shared.launchPayment(email: email,
                                                color: Configuration.Color.backgroundPayment,
                                                callbackSuccess: { (html) in
                                                    self.paymentWebView.loadHTMLString(html, baseURL: URL(string: NavitiaSDKPartners.shared.paymentBaseUrl))
        }) { (statusCode, data) in
            self.activityIndicator.stopAnimating()
        }
    }
    
    @objc func clickFilter() {
        self.delegate?.onFilterClicked(self)
    }
    
}

extension BookPaymentView {
    
    var enableFilter: Bool {
        get {
            if filterView.layer.opacity == 0 {
                return false
            }
            return true
        }
        set {
            if newValue {
                filterView.layer.opacity = 0.75
                paymentWebView.isUserInteractionEnabled = false
                filterView.isUserInteractionEnabled = false
            } else {
                filterView.layer.opacity = 0
                paymentWebView.isUserInteractionEnabled = true
                filterView.isUserInteractionEnabled = true
            }
        }
    }
    
    var enablePaymentView: Bool {
        get {
            return !paymentWebView.isHidden
        }
        set {
            if newValue {
                paymentWebView.isHidden = false
                activityIndicator.isHidden = false
            } else {
                paymentWebView.stringByEvaluatingJavaScript(from: "document.open();document.close()")
                paymentWebView.isHidden = true
                activityIndicator.isHidden = true
            }
        }
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
        delegate?.onPaymentClicked(request, NavitiaSDKPartners.shared.paymentBaseUrl, self)
        return false
    }
    
}
