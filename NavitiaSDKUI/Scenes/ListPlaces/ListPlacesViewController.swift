//
//  ListPlacesViewController.swift
//  NavitiaSDKUI
//
//  Copyright © 2019 kisio. All rights reserved.
//

import UIKit
import CoreLocation

protocol ListPlacesViewControllerDelegate: class {
    
    func searchView(from: (label: String?, name: String?, id: String), to: (label: String?, name: String?, id: String))
}

protocol ListPlacesDisplayLogic: class {
    
    func displaySearch(viewModel: ListPlaces.DisplaySearch.ViewModel)
    func displaySomething(viewModel: ListPlaces.FetchPlaces.ViewModel)
}

class ListPlacesViewController: UIViewController, ListPlacesDisplayLogic {
    
    @IBOutlet weak var searchView: SearchView!
    @IBOutlet weak var tableView: UITableView!

    private let locationManager = CLLocationManager()
    private var displayedSections: [ListPlaces.FetchPlaces.ViewModel.DisplayedSections] = []
    private var debouncedSearch: Debouncer?
    private var interactor: ListPlacesBusinessLogic?
    internal var router: (NSObjectProtocol & ListPlacesRoutingLogic & ListPlacesDataPassing)?
    internal weak var delegate: ListPlacesViewControllerDelegate?

    private var q: String = ""

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

        hideKeyboardWhenTappedAround()
        
        initLocation()
        initNavigationBar()
        initDebouncer()
        initHeader()
        initTableView()
        
        interactor?.displaySearch(request: ListPlaces.DisplaySearch.Request())
        fetchPlaces(q: "")
        interactor?.info == "from" ? searchView.focusFromField() : searchView.focusToField()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.15) {
            self.searchView.unstickTextFields()
            self.view.layoutIfNeeded()
        }
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action:  #selector(backButtonPressed))
        navigationItem.rightBarButtonItem?.tintColor = Configuration.Color.main.contrastColor()
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Configuration.Color.main.contrastColor()]
    }
    
    private func initDebouncer() {
        debouncedSearch = Debouncer(delay: 0.15) {
            self.fetchPlaces(q: self.q)
        }
    }
    
    private func initHeader() {
        searchView.delegate = self
        searchView.detailsViewIsHidden = true
        searchView.background.backgroundColor = .clear
        searchView.switchIsHidden = true
        searchView.separatorView.isHidden = true
    }
    
    private func initTableView() {
        registerTableView()
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
    }
    
    private func registerTableView() {
        tableView.register(UINib(nibName: PlacesTableViewCell.identifier, bundle: self.nibBundle), forCellReuseIdentifier: PlacesTableViewCell.identifier)
    }
    
    private func initLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    // MARK: Fetch Places

    func fetchPlaces(q: String?) {
        guard let q = q else {
            return
        }
        
        let request = ListPlaces.FetchPlaces.Request(q: q)
        
        interactor?.fetchJourneys(request: request)
    }
    
    // MARK: Display Search
    
    func displaySearch(viewModel: ListPlaces.DisplaySearch.ViewModel) {
        searchView.fromTextField.text = viewModel.fromName
        searchView.toTextField.text = viewModel.toName
        
        locationManager.startUpdatingLocation()
    }
    
    // MARK: Fetch Places
    
    func displaySomething(viewModel: ListPlaces.FetchPlaces.ViewModel) {
        displayedSections = viewModel.displayedSections
        
        tableView.reloadData()
    }
    
    func fetchDeboucedSearch(q: String?) {
        guard let q = q else {
            return
        }
        
        self.q = q
        
        debouncedSearch?.call()
    }
    
    // MARK: - Events
    
    @objc func backButtonPressed() {
        UIView.animate(withDuration: 0.15) {
            self.searchView.stickTextFields()
            self.view.layoutIfNeeded()
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension ListPlacesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return displayedSections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return displayedSections[safe: section]?.name
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard displayedSections[safe: section]?.name != nil else {
            return 0
        }

        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedSections[safe: section]?.places.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PlacesTableViewCell.identifier, for: indexPath) as? PlacesTableViewCell {

            cell.type = displayedSections[safe: indexPath.section]?.places[safe: indexPath.row]?.type
            cell.informations = (name: displayedSections[safe: indexPath.section]?.places[safe: indexPath.row]?.name,
                                 distance: displayedSections[safe: indexPath.section]?.places[safe: indexPath.row]?.distance)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let name = displayedSections[safe: indexPath.section]?.places[safe: indexPath.row]?.name,
            let id = displayedSections[safe: indexPath.section]?.places[safe: indexPath.row]?.id,
            let type = displayedSections[safe: indexPath.section]?.places[safe: indexPath.row]?.type else {
                return
        }
        
        if type != .location {
            interactor?.savePlace(request: ListPlaces.SavePlace.Request(place: (name: name, id: id, type: type.rawValue)))
        }

        if interactor?.info == "from" {
            interactor?.displaySearch(request: ListPlaces.DisplaySearch.Request(from: (label: displayedSections[safe: indexPath.section]?.places[safe: indexPath.row]?.label,
                                                                                       name: name,
                                                                                       id: id),
                                                                                to: nil))

            
            searchView.focusFromField(false)
            if searchView.toTextField.text == "" {
                interactor?.info = "to"
                searchView.focusToField()
                clearTableView()
                locationManager.stopUpdatingLocation()
                
                fetchPlaces(q: "")
            } else {
                dismissAutocompletion()
            }
        } else {
            interactor?.displaySearch(request: ListPlaces.DisplaySearch.Request(from: nil,
                                                                                to: (label: displayedSections[safe: indexPath.section]?.places[safe: indexPath.row]?.label,
                                                                                     name: name,
                                                                                     id: id)))

            searchView.focusToField(false)
            if searchView.fromTextField.text == "" {
                interactor?.info  = "from"
                searchView.focusFromField()
                clearTableView()
                locationManager.startUpdatingLocation()
                fetchPlaces(q: "")
            } else {
                dismissAutocompletion()
            }
        }
    }
    
    private func clearTableView() {
        displayedSections.removeAll()
        tableView.reloadData()
    }
    
    private func dismissAutocompletion() {
        if let from = interactor?.from, let to = interactor?.to {
            delegate?.searchView(from: from,
                                 to: to)
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
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension ListPlacesViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let request = ListPlaces.FetchLocation.Request(latitude: Double(location.coordinate.latitude),
                                                           longitude:  Double(location.coordinate.longitude))

            interactor?.fetchLocation(request: request)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}

extension ListPlacesViewController: SearchViewDelegate {
    
    func switchDepartureArrivalCoordinates() {}
    
    func fromFieldClicked(q: String?) {
        interactor?.info = "from"

        searchView.fromView.backgroundColor = Configuration.Color.white.withAlphaComponent(0.9)
        searchView.toView.backgroundColor = Configuration.Color.white
        interactor?.displaySearch(request: ListPlaces.DisplaySearch.Request())
        fetchPlaces(q: "")
    }
    
    func toFieldClicked(q: String?) {
        interactor?.info = "to"

        searchView.fromView.backgroundColor = Configuration.Color.white
        searchView.toView.backgroundColor = Configuration.Color.white.withAlphaComponent(0.9)
        interactor?.displaySearch(request: ListPlaces.DisplaySearch.Request())
        fetchPlaces(q: "")
    }
    
    func fromFieldDidChange(q: String?) {
        fetchDeboucedSearch(q: q)
    }
    
    func toFieldDidChange(q: String?) {
        fetchDeboucedSearch(q: q)
    }
}
