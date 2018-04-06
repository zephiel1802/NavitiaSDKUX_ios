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
    
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
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

        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        title = "Itinéraires"

        _viewModel = JourneySolutionViewModel()
        _viewModel.request(with: inParameters)
        
        fromLabel.text = inParameters.originLabel
        toLabel.text = inParameters.destinationLabel
        dateTimeLabel.text = "Dépars : " + (inParameters.datetime?.toString(format: "EEE dd MMM - HH:mm"))!
        
        
        collectionView.register(UINib(nibName: JourneySolutionCollectionViewCell.identifier, bundle: self.nibBundle), forCellWithReuseIdentifier: JourneySolutionCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: JourneySolutionLoadCollectionViewCell.identifier, bundle: self.nibBundle), forCellWithReuseIdentifier: JourneySolutionLoadCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: RidesharingInformationCollectionViewCell.identifier, bundle: self.nibBundle), forCellWithReuseIdentifier: RidesharingInformationCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: JourneyEmptySolutionCollectionViewCell.identifier, bundle: self.nibBundle), forCellWithReuseIdentifier: JourneyEmptySolutionCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: JourneyHeaderCollectionReusableView.identifier, bundle: self.nibBundle), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: JourneyHeaderCollectionReusableView.identifier)
        
        bundle = self.nibBundle
        UIFont.registerFontWithFilenameString(filenameString: "SDKIcons.ttf", bundle: bundle)
        
        // Do any additional setup after loading the view.
    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func resultAction(_ sender: Any) {
        if let navigationController = self.navigationController {
            navigationController.pushViewController(JourneySolutionRoadmapViewController(), animated: true)
        }
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
        if section == 1 {
            return self._viewModel.journeysRidesharing.count
        }
        return self._viewModel.journeys.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RidesharingInformationCollectionViewCell.identifier, for: indexPath) as? RidesharingInformationCollectionViewCell {
                    return cell
                }
            } else {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JourneySolutionCollectionViewCell.identifier, for: indexPath) as? JourneySolutionCollectionViewCell {
                    cell.setup(self._viewModel.journeysRidesharing[indexPath.row])
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
        print(indexPath)
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "journeySolutionRoadmapViewController") as! JourneySolutionRoadmapViewController
        if indexPath.section == 1 {
            viewController.ridesharingJourney = _viewModel.journeysRidesharing[indexPath.row]
        } else {
            viewController.journey = _viewModel.journeys[indexPath.row]
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

extension JourneySolutionViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1 && indexPath.row == 0 {
            return CGSize(width: self.collectionView.frame.size.width - 20, height: 75)
        } else if indexPath.section == 1 {
            return CGSize(width: self.collectionView.frame.size.width - 20, height: 130)
        }
        return CGSize(width: self.collectionView.frame.size.width - 20, height: 130)
    }

}

