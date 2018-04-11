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
            self._viewModel.journeySolutionDidChange = { [self] journeySolutionViewModel in
                self.collectionView.reloadData()
                if journeySolutionViewModel.journeys.isEmpty == false {
                    self.fromLabel.text = journeySolutionViewModel.journeys[0].sections?[0].from?.name
                    self.toLabel.text = journeySolutionViewModel.journeys[0].sections?[(journeySolutionViewModel.journeys[0].sections?.count)! - 1].to?.name
                }
            }
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        title = "Itinéraires"
        
        bundle = self.nibBundle
        UIFont.registerFontWithFilenameString(filenameString: "SDKIcons.ttf", bundle: bundle)
        if #available(iOS 11.0, *) {
            collectionView?.contentInsetAdjustmentBehavior = .always
        }

        setupInterface()
        registerCollectionView()

        // Request
        _viewModel = JourneySolutionViewModel()
        _viewModel.request(with: inParameters)
  
        if let count = navigationController?.viewControllers.count {
            if count == 1 {
                print("mettre le back")
            }
        }
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
    
    private func setupInterface() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        if let backgroundColor = navigationController?.navigationBar.barTintColor {
            searchView.backgroundColor = backgroundColor
        }

        
        fromLabel.text = inParameters.originLabel
        fromPinLabel.text = Icon("location-pin").iconFontCode
        fromPinLabel.font = UIFont(name: "SDKIcons", size: 22)
        fromPinLabel.textColor = UIColor(red:0, green:0.73, blue:0.46, alpha:1.0)
        
        toLabel.text = inParameters.destinationLabel
        toPinLabel.text = Icon("location-pin").iconFontCode
        toPinLabel.font = UIFont(name: "SDKIcons", size: 22)
        toPinLabel.textColor = UIColor(red:0.69, green:0.01, blue:0.33, alpha:1.0)
    }

}

extension JourneySolutionViewController: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        if self._viewModel.journeysRidesharing.count > 0 {
            return 2
        }
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self._viewModel.loading {
            return 3
        }
        if section == 1 {
            return self._viewModel.journeysRidesharing.count
        }
        return self._viewModel.journeys.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self._viewModel.loading {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JourneySolutionLoadCollectionViewCell.identifier, for: indexPath) as? JourneySolutionLoadCollectionViewCell {
                //cell.setup(self._viewModel.journeys[indexPath.row])
                return cell
            }
        }
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RidesharingInformationCollectionViewCell.identifier, for: indexPath) as? RidesharingInformationCollectionViewCell {
                    return cell
                }
            } else {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JourneySolutionCollectionViewCell.identifier, for: indexPath) as? JourneySolutionCollectionViewCell {
                    cell.setupRidesharing(self._viewModel.journeysRidesharing[indexPath.row])
                    return cell
                }
            }
        }
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JourneySolutionCollectionViewCell.identifier, for: indexPath) as? JourneySolutionCollectionViewCell {
            cell.setup(self._viewModel.journeys[indexPath.row])
            return cell
        }
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
            let viewController = storyboard?.instantiateViewController(withIdentifier: "journeySolutionRoadmapViewController") as! JourneySolutionRoadmapViewController
            if indexPath.section == 1 {
                viewController.ridesharingJourney = _viewModel.journeysRidesharing[indexPath.row]
            } else {
                viewController.journey = _viewModel.journeys[indexPath.row]
            }
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
}

extension JourneySolutionViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var safeAreaWidth: CGFloat = 20.0
        if #available(iOS 11.0, *) {
            safeAreaWidth += self.collectionView.safeAreaInsets.left + self.collectionView.safeAreaInsets.right
        }
        if indexPath.section == 1 && indexPath.row == 0 {
            return CGSize(width: self.collectionView.frame.size.width - safeAreaWidth, height: 75)
        } else if indexPath.section == 1 {
            return CGSize(width: self.collectionView.frame.size.width - safeAreaWidth, height: 130)
        }
        return CGSize(width: self.collectionView.frame.size.width - safeAreaWidth, height: 130)
    }

}

