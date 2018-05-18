//
//  BookShopViewController.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

@objc public protocol BookShopViewControllerDelegate {
    
    func onDismissBookShopViewController()
    
}

@objc open class BookShopViewController: UIViewController {

    @IBOutlet weak var statusBarView: UIView!
    @IBOutlet weak var breadcrumbContainerView: BreadcrumbView!
    @IBOutlet weak var validateBasketContainerView: UIView!
    @IBOutlet weak var validateBasketContainerHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var typeSegmentedContainerView: UIView!
    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var collectionViewBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var warningContainerView: UIView!
    
    private var _validateBasketView: ValidateBasketView!
    private var _breadcrumbView: BreadcrumbView!
    private var _validateBasketHeight: CGFloat = 50
    @objc public var delegate: BookShopViewControllerDelegate?
    
    fileprivate var _viewModel: BookShopViewModel! {
        didSet {
            self._viewModel.bookShopDidChange = { [weak self] bookShopViewModel in
                self?.collectionView.reloadData()
                self?._reloadCart()
            }
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        NavitiaSDKUI.shared.bundle = self.nibBundle
        UIFont.registerFontWithFilenameString(filenameString: "SDKIcons.ttf", bundle: NavitiaSDKUI.shared.bundle)
        
        if #available(iOS 11.0, *) {
            collectionView?.contentInsetAdjustmentBehavior = .always
        }
        
        _setupInterface()
        _registerCollectionView()
        _viewModel = BookShopViewModel()
        _viewModel.request()
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override open func viewDidLayoutSubviews() {
        if #available(iOS 11.0, *) {
            validateBasketContainerHeightContraint.constant = _validateBasketHeight + view.safeAreaInsets.bottom
        }
    }
    
    private func _registerCollectionView() {
        collectionView.register(UINib(nibName: TicketCollectionViewCell.identifier, bundle: self.nibBundle), forCellWithReuseIdentifier: TicketCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: TicketCollectionViewCell.identifier, bundle: self.nibBundle), forCellWithReuseIdentifier: TicketCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: TicketLoadCollectionViewCell.identifier, bundle: self.nibBundle), forCellWithReuseIdentifier: TicketLoadCollectionViewCell.identifier)
    }
    
    private func _setupInterface() {
        statusBarView.backgroundColor = Configuration.Color.main
        validateBasketContainerView.backgroundColor = Configuration.Color.main
        _animationValidateBasket(animated: false, hidden: true)
        
        _setupBreadcrumbView()
        _setupValidateBasketView()
        _setupTypeSegmentedControl()
        
        if let color = view.backgroundColor?.cgColor {
            typeSegmentedContainerView.addShadow(color: color, offset: CGSize(width: 0.0, height: 7.0), opacity: 1, radius: 7)
        }
    }
    
    private func _setupBreadcrumbView() {
        _breadcrumbView = BreadcrumbView()
        _breadcrumbView.delegate = self.delegate
        _breadcrumbView.stateBreadcrumb = .shop
        _breadcrumbView.translatesAutoresizingMaskIntoConstraints = false
        breadcrumbContainerView.addSubview(_breadcrumbView)
        
        NSLayoutConstraint(item: _breadcrumbView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: breadcrumbContainerView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: _breadcrumbView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: breadcrumbContainerView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: _breadcrumbView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: breadcrumbContainerView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: _breadcrumbView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: breadcrumbContainerView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0).isActive = true
    }
    
    private func _setupValidateBasketView() {
        _validateBasketView = ValidateBasketView()
        _validateBasketView.delegate = self
        _validateBasketView.translatesAutoresizingMaskIntoConstraints = false
        validateBasketContainerView.addSubview(_validateBasketView)
        
        NSLayoutConstraint(item: _validateBasketView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: validateBasketContainerView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: _validateBasketView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1, constant: _validateBasketHeight).isActive = true
        NSLayoutConstraint(item: _validateBasketView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: validateBasketContainerView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: _validateBasketView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: validateBasketContainerView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0).isActive = true
    }
    
    private func _setupTypeSegmentedControl() {
        typeSegmentedControl.tintColor = Configuration.Color.main
        typeSegmentedControl.setTitleTextAttributes([kCTFontAttributeName : UIFont.systemFont(ofSize: 13, weight: .regular)], for: .normal)
        typeSegmentedControl.setTitleTextAttributes([kCTFontAttributeName : UIFont.systemFont(ofSize: 13, weight: .bold)], for: .selected)
        typeSegmentedControl.setTitle("unit_tickets".localized(withComment: "Unit tickets", bundle: NavitiaSDKUI.shared.bundle), forSegmentAt: 0)
        typeSegmentedControl.setTitle("subscriptions".localized(withComment: "Subscriptions", bundle: NavitiaSDKUI.shared.bundle), forSegmentAt: 1)
    }
    
    private func _animationValidateBasket(animated: Bool, hidden: Bool) {
        var duration = 0.0
        if animated {
            duration = 0.4
        }
        if hidden {
            self.collectionViewBottomContraint.constant = 0
            UIView.animate(withDuration: duration, animations: {
                self.validateBasketContainerView.alpha = 0
            }, completion: {
                (value: Bool) in
                self.validateBasketContainerView.isHidden = true
            })
        } else {
            collectionViewBottomContraint.constant = validateBasketContainerHeightContraint.constant
            validateBasketContainerView.isHidden = false
            UIView.animate(withDuration: duration, animations: {
                self.validateBasketContainerView.alpha = 1
            }, completion: {
                (value: Bool) in
            })
        }
    }
    
    private func _reloadCart() {
        if NavitiaSDKPartners.shared.cart.isEmpty {
            _animationValidateBasket(animated: true, hidden: true)
        } else {
            _animationValidateBasket(animated: true, hidden: false)
            _validateBasketView.setAmount(NavitiaSDKPartners.shared.cartTotalPrice.value, currency: NavitiaSDKPartners.shared.cartTotalPrice.currency)
        }
    }

    @IBAction func onTypePressedSegmentControl(_ sender: UISegmentedControl) {
        self._viewModel.bookShopDidChange!(self._viewModel)
    }
    
}

extension BookShopViewController: UICollectionViewDataSource {

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if _viewModel.loading {
            return 4
        }
        if _viewModel.bookOffer.count > typeSegmentedControl.selectedSegmentIndex {
            return _viewModel.bookOffer[typeSegmentedControl.selectedSegmentIndex].count
        }
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if _viewModel.loading {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TicketLoadCollectionViewCell.identifier, for: indexPath) as? TicketLoadCollectionViewCell {
                return cell
            }
        }

        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TicketCollectionViewCell.identifier, for: indexPath) as? TicketCollectionViewCell {
            cell.delegate = self
            cell.indexPath = indexPath
            cell.title = _viewModel.bookOffer[typeSegmentedControl.selectedSegmentIndex][indexPath.row].title
            cell.descript = _viewModel.bookOffer[typeSegmentedControl.selectedSegmentIndex][indexPath.row].shortDescription
            cell.id = _viewModel.bookOffer[typeSegmentedControl.selectedSegmentIndex][indexPath.row].id
            cell.maxQuantity = _viewModel.bookOffer[typeSegmentedControl.selectedSegmentIndex][indexPath.row].maxQuantity
            cell.quantity = NavitiaSDKPartners.shared.cart.filter({ $0.bookOffer.id == cell.id }).first?.quantity ?? 0
            cell.setPrice(_viewModel.bookOffer[typeSegmentedControl.selectedSegmentIndex][indexPath.row].price,
                          currency: _viewModel.bookOffer[typeSegmentedControl.selectedSegmentIndex][indexPath.row].currency)
            return cell
        }
        return UICollectionViewCell()
    }
    
}

extension BookShopViewController: UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var safeAreaWidth: CGFloat = 20.0
        if #available(iOS 11.0, *) {
            safeAreaWidth += self.collectionView.safeAreaInsets.left + self.collectionView.safeAreaInsets.right
        }
        return CGSize(width: self.collectionView.frame.size.width - safeAreaWidth, height: 110)
    }
    
}

extension BookShopViewController: TicketCollectionViewCellDelegate {
    
    func onInformationPressedButton(_ ticketCollectionViewCell: TicketCollectionViewCell) {
        let informationViewController = InformationViewController(nibName: "InformationView", bundle: NavitiaSDKUI.shared.bundle)
        informationViewController.modalTransitionStyle = .crossDissolve
        informationViewController.modalPresentationStyle = .overCurrentContext
        informationViewController.titleButton = [String(format: "%@ !", "understand".localized(withComment: "Understand", bundle: NavitiaSDKUI.shared.bundle))]
        informationViewController.delegate = self
        if let indexPath = ticketCollectionViewCell.indexPath {
            informationViewController.information = _viewModel.bookOffer[typeSegmentedControl.selectedSegmentIndex][indexPath.row].legalInfos
        }
        present(informationViewController, animated: true) {}
    }
    
    func onLessAmountPressedButton(_ ticketCollectionViewCell: TicketCollectionViewCell) {
        if let id = ticketCollectionViewCell.id {
            NavitiaSDKPartners.shared.removeOffer(offerId: id, callbackSuccess: {
                ticketCollectionViewCell.quantity -= 1
                self._reloadCart()
            }) { (codeStatus, data) in }
        }
    }
    
    func onMoreAmountPressendButton(_ ticketCollectionViewCell: TicketCollectionViewCell) {
        if let id = ticketCollectionViewCell.id, ticketCollectionViewCell.quantity < ticketCollectionViewCell.maxQuantity {
            NavitiaSDKPartners.shared.addOffer(offerId: id, callbackSuccess: {
                ticketCollectionViewCell.quantity += 1
                self._reloadCart()
            }) { (codeStatus, data) in }
        }
    }

}

extension BookShopViewController: ValidateBasketViewDelegate {
    
    func onValidateButtonClicked(_ validateBasketView: ValidateBasketView) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: BookPaymentViewController.identifier) as! BookPaymentViewController

        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overCurrentContext
        NavitiaSDKPartners.shared.getOrderValidation(callbackSuccess: { (_) in
            self.present(viewController, animated: true) {}
        }) { (statusCode, data) in
            
        }
      //  present(viewController, animated: true) {}
    }
    
}

extension BookShopViewController: InformationViewDelegate {
    
    func onFirstButtonClicked(_ informationViewController: InformationViewController) {
        informationViewController.dismiss(animated: true) {}
    }
    
}
