//
//  BookPaymentViewController.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

open class BookPaymentViewController: UIViewController {
    
    @IBOutlet weak var statusBarView: UIView!
    @IBOutlet weak var breadcrumbContainerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var _breadcrumbView: BreadcrumbView!
    var bookPaymentView: BookPaymentView!
    var viewScroll = [UIView]()
    var margin: CGFloat = 20
    var composentWidth: CGFloat = 0
    var display = false
    
    fileprivate var _viewModel: BookPaymentViewModel! {
        didSet {
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        _setupInterface()
        scrollView.bounces = false
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        composentWidth = _updateWidth()
        if !display {
            _displayLogin()
            //_displayLogout()
        }
        
        _updateOriginViewScroll()
    }
    
    private func _displayLogin() {
        let bookPaymentProfilView = BookPaymentProfilView(frame: CGRect(x: 0, y: 0, width: 0, height: 75))
        bookPaymentProfilView.name = "Test"
        _addViewInScroll(view: bookPaymentProfilView)
        
        let bookPaymentCartView = BookPaymentCartView(frame: CGRect(x: 0, y: 0, width: composentWidth, height: 111))
        _addViewInScroll(view: bookPaymentCartView)
        bookPaymentCartView.setPrice(NavitiaSDKPartners.shared.cartTotalPrice.value, currency: NavitiaSDKPartners.shared.cartTotalPrice.currency)
        bookPaymentCartView.setVAT(NavitiaSDKPartners.shared.cartTotalVAT.value, currency: NavitiaSDKPartners.shared.cartTotalVAT.currency)
        for cartItem in NavitiaSDKPartners.shared.cart {
            bookPaymentCartView.addOffer(cartItem)
        }
        
        let bookPaymentConditionView = BookPaymentConditionView(frame: CGRect(x: 0, y: 0, width: 0, height: 31))
        bookPaymentConditionView.delegate = self
        _addViewInScroll(view: bookPaymentConditionView)

        bookPaymentView = BookPaymentView(frame: CGRect(x: 0, y: 0, width: 0, height: 140))
        bookPaymentView.delegate = self
        _addViewInScroll(view: bookPaymentView)
        
        display = true
    }
    
    private func _displayLogout() {
        let bookPaymentCartView = BookPaymentCartView(frame: CGRect(x: 0, y: 0, width: composentWidth, height: 111))
        _addViewInScroll(view: bookPaymentCartView)
        bookPaymentCartView.setPrice(NavitiaSDKPartners.shared.cartTotalPrice.value, currency: NavitiaSDKPartners.shared.cartTotalPrice.currency)
        bookPaymentCartView.setVAT(NavitiaSDKPartners.shared.cartTotalVAT.value, currency: NavitiaSDKPartners.shared.cartTotalVAT.currency)
        for cartItem in NavitiaSDKPartners.shared.cart {
            bookPaymentCartView.addOffer(cartItem)
        }
        
        let bookPaymentMailFormView = BookPaymentMailFormView(frame: CGRect(x: 0, y: 0, width: 0, height: 60))
        _addViewInScroll(view: bookPaymentMailFormView)
        
        let bookPaymentConditionView = BookPaymentConditionView(frame: CGRect(x: 0, y: 0, width: 0, height: 31))
        bookPaymentConditionView.delegate = self
        _addViewInScroll(view: bookPaymentConditionView)
        
        bookPaymentView = BookPaymentView(frame: CGRect(x: 0, y: 0, width: 0, height: 140))
        bookPaymentView.delegate = self
        _addViewInScroll(view: bookPaymentView)
        
        display = true
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    private func _updateWidth(customMargin: CGFloat? = nil) -> CGFloat {
        if let margeCustom = customMargin {
            if #available(iOS 11.0, *) {
                return scrollView.frame.size.width - scrollView.safeAreaInsets.left - scrollView.safeAreaInsets.right - (margeCustom * 2)
            }
            return scrollView.frame.size.width - (margeCustom * 2)
        }
        if #available(iOS 11.0, *) {
            return scrollView.frame.size.width - scrollView.safeAreaInsets.left - scrollView.safeAreaInsets.right - (margin * 2)
        }
        return scrollView.frame.size.width - (margin * 2)
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

extension BookPaymentViewController {
    
    private func _addViewInScroll(view: UIView, customMargin: CGFloat? = nil) {
        if let margeCustom = customMargin {
            view.frame.origin.x = margeCustom
        } else {
            view.frame.origin.x = margin
        }
        if viewScroll.isEmpty {
            view.frame.origin.y = 0
        } else {
            if let viewBefore = viewScroll.last {
                view.frame.origin.y = viewBefore.frame.origin.y + viewBefore.frame.size.height
            }
        }
        viewScroll.append(view)
        if let last = viewScroll.last {
            scrollView.contentSize.height = last.frame.origin.y + last.frame.height
        }
        scrollView.addSubview(view)
    }
    
    private func _updateOriginViewScroll() {
        for (index, view) in viewScroll.enumerated() {
            if index == 0 {
                view.frame.origin.y = view.frame.origin.x
                view.frame.size.width = _updateWidth(customMargin: view.frame.origin.x)
            } else {
                view.frame.origin.y = viewScroll[index - 1].frame.origin.y + viewScroll[index - 1].frame.height + margin
                composentWidth = _updateWidth()
                view.frame.size.width = _updateWidth()
            }
        }
        if let last = viewScroll.last {
            scrollView.contentSize.height = last.frame.origin.y + last.frame.height + margin
            if last is BookPaymentView && scrollView.contentSize.height < scrollView.frame.size.height {
                last.frame.origin.y = scrollView.frame.size.height - last.frame.height - margin
            }
        }
    }
    
}

extension BookPaymentViewController: BreadcrumbViewProtocol {
    
    func onDismissButtonClicked(_ BreadcrumbView: BreadcrumbView) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension BookPaymentViewController: BookPaymentConditionViewDelegate {
    
    func onConditionSwitchValueChanged(_ state: Bool, _ bookPaymentConditionView: BookPaymentConditionView) {
        bookPaymentView.hidden(!state)
        if state {
            scrollView.setContentOffset(CGPoint(x: 0, y: max(0, scrollView.contentSize.height - scrollView.bounds.size.height)), animated: true)
        }
    }
    
    func onConditionButtonClicked(_ bookPaymentConditionView: BookPaymentConditionView) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string : "http://google.fr")!, options: [:], completionHandler: { (status) in })
        } else {
            // Fallback on earlier versions
        }
    }
    
}

extension BookPaymentViewController: BookPaymentViewDelegate {
    
    func onClickPayment(_ request: URLRequest, _ baseURL: String, _ bookPaymentView: BookPaymentView) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: BookPaymentWebViewController.identifier) as! BookPaymentWebViewController
        viewController.request = request
        viewController.baseURL = baseURL
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overCurrentContext
        self.present(viewController, animated: true, completion: nil)
    }
    
}
