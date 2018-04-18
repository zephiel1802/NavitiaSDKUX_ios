//
//  JourneySolutionViewController.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 23/03/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

open class JourneySolutionViewController: UIViewController {

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
    }
    
    public var inParameters: InParameters!
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var fromPinLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var toPinLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var _viewModel: JourneySolutionViewModel! {
        didSet {
            self._viewModel.journeySolutionDidChange = { [weak self] journeySolutionViewModel in
                self?.collectionView.reloadData()
                if journeySolutionViewModel.journeys.isEmpty == false {
                    self?.fromLabel.text = journeySolutionViewModel.journeys[0].sections?[0].from?.name
                    self?.toLabel.text = journeySolutionViewModel.journeys[0].sections?[(journeySolutionViewModel.journeys[0].sections?.count)! - 1].to?.name
                    if self?.inParameters.datetime == nil {
                        if let dateTime = journeySolutionViewModel.journeys[0].departureDateTime?.toDate(format: FormatConfiguration.date) {
                            self?.dateTime = dateTime.toString(format: "EEE dd MMM - HH:mm")
                        }
                    }
                }
            }
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        NavitiaSDKUIConfig.shared.bundle = self.nibBundle
        
        title = "journeys".localized(withComment: "journeys", bundle: NavitiaSDKUIConfig.shared.bundle)
        
        UIFont.registerFontWithFilenameString(filenameString: "SDKIcons.ttf", bundle: NavitiaSDKUIConfig.shared.bundle)
        
        if #available(iOS 11.0, *) {
            collectionView?.contentInsetAdjustmentBehavior = .always
        }

        _setupInterface()
        registerCollectionView()

        // Request
        _viewModel = JourneySolutionViewModel()
        _viewModel.request(with: inParameters)
    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override open func viewDidLayoutSubviews() {
        
    }
    
    private func registerCollectionView() {
        collectionView.register(UINib(nibName: JourneySolutionCollectionViewCell.identifier, bundle: self.nibBundle), forCellWithReuseIdentifier: JourneySolutionCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: JourneySolutionLoadCollectionViewCell.identifier, bundle: self.nibBundle), forCellWithReuseIdentifier: JourneySolutionLoadCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: RidesharingInformationCollectionViewCell.identifier, bundle: self.nibBundle), forCellWithReuseIdentifier: RidesharingInformationCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: JourneyEmptySolutionCollectionViewCell.identifier, bundle: self.nibBundle), forCellWithReuseIdentifier: JourneyEmptySolutionCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: JourneyHeaderCollectionReusableView.identifier, bundle: self.nibBundle), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: JourneyHeaderCollectionReusableView.identifier)
    }
    
    private func _setupInterface() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.barTintColor = NavitiaSDKUIConfig.shared.color.tertiary
        
        if let backgroundColor = navigationController?.navigationBar.barTintColor {
            searchView.backgroundColor = backgroundColor
        }
        
        if let dateTime = inParameters.datetime {
            self.dateTime = dateTime.toString(format: "EEE dd MMM - HH:mm")
        }
        
        _setupFromTo()
    }
    
    private func _setupFromTo() {
        fromLabel.text = inParameters.originLabel
        fromPinLabel.text = Icon("location-pin").iconFontCode
        fromPinLabel.font = UIFont(name: "SDKIcons", size: 22)
        fromPinLabel.textColor = NavitiaSDKUIConfig.shared.color.origin
        
        toLabel.text = inParameters.destinationLabel
        toPinLabel.text = Icon("location-pin").iconFontCode
        toPinLabel.font = UIFont(name: "SDKIcons", size: 22)
        toPinLabel.textColor = NavitiaSDKUIConfig.shared.color.destination
    }

}

extension JourneySolutionViewController: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        if ridesharing && !_viewModel.loading {
            return 2
        }
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if _viewModel.loading {
            return 3
        }
        
        
        if section == 1 && _viewModel.journeysRidesharing.count == 0 {
            return 2
        }
        if self._viewModel.journeys.count == 0 {
            return 1
        }
        
        if section == 1 {
            return self._viewModel.journeysRidesharing.count + 1
        }
        
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
                    cell.text = "no_carpooling_options_found".localized(withComment: "no_carpooling_options_found", bundle: NavitiaSDKUIConfig.shared.bundle)
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
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "JourneyHeaderCollectionReusableView", for: indexPath) as! JourneyHeaderCollectionReusableView
            return cell
        }
        return UICollectionReusableView()
    }
    
}

extension JourneySolutionViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section != 0 {
            return CGSize(width: 0, height: 30)
        }
        return CGSize(width: 0, height: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !_viewModel.loading {
            if indexPath.section == 0 && _viewModel.journeys.count > indexPath.row {
                let viewController = storyboard?.instantiateViewController(withIdentifier: "journeySolutionRoadmapViewController") as! JourneySolutionRoadmapViewController
                viewController.journey = _viewModel.journeys[indexPath.row]
                self.navigationController?.pushViewController(viewController, animated: true)
            } else if indexPath.section == 1 && indexPath.row != 0 {
                let viewController = storyboard?.instantiateViewController(withIdentifier: "JourneySolutionRidesharingViewController") as! JourneySolutionRidesharingViewController
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
                    .bold("departure".localized(withComment: "departure", bundle: NavitiaSDKUIConfig.shared.bundle) + " : ", color: UIColor.white, size: 12.5)
                    .bold(newValue, color: UIColor.white, size: 12.5)
            }
        }
    }
    
    var ridesharing: Bool {
        get {
            if let firstSectionModes = inParameters.firstSectionModes {
                for firstSectionMode in firstSectionModes {
                    if firstSectionMode == .ridesharing {
                        return true
                    }
                }
            }
            if let lastSectionModes = inParameters.lastSectionModes {
                for lastSectionMode in lastSectionModes {
                    if lastSectionMode == .ridesharing {
                        return true
                    }
                }
            }
            return false
        }
    }

    
}

