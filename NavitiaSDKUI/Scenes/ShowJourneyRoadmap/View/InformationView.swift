//
//  InformationView.swift
//  NavitiaSDKUI
//
//  Created by Adeline Hirsch on 23/09/2019.
//

import Foundation

class InformationView: UIView {
    
    enum Status {
        case taxi_not_bookable
        case no_bookable_transport
        case some_unbookable_transport
        case no_supported_transport
        case some_unsopported_transport
    }
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var streamerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    static var identifier: String {
        return String(describing: self)
    }
    internal var status: Status? {
        didSet {
            updateStatus()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        shadowView.setShadow(opacity: 0.28)
    }
    
    class func instanceFromNib() -> InformationView {
        return UINib(nibName: identifier, bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: nil, options: nil)[0] as! InformationView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let baseHeight = descriptionLabel.frame.size.height < iconImageView.frame.size.height ? iconImageView.frame.size.height : descriptionLabel.frame.size.height
        frame.size.height = baseHeight + 40
        if let superview = superview as? StackScrollView {
            superview.reloadStack()
        }
    }
    
    private func updateStatus() {
        if let status = status {
            switch status {
            case .taxi_not_bookable:
                streamerView.backgroundColor = Configuration.Color.coolBlue
                iconImageView.image = "information".getIcon()
                iconImageView.tintColor = Configuration.Color.coolBlue
                setText(boldText: "taxi_booking_only_advance".localized(),
                        regularText: "",
                        ligneReturn: false)
                
            case .no_bookable_transport:
                streamerView.backgroundColor = Configuration.Color.orange
                iconImageView.image = "warning".getIcon()
                iconImageView.tintColor = Configuration.Color.orange
                setText(boldText: "booking_information_not_available".localized(),
                        regularText: "please_try_again".localized(),
                        ligneReturn: true)
                
            case .some_unbookable_transport:
                streamerView.backgroundColor = Configuration.Color.orange
                iconImageView.image = "warning".getIcon()
                iconImageView.tintColor = Configuration.Color.orange
                setText(boldText: "booking_information_not_available".localized(),
                        regularText: "buy_tickets_rest_journey".localized(),
                        ligneReturn: true)
                
            case .no_supported_transport:
                streamerView.backgroundColor = Configuration.Color.black
                iconImageView.image = "ticket_not_available".getIcon()
                iconImageView.tintColor = Configuration.Color.black
                setText(boldText: "do_not_support_provider".localized(),
                        regularText: "",
                        ligneReturn: false)
                
            case .some_unsopported_transport:
                streamerView.backgroundColor = Configuration.Color.black
                iconImageView.image = "ticket_not_available".getIcon()
                iconImageView.tintColor = Configuration.Color.black
                setText(boldText: "do_not_support_all_provider".localized(),
                        regularText: "buy_tickets_rest_journey".localized(),
                        ligneReturn: false)
            }
        }
    }
    
    private func setText(boldText: String, regularText: String, ligneReturn: Bool) {
        let text = boldText + (ligneReturn ? "\n" : " ") + regularText
        
        let attributedString = NSMutableAttributedString(string: text, attributes: [
            .font: UIFont.systemFont(ofSize: 14.0, weight: .regular),
            .foregroundColor: UIColor(white: 0.0, alpha: 1.0)
            ])
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14.0, weight: .bold), range: NSRange(location: 0, length: boldText.count))
        descriptionLabel.attributedText = attributedString
    }
}
