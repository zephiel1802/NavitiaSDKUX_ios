//
//  JourneySolutionRidesharingViewController.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

open class JourneySolutionRidesharingViewController: UIViewController {

    @IBOutlet weak var journeySolutionRoadmap: JourneySolutionView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var disruptions: [Disruption]?
    var notes: [Note]?
    var journey: Journey? {
        get {
            return _viewModel.journey
        }
        set {
            if _viewModel == nil {
                _viewModel = JourneySolutionRidesharingViewModel()
            }
            _viewModel.journey = newValue
        }
    }
    
    fileprivate var _viewModel: JourneySolutionRidesharingViewModel! {
        didSet {
            self._viewModel.journeySolutionRidesharingDidChange = { [weak self] journeySolutionRidesharingViewModel in
                if self?.collectionView != nil {
                    self?.collectionView.reloadData()
                }
                if let journey = journeySolutionRidesharingViewModel.journey {
                    if self?.journeySolutionRoadmap != nil {
                        self?.journeySolutionRoadmap.setDataRidesharing(journey)
                    }
                }
            }
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        title = "carpooling".localized(withComment: "Carpooling", bundle: NavitiaSDKUI.shared.bundle)
        
        _registerCollectionView()
        _viewModel.journeySolutionRidesharingDidChange!(_viewModel)
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    private func _registerCollectionView() {
        collectionView.register(UINib(nibName: JourneyRidesharingCollectionViewCell.identifier, bundle: self.nibBundle), forCellWithReuseIdentifier: JourneyRidesharingCollectionViewCell.identifier)
    }

    
    func getRidesharingCount() -> Int {
        if let sections =  _viewModel.journey?.sections {
            for section in sections {
                if let mode = section.mode, mode == .ridesharing {
                    _viewModel.ridesharingJourneys = section.ridesharingJourneys
                    return section.ridesharingJourneys?.count ?? 0
                }
            }
        }
        return 0
    }

}

extension JourneySolutionRidesharingViewController: UICollectionViewDataSource {

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getRidesharingCount()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JourneyRidesharingCollectionViewCell.identifier, for: indexPath) as? JourneyRidesharingCollectionViewCell {
            if let ridesharingJourneys = _viewModel.ridesharingJourneys?[safe: indexPath.row] {
                cell.price = ridesharingJourneys.fare?.total?.value ?? ""
                if let sectionRidesharing = ridesharingJourneys.sections?[safe: 1] {
                    cell.title = sectionRidesharing.ridesharingInformations?.network ?? ""
                    cell.startDate = sectionRidesharing.departureDateTime?.toDate(format: Configuration.date)?.toString(format: Configuration.timeRidesharing) ?? ""
                    cell.login = sectionRidesharing.ridesharingInformations?.driver?.alias ?? ""
                    cell.gender = sectionRidesharing.ridesharingInformations?.driver?.gender?.rawValue ?? ""
                    cell.seatCount(sectionRidesharing.ridesharingInformations?.seats?.available)
                    cell.setPicture(url: sectionRidesharing.ridesharingInformations?.driver?.image)
                    cell.setNotation(sectionRidesharing.ridesharingInformations?.driver?.rating?.count)
                    cell.setFullStar(sectionRidesharing.ridesharingInformations?.driver?.rating?.value)
                    cell.row = indexPath.row
                }
            }
            cell.delegate = self
            return cell
        }
        return UICollectionViewCell()
    }
    
}

extension JourneySolutionRidesharingViewController: UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var safeAreaWidth: CGFloat = 20.0
        if #available(iOS 11.0, *) {
            safeAreaWidth += self.collectionView.safeAreaInsets.left + self.collectionView.safeAreaInsets.right
        }
        return CGSize(width: self.collectionView.frame.size.width - safeAreaWidth, height: 155)
    }
    
}

extension JourneySolutionRidesharingViewController: JourneyRidesharingCollectionViewCellDelegate {
    
    func onBookButtonClicked(_ journeyRidesharingCollectionViewCell: JourneyRidesharingCollectionViewCell) {
        if let row = journeyRidesharingCollectionViewCell.row {
            let viewController = storyboard?.instantiateViewController(withIdentifier: JourneySolutionRoadmapViewController.identifier) as! JourneySolutionRoadmapViewController
            viewController.journey = _viewModel.journey
            viewController.ridesharing = true
            viewController.ridesharingIndex = row
            viewController.disruptions = disruptions
            viewController.notes = notes
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
}
