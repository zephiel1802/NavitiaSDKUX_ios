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
                typeimageView.image = UIImage(named: "stopArea", in: NavitiaSDKUI.shared.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                typeimageView.tintColor = Configuration.Color.black
            case .poi:
                typeimageView.image = UIImage(named: "poi", in: NavitiaSDKUI.shared.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                typeimageView.tintColor = Configuration.Color.black
            case .location: fallthrough
            case .locationLoading: fallthrough
            case .locationDisabled:
                typeimageView.image = UIImage(named: "locationAutocomplete", in: NavitiaSDKUI.shared.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                typeimageView.tintColor = Configuration.Color.main
            default:
                typeimageView.image = UIImage(named: "address", in: NavitiaSDKUI.shared.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
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
            } else if type == .locationDisabled {
                var enableLocationText = "please_enable_your_location_manually_in_your_settings".localized()
                if #available(iOS 10.0, *) {
                    enableLocationText = "Please_enable_your_location".localized()
                }
                
                nameLabel.attributedText = NSMutableAttributedString()
                    .bold(String(format: "%@\n", "my_position".localized()), size: 13)
                    .normal(enableLocationText, size: 11)
            } else if type == .locationLoading {
                nameLabel.attributedText = NSMutableAttributedString()
                    .bold(String(format: "%@\n", "my_position".localized()), size: 13)
                    .normal("loading".localized(), size: 11)
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
