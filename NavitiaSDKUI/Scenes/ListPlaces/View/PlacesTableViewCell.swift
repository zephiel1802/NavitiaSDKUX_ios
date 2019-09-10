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
                typeimageView.image = "autocomplete_stopArea".getIcon(customizable: true)
                typeimageView.tintColor = Configuration.Color.black
            case .poi:
                typeimageView.image = "autocomplete_poi".getIcon(customizable: true)
                typeimageView.tintColor = Configuration.Color.black
            case .location:
                typeimageView.image = "autocomplete_my_position".getIcon(customizable: true)
                typeimageView.tintColor = Configuration.Color.main
            default:
                typeimageView.image = "autocomplete_address".getIcon(customizable: true)
                typeimageView.tintColor = Configuration.Color.black
            }
        }
    }
    
    internal var informations: (name: String?, distance: String?) {
        didSet {
            guard let name = informations.name else {
                return
            }
            
            if type == .location {
                nameLabel.attributedText = NSMutableAttributedString()
                    .bold(String(format: "%@\n", "my_position".localized()), size: 13)
                    .normal(name, size: 11)
            } else {
                if let distance = informations.distance {
                    nameLabel.attributedText = NSMutableAttributedString()
                        .normal(name, size: 13)
                        .bold(String(format: " %@", distance), color: Configuration.Color.gray, size: 10)
                } else {
                    nameLabel.attributedText = NSMutableAttributedString()
                        .normal(name, size: 13)
                }
            }
        }
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
