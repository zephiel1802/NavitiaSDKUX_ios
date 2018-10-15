//
//  PublicTransportTableViewCell.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class PublicTransportView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var takeLabel: UILabel!
    @IBOutlet weak var originTransitLabel: UILabel!
    @IBOutlet weak var transportView: UIView!
    @IBOutlet weak var transportLabel: UILabel!
    @IBOutlet weak var disruptionCircleLabel: UILabel!
    @IBOutlet weak var disruptionIconTransportLabel: UILabel!
    @IBOutlet weak var informationStackView: UIStackView!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var stationButton: UIButton!
    @IBOutlet var stationsView: UIView!
    @IBOutlet var stationsHeightContraint: NSLayoutConstraint!
    @IBOutlet var stationsTopContraint: NSLayoutConstraint!
    @IBOutlet var stationsBottomContraint: NSLayoutConstraint!
    @IBOutlet var stationsHiddenBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var pinOriginView: UIView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var pinEndView: UIView!
    
    var mode: ModeTransport?
    var disruptionType: TypeDisruption?
    
    var origin: String = "" {
        didSet {
            originTransitLabel.attributedText = NSMutableAttributedString()
                .normal("at".localized(withComment: "at", bundle: NavitiaSDKUI.shared.bundle), size: 15)
                .normal(" ", size: 15)
                .bold(origin, size: 15)
                .normal(" ", size: 15)
                .normal("in_the_direction_of".localized(withComment: "in_the_direction_of", bundle: NavitiaSDKUI.shared.bundle), size: 15)
                .normal(" ", size: 15)
                .bold(directionTransit, size: 15)
            originLabel.attributedText = NSMutableAttributedString()
                .bold(origin, size: 15)
        }
    }
    
    var directionTransit: String = "" {
        didSet {
            originTransitLabel.attributedText = NSMutableAttributedString()
                .normal("at".localized(withComment: "at", bundle: NavitiaSDKUI.shared.bundle), size: 15)
                .normal(" ", size: 15)
                .bold(origin, size: 15)
                .normal(" ", size: 15)
                .normal("in_the_direction_of".localized(withComment: "in_the_direction_of", bundle: NavitiaSDKUI.shared.bundle), size: 15)
                .normal(" ", size: 15)
                .bold(directionTransit, size: 15)
        }
    }
    
    var stations: [String] = [] {
        didSet {
            if !stations.isEmpty {
                stationButton.isHidden = false
                stationsHiddenBottomContraint.isActive = true
            }
            stationsIsHidden = true
            updateStationStack()
        }
    }
    var waitingTime: String? {
        didSet {
            guard let waitingTime = waitingTime else {
                return
            }
            
            let publicTransportWaitingBlocView = PublicTransportWaitingBlocView.instanceFromNib()
            
            publicTransportWaitingBlocView.frame = informationStackView.bounds
            publicTransportWaitingBlocView.waitingTime = waitingTime
            informationStackView.addArrangedSubview(publicTransportWaitingBlocView)
        }
    }
    var stationStackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var frame: CGRect {
        willSet {
            if let view = view {
                view.frame.size = newValue.size
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        frame.size.height = destinationLabel.frame.height + destinationLabel.frame.origin.y + 15
        if let superview = superview as? StackScrollView {
            superview.reloadStack()
        }
    }

    private func setup() {
        UINib(nibName: "PublicTransportView", bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: self, options: nil)
        view.frame = self.bounds
        addSubview(view)

        addShadow(opacity: 0.28)
        frame.size.height = destinationLabel.frame.height + destinationLabel.frame.origin.y + 15
        
        stationsIsHidden = true
        disruptionIconTransportLabel.isHidden = true
        disruptionCircleLabel.isHidden = true
        stationButton.isHidden = true
        stationsHiddenBottomContraint.isActive = false
        
        setupStationStackView()
    }

    @IBAction func actionStationButton(_ sender: Any) {
        if !stations.isEmpty {
            stationsIsHidden = !stationsView.isHidden
        }
    }
    
    private func setHeight() {
        frame.size.height = destinationLabel.frame.height + destinationLabel.frame.origin.y + 15
    }
}

extension PublicTransportView {
    
    func setupStationStackView() {
        stationStackView = UIStackView(frame: stationsView.bounds)
        stationStackView.axis = .vertical
        stationStackView.distribution = .fillEqually
        stationStackView.alignment = .fill
        stationStackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        stationsView.addSubview(stationStackView)
    }
    
    func updateStationStack() {
        stationsHeightContraint.constant = CGFloat(stations.count) * 25
        for station in stations {
            let view = StationsView(frame: CGRect(x: 0, y: 0, width: stationsView.frame.size.width, height: 20))
            view.stationColor = transportColor
            view.stationName = station
            
            stationStackView.addArrangedSubview(view)
        }
    }
    
}

extension PublicTransportView {
    
    var modeString: String? {
        get {
            return mode?.rawValue
        }
        set {
            if let newValue = newValue {
                mode = ModeTransport(rawValue: newValue)
                icon = newValue
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
                    .bold(newValue, color: transportColor?.contrastColor() ?? Configuration.Color.white, size: 9)
            } else {
                transportView.isHidden = true
                disruptionCircleLabel.isHidden = true
                disruptionIconTransportLabel.isHidden = true
            }
        }
    }

    private var icon: String? {
        get {
            return iconLabel.text
        }
        set {
            if let newValue = newValue {
                iconLabel.attributedText = NSMutableAttributedString()
                    .icon(newValue, size: 20)
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
                    .normal(String(format: "%@ %@",
                                   "take_the".localized(withComment: "Take tke", bundle: NavitiaSDKUI.shared.bundle),
                                   newValue),
                            size: 15)
            }
        }
    }
    
    func setDisruptions(disruptions: [ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel.DisruptionModel]) {
        if disruptions.count > 0 {
            disruptionCircleLabel.attributedText = NSMutableAttributedString().icon("circle-filled", size: 15)
            disruptionCircleLabel.textColor = UIColor.white
            disruptionCircleLabel.isHidden = false
            
            if let firstDisruption = disruptions.first {
                disruptionIconTransportLabel.attributedText = NSMutableAttributedString().icon(firstDisruption.icon, size: 14)
                disruptionIconTransportLabel.textColor = firstDisruption.color
                disruptionIconTransportLabel.isHidden = false
            }
            
            for (index, disruption) in disruptions.enumerated() {
                let disruptionItemView = DisruptionItemView.instanceFromNib()
                
                disruptionItemView.frame = informationStackView.bounds
                disruptionItemView.setIcon(icon: disruption.icon, color: disruption.color)
                disruptionItemView.setDisruptionTitle(title: disruption.title, color: disruption.color)
                disruptionItemView.disruptionInformation = disruption.information
                disruptionItemView.disruptionDate = disruption.date
                disruptionItemView.publicTransportView = self
                informationStackView.addArrangedSubview(disruptionItemView)
                
                if index < disruptions.count - 1 {
                    let horizontalSeprator = HorizontalSeparator.instanceFromNib()
                    informationStackView.addArrangedSubview(horizontalSeprator)
                }
            }
        }
    }
    
    func setOnDemandTransport(text: String) {
        let onDemandItemView = OnDemandeItemView.instanceFromNib()
        
        onDemandItemView.frame = informationStackView.bounds
        onDemandItemView.setInformation(text: text)
        informationStackView.addArrangedSubview(onDemandItemView)
    }
    
    var startTime: String? {
        get {
            return startTimeLabel.text
        }
        set {
            if let newValue = newValue {
                startTimeLabel.attributedText = NSMutableAttributedString()
                    .normal(newValue, size: 12)
            }
        }
    }
    
    var endTime: String? {
        get {
            return endTimeLabel.text
        }
        set {
            if let newValue = newValue {
                endTimeLabel.attributedText = NSMutableAttributedString()
                    .normal(newValue, size: 12)
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
    
    var stationsIsHidden: Bool {
        get {
            return !stationsView.isHidden
        }
        set {
            if newValue {
                stationsView.isHidden = true
                stationsTopContraint.isActive = false
                stationsBottomContraint.isActive = false
                stationsHiddenBottomContraint.isActive = true
                stationButton.setAttributedTitle(NSMutableAttributedString()
                    .normal(String(format: "%@ %@ ",
                                   String(stations.count + 1),
                                   "stops".localized(withComment: "stops", bundle: NavitiaSDKUI.shared.bundle)),
                            color: Configuration.Color.gray,
                            size: 13)
                    .icon("arrow-details-down", color: Configuration.Color.gray, size: 13)
                    ,for: .normal)
                
                frame.size.height -= stationsView.frame.size.height
            } else {
                stationsView.isHidden = false
                stationsTopContraint.isActive = true
                stationsBottomContraint.isActive = true
                stationsHiddenBottomContraint.isActive = false
                stationButton.setAttributedTitle(NSMutableAttributedString()
                    .normal(String(format: "%@ %@ ",
                                   String(stations.count + 1),
                                   "stops".localized(withComment: "stops", bundle: NavitiaSDKUI.shared.bundle)),
                            color: Configuration.Color.gray,
                            size: 13)
                    .icon("arrow-details-up", color: Configuration.Color.gray, size: 13)
                    ,for: .normal)
                frame.size.height += stationsView.frame.size.height
            }
        }
    }
    
}
