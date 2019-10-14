//
//  ListPlacesViewController.swift
//  NavitiaSDKUI
//
//  Copyright © 2019 kisio. All rights reserved.
//

import UIKit
import CoreLocation

public protocol ListPlacesViewControllerDelegate: class {
    
    func searchView(from: (label: String?, name: String?, id: String), to: (label: String?, name: String?, id: String))
}

protocol ListPlacesDisplayLogic: class {
    
    func displaySearch(viewModel: ListPlaces.UpdateSearchViewFields.ViewModel)
    func displayFetchedPlaces(viewModel: ListPlaces.FetchPlaces.ViewModel)
    func displayUserLocation(viewModel: ListPlaces.FetchUserLocation.ViewModel)
}

public class ListPlacesViewController: UIViewController {
    
    @IBOutlet weak var searchView: SearchView!
    @IBOutlet weak var tableView: UITableView!
    
    private let locationManager = CLLocationManager()
    private var displayedSections: [ListPlaces.FetchPlaces.ViewModel.DisplayedSection] = []
    private var debouncedSearch: Debouncer?
    private var interactor: ListPlacesBusinessLogic?
    internal var router: (NSObjectProtocol & ListPlacesRoutingLogic & ListPlacesDataPassing)?
    public weak var delegate: ListPlacesViewControllerDelegate?
    public var singleFieldConfiguration = false
    public var singleFieldCustomPlaceholder: String?
    public var customTitle: String?
    public var singleFieldCustomIcon: UIImage?
    
    public var dataStore: ListPlacesDataStore? {
        get {
            return self.router?.dataStore
        }
    }
    
    private var query: String = ""

    static public var identifier: String {
        return String(describing: self)
    }
    
    // MARK: - Initialization
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initArchitecture()
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        if let titlesConfig = Configuration.titlesConfig, let autocompleteTitle = titlesConfig.autocompleteTitle {
            self.setTitle(title: autocompleteTitle)
        } else if let customTitle = customTitle {
            self.setTitle(title: customTitle)
        } else {
            self.setTitle(title: "journeys".localized())
        }

        initLocation()
        initNavigationBar()
        initDebouncer()
        initHeader()
        initTableView()
        addUserLocationCellItem()
        
        if singleFieldConfiguration {
            interactor?.searchFieldType = .single
        }
        searchView.focusField(interactor?.searchFieldType ?? .to)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.searchView.unstickTextFields(superview: view)
        locationManager.startUpdatingLocation()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: Setup
    
    private func initArchitecture() {
        let viewController = self
        let interactor = ListPlacesInteractor()
        let presenter = ListPlacesPresenter()
        let router = ListPlacesRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    private func initNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = Configuration.Color.main
        navigationController?.navigationBar.isTranslucent = false
        
        if !singleFieldConfiguration {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action:  #selector(backButtonPressed))
            navigationItem.rightBarButtonItem?.tintColor = Configuration.Color.main.contrastColor()
        }
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Configuration.Color.main.contrastColor()]
    }
    
    private func initDebouncer() {
        debouncedSearch = Debouncer(delay: 0.6) {
            self.fetchPlaces(query: self.query)
        }
    }
    
    private func initHeader() {
        searchView.delegate = self
        searchView.detailsViewIsHidden = true
        searchView.searchFieldsContainer.backgroundColor = .clear
        searchView.singleSearchFieldsContainer.backgroundColor = .clear
        searchView.switchIsHidden = true
        searchView.separatorView.isHidden = true
        searchView.singleFieldConfiguration = self.singleFieldConfiguration
        searchView.singleFieldCustomPlaceholder = singleFieldCustomPlaceholder
        searchView.singleFieldCustomIcon = singleFieldCustomIcon
    }
    
    private func initTableView() {
        registerTableView()
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.bounces = false
    }
    
    private func addUserLocationCellItem() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse:
                updateUserLocationCellItem(withType: .locationLoading)
            default:
                updateUserLocationCellItem(withType: .locationDisabled)
            }
        } else {
            updateUserLocationCellItem(withType: .locationDisabled)
        }
    }
    
    private func registerTableView() {
        tableView.register(UINib(nibName: PlacesTableViewCell.identifier, bundle: self.nibBundle), forCellReuseIdentifier: PlacesTableViewCell.identifier)
    }
    
    private func initLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    // MARK: Fetch Places

    func fetchPlaces(query: String) {
        // Check if user location was successfully retrieved
        let shouldSendUserLocation = displayedSections.first?.places.first?.type == .locationFound
        let request = ListPlaces.FetchPlaces.Request(query: query,
                                                     userLat: shouldSendUserLocation ? locationManager.location?.coordinate.latitude : nil,
                                                     userLon: shouldSendUserLocation ? locationManager.location?.coordinate.longitude : nil)
        interactor?.fetchPlaces(request: request)
    }
    
    func fetchHistoryItems() {
        let request = ListPlaces.FetchHistoryItems.Request()
        interactor?.fetchSavedHistoryItems(request: request)
    }
    
    func fetchDebouncedSearch(query: String?) {
        guard let query = query else {
            return
        }
        
        self.query = query
        debouncedSearch?.call()
    }
    
    // MARK: - Events
    
    @objc func backButtonPressed() {
        self.searchView.stickTextFields(superview: view)
        
        if singleFieldConfiguration {
            navigationController?.popViewController(animated: false)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}

extension ListPlacesViewController: ListPlacesDisplayLogic {
    
    func displaySearch(viewModel: ListPlaces.UpdateSearchViewFields.ViewModel) {
        searchView.origin = viewModel.fromName
        searchView.destination = viewModel.toName
        searchView.isAccessibilityElement = false
        
        if viewModel.toName != "" {
            searchView.toTextField.accessibilityLabel = String(format: "%@ %@", "arrival_with_colon".localized(), viewModel.toName)
        }
        
        if viewModel.fromName != "" {
            searchView.fromTextField.accessibilityLabel = String(format: "%@ %@", "departure_with_colon".localized(), viewModel.fromName)
        }
    }
    
    func displayFetchedPlaces(viewModel: ListPlaces.FetchPlaces.ViewModel) {
        var updatedSections = [ListPlaces.FetchPlaces.ViewModel.DisplayedSection]()
        updatedSections.append(displayedSections[0])
        updatedSections.append(contentsOf: viewModel.displayedSections)
        
        if viewModel.displayedSections.isEmpty {
            tableView.setEmptyView(message: "could_not_find_anything".localized())
        } else {
            tableView.restore()
        }
        
        displayedSections = updatedSections
        tableView.reloadData()
    }
    
    func displayUserLocation(viewModel: ListPlaces.FetchUserLocation.ViewModel) {
        displayedSections[0] = viewModel.userSection
        tableView.reloadData()
    }
}

extension ListPlacesViewController: UITableViewDataSource, UITableViewDelegate {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return displayedSections.count
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return displayedSections[safe: section]?.name
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard displayedSections[safe: section]?.name != nil else {
            return 0
        }

        return 35
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let name = displayedSections[safe: section]?.name else {
            return nil
        }
        
        let view = PlacesHeaderView.instanceFromNib()
        view.title = name

        if section == 0 {
            view.lineView.isHidden = true
        }
        
        return view
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedSections[safe: section]?.places.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PlacesTableViewCell.identifier, for: indexPath) as? PlacesTableViewCell {
            cell.type = displayedSections[safe: indexPath.section]?.places[safe: indexPath.row]?.type
            cell.informations = (name: displayedSections[safe: indexPath.section]?.places[safe: indexPath.row]?.name,
                                 distance: displayedSections[safe: indexPath.section]?.places[safe: indexPath.row]?.distance)
            
            // Setup accessibility
            if displayedSections[safe: indexPath.section]?.name == "history".localized().uppercased() {
                if let type = cell.type {
                    var accessibilityText = ""
                    switch type {
                    case .stopArea :
                        accessibilityText = "stop".localized()
                    case .poi :
                        accessibilityText = "point_of_interest".localized()
                    case .locationFound :
                        accessibilityText = "my_position".localized()
                    default:
                        accessibilityText = "addresse".localized()
                    }
                    
                    if let cellName = cell.informations.name {
                        cell.accessibilityLabel = String(format: "%@ %@", accessibilityText, cellName)
                    } else {
                        cell.accessibilityLabel = accessibilityText
                    }
                    
                    cell.accessibilityHint = (cell.informations.distance ?? "")
                }
            } else {
                var text = ""
                if cell.type == .locationDisabled || cell.type == .locationLoading || cell.type == .locationFound || cell.type == .locationNotFound {
                    text = "my_position".localized()
                }
                
                cell.accessibilityLabel = text + (cell.informations.name ?? "")
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let type = displayedSections[safe: indexPath.section]?.places[safe: indexPath.row]?.type else {
            return
        }
        
        if type == .locationDisabled {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
            }
            return
        }
        
        guard let name = displayedSections[safe: indexPath.section]?.places[safe: indexPath.row]?.name,
            let id = displayedSections[safe: indexPath.section]?.places[safe: indexPath.row]?.id else {
                return
        }
        
        if type != .locationFound {
            interactor?.saveHistoryItem(request: ListPlaces.SavePlace.Request(place: (name: name, id: id, type: type.rawValue)))
        }
        
        switch interactor?.searchFieldType {
        case .from?:
            let request = ListPlaces.UpdateSearchViewFields.Request(from: (label: displayedSections[safe: indexPath.section]?.places[safe: indexPath.row]?.label,
                                                                           name: name,
                                                                           id: id),
                                                                    to: nil)
            interactor?.updateSearchViewFields(request:request)
            searchView.focusField(nil)
            
            if searchView.toTextField.text == "" && !singleFieldConfiguration {
                interactor?.searchFieldType = .to
                searchView.focusField(.to)
                
                clearTableView()
                fetchHistoryItems()
            } else {
                dismissAutocompletion()
            }
        case .to?:
            let request = ListPlaces.UpdateSearchViewFields.Request(from: nil,
                                                                    to: (label: displayedSections[safe: indexPath.section]?.places[safe: indexPath.row]?.label,
                                                                         name: name,
                                                                         id: id))
            interactor?.updateSearchViewFields(request: request)
            searchView.focusField(nil)
            
            if searchView.fromTextField.text == "" {
                interactor?.searchFieldType = .from
                searchView.focusField(.from)
                
                clearTableView()
                fetchHistoryItems()
            } else {
                dismissAutocompletion()
            }
        case .single?:
            let request = ListPlaces
                .UpdateSearchViewFields
                .Request(from: (label: displayedSections[safe: indexPath.section]?.places[safe: indexPath.row]?.label, name: name,id: id),to: nil)
            interactor?.updateSearchViewFields(request:request)
            searchView.focusField(nil)
            
            if singleFieldConfiguration {
                interactor?.searchFieldType = .single
                searchView.focusField(.single)
                
                clearTableView()
                fetchHistoryItems()
            } else {
                dismissAutocompletion()
            }
        default:
            break
        }
    }
    
    private func updateUserLocationCellItem(withType type: ListPlaces.FetchPlaces.ViewModel.ModelType) {
        let place = ListPlaces.FetchPlaces.ViewModel.Place(label: nil,
                                                           name: nil,
                                                           id: nil,
                                                           distance: nil,
                                                           type: type)
        let userLocationSection = ListPlaces.FetchPlaces.ViewModel.DisplayedSection(name: nil, places: [place])
        
        if displayedSections.count > 0 {
            displayedSections[0] = userLocationSection
        } else {
            displayedSections.append(userLocationSection)
        }
        
        tableView.reloadData()
    }
    
    private func clearTableView() {
        displayedSections = [displayedSections[0]]
        tableView.reloadData()
    }
    
    private func dismissAutocompletion() {
        if let from = interactor?.from {
            delegate?.searchView(from: from, to: interactor?.to ?? (nil, nil, ""))
        }
        
        backButtonPressed()
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        guard let _ = ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) else {
            return
        }
        
        tableView.contentInset = UIEdgeInsets.zero
    }
}

extension ListPlacesViewController: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            updateUserLocationCellItem(withType: .locationLoading)
        default:
            updateUserLocationCellItem(withType: .locationDisabled)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let request = ListPlaces.FetchUserLocation.Request(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            interactor?.fetchUserLocationAddress(request: request)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == CLError.Code.locationUnknown {
            updateUserLocationCellItem(withType: .locationNotFound)
        }
    }
}

extension ListPlacesViewController: SearchViewDelegate {
    
    func switchDepartureArrivalCoordinates() {}
    
    func singleSearchFieldClicked(query: String?) {
        interactor?.searchFieldType = .from
        
        searchView.fromView.backgroundColor = Configuration.Color.white.withAlphaComponent(0.9)
        searchView.toView.backgroundColor = Configuration.Color.white
        interactor?.updateSearchViewFields(request: ListPlaces.UpdateSearchViewFields.Request())
        fetchHistoryItems()
    }
    
    func fromFieldClicked(query: String?) {
        interactor?.searchFieldType = .from

        searchView.fromView.backgroundColor = Configuration.Color.white.withAlphaComponent(0.9)
        searchView.toView.backgroundColor = Configuration.Color.white
        interactor?.updateSearchViewFields(request: ListPlaces.UpdateSearchViewFields.Request())
        fetchHistoryItems()
    }
    
    func toFieldClicked(query: String?) {
        interactor?.searchFieldType = .to

        searchView.fromView.backgroundColor = Configuration.Color.white
        searchView.toView.backgroundColor = Configuration.Color.white.withAlphaComponent(0.9)
        interactor?.updateSearchViewFields(request: ListPlaces.UpdateSearchViewFields.Request())
        fetchHistoryItems()
    }
    
    func singleSearchFieldChange(query: String?) {
        fetchDebouncedSearch(query: query)
    }
    
    func fromFieldDidChange(query: String?) {
        fetchDebouncedSearch(query: query)
    }
    
    func toFieldDidChange(query: String?) {
        fetchDebouncedSearch(query: query)
    }
    
    func singleSearchFieldClearButtonClicked() {
        interactor?.from = nil
        interactor?.updateSearchViewFields(request: ListPlaces.UpdateSearchViewFields.Request())
        fetchHistoryItems()
    }
    
    func fromFieldClearButtonClicked() {
        interactor?.from = nil
        interactor?.updateSearchViewFields(request: ListPlaces.UpdateSearchViewFields.Request())
        fetchHistoryItems()
    }
    
    func toFieldClearButtonClicked() {
        interactor?.to = nil
        interactor?.updateSearchViewFields(request: ListPlaces.UpdateSearchViewFields.Request())
        fetchHistoryItems()
    }
}
