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

public protocol JourneyPriceDelegate: class {
    
    func requestPrice(ticketInputData: Data, callback:  @escaping ((_ ticketPriceDictionary: [[String: Any]]) -> ()))
    func buyTicket(journeyJson: String)
}

public class ListJourneysViewController: UIViewController, ListJourneysDisplayLogic, JourneyRootViewController {
    @IBOutlet weak var searchView: SearchView!
    @IBOutlet weak var journeysCollectionView: UICollectionView!
    
    public var journeyPriceDelegate: JourneyPriceDelegate?
    public var journeysRequest: JourneysRequest?
    internal var interactor: ListJourneysBusinessLogic?
    internal var router: (NSObjectProtocol & ListJourneysViewRoutingLogic & ListJourneysDataPassing)?
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
        
        if let titlesConfig = Configuration.titlesConfig, let journeysTitle = titlesConfig.journeysTitle {
            setTitle(title: journeysTitle)
        } else {
            setTitle(title: "journeys".localized())
        }
        
        hideKeyboardWhenTappedAround()
        
        initNavigationBar()
        initHeader()
        initCollectionView()
        searchView.isClearButtonAccessible = false

        if let journeysRequest = journeysRequest {
            interactor?.journeysRequest = journeysRequest
        }
        
        journeyPriceDelegate = router?.dataStore?.delegate
        interactor?.displaySearch(request: ListJourneys.DisplaySearch.Request())
        interactor?.journeysRequest?.allowedPhysicalModes != nil ? fetchPhysicalMode() : fetchJourneys()
    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        initActivityView()
        journeysCollectionView.collectionViewLayout.invalidateLayout()
        reloadCollectionViewLayout()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchView.fromTextField.resignFirstResponder()
        searchView.toTextField.resignFirstResponder()
        
        if interactor?.journeysRequest?.originId == nil {
            searchView.fromTextField.becomeFirstResponder()
        } else if interactor?.journeysRequest?.destinationId == nil {
            searchView.toTextField.becomeFirstResponder()
        }
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
        searchView.isAccessibilityElement = false
        if let modeTransportViewSelected = interactor?.modeTransportViewSelected {
            searchView.transportModeView.updateSelectedButton(selectedButton: modeTransportViewSelected)
        }
        if let travelerType = interactor?.journeysRequest?.travelerType {
            switch travelerType {
            case .wheelchair:
                searchView.wheelchairTravelTypeIsOn = true
                searchView.luggageTravelTypeIsOn = false
                searchView.walkingSpeedView.isActive = false
                searchView.walkingSpeedView.speed = .slow
            case .luggage:
                searchView.wheelchairTravelTypeIsOn = false
                searchView.luggageTravelTypeIsOn = true
                searchView.walkingSpeedView.isActive = false
                searchView.walkingSpeedView.speed = .medium
            case .slow_walker:
                searchView.wheelchairTravelTypeIsOn = false
                searchView.luggageTravelTypeIsOn = false
                searchView.walkingSpeedView.isActive = true
                searchView.walkingSpeedView.speed = .slow
            case .standard:
                searchView.wheelchairTravelTypeIsOn = false
                searchView.luggageTravelTypeIsOn = false
                searchView.walkingSpeedView.isActive = true
                searchView.walkingSpeedView.speed = .medium
            case .fast_walker:
                searchView.wheelchairTravelTypeIsOn = false
                searchView.luggageTravelTypeIsOn = false
                searchView.walkingSpeedView.isActive = true
                searchView.walkingSpeedView.speed = .fast
            }
        }
        searchView.dateFormView.dateTimeRepresentsSegmentedControl = interactor?.journeysRequest?.datetimeRepresents?.rawValue
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
        interactor?.modeTransportViewSelected = searchView.transportModeView.getSelectedButton()
        router?.routeToBack()
    }
    
    func displaySearch(viewModel: ListJourneys.DisplaySearch.ViewModel) {
        searchView.fromTextField.text = viewModel.fromName
        searchView.toTextField.text = viewModel.toName
        
        searchView.dateTime = viewModel.dateTime
        searchView.lock = !NavitiaSDKUI.shared.advancedSearchMode
        searchView.dateFormView.date = viewModel.date
        searchView.isAccessibilityElement = false
        
        if let text = viewModel.toName, text != "" {
            searchView.toTextField.accessibilityLabel = String(format: "%@ %@", "arrival_with_colon".localized(), text)
        }
        if let text = viewModel.fromName, text != "" {
            searchView.fromTextField.accessibilityLabel = String(format: "%@ %@", "departure_with_colon".localized(), text)
        }
        
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
        
        if viewModel.loaded {
            DispatchQueue.main.async {
                self.searchView.lockSwitch = false
                self.anim()
                self.activityView.stopAnimating()
            }
        } else {
            searchView.lockSwitch = true
        }
        
        journeysCollectionView.reloadData()
        reloadCollectionViewLayout()
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
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JourneySolutionCollectionViewCell.identifier, for: indexPath) as? JourneySolutionCollectionViewCell,
                let viewModel = viewModel.displayedJourneys[safe: indexPath.row] {
                cell.journeySolutionDelegate = self
                cell.dateTime = viewModel.dateTime
                cell.duration = viewModel.duration
                cell.walkingDescription = viewModel.walkingInformation
                cell.accessibility = viewModel.accessibility
                cell.friezeSections = viewModel.friezeSections
                
                if journeyPriceDelegate != nil {
                    cell.indexPath = indexPath
                    cell.configurePrice(priceModel: viewModel.priceModel)
                }
                
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
                    cell.descriptionText = "no_carpooling_options_found".localized()
                    return cell
                }
            }
            // Result
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JourneySolutionCollectionViewCell.identifier, for: indexPath) as? JourneySolutionCollectionViewCell,
                let viewModel = viewModel.displayedRidesharings[safe: indexPath.row - 1] {
                cell.dateTime = viewModel.dateTime
                cell.duration = viewModel.duration
                cell.walkingDescription = viewModel.walkingInformation
                cell.accessibility = viewModel.accessibility
                cell.friezeSections = viewModel.friezeSections
                
                return cell
            }
        }
        // Other
        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind.isEqual(UICollectionView.elementKindSectionHeader) {
            if let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: JourneyHeaderCollectionReusableView.identifier, for: indexPath) as? JourneyHeaderCollectionReusableView {
                cell.title = "carpooling".localized()
                
                return cell
            }
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
            if let cell = collectionView.cellForItem(at: indexPath) as? JourneySolutionCollectionViewCell, (journeyPriceDelegate == nil || cell.isLoaded) {
                selector = NSSelectorFromString("routeToJourneySolutionRoadmapWithIndexPath:priceModel:")
                if let router = router, router.responds(to: selector) {
                    router.perform(selector, with: indexPath, with: self.viewModel?.displayedJourneys[indexPath.row].priceModel)
                }
            } else if indexPath.section == 1 && viewModel.displayedRidesharings.count > indexPath.row - 1 && indexPath.row != 0 {
                selector = NSSelectorFromString("routeToListRidesharingOffersWithIndexPath:")
                
                if let router = router, router.responds(to: selector) {
                    router.perform(selector, with: indexPath)
                }
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
                let friezeView = FriezeView(frame: CGRect(x: 0, y: 0, width: width - 66, height: 27))
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
    
    func fromFieldClicked(query: String?) {
        searchView.endEditing(true)
        router?.routeToListPlaces(searchFieldType: .from)
    }
    
    func toFieldClicked(query: String?) {
        searchView.endEditing(true)
        router?.routeToListPlaces(searchFieldType: .to)
    }
}

extension ListJourneysViewController: ListPlacesViewControllerDelegate {
    
    public func searchView(from: (label: String?, name: String?, id: String), to: (label: String?, name: String?, id: String)) {
        let request = ListJourneys.DisplaySearch.Request(from: from, to: to)
        
        interactor?.displaySearch(request: request)
        
        fetchJourneys()
    }
}

extension ListJourneysViewController: SearchButtonViewDelegate {
    
    func search() {
        if searchView.isPreferencesShown {
            if let physicalModes = searchView.transportModeView?.getPhysicalModes() {
                interactor?.journeysRequest?.allowedPhysicalModes = physicalModes
            }
            
            if let firstSectionModes = searchView.transportModeView?.getFirstSectionMode() {
                var modes = [CoverageRegionJourneysRequestBuilder.FirstSectionMode]()
                for mode in firstSectionModes {
                    if let sectionMode = CoverageRegionJourneysRequestBuilder.FirstSectionMode(rawValue:mode) {
                        modes.append(sectionMode)
                    }
                }
                
                interactor?.journeysRequest?.firstSectionModes = modes
            }
            
            if let lastSectionModes = searchView.transportModeView?.getLastSectionMode() {
                var modes = [CoverageRegionJourneysRequestBuilder.LastSectionMode]()
                for mode in lastSectionModes {
                    if let sectionMode = CoverageRegionJourneysRequestBuilder.LastSectionMode(rawValue:mode) {
                        modes.append(sectionMode)
                    }
                }
                
                interactor?.journeysRequest?.lastSectionModes = modes
            }
            
            if let realTimeModes = searchView.transportModeView?.getRealTimeModes() {
                interactor?.journeysRequest?.addPoiInfos = []
                
                for mode in realTimeModes {
                    if mode == "bss" {
                        interactor?.journeysRequest?.addPoiInfos?.append(.bssStands)
                    } else if mode == "car" {
                        interactor?.journeysRequest?.addPoiInfos?.append(.carPark)
                    }
                }
            }
            
            if searchView.wheelchairTypeView.isOn {
                interactor?.journeysRequest?.travelerType = .wheelchair
            } else if searchView.luggageTypeView.isOn {
                interactor?.journeysRequest?.travelerType = .luggage
            } else {
                switch searchView.walkingSpeedView.speed {
                case .slow:
                    interactor?.journeysRequest?.travelerType = .slow_walker
                case .medium:
                    interactor?.journeysRequest?.travelerType = .standard
                case .fast:
                    interactor?.journeysRequest?.travelerType = .fast_walker
                }
            }
            
            searchView.hidePreferences()
            fetchPhysicalMode()
        } else if searchView.isDateShown {
            if let date = searchView.dateFormView.date {
                interactor?.updateDate(request: FormJourney.UpdateDate.Request(date: date,
                                                                               dateTimeRepresents: searchView.dateFormView.departureArrivalSegmentedControl.selectedSegmentIndex == 0 ? .departure : .arrival))
            }
            print("Changement de date")
            searchView.hideDate()
            fetchJourneys()
        }
    }
}

extension ListJourneysViewController: JourneySolutionCollectionViewCellDelegate {
    
    func getPrice(ticketsInputList: [TicketInput], indexPath: IndexPath?) {
        do {
            let jsonData = try JSONEncoder().encode(ticketsInputList)
            journeyPriceDelegate?.requestPrice(ticketInputData: jsonData, callback: { (ticketPriceDictionary) in
                do {
                    guard let index = indexPath, let priceModel = self.viewModel?.displayedJourneys[safe: index.row]?.priceModel else {
                        return
                    }
                    
                    var pricedTicketsFromHermaas = [PricedTicket]()
                    for response in ticketPriceDictionary {
                        let pricedTicketData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                        var pricedTicket = try JSONDecoder().decode(PricedTicket.self, from: pricedTicketData)
                        
                        // Merge navitia prices with hermaas prices
                        if let navitiaTicket = priceModel.navitiaPricedTickets?.first(where: { $0.ticketId == pricedTicket.ticketId }) {
                            pricedTicket.price = navitiaTicket.price
                            pricedTicket.priceWithTax = navitiaTicket.priceWithTax
                        }
                        
                        pricedTicketsFromHermaas.append(pricedTicket)
                    }
                    
                    self.viewModel?.displayedJourneys[index.row].priceModel?.hermaasPricedTickets = pricedTicketsFromHermaas
                    
                    // Check which ticket has an error
                    if let ticketInputs = priceModel.ticketsInput {
                        for ticket in ticketInputs {
                            if !pricedTicketsFromHermaas.contains(where: { $0.ticketId == ticket.ride.ticketId }) {
                                self.viewModel?.displayedJourneys[safe: index.row]?.priceModel?.unexpectedErrorTicketList?.append((productId: ticket.productId, ticketId: ticket.ride.ticketId))
                            }
                        }
                    }
                    
                    var isPriceMissing = false
                    if let unbookableSectionCount = priceModel.unbookableSectionIdList?.count,
                        let unexpectedErrorCount = priceModel.unexpectedErrorTicketList?.count,
                        unbookableSectionCount > 0 || unexpectedErrorCount > 0 {
                        isPriceMissing = true
                    }
                    
                    if let hermaasPricedTicketsCount = priceModel.hermaasPricedTickets?.count,
                        let ticketsInputCount = priceModel.ticketsInput?.count,
                        hermaasPricedTicketsCount < ticketsInputCount {
                        isPriceMissing = true
                    }
                    
                    // Compute total price
                    var totalPrice: Double = 0
                    for ticket in pricedTicketsFromHermaas {
                        if ticket.currency.lowercased() == "eur" {
                            totalPrice += ticket.priceWithTax
                        } else {
                            isPriceMissing = true
                        }
                    }
                    
                    if pricedTicketsFromHermaas.count == 0 {
                        self.viewModel?.displayedJourneys[index.row].priceModel?.state = isPriceMissing ? .unavailable_price : .no_price
                        self.viewModel?.displayedJourneys[index.row].priceModel?.totalPrice = nil
                    } else {
                        self.viewModel?.displayedJourneys[index.row].priceModel?.state = isPriceMissing ? .incomplete_price : .full_price
                        self.viewModel?.displayedJourneys[index.row].priceModel?.totalPrice = totalPrice
                    }
                    
                    DispatchQueue.main.async {
                        self.journeysCollectionView.reloadItems(at: [index])
                    }
                } catch {
                    if let index = indexPath, self.viewModel?.displayedJourneys[safe: index.row] != nil {
                        self.viewModel?.displayedJourneys[index.row].priceModel?.hermaasPricedTickets = []
                    }
                }
            })
        } catch {
            if let index = indexPath, self.viewModel?.displayedJourneys[safe: index.row] != nil {
                self.viewModel?.displayedJourneys[index.row].priceModel?.hermaasPricedTickets = []
            }
        }
    }
}
