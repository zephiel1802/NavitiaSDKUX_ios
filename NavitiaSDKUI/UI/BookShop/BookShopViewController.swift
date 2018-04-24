//
//  BookShopViewController.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 23/04/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

open class BookShopViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        NavitiaSDKUIConfig.shared.bundle = self.nibBundle
        
        UIFont.registerFontWithFilenameString(filenameString: "SDKIcons.ttf", bundle: NavitiaSDKUIConfig.shared.bundle)
        
        if #available(iOS 11.0, *) {
            collectionView?.contentInsetAdjustmentBehavior = .always
        }
        
        _setupInterface()
        _registerCollectionView()
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func _registerCollectionView() {
        collectionView.register(UINib(nibName: TicketCollectionViewCell.identifier, bundle: self.nibBundle), forCellWithReuseIdentifier: TicketCollectionViewCell.identifier)
    }
    
    private func _setupInterface() {
        
    }
    
}

extension BookShopViewController: UICollectionViewDataSource {

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Send count - SDK Partner
        return 10
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TicketCollectionViewCell.identifier, for: indexPath) as? TicketCollectionViewCell {
          //  cell.setup(self._viewModel.journeys[indexPath.row])
            cell.title = "[TITLE]"
            cell.descript = "[DESCRIPTION]\n[DESCRIPTION LINE 2]"
            cell.setPrice(999.99, currency: "CAD")
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
