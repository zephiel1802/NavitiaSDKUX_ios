//
//  BookPaymentView.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 03/05/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

protocol BookPaymentViewDelegate {
    
    func onClickPayment(_ request: URLRequest, _ baseURL: String, _ bookPaymentView: BookPaymentView)
    
}

open class BookPaymentView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var paymentWebView: UIWebView!
    @IBOutlet weak var filterView: UIView!
    
    var baseURL: String = ""
    var delegate: BookPaymentViewDelegate?
    
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
        
        paymentWebView.scrollView.bounces = false
        paymentWebView.delegate = self
        paymentWebView.isOpaque = false
        paymentWebView.backgroundColor = UIColor.clear
        hidden(true)
        loadHTML()
    }
    
    func loadHTML() {
        NavitiaSDKPartners.shared.launchPayment(color: UIColor(red: 238/255, green: 238/255, blue: 242/255, alpha: 1),
                                                callbackSuccess: { (htmlString, baseURL) in
            self.baseURL = baseURL
            self.paymentWebView.loadHTMLString(htmlString, baseURL: URL(string: baseURL))
        }) { (statusCode, data) in
            
        }
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
    
}

extension BookPaymentView: UIWebViewDelegate {
    
    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if request.url?.absoluteString.starts(with: baseURL) ?? true {
            return true
        }
        delegate?.onClickPayment(request, baseURL, self)
        return false
    }
    
}
