//
//  CoverageViewController.swift
//  NavitiaSDKUI-Example
//
//  Created by Adeline Hirsch on 07/06/2019.
//  Copyright © 2019 kisio. All rights reserved.
//

import Foundation
import NavitiaSDKUI

class CoverageViewController: UIViewController {

    let segueIdentifier = "goToConfiguration"
    var retrievedCoverages: [String] = []
    var coverageIds: [String] = []
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var loaderIndicatorView: UIActivityIndicatorView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loaderIndicatorView.startAnimating()
        retrieveCoverageList()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let vc = segue.destination as? ConfigurationViewController {
            vc.coverages = retrievedCoverages
            vc.coverageIds = coverageIds
        }
    }
    
    private func retrieveCoverageList() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            self.messageLabel.text = "Error retrieving coverages"
            
            return
        }
        
        let coverageApi = CoverageApi(token: appDelegate.token)
        let coverageRequestBuilder = CoverageRequestBuilder(currentApi: coverageApi)
        coverageIds = []
        retrievedCoverages = []
        
        coverageRequestBuilder.get { (datas, error) in
            if let error = error {
                self.messageLabel.text = String(format: "Error retrieving coverages: %@", error.localizedDescription)
            } else if let datas = datas, let regions = datas.regions {
                let sortedRegions = regions.sorted {
                    ($0.name?.lowercased() ?? $0.id?.lowercased() ?? "") < ($1.name?.lowercased() ?? $1.id?.lowercased() ?? "")
                }
                
                for data in sortedRegions {
                    self.retrievedCoverages.append(data.name ?? data.id ?? "unknown")
                    self.coverageIds.append(data.id ?? "unknown")
                }
                
                self.performSegue(withIdentifier: self.segueIdentifier, sender: self)
            } else {
                self.messageLabel.text = "Error retrieving coverages"
            }
        }
    }
}
