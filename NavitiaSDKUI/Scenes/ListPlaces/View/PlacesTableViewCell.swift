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
            case .address:
                typeimageView.image = UIImage(named: "address", in: NavitiaSDKUI.shared.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                typeimageView.tintColor = Configuration.Color.black
            case .poi:
                typeimageView.image = UIImage(named: "poi", in: NavitiaSDKUI.shared.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                typeimageView.tintColor = Configuration.Color.black
            case .location:
                typeimageView.image = UIImage(named: "locationAutocomplete", in: NavitiaSDKUI.shared.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                typeimageView.tintColor = Configuration.Color.main
            }
        }
    }
    
    internal var name: String? {
        didSet {
            guard let name = name else {
                return
            }
            
            if type == .location {
                nameLabel.attributedText = NSMutableAttributedString()
                    .bold("Ma position\n", size: 13)
                    .normal(name, size: 11)
            } else {
                nameLabel.text = name
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
