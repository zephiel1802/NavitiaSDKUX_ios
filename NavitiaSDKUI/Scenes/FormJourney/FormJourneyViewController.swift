//
//  FormJourneyViewController.swift
//  NavitiaSDKUI
//
//  Copyright © 2019 kisio. All rights reserved.
//

import UIKit

protocol FormJourneyDisplayLogic: class {
    
    func displaySomething(viewModel: FormJourney.Something.ViewModel)
}

class FormJourneyViewController: UIViewController, FormJourneyDisplayLogic, JourneyRootViewController {
    
    @IBOutlet weak var searchView: SearchView!
    @IBOutlet weak var stackScrollView: StackScrollView!
    
    var from: (name: String?, id: String)?
    var to: (name: String?, id: String)?
    
    var journeysRequest: JourneysRequest?
    internal var interactor: FormJourneyBusinessLogic?
    private var router: (NSObjectProtocol & FormJourneyRoutingLogic & FormJourneyDataPassing)?
    
    // MARK: - Initialization
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initSDK()
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
        
        hideKeyboardWhenTappedAround()
    
        let modeTransportView = ModeTransportView.instanceFromNib()
        modeTransportView.frame.size = CGSize(width: stackScrollView.frame.size.width, height: 100)
        stackScrollView.addSubview(modeTransportView, margin: UIEdgeInsets(top: 10, left: 10, bottom: 17, right: 10), safeArea: false)
        
        let dateFormView = DateFormView.instanceFromNib()
        dateFormView.frame.size = CGSize(width: stackScrollView.frame.size.width, height: 93)
        stackScrollView.addSubview(dateFormView, margin: UIEdgeInsets(top: 17, left: 10, bottom: 17, right: 10), safeArea: false)
        
        let searchButtonView = SearchButtonView.instanceFromNib()
        searchButtonView.frame.size = CGSize(width: stackScrollView.frame.size.width, height: 37)
        searchButtonView.delegate = self
        stackScrollView.addSubview(searchButtonView, margin: UIEdgeInsets(top: 17, left: 10, bottom: 10, right: 10), safeArea: false)
        
        stackScrollView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    
    }
    
    private func initSDK() {
        NavitiaSDKUI.shared.bundle = self.nibBundle
        UIFont.registerFontWithFilenameString(filenameString: "SDKIcons.ttf", bundle: NavitiaSDKUI.shared.bundle)
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
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    func doSomething() {
        let request = FormJourney.Something.Request()
        interactor?.doSomething(request: request)
    }
    
    func displaySomething(viewModel: FormJourney.Something.ViewModel) {
        //nameTextField.text = viewModel.name
    }
}

extension FormJourneyViewController: SearchViewDelegate {
    
    func switchDepartureArrivalCoordinates() {
//        if journeysRequest != nil {
//            searchView.lockSwitch = true
//            journeysRequest!.switchOriginDestination()
//            fetchJourneys()
//        }
    }
    
    func fromFieldClicked(q: String?) {
        router?.routeToListPlaces(info: "from")
    }
    
    func toFieldClicked(q: String?) {
        router?.routeToListPlaces(info: "to")
    }
}

extension FormJourneyViewController: SearchButtonViewDelegate {
    
    func search() {
        router?.routeToListJourneys()
    }
}

extension FormJourneyViewController: ListPlacesViewControllerDelegate {
    
    func searchView(from: (name: String?, id: String), to: (name: String?, id: String)) {
        self.from = from
        self.to = to
        
        searchView.fromTextField.text = from.name
        searchView.toTextField.text = to.name
    }
}
