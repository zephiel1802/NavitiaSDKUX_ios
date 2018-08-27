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
    
    var interactor: JourneySolutionBusinessLogic?
    var router: (NSObjectProtocol & JourneySolutionViewRoutingLogic & JourneySolutionDataPassing)?
    var viewModel: JourneySolution.FetchJourneys.ViewModel?
    
    public var inParameters: InParameters!
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        NavitiaSDKUI.shared.bundle = self.nibBundle
        
        addBackButton(targetSelector: #selector(backButtonPressed))
        
        title = "journeys".localized(withComment: "Journeys", bundle: NavitiaSDKUI.shared.bundle)
        
        UIFont.registerFontWithFilenameString(filenameString: "SDKIcons.ttf", bundle: NavitiaSDKUI.shared.bundle)
        
        if #available(iOS 11.0, *) {
            collectionView?.contentInsetAdjustmentBehavior = .always
        }

        _registerCollectionView()
        
        // Clean
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

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    // MARK: - View lifecycle
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        _setupInterface()
        _fetchJourneys()
    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    @objc func backButtonPressed() {
        if isRootViewController() {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func _registerCollectionView() {
        collectionView.register(UINib(nibName: JourneySolutionCollectionViewCell.identifier, bundle: self.nibBundle), forCellWithReuseIdentifier: JourneySolutionCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: JourneySolutionLoadCollectionViewCell.identifier, bundle: self.nibBundle), forCellWithReuseIdentifier: JourneySolutionLoadCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: RidesharingInformationCollectionViewCell.identifier, bundle: self.nibBundle), forCellWithReuseIdentifier: RidesharingInformationCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: JourneyEmptySolutionCollectionViewCell.identifier, bundle: self.nibBundle), forCellWithReuseIdentifier: JourneyEmptySolutionCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: JourneyHeaderCollectionReusableView.identifier, bundle: self.nibBundle), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: JourneyHeaderCollectionReusableView.identifier)
    }
    
    private func _setupInterface() {
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
    
    @IBAction func switchDepartureArrivalCoordinates(_ sender: UIButton) {
        switchDepartureArrivalButton.isEnabled = false
        
        let oldOriginLabel = self.inParameters.originLabel
        self.inParameters.originLabel = self.inParameters.destinationLabel
        self.inParameters.destinationLabel = oldOriginLabel
        
        let oldFromLabelText = self.fromLabel.text
        self.fromLabel.text = self.toLabel.text
        self.toLabel.text = oldFromLabelText
        
        let oldOriginId = self.inParameters.originId
        self.inParameters.originId = self.inParameters.destinationId
        self.inParameters.destinationId = oldOriginId
        
        _fetchJourneys()
    }
    
}

extension JourneySolutionViewController: JourneySolutionDisplayLogic {
    
    // MARK: - Fetch journeys
    
    private func _fetchJourneys() {
        let request = JourneySolution.FetchJourneys.Request(inParameters: inParameters)
        
        interactor?.fetchJourneys(request: request)
    }
    
    func displayFetchedJourneys(viewModel: JourneySolution.FetchJourneys.ViewModel) {
        self.viewModel = viewModel
        
        guard let viewModel = self.viewModel else {
            return
        }

        fromLabel.attributedText = viewModel.searchInformation.origin
        toLabel.attributedText = viewModel.searchInformation.destination
        dateTimeLabel.attributedText = viewModel.searchInformation.dateTime

        if viewModel.loaded {
            switchDepartureArrivalButton.isEnabled = true
        }
        
        collectionView.reloadData()
    }
    
}

extension JourneySolutionViewController: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let viewModel = self.viewModel else {
            return 0
        }
        // Journey + Carsharing
        if ridesharing && viewModel.loaded {
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
                            displayedDisruptions: viewModel.displayedDisruptions)
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
                            displayedDisruptions: viewModel.displayedDisruptions)
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
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // Carsharing : Header
        if section == 1 {
            return CGSize(width: 0, height: 30)
        }
        // Null
        return CGSize(width: 0, height: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if !_viewModel.loading {
//            if indexPath.section == 0 && _viewModel.journeys.count > indexPath.row {
//                _viewModel.indexJourney = indexPath.row
//                let selector = NSSelectorFromString("routeToJourneySolutionRoadmap")
//                if let router = router, router.responds(to: selector) {
//                    router.perform(selector)
//                }
//            } else if indexPath.section == 1 && indexPath.row != 0 {
//                _viewModel.indexRidesharing = indexPath.row - 1
//                let selector = NSSelectorFromString("routeToJourneySolutionRidesharing")
//                if let router = router, router.responds(to: selector) {
//                    router.perform(selector)
//                }
//            }
//        }
    }
    
}

extension JourneySolutionViewController: UICollectionViewDelegateFlowLayout {
    
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

extension JourneySolutionViewController {
    
    var ridesharing: Bool {
        get {
            if let firstSectionModes = inParameters.firstSectionModes {
                if let _ = firstSectionModes.index(where: { $0 == .ridesharing }) {
                    return true
                }
            }
            if let lastSectionModes = inParameters.lastSectionModes {
                if let _ = lastSectionModes.index(where: { $0 == .ridesharing }) {
                    return true
                }
            }
            return false
        }
    }
    
    public struct InParameters {
        public init(originId: String, destinationId: String) {
            self.originId = originId
            self.destinationId = destinationId
        }
        
        public var originId: String
        public var originLabel: String?
        public var destinationId: String
        public var destinationLabel: String?
        public var datetime: Date?
        public var datetimeRepresents: JourneysRequestBuilder.DatetimeRepresents?
        public var forbiddenUris: [String]?
        public var allowedId: [String]?
        public var firstSectionModes: [JourneysRequestBuilder.FirstSectionMode]?
        public var lastSectionModes: [JourneysRequestBuilder.LastSectionMode]?
        public var count: Int32?
        public var minNbJourneys: Int32?
        public var maxNbJourneys: Int32?
        public var bssStands: Bool?
    }
    
}
