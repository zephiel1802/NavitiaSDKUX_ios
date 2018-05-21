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
    var bookPaymentMailFormView: BookPaymentMailFormView?
    var bookPaymentConditionView: BookPaymentConditionView?
    var bookPaymentView: BookPaymentView!
    var viewScroll = [UIView]()
    var margin: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    var composentWidth: CGFloat = 0
    var display = false
    
    fileprivate var _viewModel: BookPaymentViewModel! {
        didSet {
            _viewModel.returnPayment = { [weak self] in
                self?._onInformationPressedButton()
                self?.bookPaymentView.launchPayment()
            }
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        _setupInterface()
        _viewModel = BookPaymentViewModel()
        _setupGesture()
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
            if _viewModel.isConnected {
                _displayLogin()
            } else {
                _displayLogout()
            }
        }
        
        _updateOriginViewScroll()
    }
    
    private func _setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(BookPaymentViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    private func _displayLogin() {
        let bookPaymentProfilView = BookPaymentProfilView(frame: CGRect(x: 0, y: 0, width: 0, height: 75))
        if let userInfo = NavitiaSDKPartners.shared.userInfo as? KeolisUserInfo {
            bookPaymentProfilView.name = String(format: "%@ %@", userInfo.firstName, userInfo.lastName)
        }
        _addViewInScroll(view: bookPaymentProfilView)
        
        let bookPaymentCartView = BookPaymentCartView(frame: CGRect(x: 0, y: 0, width: composentWidth, height: 111))
        _addViewInScroll(view: bookPaymentCartView)
        bookPaymentCartView.setPrice(NavitiaSDKPartners.shared.cartTotalPrice.value, currency: NavitiaSDKPartners.shared.cartTotalPrice.currency)
        bookPaymentCartView.setVAT(NavitiaSDKPartners.shared.cartTotalVAT.value, currency: NavitiaSDKPartners.shared.cartTotalVAT.currency)
        for cartItem in NavitiaSDKPartners.shared.cart {
            bookPaymentCartView.addOffer(cartItem)
        }
        
        bookPaymentConditionView = BookPaymentConditionView(frame: CGRect(x: 0, y: 0, width: 0, height: 31))
        bookPaymentConditionView!.delegate = self
        bookPaymentConditionView!.isEnable = true
        _addViewInScroll(view: bookPaymentConditionView!)

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
        
        bookPaymentMailFormView = BookPaymentMailFormView(frame: CGRect(x: 0, y: 0, width: 0, height: 60))
        bookPaymentMailFormView?.delegate = self
        _addViewInScroll(view: bookPaymentMailFormView!)
        
        bookPaymentConditionView = BookPaymentConditionView(frame: CGRect(x: 0, y: 0, width: 0, height: 31))
        bookPaymentConditionView!.delegate = self
        _addViewInScroll(view: bookPaymentConditionView!)
        
        bookPaymentView = BookPaymentView(frame: CGRect(x: 0, y: 0, width: 0, height: 140))
        bookPaymentView.delegate = self
        _addViewInScroll(view: bookPaymentView)
        
        display = true
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(BookPaymentViewController.adjustForKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self, selector: #selector(BookPaymentViewController.adjustForKeyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
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
        _breadcrumbView.stateBreadcrumb = .payment
        _breadcrumbView.translatesAutoresizingMaskIntoConstraints = false
        breadcrumbContainerView.addSubview(_breadcrumbView)
        
        NSLayoutConstraint(item: _breadcrumbView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: breadcrumbContainerView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: _breadcrumbView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: breadcrumbContainerView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: _breadcrumbView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: breadcrumbContainerView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: _breadcrumbView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: breadcrumbContainerView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0).isActive = true
    }
    
    private func _onInformationPressedButton() {
        let informationViewController = InformationViewController(nibName: "InformationView", bundle: NavitiaSDKUI.shared.bundle)
        informationViewController.modalTransitionStyle = .crossDissolve
        informationViewController.modalPresentationStyle = .overCurrentContext
        informationViewController.titleButton = [String(format: "%@ !", "understood".localized(withComment: "Understood !", bundle: NavitiaSDKUI.shared.bundle))]
        informationViewController.delegate = self
        informationViewController.information =  "your_payment_has_been_refused".localized(withComment: "Your payment has been refused", bundle: NavitiaSDKUI.shared.bundle)
        informationViewController.iconName = "paiement-denied"
        present(informationViewController, animated: true) {}
    }

}

// ScrollView
extension BookPaymentViewController {
    
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
            if last is BookPaymentView && scrollView.contentSize.height < scrollView.frame.size.height {
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

// Keyboard
extension BookPaymentViewController {
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        if scrollView.contentSize.height > scrollView.bounds.size.height {
            let userInfo = notification.userInfo!
            let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
            
            if notification.name == Notification.Name.UIKeyboardWillHide {
                scrollView.contentInset = UIEdgeInsets.zero
                if let _ = bookPaymentMailFormView {
                    scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                }
            } else {
                 scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
                if let bookPaymentMailFormView = bookPaymentMailFormView {
                    scrollView.setContentOffset(CGPoint(x: 0, y: bookPaymentMailFormView.frame.origin.y - 10), animated: true)
                }
            }
            scrollView.scrollIndicatorInsets = scrollView.contentInset
        }
    }
    
}

extension BookPaymentViewController: BookShopViewControllerDelegate {
    
    public func onDismissBookShopViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension BookPaymentViewController: BookPaymentConditionViewDelegate {
    
    func onConditionSwitchValueChanged(_ bookPaymentConditionView: BookPaymentConditionView) {
        if !_viewModel.isConnected {
            guard let bookPaymentMailFormView = bookPaymentMailFormView else {
                return
            }
            if bookPaymentConditionView.conditionSwitch.isOn {
                if bookPaymentMailFormView.isValid {
                    bookPaymentView.email = bookPaymentMailFormView.mailTextField.text
                }
            } else {
                bookPaymentView.enablePaymentView = false
            }
        }
        
        if bookPaymentConditionView.conditionSwitch.isOn {
            dismissKeyboard()
            if let userInfo = NavitiaSDKPartners.shared.userInfo as? KeolisUserInfo {
                bookPaymentView.email = userInfo.email
                bookPaymentView.launchPayment()
                bookPaymentView.enableFilter = false
            }
            scrollView.setContentOffset(CGPoint(x: 0, y: max(0, scrollView.contentSize.height - scrollView.bounds.size.height)), animated: true)
        } else {
            bookPaymentView.enableFilter = true
        }
    }
    
    func onConditionSwitchClicked(_ bookPaymentConditionView: BookPaymentConditionView) {
        bookPaymentMailFormView?.checkValidation(.error)
    }
    
    func onConditionLabelClicked(_ bookPaymentConditionView: BookPaymentConditionView) {
        guard let url = Configuration.cguURL else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: { (status) in })
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
}

extension BookPaymentViewController: BookPaymentViewDelegate {
    
    func onPaymentClicked(_ request: URLRequest, _ baseURL: String, _ bookPaymentView: BookPaymentView) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: BookPaymentWebViewController.identifier) as! BookPaymentWebViewController
        viewController.request = request
        viewController.viewModel = _viewModel
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overCurrentContext
        present(viewController, animated: true, completion: nil)
    }
    
    func onFilterClicked(_ bookPaymentView: BookPaymentView) {
        bookPaymentMailFormView?.checkValidation(.error)
        bookPaymentConditionView?.checkValidation()
    }
}

extension BookPaymentViewController: BookPaymentMailFormViewDelegate {
    
    func onReturnButtonClicked(_ bookPaymentMailFormView: BookPaymentMailFormView) {
        dismissKeyboard()
        bookPaymentConditionView?.checkValidation()
    }
    
    func valueChangedTextField(_ value: Bool, _ bookPaymentMailFormView: BookPaymentMailFormView) {
        if let bookPaymentConditionView = bookPaymentConditionView {
            bookPaymentConditionView.isEnable = value
        }
        
        if bookPaymentConditionView?.conditionSwitch.isOn ?? true {
            bookPaymentConditionView?.conditionSwitch.setOn(false, animated: true)
            if !_viewModel.isConnected {
                bookPaymentView.enablePaymentView = false
            }
            bookPaymentView.enableFilter = true
        }
    }
    
}

extension BookPaymentViewController: InformationViewDelegate {
    
    func onFirstButtonClicked(_ informationViewController: InformationViewController) {
        informationViewController.dismiss(animated: true) {}
    }
    
}

