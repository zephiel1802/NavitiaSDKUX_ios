//
//  JourneySolutionViewController.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

protocol JourneySolutionDisplayLogic: class {
    
    func displayFetchedJourneys(viewModel: JourneySolution.FetchJourneys.ViewModel)
    
}

open class JourneySolutionViewController: UIViewController {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var fromPinLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var toPinLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var switchDepartureArrivalImageView: UIImageView!
    @IBOutlet weak var switchDepartureArrivalButton: UIButton!
    
    public var journeysRequest: JourneysRequest?
    
    private var interactor: JourneySolutionBusinessLogic?
    private var router: (NSObjectProtocol & JourneySolutionViewRoutingLogic & JourneySolutionDataPassing)?
    private var viewModel: JourneySolution.FetchJourneys.ViewModel?

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        _initSDK()
        _initArchitecture()
        _initHeader()
        _initCollectionView()
        
        _fetchJourneys()
    }
    
    // MARK: - Initialization
    
    private func _initSDK() {
        NavitiaSDKUI.shared.bundle = self.nibBundle
        UIFont.registerFontWithFilenameString(filenameString: "SDKIcons.ttf", bundle: NavitiaSDKUI.shared.bundle)
    }
    
    private func _initArchitecture() {
        let viewController = self
        let interactor = JourneySolutionInteractor()
        let presenter = JourneySolutionPresenter()
        let router = JourneySolutionRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    private func _initHeader() {
        title = "journeys".localized(withComment: "Journeys", bundle: NavitiaSDKUI.shared.bundle)
        addBackButton(targetSelector: #selector(backButtonPressed))
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = Configuration.Color.main
        
        switchDepartureArrivalImageView.image = UIImage(named: "switch", in: NavitiaSDKUI.shared.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        switchDepartureArrivalImageView.tintColor = Configuration.Color.main
        
        fromPinLabel.attributedText = NSMutableAttributedString()
            .icon("location-pin", color: Configuration.Color.origin, size: 22)
        
        toPinLabel.attributedText = NSMutableAttributedString()
            .icon("location-pin", color: Configuration.Color.destination, size: 22)
        
        if let backgroundColor = navigationController?.navigationBar.barTintColor {
            searchView.backgroundColor = backgroundColor
        }
    }
    
    private func _initCollectionView() {
        if #available(iOS 11.0, *) {
            collectionView?.contentInsetAdjustmentBehavior = .always
        }
        collectionView.collectionViewLayout.invalidateLayout()
        _registerCollectionView()
    }
    
    private func _registerCollectionView() {
        collectionView.register(UINib(nibName: JourneySolutionCollectionViewCell.identifier, bundle: self.nibBundle), forCellWithReuseIdentifier: JourneySolutionCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: JourneySolutionLoadCollectionViewCell.identifier, bundle: self.nibBundle), forCellWithReuseIdentifier: JourneySolutionLoadCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: RidesharingInformationCollectionViewCell.identifier, bundle: self.nibBundle), forCellWithReuseIdentifier: RidesharingInformationCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: JourneyEmptySolutionCollectionViewCell.identifier, bundle: self.nibBundle), forCellWithReuseIdentifier: JourneyEmptySolutionCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: JourneyHeaderCollectionReusableView.identifier, bundle: self.nibBundle), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: JourneyHeaderCollectionReusableView.identifier)
    }
    
    // MARK: - Events
    
    @objc func backButtonPressed() {
        if isRootViewController() {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func switchDepartureArrivalCoordinates(_ sender: UIButton) {
        if journeysRequest != nil {
            switchDepartureArrivalButton.isEnabled = false
            journeysRequest!.switchOriginDestination()
            _fetchJourneys()
        }
    }
    
}

extension JourneySolutionViewController: JourneySolutionDisplayLogic {
    
    // MARK: - Fetch journeys
    
    private func _fetchJourneys() {
        guard let journeysRequest = self.journeysRequest else {
            return
        }

        let request = JourneySolution.FetchJourneys.Request(journeysRequest: journeysRequest)
        interactor?.fetchJourneys(request: request)
    }
    
    func displayFetchedJourneys(viewModel: JourneySolution.FetchJourneys.ViewModel) {
        self.viewModel = viewModel
        
        guard let viewModel = self.viewModel else {
            return
        }

        fromLabel.attributedText = viewModel.headerInformations.origin
        toLabel.attributedText = viewModel.headerInformations.destination
        dateTimeLabel.attributedText = viewModel.headerInformations.dateTime

        if viewModel.loaded {
            switchDepartureArrivalButton.isEnabled = true
        }
        
        collectionView.reloadData()
    }
    
}

extension JourneySolutionViewController: UICollectionViewDataSource {
    
    // MARK: - CollectionView Data Source
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let journeysRequest = self.journeysRequest, let viewModel = self.viewModel else {
            return 0
        }
        // Journey + Carsharing
        if journeysRequest.ridesharingIsActive && viewModel.loaded {
            return 2
        }
        
        // Journey
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = self.viewModel else {
            return 0
        }
        // Loading
        if !viewModel.loaded {
            return 4
        }
        // Carsharing : Header + Empty
        if section == 1 && viewModel.displayedRidesharings.count == 0 {
            return 2
        }
        // Journey : Empty
        if section == 0 && viewModel.displayedJourneys.count == 0 {
            return 1
        }
        // Carsharing : Header + Solution
        if section == 1 {
            return viewModel.displayedRidesharings.count + 1
        }
        // Journey : Solution
        return viewModel.displayedJourneys.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Loading
        guard let viewModel = viewModel else {
            return UICollectionViewCell()
        }
        
        if !viewModel.loaded {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JourneySolutionLoadCollectionViewCell.identifier, for: indexPath) as? JourneySolutionLoadCollectionViewCell {
                return cell
            }
        }
        // Journey
        if indexPath.section == 0 {
            // No journey
            if viewModel.displayedJourneys.count == 0 {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JourneyEmptySolutionCollectionViewCell.identifier, for: indexPath) as? JourneyEmptySolutionCollectionViewCell {
                    return cell
                }
            }
            // Result
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JourneySolutionCollectionViewCell.identifier, for: indexPath) as? JourneySolutionCollectionViewCell {
                cell.setup(displayedJourney: viewModel.displayedJourneys[indexPath.row],
                            displayedDisruptions: viewModel.disruptions)
                return cell
            }
        }
        // Carsharing A FAIRE
        if indexPath.section == 1 {
            // Header
            if indexPath.row == 0 {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RidesharingInformationCollectionViewCell.identifier, for: indexPath) as? RidesharingInformationCollectionViewCell {
                    return cell
                }
            }
            // No journey
            if indexPath.row == 1 && viewModel.displayedRidesharings.count == 0 {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JourneyEmptySolutionCollectionViewCell.identifier, for: indexPath) as? JourneyEmptySolutionCollectionViewCell {
                    cell.text = "no_carpooling_options_found".localized(withComment: "No carpooling options found", bundle: NavitiaSDKUI.shared.bundle)
                    return cell
                }
            }
            // Result
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JourneySolutionCollectionViewCell.identifier, for: indexPath) as? JourneySolutionCollectionViewCell {
                cell.setup(displayedJourney: viewModel.displayedRidesharings[indexPath.row - 1],
                            displayedDisruptions: viewModel.disruptions)
                return cell
            }
        }
        // Other
        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind.isEqual(UICollectionElementKindSectionHeader) {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: JourneyHeaderCollectionReusableView.identifier, for: indexPath) as! JourneyHeaderCollectionReusableView
            cell.title = "carpooling".localized(withComment: "Carpooling", bundle: NavitiaSDKUI.shared.bundle)
            return cell
        }
        return UICollectionReusableView()
    }
    
}

extension JourneySolutionViewController: UICollectionViewDelegate {
    
    // MARK: - CollectionView Delegate
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // Carsharing : Header
        if section == 1 {
            return CGSize(width: 0, height: 30)
        }
        // Null
        return CGSize(width: 0, height: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else {
            return
        }
        
        var selector: Selector!
        
        if viewModel.loaded {
            if indexPath.section == 0 && viewModel.displayedJourneys.count > indexPath.row {
                selector = NSSelectorFromString("routeToJourneySolutionRoadmapWithIndexPath:")
            } else if indexPath.section == 1 && viewModel.displayedRidesharings.count > indexPath.row - 1 && indexPath.row != 0 {
                selector = NSSelectorFromString("routeToJourneySolutionRidesharingWithIndexPath:")
            }
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: indexPath)
            }
        }
    }
    
}

extension JourneySolutionViewController: UICollectionViewDelegateFlowLayout {
    
    // MARK: - CollectionView Delegate Flow Layout
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var safeAreaWidth: CGFloat = 20.0
        if #available(iOS 11.0, *) {
            safeAreaWidth += self.collectionView.safeAreaInsets.left + self.collectionView.safeAreaInsets.right
        }
        guard let viewModel = viewModel else {
            return CGSize()
        }
        
        // Loading
        if !viewModel.loaded {
            return CGSize(width: self.collectionView.frame.size.width - safeAreaWidth, height: 130)
        }
        // Journey
        if indexPath.section == 0 {
            // No journey
            if viewModel.displayedJourneys.count == 0 {
                return CGSize(width: self.collectionView.frame.size.width - safeAreaWidth, height: 35)
            }
            // Result
            if viewModel.displayedJourneys[indexPath.row].walkingInformation == nil {
                return CGSize(width: self.collectionView.frame.size.width - safeAreaWidth, height: 97)
            }
            return CGSize(width: self.collectionView.frame.size.width - safeAreaWidth, height: 130)
        }
        // Carsharing
        if indexPath.section == 1 {
            // Header
            if indexPath.row == 0 {
                return CGSize(width: self.collectionView.frame.size.width - safeAreaWidth, height: 75)
            }
            // No journey
            if indexPath.row == 1 && viewModel.displayedRidesharings.count == 0 {
                return CGSize(width: self.collectionView.frame.size.width - safeAreaWidth, height: 35)
            }
            // Result
            return CGSize(width: self.collectionView.frame.size.width - safeAreaWidth, height: 97)
        }
        // Other
        return CGSize(width: self.collectionView.frame.size.width - safeAreaWidth, height: 130)
    }

}
