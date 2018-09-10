//
//  JourneySolutionViewController.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

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
    
    public var inParameters: InParameters!
    
    fileprivate var _viewModel: JourneySolutionViewModel! {
        didSet {
            self._viewModel.journeySolutionDidChange = { [weak self] journeySolutionViewModel in
                self?.switchDepartureArrivalButton.isEnabled = true
                
                self?.collectionView.reloadData()
                if !journeySolutionViewModel.journeys.isEmpty || !journeySolutionViewModel.journeysRidesharing.isEmpty {
                    if self?.inParameters.originLabel == nil {
                        self?.fromLabel.text = !journeySolutionViewModel.journeys.isEmpty ? journeySolutionViewModel.journeys[0].sections?[0].from?.name : journeySolutionViewModel.journeysRidesharing[0].sections?[0].from?.name
                    }
                    if self?.inParameters.destinationLabel == nil {
                        self?.toLabel.text = !journeySolutionViewModel.journeys.isEmpty ? journeySolutionViewModel.journeys[0].sections?[(journeySolutionViewModel.journeys[0].sections?.count)! - 1].to?.name : journeySolutionViewModel.journeysRidesharing[0].sections?[(journeySolutionViewModel.journeysRidesharing[0].sections?.count)! - 1].to?.name
                    }
                    if self?.inParameters.datetime == nil {
                        if let dateTime = !journeySolutionViewModel.journeys.isEmpty ? journeySolutionViewModel.journeys[0].departureDateTime?.toDate(format: Configuration.date) : journeySolutionViewModel.journeysRidesharing[0].departureDateTime?.toDate(format: Configuration.date) {
                            self?.dateTime = dateTime.toString(format: Configuration.timeJourneySolution)
                        }
                    }
                }
            }
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        NavitiaSDKUI.shared.bundle = self.nibBundle
        
        addBackButton(targetSelector: #selector(backButtonPressed))
        
        title = "journeys".localized(withComment: "Journeys", bundle: NavitiaSDKUI.shared.bundle)
        
        UIFont.registerFontWithFilenameString(filenameString: "SDKIcons.ttf", bundle: NavitiaSDKUI.shared.bundle)
        
        if #available(iOS 11.0, *) {
            collectionView?.contentInsetAdjustmentBehavior = .always
        }

        _setupInterface()
        _registerCollectionView()

        // Request
        _viewModel = JourneySolutionViewModel()
        _viewModel.request(with: inParameters)
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        fromLabel.text = inParameters.originLabel ?? inParameters.originId
        fromPinLabel.attributedText = NSMutableAttributedString()
            .icon("location-pin", color: Configuration.Color.origin, size: 22)
        
        toLabel.text = inParameters.destinationLabel ?? inParameters.destinationId
        toPinLabel.attributedText = NSMutableAttributedString()
            .icon("location-pin", color: Configuration.Color.destination, size: 22)
        
        if let backgroundColor = navigationController?.navigationBar.barTintColor {
            searchView.backgroundColor = backgroundColor
        }
        
        if let dateTime = inParameters.datetime {
            self.dateTime = dateTime.toString(format: Configuration.timeJourneySolution)
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
        
        _viewModel.journeys = [Journey]()
        _viewModel.journeysRidesharing = [Journey]()
        self.collectionView.reloadData()
        
        let oldOriginId = self.inParameters.originId
        self.inParameters.originId = self.inParameters.destinationId
        self.inParameters.destinationId = oldOriginId
        
        _viewModel.request(with: inParameters)
    }
}

extension JourneySolutionViewController: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        // Journey + Carsharing
        if ridesharing && !_viewModel.loading {
            return 2
        }
        
        // Journey
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Loading
        if _viewModel.loading {
            return 4
        }
        // Carsharing : Header + Empty
        if section == 1 && _viewModel.journeysRidesharing.count == 0 {
            return 2
        }
        // Journey : Empty
        if section == 0 && self._viewModel.journeys.count == 0 {
            return 1
        }
        // Carsharing : Header + Solution
        if section == 1 {
            return self._viewModel.journeysRidesharing.count + 1
        }
        // Journey : Solution
        return self._viewModel.journeys.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Loading
        if _viewModel.loading {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JourneySolutionLoadCollectionViewCell.identifier, for: indexPath) as? JourneySolutionLoadCollectionViewCell {
                return cell
            }
        }
        // Journey
        if indexPath.section == 0 {
            // No journey
            if self._viewModel.journeys.count == 0 {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JourneyEmptySolutionCollectionViewCell.identifier, for: indexPath) as? JourneyEmptySolutionCollectionViewCell {
                    return cell
                }
            }
            // Result
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JourneySolutionCollectionViewCell.identifier, for: indexPath) as? JourneySolutionCollectionViewCell {
                cell.disruptions = _viewModel.disruptions
                cell.setup(self._viewModel.journeys[indexPath.row])
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
            if indexPath.row == 1 && self._viewModel.journeysRidesharing.count == 0 {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JourneyEmptySolutionCollectionViewCell.identifier, for: indexPath) as? JourneyEmptySolutionCollectionViewCell {
                    cell.text = "no_carpooling_options_found".localized(withComment: "No carpooling options found", bundle: NavitiaSDKUI.shared.bundle)
                    return cell
                }
            }
            // Result
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JourneySolutionCollectionViewCell.identifier, for: indexPath) as? JourneySolutionCollectionViewCell {
                cell.setupRidesharing(self._viewModel.journeysRidesharing[indexPath.row - 1])
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
        if !_viewModel.loading {
            if indexPath.section == 0 && _viewModel.journeys.count > indexPath.row {
                let viewController = storyboard?.instantiateViewController(withIdentifier: JourneySolutionRoadmapViewController.identifier) as! JourneySolutionRoadmapViewController
                viewController.disruptions = _viewModel.disruptions
                viewController.notes = _viewModel.notes
                viewController.journey = _viewModel.journeys[indexPath.row]
                self.navigationController?.pushViewController(viewController, animated: true)
            } else if indexPath.section == 1 && indexPath.row != 0 {
                let viewController = storyboard?.instantiateViewController(withIdentifier: JourneySolutionRidesharingViewController.identifier) as! JourneySolutionRidesharingViewController
                viewController.disruptions = _viewModel.disruptions
                viewController.notes = _viewModel.notes
                viewController.journey = _viewModel.journeysRidesharing[indexPath.row - 1]
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
}

extension JourneySolutionViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var safeAreaWidth: CGFloat = 20.0
        if #available(iOS 11.0, *) {
            safeAreaWidth += self.collectionView.safeAreaInsets.left + self.collectionView.safeAreaInsets.right
        }
        // Loading
        if _viewModel.loading {
            return CGSize(width: self.collectionView.frame.size.width - safeAreaWidth, height: 130)
        }
        // Journey
        if indexPath.section == 0 {
            // No journey
            if self._viewModel.journeys.count == 0 {
                return CGSize(width: self.collectionView.frame.size.width - safeAreaWidth, height: 35)
            }
            // Result
            if let walkingDuration = _viewModel.journeys[indexPath.row].durations?.walking {
                if walkingDuration <= 0 {
                    return CGSize(width: self.collectionView.frame.size.width - safeAreaWidth, height: 97)
                }
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
            if indexPath.row == 1 && self._viewModel.journeysRidesharing.count == 0 {
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
    
    var dateTime: String? {
        get {
            return dateTimeLabel.text
        }
        set {
            if let newValue = newValue {
                dateTimeLabel.attributedText = NSMutableAttributedString()
                    .bold(String(format: "%@ : %@",
                                 "departure".localized(withComment: "Departure : ", bundle: NavitiaSDKUI.shared.bundle),
                                 newValue),
                          color: UIColor.white,
                          size: 12.5)
            }
        }
    }
    
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
