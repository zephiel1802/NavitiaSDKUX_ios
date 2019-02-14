//
//  LocationTableViewCell.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 14/02/2019.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    @IBOutlet weak var addressLabel: UILabel!
    //    internal var type: ListPlaces.FetchPlaces.ViewModel.ModelType? {
//        didSet {
//            guard let type = type else {
//                return
//            }
//
//            switch type {
//            case .stopArea:
//                typeimageView.image = UIImage(named: "stopArea", in: NavitiaSDKUI.shared.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
//            case .address:
//                typeimageView.image = UIImage(named: "address", in: NavitiaSDKUI.shared.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
//            case .poi:
//                typeimageView.image = UIImage(named: "poi", in: NavitiaSDKUI.shared.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
//            }
//
//            typeimageView.tintColor = Configuration.Color.black
//        }
//    }
//
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
