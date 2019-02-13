//
//  ListJourneysViewController.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

protocol ListJourneysDisplayLogic: class {
    
    func displaySearch(viewModel: ListJourneys.DisplaySearch.ViewModel)
    func callbackFetchedPhysicalModes(viewModel: ListJourneys.FetchPhysicalModes.ViewModel)
    func displayFetchedJourneys(viewModel: ListJourneys.FetchJourneys.ViewModel)
}

open class ListJourneysViewController: UIViewController, ListJourneysDisplayLogic, JourneyRootViewController {
    
    @IBOutlet weak var searchView: SearchView!
    @IBOutlet weak var journeysCollectionView: UICollectionView!
    
    public var journeysRequest: JourneysRequest?
    internal var interactor: ListJourneysBusinessLogic?
    private var router: (NSObjectProtocol & ListJourneysViewRoutingLogic & ListJourneysDataPassing)?
    private var viewModel: ListJourneys.FetchJourneys.ViewModel?
    
    let activityView = UIActivityIndicatorView(style: .gray)

    static var identifier: String {
        return String(describing: self)
    }
    
    // MARK: - Initialization
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
        initArchitecture()
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        title = "journeys".localized()
        
        initNavigationBar()
        initHeader()
        initCollectionView()

        interactor?.journeysRequest = journeysRequest
        interactor?.displaySearch(request: ListJourneys.DisplaySearch.Request())
        
        interactor?.journeysRequest?.allowedPhysicalModes != nil ? fetchPhysicalMode() : fetchJourneys()
    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        initActivityView()
        journeysCollectionView.collectionViewLayout.invalidateLayout()
        reloadCollectionViewLayout()
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
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func initHeader() {
        searchView.delegate = self
    }
    
    private func initCollectionView() {
        let listJourneysCollectionViewLayout = ListJourneysCollectionViewLayout()
        
        listJourneysCollectionViewLayout.delegate = self
        journeysCollectionView.setCollectionViewLayout(listJourneysCollectionViewLayout, animated: true)
        
        if #available(iOS 11.0, *) {
            journeysCollectionView?.contentInsetAdjustmentBehavior = .always
        }
        
        journeysCollectionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        registerCollectionView()
    }
    
    private func registerCollectionView() {
        journeysCollectionView.register(UINib(nibName: JourneySolutionCollectionViewCell.identifier, bundle: self.nibBundle), forCellWithReuseIdentifier: JourneySolutionCollectionViewCell.identifier)
        journeysCollectionView.register(UINib(nibName: JourneySolutionLoadCollectionViewCell.identifier, bundle: self.nibBundle), forCellWithReuseIdentifier: JourneySolutionLoadCollectionViewCell.identifier)
        journeysCollectionView.register(UINib(nibName: RidesharingInformationCollectionViewCell.identifier, bundle: self.nibBundle), forCellWithReuseIdentifier: RidesharingInformationCollectionViewCell.identifier)
        journeysCollectionView.register(UINib(nibName: JourneyEmptySolutionCollectionViewCell.identifier, bundle: self.nibBundle), forCellWithReuseIdentifier: JourneyEmptySolutionCollectionViewCell.identifier)
        journeysCollectionView.register(UINib(nibName: JourneyHeaderCollectionReusableView.identifier, bundle: self.nibBundle), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: JourneyHeaderCollectionReusableView.identifier)
    }
    
    private func initActivityView() {
        activityView.center.x = journeysCollectionView.center.x
        activityView.frame.origin.y = 10
        
        journeysCollectionView.addSubview(activityView)
    }
    
    // MARK: - Events
    
    @objc func backButtonPressed() {
        router?.routeToBack()
    }
    
    func displaySearch(viewModel: ListJourneys.DisplaySearch.ViewModel) {
        searchView.fromTextField.text = viewModel.fromName
        searchView.toTextField.text = viewModel.toName
        searchView.dateTime = viewModel.dateTime
        
        searchView.accessibilityLabel = viewModel.accessibilityHeader
        searchView.switchDepartureArrivalButton.accessibilityLabel = viewModel.accessibilitySwitchButton
    }
    
    internal func fetchPhysicalMode() {
        guard let journeysRequest = interactor?.journeysRequest else {
            return
        }
        
        activityView.startAnimating()
        interactor?.fetchPhysicalModes(request: ListJourneys.FetchPhysicalModes.Request(journeysRequest: journeysRequest))
    }
    
    func callbackFetchedPhysicalModes(viewModel: ListJourneys.FetchPhysicalModes.ViewModel) {
        guard let allowedPhysicalModes = interactor?.journeysRequest?.allowedPhysicalModes else {
            fetchJourneys()
            return
        }
        
        var physicalModes = viewModel.physicalModes
        
        for physicalMode in allowedPhysicalModes {
            physicalModes = physicalModes.filter{$0 != physicalMode}
        }
        
        interactor?.journeysRequest?.forbiddenUris = physicalModes
        
        fetchJourneys()
    }
    
    // MARK: - Fetch journeys
    
    internal func fetchJourneys() {
        guard let journeysRequest = interactor?.journeysRequest else {
            return
        }

        activityView.startAnimating()
        let request = ListJourneys.FetchJourneys.Request(journeysRequest: journeysRequest)
        
        interactor?.fetchJourneys(request: request)
    }
    
    func displayFetchedJourneys(viewModel: ListJourneys.FetchJourneys.ViewModel) {
        self.viewModel = viewModel
        
        guard let viewModel = self.viewModel else {
            return
        }
        
        viewModel.loaded == true ? (searchView.lockSwitch = false) : (searchView.lockSwitch = true)
        journeysCollectionView.reloadData()

        reloadCollectionViewLayout()
        
        if viewModel.loaded {
            DispatchQueue.main.async(execute: { () -> Void in
                self.anim()
                self.activityView.stopAnimating()
            })
        }
    }
    
    private func reloadCollectionViewLayout() {
        guard let collectionViewLayout = journeysCollectionView.collectionViewLayout as? ListJourneysCollectionViewLayout else {
            return
        }
        
        collectionViewLayout.reloadLayout()
        
    }
    
    func anim() {
        let cells = journeysCollectionView.visibleCells
        let collectionViewHeight = journeysCollectionView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: collectionViewHeight)
            
        }
        
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 0.75, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter = delayCounter + 1
        }
    }
}

extension ListJourneysViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - CollectionView Data Source
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let journeysRequest = interactor?.journeysRequest, let viewModel = self.viewModel else {
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
            return 0
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
                cell.setup(displayedJourney: viewModel.displayedJourneys[indexPath.row])
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
                    cell.text = "no_carpooling_options_found".localized()
                    return cell
                }
            }
            // Result
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JourneySolutionCollectionViewCell.identifier, for: indexPath) as? JourneySolutionCollectionViewCell {
                cell.setup(displayedJourney: viewModel.displayedRidesharings[indexPath.row - 1])
                return cell
            }
        }
        // Other
        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind.isEqual(UICollectionView.elementKindSectionHeader) {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: JourneyHeaderCollectionReusableView.identifier, for: indexPath) as! JourneyHeaderCollectionReusableView
            cell.title = "carpooling".localized()
            
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
}

extension ListJourneysViewController: ListJourneysCollectionViewLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForCellAtIndexPath indexPath: IndexPath, width: CGFloat) -> CGFloat {
        guard let viewModel = viewModel else {
            return 0
        }
        
        // Loading
        if !viewModel.loaded {
            return 130
        }
        
        // Journey
        if indexPath.section == 0 {
            if viewModel.displayedJourneys.count == 0 {
                // No journey
                return 35
            }
            
            var height: CGFloat = 60
            if let _ = viewModel.displayedJourneys[safe: indexPath.row]?.walkingInformation {
                height += 30
            }
            
            if let sections = viewModel.displayedJourneys[safe: indexPath.row]?.friezeSections {
                let friezeView = FriezeView(frame: CGRect(x: 0, y: 0, width: width - 20, height: 27))
                friezeView.addSection(friezeSections: sections)
                
                return height + friezeView.frame.size.height
            }
        }
        
        // Carsharing
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                // Header
                return 75
            } else if indexPath.row == 1 && viewModel.displayedRidesharings.count == 0 {
                // No journey
                return 35
            }
            var height: CGFloat = 60
            if let _ = viewModel.displayedRidesharings[safe: indexPath.row - 1]?.walkingInformation {
                height += 30
            }
            
            if let sections = viewModel.displayedRidesharings[safe: indexPath.row - 1]?.friezeSections {
                let friezeView = FriezeView(frame: CGRect(x: 0, y: 0, width: width - 20, height: 27))
                friezeView.addSection(friezeSections: sections)
                
                return height + friezeView.frame.size.height
            }
        }
        
        // Other
        return 117
    }

    private func getHeightForJourneySolutionCollectionViewCell(indexPath: IndexPath, width: CGFloat) -> CGFloat {
        guard let viewModel = viewModel, let displayedJourney = viewModel.displayedJourneys[safe: indexPath.row] else {
            return 0
        }
        
        let height: CGFloat = 60
        let friezeView = FriezeView(frame: CGRect(x: 0, y: 0, width: width - 20, height: 27))
        friezeView.addSection(friezeSections: displayedJourney.friezeSections)
        
        if displayedJourney.walkingInformation != nil {
            return height + friezeView.frame.size.height + 30
        }
  
        return height + friezeView.frame.size.height
    }
}

extension ListJourneysViewController: SearchViewDelegate {
    
    func switchDepartureArrivalCoordinates() {
        if interactor?.journeysRequest != nil {
            searchView.lockSwitch = true
            interactor?.journeysRequest?.switchOriginDestination()
            interactor?.displaySearch(request: ListJourneys.DisplaySearch.Request())
            fetchJourneys()
        }
    }
    
    func fromFieldClicked(q: String?) {
        router?.routeToListPlaces(info: "from")
    }
    
    func toFieldClicked(q: String?) {
        router?.routeToListPlaces(info: "to")
    }
}

extension ListJourneysViewController: ListPlacesViewControllerDelegate {
    
    func searchView(from: (name: String, id: String), to: (name: String, id: String)) {
        let request = ListJourneys.DisplaySearch.Request(from: from, to: to)
        
        interactor?.displaySearch(request: request)
        
        fetchJourneys()
    }
}
