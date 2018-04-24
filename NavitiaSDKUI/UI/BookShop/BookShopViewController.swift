//
//  BookShopViewController.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 23/04/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

open class BookShopViewController: UIViewController {

    @IBOutlet weak var breadcrumbView: BreadcrumbView!
    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var _viewModel: BookShopViewModel! {
        didSet {
            self._viewModel.bookShopDidChange = { [weak self] bookShopViewModel in
                self?.collectionView.reloadData()
            }
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        NavitiaSDKUIConfig.shared.bundle = self.nibBundle
        
        UIFont.registerFontWithFilenameString(filenameString: "SDKIcons.ttf", bundle: NavitiaSDKUIConfig.shared.bundle)
        
        if #available(iOS 11.0, *) {
            collectionView?.contentInsetAdjustmentBehavior = .always
        }
        
        _setupInterface()
       _registerCollectionView()
        
        _viewModel = BookShopViewModel()
      //  _viewModel.request(with: inParameters)
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override open func viewDidLayoutSubviews() {}
    
    private func _registerCollectionView() {
        collectionView.register(UINib(nibName: TicketCollectionViewCell.identifier, bundle: self.nibBundle), forCellWithReuseIdentifier: TicketCollectionViewCell.identifier)
    }
    
    private func _setupInterface() {
        let breadcrumbView = BreadcrumbView()
        breadcrumbView.delegate = self
        breadcrumbView.stateBreadcrumb = .shop
        breadcrumbView.translatesAutoresizingMaskIntoConstraints = false
        self.breadcrumbView.addSubview(breadcrumbView)
        
        NSLayoutConstraint(item: breadcrumbView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.breadcrumbView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: breadcrumbView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.breadcrumbView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: breadcrumbView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.breadcrumbView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: breadcrumbView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.breadcrumbView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0).isActive = true
        
        typeSegmentedControl.tintColor = Configuration.Color.main
        typeSegmentedControl.setTitle("Titres unitaires".localized(withComment: "Titres unitaires", bundle: NavitiaSDKUIConfig.shared.bundle), forSegmentAt: 0)
        typeSegmentedControl.setTitle("Abonnements".localized(withComment: "Abonnements", bundle: NavitiaSDKUIConfig.shared.bundle), forSegmentAt: 1)
    }

    @IBAction func onTypePressedSegmentControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("coucououcoucuouc 1")
        case 1:
            print("coucououcoucuouc 2")
        default:
            break
        }
        collectionView.reloadData()
    }
    
}

extension BookShopViewController: UICollectionViewDataSource {

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Send count - SDK Partner
        if typeSegmentedControl.selectedSegmentIndex == 1 {
            return _viewModel.abonnement.count
        }
        return _viewModel.ticket.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TicketCollectionViewCell.identifier, for: indexPath) as? TicketCollectionViewCell {
            if typeSegmentedControl.selectedSegmentIndex == 1 {
                cell.title = _viewModel.abonnement[indexPath.row].name
                cell.amount = _viewModel.abonnement[indexPath.row].count
            } else {
                cell.title = _viewModel.ticket[indexPath.row].name
                cell.amount = _viewModel.ticket[indexPath.row].count
            }
            cell.descript = "[DESCRIPTION]"
            cell.setPrice(999.99, currency: "CAD")
            cell.delegate = self
            cell.indexPath = indexPath
            
            return cell
        }
        return UICollectionViewCell()
    }
    
}

extension BookShopViewController: UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // No Action
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

extension BookShopViewController: BreadcrumbViewProtocol {
    
    func onDismissButtonClicked(_ BreadcrumbView: BreadcrumbView) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension BookShopViewController: TicketCollectionViewCellDelegate {
    
    func onInformationPressedButton(_ ticketCollectionViewCell: TicketCollectionViewCell) {
        print("Oui je veux une information sur le titre")
    }
    
    func onAddBasketPressedButton(_ ticketCollectionViewCell: TicketCollectionViewCell) {
        print("Oui je veux un ticket")
        if typeSegmentedControl.selectedSegmentIndex == 1 {
            _viewModel.abonnement[ticketCollectionViewCell.indexPath.row].count = 1
        }
        _viewModel.ticket[ticketCollectionViewCell.indexPath.row].count = 1
    }
    
    func onLessAmountPressedButton(_ ticketCollectionViewCell: TicketCollectionViewCell) {
        print("Oui je veux enlever un ticket")
        if typeSegmentedControl.selectedSegmentIndex == 1 {
            _viewModel.abonnement[ticketCollectionViewCell.indexPath.row].count -= 1
        }
        _viewModel.ticket[ticketCollectionViewCell.indexPath.row].count -= 1
    }
    
    func onMoreAmountPressendButton(_ ticketCollectionViewCell: TicketCollectionViewCell) {
        if typeSegmentedControl.selectedSegmentIndex == 1 {
            _viewModel.abonnement[ticketCollectionViewCell.indexPath.row].count += 1
        }
        _viewModel.ticket[ticketCollectionViewCell.indexPath.row].count += 1
    }

}

