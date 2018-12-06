//
//  DisruptionItemView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class DisruptionItemView: UIView {
    
    @IBOutlet weak var disruptionImage: UIImageView!
    @IBOutlet weak var disruptionTitleLabel: UILabel!
    @IBOutlet weak var disruptionDateLabel: UILabel!
    @IBOutlet weak var displayArrowLabel: UILabel!
    @IBOutlet weak var disruptionInformationLabel: UILabel!
    @IBOutlet var disruptionInformationBottomConstraint: NSLayoutConstraint!
    @IBOutlet var disruptionDateBottomConstraint: NSLayoutConstraint!
    
    var accessibility: String?
    
    var disruptionInformation: String? {
        didSet {
            guard let disruptionInformation = disruptionInformation else {
                return
            }
            
            disruptionInformationLabel.attributedText = NSMutableAttributedString().normal(disruptionInformation, color: Configuration.Color.darkerGray, size: 12)
        }
    }
    
    var disruptionDate: String? {
        didSet {
            guard let disruptionDate = disruptionDate else {
                return
            }
            
            disruptionDateLabel.attributedText = NSMutableAttributedString().bold(disruptionDate, color: Configuration.Color.darkerGray, size: 12)
        }
    }
    
    var disruptionInformationHidden: Bool? {
        didSet {
            guard let disruptionInformationHidden = disruptionInformationHidden else {
                return
            }
            
            if disruptionInformationHidden {
                displayArrowLabel.attributedText = NSMutableAttributedString().icon("arrow-details-down", color: Configuration.Color.darkerGray, size: 14)
                disruptionDateBottomConstraint.isActive = true
                disruptionInformationBottomConstraint.isActive = false
                disruptionInformationLabel.isHidden = true
            } else {
                displayArrowLabel.attributedText = NSMutableAttributedString().icon("arrow-details-up", color: Configuration.Color.darkerGray, size: 14)
                disruptionDateBottomConstraint.isActive = false
                disruptionInformationBottomConstraint.isActive = true
                disruptionInformationLabel.isHidden = false
            }
        }
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    class func instanceFromNib() -> DisruptionItemView {
        return UINib(nibName: identifier, bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: nil, options: nil)[0] as! DisruptionItemView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        disruptionInformationHidden = true
    }
    
    func setIcon(icon: String) {
        guard let image = Disruption().levelImage(name: icon) else {
            disruptionImage.isHidden = true
            
            return
        }
        
        disruptionImage.isHidden = false
        disruptionImage.image = image
    }
    
    func setDisruptionTitle(title: String, color: UIColor) {
        disruptionTitleLabel.attributedText = NSMutableAttributedString().bold(title, color: color, size: 12)
    }

    @IBAction func manageDisruptionInformationDisplay(_ sender: UIButton) {
        disruptionInformationHidden = !disruptionInformationLabel.isHidden
    }
}

