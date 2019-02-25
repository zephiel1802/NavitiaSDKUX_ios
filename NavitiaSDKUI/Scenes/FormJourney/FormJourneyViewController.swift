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

class FormJourneyViewController: UIViewController, FormJourneyDisplayLogic, JourneyRootViewController {
    
    @IBOutlet weak var searchView: SearchView!
    @IBOutlet weak var stackScrollView: StackScrollView!

    private var transportModeView: TransportModeView!
    private var dateFormView: DateFormView!
    private var searchButtonView: SearchButtonView!
    // ⚠️
    private var display = false
    
    internal var interactor: FormJourneyBusinessLogic?
    internal var router: (NSObjectProtocol & FormJourneyRoutingLogic & FormJourneyDataPassing)?
    
    // ⚠️ Trouver une solution concernant l'us age de l'interactor !!
    var journeysRequest: JourneysRequest?
    
    // MARK: - Initialization
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initArchitecture()
    }
    
    override func viewWillTransition( to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator ) {
        stackScrollView.reloadStack()
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        title = "journeys".localized()
        
        hideKeyboardWhenTappedAround()
        
        initNavigationBar()
        initHeader()
        initStackScrollView()

        // ⚠️
        interactor?.journeysRequest = journeysRequest
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
    
    private func initArchitecture() {
        let viewController = self
        let interactor = FormJourneyInteractor()
        let presenter = FormJourneyPresenter()
        let router = FormJourneyRouter()
        
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
    }
    
    private func initSearchButton() {
        searchButtonView = SearchButtonView.instanceFromNib()
        searchButtonView.frame.size = CGSize(width: stackScrollView.frame.size.width, height: 37)
        searchButtonView.delegate = self
        stackScrollView.addSubview(searchButtonView, margin: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), safeArea: false)
    }
    
    // MARK: - Events,;
    
    @objc func backButtonPressed() {
        if isRootViewController() {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    func displaySearch(viewModel: FormJourney.DisplaySearch.ViewModel) {
        if viewModel.fromName == nil || viewModel.toName == nil {
            searchButtonView.isEnabled = false
        } else {
            searchButtonView.isEnabled = true
        }
        
        searchView.fromTextField.text = viewModel.fromName
        searchView.toTextField.text = viewModel.toName
        
        dateFormView.date = interactor?.journeysRequest?.datetime
        dateFormView.dateTimeRepresentsSegmentedControl = interactor?.journeysRequest?.datetimeRepresents?.rawValue
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
        
        if let modes = transportModeView?.getModes() {
            var firstSectionModes = [CoverageRegionJourneysRequestBuilder.FirstSectionMode]()
            var lastSectionModes = [CoverageRegionJourneysRequestBuilder.LastSectionMode]()
            
            for mode in modes {
                if let sectionMode = CoverageRegionJourneysRequestBuilder.FirstSectionMode(rawValue:mode) {
                    firstSectionModes.append(sectionMode)
                }
                if let sectionMode = CoverageRegionJourneysRequestBuilder.LastSectionMode(rawValue:mode) {
                    lastSectionModes.append(sectionMode)
                }
            }
            
            interactor?.journeysRequest?.firstSectionModes = firstSectionModes
            interactor?.journeysRequest?.lastSectionModes = lastSectionModes
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
