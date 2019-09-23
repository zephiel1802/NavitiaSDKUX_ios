//
//  InformationView.swift
//  NavitiaSDKUI
//
//  Created by Adeline Hirsch on 23/09/2019.
//

import Foundation

class InformationView: UIView {
    
    enum Mode {
        case warning
        case info
        case neutal
    }
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var streamerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    static var identifier: String {
        return String(describing: self)
    }
    internal var titleText: String? {
        didSet {
            if let text = titleText {
                titleLabel.text = text
            }
        }
    }
    internal var descriptionText: String? {
        didSet {
            if let text = descriptionText {
                descriptionLabel.text = text
            }
        }
    }
    internal var mode: Mode? {
        didSet {
            if let mode = mode {
                switch mode {
                case .info:
                    streamerView.backgroundColor = Configuration.Color.alertInfoDarker
                case .neutal:
                    streamerView.backgroundColor = Configuration.Color.black
                case .warning :
                    streamerView.backgroundColor = Configuration.Color.alertWarning
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundView.setShadow(opacity: 0.28)
    }
    
    class func instanceFromNib() -> InformationView {
        return UINib(nibName: identifier, bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: nil, options: nil)[0] as! InformationView
    }
}
