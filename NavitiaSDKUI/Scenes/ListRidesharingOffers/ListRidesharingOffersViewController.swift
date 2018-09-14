//
//  ListRidesharingViewController.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

protocol ListRidesharingOffersDisplayLogic: class {
    
    func displayRidesharingOffers(viewModel: ListRidesharingOffers.GetRidesharingOffers.ViewModel)
}

internal class ListRidesharingOffersViewController: UIViewController, ListRidesharingOffersDisplayLogic {
    
    @IBOutlet weak var journeySummaryView: JourneySolutionView!
    @IBOutlet weak var ridesharingOffersCollectionView: UICollectionView!
    
    static var identifier: String {
        return String(describing: self)
    }
    
    internal var router: (NSObjectProtocol & ListRidesharingOffersRoutingLogic & ListRidesharingOffersDataPassing)?
    private var interactor: ListRidesharingOffersBusinessLogic?
    private var viewModel: ListRidesharingOffers.GetRidesharingOffers.ViewModel?
    
    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        _initSDK()
        _initArchitecture()
    }
    
    private func _initSDK() {
        NavitiaSDKUI.shared.bundle = self.nibBundle
        UIFont.registerFontWithFilenameString(filenameString: "SDKIcons.ttf", bundle: NavitiaSDKUI.shared.bundle)
    }
    
    private func _initArchitecture() {
        let viewController = self
        let interactor = ListRidesharingOffersInteractor()
        let presenter = ListRidesharingOffersPresenter()
        let router = ListRidesharingOffersRouter()

        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "carpooling".localized(withComment: "Carpooling", bundle: NavitiaSDKUI.shared.bundle)
        ridesharingOffersCollectionView.register(UINib(nibName: RidesharingOfferCollectionViewCell.identifier, bundle: self.nibBundle), forCellWithReuseIdentifier: RidesharingOfferCollectionViewCell.identifier)
        
        getRidesharingOffers()
    }
    
    func displayRidesharingOffers(viewModel: ListRidesharingOffers.GetRidesharingOffers.ViewModel) {
        self.viewModel = viewModel
        
        self.journeySummaryView.setRidesharingData(duration: viewModel.journeySummary.duration, sections: viewModel.journeySummary.sections)
        self.ridesharingOffersCollectionView.reloadData()
    }
    
    private func getRidesharingOffers() {
        let ridesharingOffersRequest = ListRidesharingOffers.GetRidesharingOffers.Request()
        interactor?.getRidesharingOffers(request: ridesharingOffersRequest)
    }
}

extension ListRidesharingOffersViewController: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else {
            return 0
        }
        
        return viewModel.displayedRidesharingOffers.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RidesharingOfferCollectionViewCell.identifier, for: indexPath) as? RidesharingOfferCollectionViewCell , let targetRidesharingOffer = self.viewModel?.displayedRidesharingOffers[safe: indexPath.row] {
            cell.network = targetRidesharingOffer.network
            cell.departureDate = targetRidesharingOffer.departure
            cell.setPicture(url: targetRidesharingOffer.driverPictureURL)
            cell.driverNickname = targetRidesharingOffer.driverNickname
            cell.driverGender = targetRidesharingOffer.driverGender
            cell.setDriverRating(targetRidesharingOffer.ratingCount)
            cell.setFullStar(targetRidesharingOffer.rating)
            cell.setSeatsCount(targetRidesharingOffer.seatsCount)
            cell.price = targetRidesharingOffer.price
            cell.delegate = self
            
            return cell
        }
        
        return UICollectionViewCell()
    }
}

extension ListRidesharingOffersViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var safeAreaWidth: CGFloat = 20.0
        if #available(iOS 11.0, *) {
            safeAreaWidth += self.ridesharingOffersCollectionView.safeAreaInsets.left + self.ridesharingOffersCollectionView.safeAreaInsets.right
        }
        
        return CGSize(width: self.ridesharingOffersCollectionView.frame.size.width - safeAreaWidth, height: 155)
    }
}

extension ListRidesharingOffersViewController: RidesharingOfferCollectionViewCellDelegate {
    
    func onBookButtonClicked(_ journeyRidesharingCollectionViewCell: RidesharingOfferCollectionViewCell) {
        print("onBookButtonClicked CALLED")
    }
}
