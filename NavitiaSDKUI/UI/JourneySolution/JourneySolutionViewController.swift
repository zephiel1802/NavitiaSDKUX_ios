//
//  JourneySolutionViewController.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 23/03/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

open class JourneySolutionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var _viewModel: JourneySolutionViewModel! {
        didSet {
            self._viewModel.journeySolutionDidChange = { [unowned self] journeySolutionViewModel in
                self.collectionView.reloadData()
                //_ = journeySolutionViewModel.journeys
            }
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

        
        
        self.title = "Itinéraires"
        
        _viewModel = JourneySolutionViewModel()
        _viewModel.request()
        collectionView.register(UINib(nibName: "JourneySolutionCollectionViewCell", bundle: self.nibBundle), forCellWithReuseIdentifier: "JourneySolutionCollectionViewCell")
        collectionView.register(UINib(nibName: "JourneyHeaderCollectionReusableView", bundle: self.nibBundle), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "JourneyHeaderCollectionReusableView")
        
        collectionView.register(UINib(nibName: "RidesharingInformationCollectionViewCell", bundle: self.nibBundle), forCellWithReuseIdentifier: "RidesharingInformationCollectionViewCell")
        
        collectionView.register(UINib(nibName: JourneyEmptySolutionCollectionViewCell.identifier, bundle: self.nibBundle), forCellWithReuseIdentifier: JourneyEmptySolutionCollectionViewCell.identifier)

        bundle = self.nibBundle
        

        
        // Do any additional setup after loading the view.
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
        return 2
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return self._viewModel.journeyRidesharingSolutionModels.count
        }
        return self._viewModel.journeySolutionModels.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RidesharingInformationCollectionViewCell.identifier, for: indexPath) as? RidesharingInformationCollectionViewCell {
                    return cell
                }
            } else {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JourneySolutionCollectionViewCell.identifier, for: indexPath) as? JourneySolutionCollectionViewCell {
                    let formattedStringDateTime = NSMutableAttributedString()
                    formattedStringDateTime
                        .bold(self._viewModel.journeyRidesharingSolutionModels[indexPath.row].departureDateTime.toString(format: "HH:mm"))
                        .bold(" - ")
                        .bold(self._viewModel.journeyRidesharingSolutionModels[indexPath.row].arrivalDateTime.toString(format: "HH:mm"))
                    
                    
                    cell.dateTime = formattedStringDateTime
                    
                    let formattedStringDuration = NSMutableAttributedString()
                    formattedStringDuration
                        .bold(self._viewModel.journeyRidesharingSolutionModels[indexPath.row].duration.toString(allowedUnits: [ .hour, .minute ])!)
                    cell.duration = formattedStringDuration
                    
                    let formattedString = NSMutableAttributedString()
                    formattedString
                        .normal("Dont ")
                        .bold(self._viewModel.journeyRidesharingSolutionModels[indexPath.row].durationWalking.toString(allowedUnits: [ .hour, .minute ])!)
                        .normal(" à pied (")
                        .normal(String(self._viewModel.journeyRidesharingSolutionModels[indexPath.row].distanceWalking))
                        .normal(" mètres)")
                    cell.durationWalker = formattedString
                    
                    return cell
                }
            }
        }
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JourneySolutionCollectionViewCell.identifier, for: indexPath) as? JourneySolutionCollectionViewCell {
            let formattedStringDateTime = NSMutableAttributedString()
            formattedStringDateTime
                .bold(self._viewModel.journeySolutionModels[indexPath.row].departureDateTime.toString(format: "HH:mm"))
                .bold(" - ")
                .bold(self._viewModel.journeySolutionModels[indexPath.row].arrivalDateTime.toString(format: "HH:mm"))
            
            
            cell.dateTime = formattedStringDateTime
            
            let formattedStringDuration = NSMutableAttributedString()
            formattedStringDuration
                .bold(self._viewModel.journeySolutionModels[indexPath.row].duration.toString(allowedUnits: [ .hour, .minute ])!)
            cell.duration = formattedStringDuration
            
            let formattedString = NSMutableAttributedString()
            formattedString
                .normal("Dont ")
                .bold(self._viewModel.journeySolutionModels[indexPath.row].durationWalking.toString(allowedUnits: [ .hour, .minute ])!)
                .normal(" à pied (")
                .normal(String(self._viewModel.journeySolutionModels[indexPath.row].distanceWalking))
                .normal(" mètres)")
            cell.durationWalker = formattedString
            
            return cell
        }

        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind.isEqual(UICollectionElementKindSectionHeader) {
          //  let cell = UICollectionReusableView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
          //  cell.backgroundColor = UIColor.red
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "JourneyHeaderCollectionReusableView", for: indexPath) as! JourneyHeaderCollectionReusableView
//            cell.title = "MyString "
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

