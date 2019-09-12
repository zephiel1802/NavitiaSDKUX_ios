//
//  PlacesTableViewCell.swift
//  NavitiaSDKUI
//
//  Copyright © 2019 kisio. All rights reserved.
//

import UIKit

class PlacesTableViewCell: UITableViewCell {
    
    enum ModelType: String {
        case stopArea = "stopArea"
        case address = "address"
        case poi = "poi"
        case location = "location"
    }
    
    @IBOutlet weak var typeimageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    internal var type: ListPlaces.FetchPlaces.ViewModel.ModelType? {
        didSet {
            guard let type = type else {
                return
            }
            
            switch type {
            case .stopArea:
                typeimageView.image = "journey_stop_area".getIcon(customizable: true)
                typeimageView.tintColor = Configuration.Color.black
            case .poi:
                typeimageView.image = "journey_poi".getIcon(customizable: true)
                typeimageView.tintColor = Configuration.Color.black
            case .locationLoading, .locationDisabled, .locationFound, .locationNotFound:
                typeimageView.image = "journey_my_position".getIcon(customizable: true)
                typeimageView.tintColor = Configuration.Color.main
            default:
                typeimageView.image = "journey_address".getIcon(customizable: true)
                typeimageView.tintColor = Configuration.Color.black
            }
        }
    }
    
    internal var informations: (name: String?, distance: String?) {
        didSet {
            if let name = informations.name {
                if type == .locationFound {
                    nameLabel.attributedText = NSMutableAttributedString()
                        .bold(String(format: "%@\n", "my_position".localized()), size: 13)
                        .normal(name, size: 11)
                } else if let distance = informations.distance {
                    nameLabel.attributedText = NSMutableAttributedString()
                        .normal(name, size: 13)
                        .bold(String(format: " %@", distance), color: Configuration.Color.gray, size: 10)
                } else {
                    nameLabel.attributedText = NSMutableAttributedString()
                        .normal(name, size: 13)
                }
            } else if type == .locationDisabled {
                var enableLocationText = "please_enable_location_manually".localized()
                if #available(iOS 10.0, *) {
                    enableLocationText = "please_enable_location".localized()
                }
                
                nameLabel.attributedText = NSMutableAttributedString()
                    .bold(String(format: "%@\n", "my_position".localized()), size: 13)
                    .normal(enableLocationText, size: 11)
            } else if type == .locationLoading {
                nameLabel.attributedText = NSMutableAttributedString()
                    .bold(String(format: "%@\n", "my_position".localized()), size: 13)
                    .normal("loading".localized(), size: 11)
            } else if type == .locationNotFound {
                nameLabel.attributedText = NSMutableAttributedString()
                    .bold(String(format: "%@\n", "my_position".localized()), size: 13)
                    .normal("location_not_found".localized(), size: 11)
            }
            
            isUserInteractionEnabled = type != .locationLoading && type != .locationNotFound
        }
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
