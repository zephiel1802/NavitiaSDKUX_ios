//
//  DisruptionItemView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class DisruptionItemView: UIView {
    
    @IBOutlet weak var disruptionIconLabel: UILabel!
    @IBOutlet weak var disruptionTitleLabel: UILabel!
    @IBOutlet weak var disruptionDateLabel: UILabel!
    @IBOutlet weak var displayArrowLabel: UILabel!
    @IBOutlet weak var disruptionInformationLabel: UILabel!
    @IBOutlet var disruptionInformationBottomConstraint: NSLayoutConstraint!
    @IBOutlet var disruptionDateBottomConstraint: NSLayoutConstraint!
    
    var publicTransportView: PublicTransportView?
    
    var disruption: Disruption? {
        get {
            return self.disruption
        }
        set {
            if let newValue = newValue {
                setDisruptionType(newValue)
                setDisruptionTitle(title: newValue.severity?.name ?? "", color: newValue.severity?.color?.toUIColor())
                disruptionInformation = Disruption.message(disruption: newValue)?.text?.htmlToAttributedString?.string
                if let startDate = newValue.applicationPeriods?.first?.begin?.toDate(format: Configuration.date), let endDate = newValue.applicationPeriods?.first?.end?.toDate(format: Configuration.date) {
                    disruptionDate = String(format: "%@ %@ %@ %@", "from".localized(withComment: "Back", bundle: NavitiaSDKUI.shared.bundle), startDate.toString(format: Configuration.dateInterval), "to_period".localized(withComment: "Back", bundle: NavitiaSDKUI.shared.bundle), endDate.toString(format: Configuration.dateInterval))
                }
            }
        }
    }
    
    class func instanceFromNib() -> DisruptionItemView {
        return UINib(nibName: "DisruptionItemView", bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: nil, options: nil)[0] as! DisruptionItemView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        disruptionInformationHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.publicTransportView?.layoutSubviews()
    }
    
    @IBAction func manageDisruptionInformationDisplay(_ sender: UIButton) {
        disruptionInformationHidden = !disruptionInformationLabel.isHidden
    }
}

extension DisruptionItemView {
    
    func setDisruptionType(_ disruption: Disruption) {
        disruptionIconLabel.attributedText = NSMutableAttributedString().icon(Disruption.iconName(of: disruption.level), size: 15)
        disruptionIconLabel.textColor = disruption.severity?.color?.toUIColor() ?? UIColor.red
    }
    
    func setDisruptionTitle(title: String, color: UIColor?) {
        disruptionTitleLabel.attributedText = NSMutableAttributedString().bold(title, color: color ?? UIColor.black, size: 12)
    }
    
    var disruptionInformation: String? {
        get {
            return disruptionInformationLabel.text
        }
        set {
            if let newValue = newValue {
                disruptionInformationLabel.attributedText = NSMutableAttributedString().normal(newValue, color: Configuration.Color.darkerGray, size: 12)
            }
        }
    }
    
    var disruptionDate: String? {
        get {
            return disruptionDateLabel.text
        }
        set {
            if let newValue = newValue {
                disruptionDateLabel.attributedText = NSMutableAttributedString().bold(newValue, color: Configuration.Color.darkerGray, size: 12)
            }
        }
    }
    
    var disruptionInformationHidden: Bool? {
        get {
            return disruptionInformationLabel.isHidden
        }
        set {
            if let newValue = newValue, newValue {
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
}
