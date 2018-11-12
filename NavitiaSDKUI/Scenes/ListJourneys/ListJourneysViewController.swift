//
//  ListJourneysViewController.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

protocol ListJourneysDisplayLogic: class {
    
    func displayFetchedJourneys(viewModel: ListJourneys.FetchJourneys.ViewModel)
}

open class ListJourneysViewController: UIViewController, ListJourneysDisplayLogic {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var fromPinLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var toPinLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var journeysCollectionView: UICollectionView!
    @IBOutlet weak var switchDepartureArrivalImageView: UIImageView!
    @IBOutlet weak var switchDepartureArrivalButton: UIButton!
    
    public var journeysRequest: JourneysRequest?
    private var interactor: ListJourneysBusinessLogic?
    private var router: (NSObjectProtocol & ListJourneysViewRoutingLogic & ListJourneysDataPassing)?
    private var viewModel: ListJourneys.FetchJourneys.ViewModel?

    // MARK: - Initialization
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initSDK()
        initArchitecture()
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        title = "journeys".localized(withComment: "Journeys", bundle: NavitiaSDKUI.shared.bundle)
        
        initNavigationBar()
        initHeader()
        initCollectionView()

        fetchJourneys()
    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        journeysCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func initSDK() {
        NavitiaSDKUI.shared.bundle = self.nibBundle
        UIFont.registerFontWithFilenameString(filenameString: "SDKIcons.ttf", bundle: NavitiaSDKUI.shared.bundle)
    }
    
    private func initArchitecture() {
        let viewController = self
        let interactor = ListJourneysInteractor()
        let presenter = ListJourneysPresenter()
        let router = ListJourneysRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    private func initNavigationBar() {
        addBackButton(targetSelector: #selector(backButtonPressed))
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = Configuration.Color.main
    }
    
    private func initHeader() {
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
    
    private func initCollectionView() {
        if #available(iOS 11.0, *) {
            journeysCollectionView?.contentInsetAdjustmentBehavior = .always
        }
        
        registerCollectionView()
    }
    
    private func registerCollectionView() {
        journeysCollectionView.register(UINib(nibName: JourneySolutionCollectionViewCell.identifier, bundle: self.nibBundle), forCellWithReuseIdentifier: JourneySolutionCollectionViewCell.identifier)
        journeysCollectionView.register(UINib(nibName: JourneySolutionLoadCollectionViewCell.identifier, bundle: self.nibBundle), forCellWithReuseIdentifier: JourneySolutionLoadCollectionViewCell.identifier)
        journeysCollectionView.register(UINib(nibName: RidesharingInformationCollectionViewCell.identifier, bundle: self.nibBundle), forCellWithReuseIdentifier: RidesharingInformationCollectionViewCell.identifier)
        journeysCollectionView.register(UINib(nibName: JourneyEmptySolutionCollectionViewCell.identifier, bundle: self.nibBundle), forCellWithReuseIdentifier: JourneyEmptySolutionCollectionViewCell.identifier)
        journeysCollectionView.register(UINib(nibName: JourneyHeaderCollectionReusableView.identifier, bundle: self.nibBundle), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: JourneyHeaderCollectionReusableView.identifier)
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
            fetchJourneys()
        }
    }
    
    // MARK: - Fetch journeys
    
    private func fetchJourneys() {
        guard let journeysRequest = self.journeysRequest else {
            return
        }

        let request = ListJourneys.FetchJourneys.Request(journeysRequest: journeysRequest)
        
        interactor?.fetchJourneys(request: request)
    }
    
    func displayFetchedJourneys(viewModel: ListJourneys.FetchJourneys.ViewModel) {
        self.viewModel = viewModel
        
        guard let viewModel = self.viewModel else {
            return
        }
        
        viewModel.loaded == true ? (switchDepartureArrivalButton.isEnabled = true) : (switchDepartureArrivalButton.isEnabled = false)

        fromLabel.attributedText = viewModel.headerInformations.origin
        toLabel.attributedText = viewModel.headerInformations.destination
        dateTimeLabel.attributedText = viewModel.headerInformations.dateTime
        journeysCollectionView.reloadData()
    }
}

extension ListJourneysViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        guard let viewModel = viewModel else {
            return UICollectionViewCell()
        }
        // Loading
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
        // Carsharing
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
        if kind.isEqual(UICollectionView.elementKindSectionHeader) {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: JourneyHeaderCollectionReusableView.identifier, for: indexPath) as! JourneyHeaderCollectionReusableView
            cell.title = "carpooling".localized(withComment: "Carpooling", bundle: NavitiaSDKUI.shared.bundle)
            
            return cell
        }
        
        return UICollectionReusableView()
    }

    // MARK: - CollectionView Delegate
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // Carsharing : Header
        if section == 1 {
            return CGSize(width: 0, height: 30)
        }
        // Null
        return CGSize.zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else {
            return
        }
        
        var selector: Selector?
        
        if viewModel.loaded {
            if indexPath.section == 0 && viewModel.displayedJourneys.count > indexPath.row {
                selector = NSSelectorFromString("routeToJourneySolutionRoadmapWithIndexPath:")
            } else if indexPath.section == 1 && viewModel.displayedRidesharings.count > indexPath.row - 1 && indexPath.row != 0 {
                selector = NSSelectorFromString("routeToListRidesharingOffersWithIndexPath:")
            }
            
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: indexPath)
            }
        }
    }

    // MARK: - CollectionView Delegate Flow Layout
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var safeAreaWidth: CGFloat = 20.0
        if #available(iOS 11.0, *) {
            safeAreaWidth += self.journeysCollectionView.safeAreaInsets.left + self.journeysCollectionView.safeAreaInsets.right
        }
        
        guard let viewModel = viewModel else {
            return CGSize()
        }
        
        // Loading
        if !viewModel.loaded {
            return CGSize(width: self.journeysCollectionView.frame.size.width - safeAreaWidth, height: 130)
        }
        // Journey
        if indexPath.section == 0 {
            if viewModel.displayedJourneys.count == 0 {
                // No journey
                return CGSize(width: self.journeysCollectionView.frame.size.width - safeAreaWidth, height: 35)
            } else if viewModel.displayedJourneys[indexPath.row].walkingInformation == nil {
                // Result
                return CGSize(width: self.journeysCollectionView.frame.size.width - safeAreaWidth, height: 97)
            }
            
            return CGSize(width: self.journeysCollectionView.frame.size.width - safeAreaWidth, height: 130)
        }
        // Carsharing
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                // Header
                return CGSize(width: self.journeysCollectionView.frame.size.width - safeAreaWidth, height: 75)
            } else if indexPath.row == 1 && viewModel.displayedRidesharings.count == 0 {
                // No journey
                return CGSize(width: self.journeysCollectionView.frame.size.width - safeAreaWidth, height: 35)
            }
            // Result
            return CGSize(width: self.journeysCollectionView.frame.size.width - safeAreaWidth, height: 97)
        }
        // Other
        return CGSize(width: self.journeysCollectionView.frame.size.width - safeAreaWidth, height: 130)
    }
}
