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
    
    var modeTransportView: ModeTransportView?
    
//    var from: (name: String, id: String)?
//    var to: (name: String, id: String)?
    
    var journeysRequest: JourneysRequest?
    internal var interactor: FormJourneyBusinessLogic?
    internal var router: (NSObjectProtocol & FormJourneyRoutingLogic & FormJourneyDataPassing)?
    
    var dateFormView: DateFormView!
    
    // MARK: - Initialization
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
       // initSDK()
        initArchitecture()
    }
    
    override func viewWillTransition( to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator ) {
        stackScrollView.reloadStack()
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        title = "journeys".localized()
        
        initNavigationBar()
        initHeader()
        
        interactor?.journeysRequest = journeysRequest
        interactor?.displaySearch(request: FormJourney.DisplaySearch.Request())
        
        hideKeyboardWhenTappedAround()

        

        stackScrollView.translatesAutoresizingMaskIntoConstraints = false
        stackScrollView.bounces = false
    }
    
    var display = false
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !display {
            modeTransportView = ModeTransportView(frame: CGRect(x: 0, y: 0, width: stackScrollView.frame.size.width, height: 0))
            modeTransportView?.isColorInverted = true
            stackScrollView.addSubview(modeTransportView!, margin: UIEdgeInsets(top: 10, left: 10, bottom: 17, right: 10), safeArea: true)
            modeTransportView?.transportModeLabel?.textColor = NavitiaSDKUI.shared.mainColor
            //        stackScrollView.addSubview(modeTransportView)
            
            dateFormView = DateFormView.instanceFromNib()
            dateFormView.frame.size = CGSize(width: stackScrollView.frame.size.width, height: 93)
            stackScrollView.addSubview(dateFormView, margin: UIEdgeInsets(top: 17, left: 10, bottom: 17, right: 10), safeArea: false)
            if let datetimeRepresents = journeysRequest?.datetimeRepresents {
                dateFormView.departureArrivalSegmentedControl.selectedSegmentIndex = datetimeRepresents == .departure ? 0 : 1
            }
            if let date = journeysRequest?.datetime {
                dateFormView.date = date
                
                let dateFormmatter = DateFormatter()
                
                dateFormmatter.dateFormat = "EEEE d MMMM 'à' HH:mm"
                dateFormView.dateTextField.text = dateFormmatter.string(from: date)
            }
            
            
            let searchButtonView = SearchButtonView.instanceFromNib()
            searchButtonView.frame.size = CGSize(width: stackScrollView.frame.size.width, height: 37)
            searchButtonView.delegate = self
            stackScrollView.addSubview(searchButtonView, margin: UIEdgeInsets(top: 17, left: 10, bottom: 10, right: 10), safeArea: false)
            
            display = true
        }
        
    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        stackScrollView.reloadStack()
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
        searchView.dateTimeIsHidden = true
    }
    
    // MARK: - Events
    
    @objc func backButtonPressed() {
        if isRootViewController() {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    func displaySearch(viewModel: FormJourney.DisplaySearch.ViewModel) {
        searchView.fromTextField.text = viewModel.fromName
        searchView.toTextField.text = viewModel.toName
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
        if let physicalModes = modeTransportView?.getPhysicalModes() {
            interactor?.journeysRequest?.allowedPhysicalModes = physicalModes
        }
        
        if let modes = modeTransportView?.getModes() {
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
        router?.routeToListJourneys()
    }
}

extension FormJourneyViewController: ListPlacesViewControllerDelegate {
    
    func searchView(from: (name: String, id: String), to: (name: String, id: String)) {
        let request = FormJourney.DisplaySearch.Request(from: from, to: to)
        
        interactor?.displaySearch(request: request)
    }
}
