//
//  FormJourneyViewController.swift
//  NavitiaSDKUI
//
//  Copyright © 2019 kisio. All rights reserved.
//

import UIKit

protocol FormJourneyDisplayLogic: class {
    
    func displaySearch(viewModel: FormJourney.DisplaySearch.ViewModel)
}

open class FormJourneyViewController: UIViewController, FormJourneyDisplayLogic, JourneyRootViewController {
    
    @IBOutlet weak var searchView: SearchView!
    @IBOutlet weak var stackScrollView: StackScrollView!
    @IBOutlet var vwHeader: UIView!
    @IBOutlet var vwBackground: UIView!
    
    private var transportModeView: TransportModeView!
    private var dateFormView: DateFormView!
    private var searchButtonView: SearchButtonView!
    private var display = false
    var home:Place?
    var work:Place?
    
    internal var interactor: FormJourneyBusinessLogic?
    internal var router: (NSObjectProtocol & FormJourneyRoutingLogic & FormJourneyDataPassing)?
    private var interactorL: ListPlacesBusinessLogic?
    internal weak var delegate: ListPlacesViewControllerDelegate?
    public var journeysRequest: JourneysRequest?
    
    // MARK: - Initialization
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initArchitecture()
    }
    
    override open func viewWillTransition( to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator ) {
        stackScrollView.reloadStack()
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        initNavigationBar()
        setupUI()
        initHeader()
        initStackScrollView()
        
        interactor?.journeysRequest = journeysRequest
    }
    
    @objc func setupUI() {
        //Setup for common method invoke
        vwBackground.createDefaultGradientView()
        setupHeaderView(with: "journeys".localized(), showBackButton: true) {
            DispatchQueue.main.async {
                self.touchBackButton()
            }
        }
    }
    
    fileprivate func touchBackButton() {
        if isRootViewController() {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func setupHeaderView(with title: String, showBackButton: Bool, actionBlock: @escaping HeaderViewActionBlock){
        if let header = self.vwHeader{
            HeaderView.setupHeaderView(in: header, with: title, showBackButton: showBackButton, action: actionBlock)
        }
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !display {
            initTransportModeView()
            initDateFormView()
            initSearchButton()
            
            display = true
            interactor?.displaySearch(request: FormJourney.DisplaySearch.Request())
        }
    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        stackScrollView.reloadStack()
        if let modeTransportViewSelected = interactor?.modeTransportViewSelected {
            transportModeView.updateSelectedButton(selectedButton: modeTransportViewSelected)
        }
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchView.fromTextField.resignFirstResponder()
        searchView.toTextField.resignFirstResponder()
        
        if (searchView.fromTextField.text == "") {
            home = UserDefaults.standard.structData(Place.self, forKey: "home_address")
            work = UserDefaults.standard.structData(Place.self, forKey: "work_address")
            
            assignHomeWorkAddress(home: home, work: work)
        }
    }
    
    private func initArchitecture() {
        let viewController = self
        let interactor = FormJourneyInteractor()
        let interactorL = ListPlacesInteractor()
        let presenter = FormJourneyPresenter()
        let presenterL = ListPlacesPresenter()
        let router = FormJourneyRouter()
        let routerL = ListPlacesRouter()
        
        viewController.interactor = interactor
        viewController.interactorL = interactorL
        viewController.router = router
        interactor.presenter = presenter
        interactorL.presenter = presenterL
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
        routerL.dataStore = interactorL
    }
    
    private func initNavigationBar() {
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = Configuration.Color.main
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.isHidden = true
        navigationController?.isNavigationBarHidden = true
    }
    
    private func initHeader() {
        searchView.delegate = self
        searchView.detailsViewIsHidden = true
    }
    
    private func initStackScrollView() {
        stackScrollView.translatesAutoresizingMaskIntoConstraints = false
        stackScrollView.bounces = false
    }
    
    private func initTransportModeView() {
        transportModeView = TransportModeView(frame: CGRect(x: 0, y: 0, width: stackScrollView.frame.size.width, height: 0))
        transportModeView?.isColorInverted = true
        stackScrollView.addSubview(transportModeView!, margin: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), safeArea: true)
    }
    
    private func initDateFormView() {
        dateFormView = DateFormView.instanceFromNib()
        dateFormView.frame.size = CGSize(width: stackScrollView.frame.size.width, height: 93)
        stackScrollView.addSubview(dateFormView, margin: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), safeArea: false)
        dateFormView.dateTimeRepresentsSegmentedControl = journeysRequest?.datetimeRepresents?.rawValue
        dateFormView.date = journeysRequest?.datetime
        dateFormView.isAccessibilityElement = false
    }
    
    private func initSearchButton() {
        searchView.isClearButtonAccessible = false
        searchButtonView = SearchButtonView.instanceFromNib()
        searchButtonView.frame.size = CGSize(width: stackScrollView.frame.size.width, height: 37)
        searchButtonView.delegate = self
        stackScrollView.addSubview(searchButtonView, margin: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), safeArea: false)
    }
    
    // MARK: - Events
    
    func displaySearch(viewModel: FormJourney.DisplaySearch.ViewModel) {
        if viewModel.fromName == nil || viewModel.toName == nil {
            searchButtonView.isEnabled = false
        } else {
            searchButtonView.isEnabled = true
        }
        
        searchView.fromTextField.text = viewModel.fromName
        searchView.toTextField.text = viewModel.toName
        
        searchView.isAccessibilityElement = false
        if let text = viewModel.toName, text != "" {
            searchView.toTextField.accessibilityLabel = String(format: "%@ %@", "arrival_with_colon".localized(), text)
        }
        
        if let text = viewModel.fromName, text != "" {
            searchView.fromTextField.accessibilityLabel = String(format: "%@ %@", "departure_with_colon".localized(), text)
        }
        
        dateFormView.date = interactor?.journeysRequest?.datetime
        dateFormView.dateTimeRepresentsSegmentedControl = interactor?.journeysRequest?.datetimeRepresents?.rawValue
    }
    
    func assignHomeWorkAddress(home:Place?, work:Place?) {
        let homeModel = FormJourney.DisplaySearch.ViewModel(fromName: home?.name, toName: work?.name)
        self.displaySearch(viewModel: homeModel)
        
        interactorL?.displaySearch(request: ListPlaces.DisplaySearch.Request())
        interactorL?.info == "from" ? searchView.focusFromField() : searchView.focusToField()
        
        if interactorL?.info == "from" {
            let request = ListPlaces.DisplaySearch.Request(from: (label:home?.label,
                                                                  name: home!.name,
                                                                  id: home!.id) as? (label: String?, name: String?, id: String),
                                                           to: nil)
            interactorL?.displaySearch(request:request)
            
            
            searchView.focusFromField(false)
            if searchView.toTextField.text == "" {
                interactorL?.info = "to"
                searchView.focusToField()
                fetchPlaces(q: "")
            } else {
                dismissAutocompletion()
            }
        } else {
            
            let request = ListPlaces.DisplaySearch.Request(from: nil,
                                                           to: (label: work?.label,
                                                                name: work?.name,
                                                                id: work!.id) as? (label: String?, name: String?, id: String))
            
            interactorL?.displaySearch(request: request)
            
            searchView.focusToField(false)
            if searchView.fromTextField.text == "" {
                interactorL?.info  = "from"
                searchView.focusFromField()
                fetchPlaces(q: "")
            } else {
                dismissAutocompletion()
            }
        }
    }
    
    func fetchPlaces(q: String?) {
        guard let q = q else {
            return
        }
        
        let request = ListPlaces.FetchPlaces.Request(q: q)
        
        interactorL?.fetchJourneys(request: request)
    }
    
    private func dismissAutocompletion() {
        if let from = interactorL?.from, let to = interactorL?.to {
            delegate?.searchView(from: from, to: to)
        }
        
        backButtonPressed()
    }
    
    @objc func backButtonPressed() {
        UIView.animate(withDuration: 0.15) {
            self.searchView.stickTextFields()
            self.view.layoutIfNeeded()
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension FormJourneyViewController: SearchViewDelegate {
    
    func switchDepartureArrivalCoordinates() {
        if journeysRequest != nil {
            interactor?.journeysRequest?.switchOriginDestination()
            interactor?.displaySearch(request: FormJourney.DisplaySearch.Request())
        }
    }
    
    func fromFieldClicked(q: String?) {
        view.endEditing(true)
        router?.routeToListPlaces(info: "from")
    }
    
    func toFieldClicked(q: String?) {
        searchView.endEditing(true)
        router?.routeToListPlaces(info: "to")
    }
}

extension FormJourneyViewController: SearchButtonViewDelegate {
    
    func search() {
        if let date = dateFormView.date {
            interactor?.updateDate(request: FormJourney.UpdateDate.Request(date: date,
                                                                           dateTimeRepresents: dateFormView.departureArrivalSegmentedControl.selectedSegmentIndex == 0 ? .departure : .arrival))
        }
        
        if let physicalModes = transportModeView?.getPhysicalModes() {
            interactor?.journeysRequest?.allowedPhysicalModes = physicalModes
        }
        
        if let firstSectionModes = transportModeView?.getFirstSectionMode() {
            var modes = [CoverageRegionJourneysRequestBuilder.FirstSectionMode]()
            for mode in firstSectionModes {
                if let sectionMode = CoverageRegionJourneysRequestBuilder.FirstSectionMode(rawValue:mode) {
                    modes.append(sectionMode)
                }
            }

            interactor?.journeysRequest?.firstSectionModes = modes
        }
        
        if let lastSectionModes = transportModeView?.getLastSectionMode() {
            var modes = [CoverageRegionJourneysRequestBuilder.LastSectionMode]()
            for mode in lastSectionModes {
                if let sectionMode = CoverageRegionJourneysRequestBuilder.LastSectionMode(rawValue:mode) {
                    modes.append(sectionMode)
                }
            }
            
            interactor?.journeysRequest?.lastSectionModes = modes
        }

        if let realTimeModes = transportModeView?.getRealTimeModes() {
            interactor?.journeysRequest?.addPoiInfos = []
            
            for mode in realTimeModes {
                if mode == "bss" {
                    interactor?.journeysRequest?.addPoiInfos?.append(.bssStands)
                } else if mode == "car" {
                    interactor?.journeysRequest?.addPoiInfos?.append(.carPark)
                }
            }
        }
        
        interactor?.modeTransportViewSelected = transportModeView.getSelectedButton()
        
        router?.routeToListJourneys()
    }
}

extension FormJourneyViewController: ListPlacesViewControllerDelegate {
    
    func searchView(from: (label: String?, name: String?, id: String), to: (label: String?, name: String?, id: String)) {
        let request = FormJourney.DisplaySearch.Request(from: from, to: to)
        
        interactor?.displaySearch(request: request)
    }
}
