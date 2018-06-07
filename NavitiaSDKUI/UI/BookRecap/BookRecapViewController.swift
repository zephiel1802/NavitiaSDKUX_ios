//
//  BookRecapViewController.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

open class BookRecapViewController: UIViewController {
    
    @IBOutlet weak var statusBarView: UIView!
    @IBOutlet weak var breadcrumbContainerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var _breadcrumbView: BreadcrumbView!
    
    var transactionID: String = ""
    var customerID: String = ""
    var viewScroll = [UIView]()
    var margin: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    var composentWidth: CGFloat = 0
    var display = false
    var bookTicketDelegate: BookTicketDelegate?
    
    fileprivate var _viewModel: BookRecapViewModel!
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        NavitiaSDKUI.shared.bundle = self.nibBundle
        UIFont.registerFontWithFilenameString(filenameString: "SDKIcons.ttf", bundle: NavitiaSDKUI.shared.bundle)
        
        if #available(iOS 11.0, *) {
            scrollView?.contentInsetAdjustmentBehavior = .always
        }
        
        _setupInterface()
        _viewModel = BookRecapViewModel()
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        composentWidth = _updateWidth()
        if !display {
            if _viewModel.isConnected {
                _displayLogin()
            } else {
                _displayLogout()
            }
            NavitiaSDKPartners.shared.resetCart(callbackSuccess: {}, callbackError: { (_, _) in })
        }
        
        _updateOriginViewScroll()
    }
    
    private func _displayLogin() {
        let bookPaymentProfilView = BookPaymentProfilView(frame: CGRect(x: 0, y: 0, width: 0, height: 75))
        if let userInfo = NavitiaSDKPartners.shared.userInfo as? KeolisUserInfo {
            bookPaymentProfilView.name = String(format: "%@ %@", userInfo.firstName, userInfo.lastName)
        }
        _addViewInScroll(view: bookPaymentProfilView)
        
        let bookRecapInformationView = BookRecapInformationView(frame: CGRect(x: 0, y: 0, width: 0, height: 285))
        bookRecapInformationView.setCustomer(str: customerID)
        bookRecapInformationView.setTransaction(str: transactionID)
        bookRecapInformationView.setAmount(str: String(format: "%0.2f%@", NavitiaSDKPartners.shared.cartTotalPrice.value, NavitiaSDKPartners.shared.cartTotalPrice.currency))
        _addViewInScroll(view: bookRecapInformationView)
        
        let bookRecapTicketView = BookRecapTicketView(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
        bookRecapTicketView.delegate = self
        _addViewInScroll(view: bookRecapTicketView)
        
        display = true
    }
    
    private func _displayLogout() {
        let bookRecapInformationView = BookRecapInformationView(frame: CGRect(x: 0, y: 0, width: 0, height: 285))
        bookRecapInformationView.setCustomer(str: customerID)
        bookRecapInformationView.setTransaction(str: transactionID)
        bookRecapInformationView.setAmount(str: String(format: "%0.2f%@", NavitiaSDKPartners.shared.cartTotalPrice.value, NavitiaSDKPartners.shared.cartTotalPrice.currency))
        _addViewInScroll(view: bookRecapInformationView)
        
        let bookRecapTicketView = BookRecapTicketView(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
        bookRecapTicketView.delegate = self
        _addViewInScroll(view: bookRecapTicketView)
        
        let bookRecapConnectView = BookRecapConnectView(frame: CGRect(x: 0, y: 0, width: 0, height: 70))
        bookRecapConnectView.delegate = self
        _addViewInScroll(view: bookRecapConnectView)
        
        display = true
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    private func _setupInterface() {
        scrollView.bounces = false
        statusBarView.backgroundColor = Configuration.Color.main
        
        _setupBreadcrumbView()
    }
    
    private func _setupBreadcrumbView() {
        _breadcrumbView = BreadcrumbView()
        _breadcrumbView.delegate = self
        _breadcrumbView.stateBreadcrumb = .tickets
        _breadcrumbView.translatesAutoresizingMaskIntoConstraints = false
        breadcrumbContainerView.addSubview(_breadcrumbView)
        
        _breadcrumbView.returnButton.isHidden = true
        
        NSLayoutConstraint(item: _breadcrumbView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: breadcrumbContainerView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: _breadcrumbView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: breadcrumbContainerView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: _breadcrumbView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: breadcrumbContainerView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: _breadcrumbView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: breadcrumbContainerView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0).isActive = true
    }
    
}

// ScrollView
extension BookRecapViewController {
    
    private func _addViewInScroll(view: UIView, customMargin: CGFloat? = nil) {
        if let margeCustom = customMargin {
            view.frame.origin.x = margeCustom
        } else {
            view.frame.origin.x = margin.left
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
            view.frame.origin.x = margin.left
            if index == 0 {
                view.frame.origin.y = margin.top
                view.frame.size.width = _updateWidth(customMargin: margin)
            } else {
                view.frame.origin.y = viewScroll[index - 1].frame.origin.y + viewScroll[index - 1].frame.height + margin.bottom + margin.top
                composentWidth = _updateWidth()
                view.frame.size.width = _updateWidth()
            }
        }
        
        if let last = viewScroll.last {
            scrollView.contentSize.height = last.frame.origin.y + last.frame.height + margin.bottom
            if (last is BookRecapTicketView || last is BookRecapConnectView) && scrollView.contentSize.height < scrollView.frame.size.height {
                last.frame.origin.y = scrollView.frame.size.height - last.frame.height - margin.bottom
            }
        }
    }

    private func _updateWidth(customMargin: UIEdgeInsets? = nil) -> CGFloat {
        if let margeCustom = customMargin {
            if #available(iOS 11.0, *) {
                return scrollView.frame.size.width - scrollView.safeAreaInsets.left - scrollView.safeAreaInsets.right - margeCustom.left - margeCustom.right
            }
            return scrollView.frame.size.width - margeCustom.left - margeCustom.right
        }
        if #available(iOS 11.0, *) {
            return scrollView.frame.size.width - scrollView.safeAreaInsets.left - scrollView.safeAreaInsets.right - margin.left - margin.right
        }
        return scrollView.frame.size.width - margin.left - margin.right
    }
    
}

extension BookRecapViewController: BreadcrumbViewDelegate {
    
    public func onDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension BookRecapViewController: BookRecapTicketViewDelegate {
    
    func onDisplayTicketsPressedButton(_ bookRecapTicketView: BookRecapTicketView) {
        bookTicketDelegate?.onDisplayTicket()
    }
    
}

extension BookRecapViewController: BookRecapConnectViewDelegate {
    
    func onConnectionPressedButton(_ bookRecapConnectView: BookRecapConnectView) {
        bookTicketDelegate?.onDisplayConnectionAccount()
    }
    
}
