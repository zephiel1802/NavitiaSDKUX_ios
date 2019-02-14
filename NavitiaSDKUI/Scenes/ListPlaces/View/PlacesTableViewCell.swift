//
//  PlacesTableViewCell.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 30/01/2019.
//

import UIKit

class PlacesTableViewCell: UITableViewCell {
    
    enum ModelType: String {
        case stopArea
        case address
        case poi
        case location
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
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //setup()
    }
    
}
