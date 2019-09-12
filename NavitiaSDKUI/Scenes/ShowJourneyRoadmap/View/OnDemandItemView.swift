//
//  DisruptionItemView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class OnDemandItemView: UIView {
    
    @IBOutlet weak var reservationIconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var informationLabel: UILabel!
    
    private var phoneNumber = ""
    
    // MARK: - UINib
    
    static var identifier: String {
        return String(describing: self)
    }
    
    class func instanceFromNib() -> OnDemandItemView {
        return UINib(nibName: identifier, bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: nil, options: nil)[0] as! OnDemandItemView
    }
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    // MARK: - Function
    
    private func setup() {
        reservationIconImageView.image = "phone_tad".getIcon()
        reservationIconImageView.tintColor = Configuration.Color.main
        
        titleLabel.attributedText = NSMutableAttributedString().normal("mandatory_reservation".localized(), color: Configuration.Color.main, size: 13)
    }
}

extension OnDemandItemView {

    func setInformation(text: String) {
        let attri = NSMutableAttributedString().normal(text, color: Configuration.Color.black, size: 12)
        
        do {
            let types: NSTextCheckingResult.CheckingType = [.phoneNumber]
            let detector = try NSDataDetector(types: types.rawValue)
            detector.enumerateMatches(in: text, options: [], range: NSMakeRange(0, text.count)) { (resul, _, _) in
                if let range = resul?.range, let phoneNumber = resul?.phoneNumber {
                    attri.addAttributes([
                        .font: UIFont.systemFont(ofSize: 13.0, weight: .bold),
                        .foregroundColor: Configuration.Color.main,
                        .underlineStyle: NSUnderlineStyle.single.rawValue
                        ], range: range)
                    self.phoneNumber = phoneNumber
                    
                    let tap = UITapGestureRecognizer(target: self, action: #selector(OnDemandItemView.callNumber))
                    informationLabel.isUserInteractionEnabled = true
                    informationLabel.addGestureRecognizer(tap)
                }
            }
        } catch {}
        
        informationLabel.attributedText = attri
    }
    
    @objc func callNumber(gesture: UITapGestureRecognizer) {
        var phoneNumber = ""
        
        for item in self.phoneNumber.components(separatedBy: CharacterSet(charactersIn:"+0123456789").inverted) {
            phoneNumber += item
        }
        
        if phoneNumber != "", let phoneCallURL = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(phoneCallURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(phoneCallURL)
            }
        }
    }
}
