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
    
    var journey: Journey?
    var ridesharingJourneys: [Journey]?
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        title = "carpooling".localized(withComment: "Carpooling", bundle: NavitiaSDKUIConfig.shared.bundle)
        
        if let journey = journey {
            journeySolutionRoadmap.setDataRidesharing(journey)
        }
        collectionView.register(UINib(nibName: JourneyRidesharingCollectionViewCell.identifier, bundle: self.nibBundle), forCellWithReuseIdentifier: JourneyRidesharingCollectionViewCell.identifier)
        // Do any additional setup after loading the view.
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getRidesharingCount() -> Int {
        if let sections = journey?.sections {
            for section in sections {
                if let mode = section.mode {
                    if mode == "ridesharing" {
                        ridesharingJourneys = section.ridesharingJourneys
                        return section.ridesharingJourneys?.count ?? 0
                    }
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
            if let ridesharingJourneys = ridesharingJourneys {
                cell.title = ridesharingJourneys[indexPath.row].sections?[1].ridesharingInformations?._operator ?? ""
                cell.title = ridesharingJourneys[indexPath.row].sections?[1].ridesharingInformations?._operator ?? ""
                cell.startDate = ridesharingJourneys[indexPath.row].sections?[1].departureDateTime?.toDate(format: FormatConfiguration.date)?.toString(format: FormatConfiguration.time) ?? ""
                cell.login = ridesharingJourneys[indexPath.row].sections?[1].ridesharingInformations?.driver?.alias ?? ""
                cell.gender = ridesharingJourneys[indexPath.row].sections?[1].ridesharingInformations?.driver?.gender ?? ""
                cell.seatCount(ridesharingJourneys[indexPath.row].sections?[1].ridesharingInformations?.seats?.available)
                cell.price = ridesharingJourneys[indexPath.row].fare?.total?.value ?? ""
                cell.setPicture(url: ridesharingJourneys[indexPath.row].sections?[1].ridesharingInformations?.driver?.image)
                cell.setNotation(ridesharingJourneys[indexPath.row].sections?[1].ridesharingInformations?.driver?.rating?.count)
                cell.setFullStar(ridesharingJourneys[indexPath.row].sections?[1].ridesharingInformations?.driver?.rating?.value)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
}

extension JourneySolutionRidesharingViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "journeySolutionRoadmapViewController") as! JourneySolutionRoadmapViewController
        viewController.journey = journey
        viewController.ridesharing = true
        viewController.ridesharingIndex = indexPath.row
        self.navigationController?.pushViewController(viewController, animated: true)
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
