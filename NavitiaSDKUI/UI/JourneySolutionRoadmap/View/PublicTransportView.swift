//
//  PublicTransportTableViewCell.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 09/04/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class PublicTransportView: UIView {
    
    @IBOutlet var _view: UIView!
    
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var takeLabel: UILabel!
    @IBOutlet weak var originTransitLabel: UILabel!
    @IBOutlet weak var directionTransitLabel: UILabel!
    
    @IBOutlet weak var transportView: UIView!
    @IBOutlet weak var transportLabel: UILabel!
    @IBOutlet weak var disruptionCircleLabel: UILabel!
    @IBOutlet weak var disruptionIconTransportLabel: UILabel!
    
    
    @IBOutlet var disruptionView: UIView!
    @IBOutlet var waitView: UIView!
    @IBOutlet var waitHeightContraint: NSLayoutConstraint!
    @IBOutlet var disruptionTopContraint: NSLayoutConstraint!
    @IBOutlet var disruptionBottomWaitTopContraint: NSLayoutConstraint!
    @IBOutlet var waitBottomContraint: NSLayoutConstraint!
    @IBOutlet var waitIconLabel: UILabel!
    @IBOutlet var waitTimeLabel: UILabel!
    
    @IBOutlet weak var disruptionIconLabel: UILabel!
    @IBOutlet weak var disruptionTitleLabel: UILabel!
    @IBOutlet weak var disruptionInformationLabel: UILabel!
    @IBOutlet weak var disruptionDateLabel: UILabel!
    
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    
    @IBOutlet weak var stationButton: UIButton!
    
    @IBOutlet var stationsView: UIView!
    @IBOutlet var stationsHeightContraint: NSLayoutConstraint!
    @IBOutlet var stationsTopContraint: NSLayoutConstraint!
    @IBOutlet var stationsBottomContraint: NSLayoutConstraint!
    
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    
    @IBOutlet weak var pinOriginView: UIView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var pinEndView: UIView!
    
     var _type: TypeTransport?
     var _disruptionType: TypeDisruption?
    
    var stations: [String] = [] {
        didSet {
            stationsIsHidden = true
            displayStationStack()
        }
    }
    var stationStackView: UIStackView!
    
    enum TypeStep: String {
        case departure
        case arrival
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _setup()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var frame: CGRect {
        willSet {
            if let _view = _view {
                _view.frame.size = newValue.size
            }
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        _setup()
    }
    
    private func _setup() {
        UINib(nibName: "PublicTransportView", bundle: bundle).instantiate(withOwner: self, options: nil)
        _view.frame = self.bounds
        addSubview(_view)
        
        stationsIsHidden = true
        waitIsHidden = true
        disruptionIsHidden = true
        disruptionIconTransportLabel.isHidden = true
        disruptionCircleLabel.isHidden = true
        
        setHeight()
        addStationStackView()
        
//
////
////        let s = UIStackView(frame: stationsView.bounds)
////        s.axis = .vertical
////        s.distribution = .fillEqually
////        s.alignment = .fill
////        s.spacing = 7
////        s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
////
////
////
////
////
////        stationsView.addSubview(s)
//
//        let view1 = StationsView(frame: CGRect(x: 0, y: 0, width: stationsView.frame.size.width, height: 20))
//        view1.stationColor = UIColor.purple
//        view1.stationName = "Chatelet"
//
//
//        let view2 = StationsView(frame: CGRect(x: 0, y: 0, width: stationsView.frame.size.width, height: 20))
//        view2.stationColor = UIColor.purple
//        view2.stationName = "Madelaine"
//
//        let view3 = StationsView(frame: CGRect(x: 0, y: 0, width: stationsView.frame.size.width, height: 20))
//        view3.stationColor = UIColor.purple
//        view3.stationName = "Pyramide"
//
//        stationStackView.addArrangedSubview(view1)
//        stationStackView.addArrangedSubview(view2)
//        stationStackView.addArrangedSubview(view3)
    }

    @IBAction func actiii(_ sender: Any) {
        stationsIsHidden = !stationsView.isHidden
    }
    
    private func setHeight() {
        frame.size.height = destinationLabel.frame.height + destinationLabel.frame.origin.y + 15
    }
    
    private func addStationStackView() {
        stationStackView = UIStackView(frame: stationsView.bounds)
        stationStackView.axis = .vertical
        stationStackView.distribution = .fillEqually
        stationStackView.alignment = .fill
        stationStackView.spacing = 7
        stationStackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        stationsView.addSubview(stationStackView)
    }
    
    private func displayStationStack() {
        stationsHeightContraint.constant = CGFloat(stations.count)  * 21
        for station in stations {
            let view = StationsView(frame: CGRect(x: 0, y: 0, width: stationsView.frame.size.width, height: 20))
            view.stationColor = transportColor
            view.stationName = station
            stationStackView.addArrangedSubview(view)
        }
    }

}

extension PublicTransportView {
    
    var type: TypeTransport? {
        get {
            return _type
        }
        set {
            if let type = newValue {
                _type = type
                icon = type.rawValue
                take = type.rawValue
            }
        }
    }
    
    var transportColor: UIColor? {
        get {
            return transportView.backgroundColor
        }
        set {
            transportView.backgroundColor = newValue
            pinOriginView.backgroundColor = newValue
            lineView.backgroundColor = newValue
            pinEndView.backgroundColor = newValue
        }
    }
    
    var transportName: String? {
        get {
            return transportLabel.text
        }
        set {
            if let newValue = newValue {
                transportLabel.attributedText = NSMutableAttributedString()
                    .bold(newValue, color: UIColor.white, size: 9)
            }
        }
    }

    var icon: String? {
        get {
            return iconLabel.text
        }
        set {
            if let newValue = newValue {
                iconLabel.text = Icon(newValue).iconFontCode
                iconLabel.font = UIFont(name: "SDKIcons", size: 20)
            }
        }
    }
    
    var take: String? {
        get {
            return takeLabel.text
        }
        set {
            if let newValue = newValue {
                takeLabel.attributedText = NSMutableAttributedString()
                    .normal("Prendre le ", size: 15)
                    .bold(newValue, size: 15)
            }
        }
    }
    
    var disruptionType: TypeDisruption? {
        get {
            return _disruptionType
        }
        set {
            if let newValue = newValue {
                _disruptionType = newValue
                disruptionIsHidden = false
                disruptionIconLabel.attributedText = NSMutableAttributedString()
                    .icon("disruption-" + newValue.rawValue, size: 15)
                disruptionIconLabel.textColor = UIColor.red
                disruptionTitleLabel.attributedText = NSMutableAttributedString()
                    .normal(newValue.rawValue, size: 12)
                
                
                disruptionCircleLabel.attributedText = NSMutableAttributedString()
                    .icon("circle-filled", size: 15)
                disruptionCircleLabel.textColor = UIColor.white
                disruptionCircleLabel.isHidden = false
                
                disruptionIconTransportLabel.attributedText = NSMutableAttributedString()
                    .icon("disruption-" + newValue.rawValue, size: 14)
                disruptionIconTransportLabel.textColor = UIColor.red
                disruptionIconTransportLabel.isHidden = false
                
            }
        }
    }
    
    var disruptionInformation: String? {
        get {
            return disruptionInformationLabel.text
        }
        set {
            if let newValue = newValue {
                disruptionInformationLabel.attributedText = NSMutableAttributedString()
                    .normal(newValue, size: 12)
            }
        }
    }
    
    var disruptionDate: String? {
        get {
            return disruptionDateLabel.text
        }
        set {
            if let newValue = newValue {
                disruptionDateLabel.attributedText = NSMutableAttributedString()
                    .bold(newValue, size: 12)
            }
        }
    }
    
    var waitTime: String? {
        get {
            return waitTimeLabel.text
        }
        set {
            if let newValue = newValue {
                waitIconLabel.attributedText = NSMutableAttributedString()
                    .icon("clock", size: 15)
                waitTimeLabel.attributedText = NSMutableAttributedString()
                    .normal("Attendre ", size: 12)
                    .normal(newValue, size: 12)
                    .normal(" minutes", size: 12)
                waitIsHidden = false
            }
        }
    }
    
    var origin: String? {
        get {
            return originLabel.text
        }
        set {
            if let newValue = newValue {
                originTransitLabel.attributedText = NSMutableAttributedString()
                    .normal("à ", size: 15)
                    .bold(newValue, size: 15)
                originLabel.attributedText = NSMutableAttributedString()
                    .bold(newValue, size: 15)
            }
        }
    }
    
    var destination: String? {
        get {
            return destinationLabel.text
        }
        set {
            if let newValue = newValue {
                destinationLabel.attributedText = NSMutableAttributedString()
                    .bold(newValue, size: 15)
            }
        }
    }
    
    var directionTransit: String? {
        get {
            return directionTransitLabel.text
        }
        set {
            if let newValue = newValue {
                directionTransitLabel.attributedText = NSMutableAttributedString()
                    .normal("en direction de ", size: 15)
                    .bold(newValue, size: 15)
            }
        }
    }
    
    var disruptionIsHidden: Bool {
        get {
            return !disruptionView.isHidden
        }
        set {
            if newValue {
                disruptionView.isHidden = true
                frame.size.height -= disruptionView.frame.size.height
                disruptionBottomWaitTopContraint.isActive = false
                disruptionTopContraint.isActive = false
            } else {
                disruptionView.isHidden = false
                frame.size.height += disruptionView.frame.size.height
                disruptionBottomWaitTopContraint.isActive = true
                disruptionTopContraint.isActive = true
            }
        }
    }
    
    var waitIsHidden: Bool {
        get {
            return !waitView.isHidden
        }
        set {
            if newValue {
                waitView.isHidden = true
                frame.size.height -= waitView.frame.size.height
                disruptionBottomWaitTopContraint.isActive = false
                waitBottomContraint.isActive = false
            } else {
                waitView.isHidden = false
                frame.size.height += waitView.frame.size.height
                disruptionBottomWaitTopContraint.isActive = true
                waitBottomContraint.isActive = true
            }
        }
    }
    
    var stationsIsHidden: Bool {
        get {
            return !stationsView.isHidden
        }
        set {
            if newValue {
                stationsView.isHidden = true
                stationsTopContraint.isActive = false
                stationsBottomContraint.isActive = false
                stationButton.setAttributedTitle(NSMutableAttributedString()
                    .normal(String(stations.count), size: 13)
                    .normal(" arrêts  ", size: 13)
                    .icon("arrow-details-up", size: 13)
                    ,for: .normal)
                frame.size.height -= stationsView.frame.size.height
            } else {
                stationsView.isHidden = false
                stationsTopContraint.isActive = true
                stationsBottomContraint.isActive = true
                stationButton.setAttributedTitle(NSMutableAttributedString()
                    .normal(String(stations.count), size: 13)
                    .normal(" arrêts  ", size: 13)
                    .icon("arrow-details-down", size: 13)
                    ,for: .normal)
                frame.size.height += stationsView.frame.size.height
            }
        }
    }
    
}
