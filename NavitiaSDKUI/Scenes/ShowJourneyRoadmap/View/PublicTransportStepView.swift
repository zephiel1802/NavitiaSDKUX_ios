//
//  PublicTransportStepView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class PublicTransportStepView: UIView {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var publicTransportIconLabel: UILabel!
    @IBOutlet var commercialModeLabel: UILabel!
    @IBOutlet weak var informationsLabel: UILabel!
    @IBOutlet weak var transportIconView: UIView!
    @IBOutlet weak var transportIconLabel: UILabel!
    @IBOutlet weak var disruptionCircleLabel: UILabel!
    @IBOutlet weak var disruptionIconLabel: UILabel!
    @IBOutlet weak var networkContainerView: UIView!
    @IBOutlet weak var networkLabel: UILabel!
    @IBOutlet weak var waitingContainerView: UIView!
    @IBOutlet weak var waitingIconLabel: UILabel!
    @IBOutlet weak var waitingInformationsLabel: UILabel!
    @IBOutlet weak var publicTransportContainerView: UIView!
    @IBOutlet weak var publicTransportPinFromView: UIView!
    @IBOutlet weak var publicTransportLineView: UIView!
    @IBOutlet weak var publicTransportPinToView: UIView!
    @IBOutlet weak var publicTransportStartTimeLabel: UILabel!
    @IBOutlet weak var publicTransportFromLabel: UILabel!
    @IBOutlet var publicTransportStationsContainerView: UIView!
    @IBOutlet weak var publicTransportStationsButtonContainerView: UIButton!
    @IBOutlet weak var publicTransportStationsLabel: UILabel!
    @IBOutlet weak var publicTransportStationsFlecheLabel: UILabel!
    @IBOutlet var publicTransportStationsStackContainerView: UIView!
    @IBOutlet weak var publicTransportEndTimeLabel: UILabel!
    @IBOutlet weak var publicTransportToLabel: UILabel!
    @IBOutlet var publicTransportStationsContainerTopContraint: NSLayoutConstraint!
    @IBOutlet var publicTransportStationsContainerBottomContraint: NSLayoutConstraint!
    @IBOutlet var publicTransportStationsStackContainerTopContraint: NSLayoutConstraint!
    @IBOutlet var publicTransportStationsStackContainerBottomContraint: NSLayoutConstraint!
    @IBOutlet var publicTransportStationsStackHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var publicTransportFromToContraint: NSLayoutConstraint!

    private var stationStackView: UIStackView!
    
    static var identifier: String {
        return String(describing: self)
    }
    
    class func instanceFromNib() -> PublicTransportStepView {
        return UINib(nibName: identifier, bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: nil, options: nil)[0] as! PublicTransportStepView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        transport = nil
        disruptions = nil
        network = nil
        waiting = nil
        stopDates = nil

        initStationStackView()
        addShadow(opacity: 0.28)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        frame.size.height = stackView.frame.origin.y + stackView.frame.size.height
        if let superview = superview as? StackScrollView {
            superview.reloadStack()
        }
    }
    
    func updateAccessibility() {
        guard let commercialMode = commercialModeLabel.text, let informations = informationsLabel.text else {
            return
        }
        
        var accessibilityLabel = String(format: "%@ ", commercialMode)
        
        if let code = transportIconLabel.text {
            accessibilityLabel.append(String(format: "%@ ", code))
        }
        
        accessibilityLabel.append(String(format: "%@.", informations))
        
        if let waiting = waitingInformationsLabel.text, !waitingContainerView.isHidden {
            accessibilityLabel.append(String(format: "%@.", waiting))
        }
        
        
        
        for item in stackView.arrangedSubviews {
            if let itemDisruption = item as? DisruptionItemView,
                let accessibility = itemDisruption.accessibility {
                accessibilityLabel.append(accessibility)
            } else if let itemOnDemandTransport = item as? OnDemandeItemView,
                let title = itemOnDemandTransport.titleLabel.text,
                let information = itemOnDemandTransport.informationLabel.text {
                accessibilityLabel.append(String(format: "%@ : %@.", title, information))
            }
        }
        
        self.accessibilityLabel = accessibilityLabel
    }
    
    //MARK: Common
    
    var icon: String? {
        didSet {
            guard let icon = icon else {
                return
            }

            publicTransportIconLabel.attributedText = NSMutableAttributedString().icon(icon, size: 20)
        }
    }

    var commercialMode: String? {
        didSet {
            guard let commercialMode = commercialMode else {
                return
            }

            commercialModeLabel.attributedText = NSMutableAttributedString()
                .normal(String(format: "%@ %@",
                               "take_the".localized(withComment: "Take tke", bundle: NavitiaSDKUI.shared.bundle),
                               commercialMode),
                        size: 15)
            }
    }

    var informations: (from: String, direction: String)? = nil {
        didSet {
            guard let informations = informations else {
                return
            }

            informationsLabel.attributedText = NSMutableAttributedString()
                .normal("at".localized(withComment: "at", bundle: NavitiaSDKUI.shared.bundle), size: 15)
                .normal(" ", size: 15)
                .bold(informations.from, size: 15)
                .normal(" ", size: 15)
                .normal("in_the_direction_of".localized(withComment: "in_the_direction_of", bundle: NavitiaSDKUI.shared.bundle), size: 15)
                .normal(" ", size: 15)
                .bold(informations.direction, size: 15)
        }
    }

    //MARK: Network
    var network: String? = nil {
        didSet {
            guard let network = network else {
                networkContainerView.isHidden = true
                return
            }

            networkContainerView.isHidden = false
            networkLabel.attributedText = NSMutableAttributedString()
                .semiBold("Réseau : ", color: Configuration.Color.darkerGray, size: 12)
                .semiBold(network, color: Configuration.Color.main, size: 12)
        }
    }

    //MARK: OnDemandeTransport
    var notes: [ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.Note]? = nil {
        didSet {
            guard let onDemandTransports = notes else {
                return
            }

            for onDemandTransport in onDemandTransports {
                let onDemandeItemView = OnDemandeItemView.instanceFromNib()

                onDemandeItemView.setInformation(text: onDemandTransport.content)
                stackView.insertArrangedSubview(onDemandeItemView, at: 2)
            }
        }
    }

    //MARK: Disruption
    var disruptions: [ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionClean.DisruptionClean]? = nil {
        didSet {
            guard let disruptions = disruptions, disruptions.count > 0 else {
                disruptionIconLabel.isHidden = true
                disruptionCircleLabel.isHidden = true
                return
            }

            if let firstDisruption = disruptions.first {
                disruptionCircleLabel.attributedText = NSMutableAttributedString().icon("circle-filled", color: Configuration.Color.white, size: 15)
                disruptionCircleLabel.isHidden = false
                disruptionIconLabel.attributedText = NSMutableAttributedString().icon(firstDisruption.icon, color: firstDisruption.color, size: 14)
                disruptionIconLabel.isHidden = false
            }

            for (index, disruption) in disruptions.enumerated() {
                let disruptionItemView = DisruptionItemView.instanceFromNib()

                disruptionItemView.setIcon(icon: disruption.icon, color: disruption.color)
                disruptionItemView.setDisruptionTitle(title: disruption.title, color: disruption.color)
                disruptionItemView.disruptionInformation = disruption.information
                disruptionItemView.disruptionDate = disruption.date
                disruptionItemView.accessibility = disruption.accessibility

                stackView.insertArrangedSubview(disruptionItemView, at: 3)
                
                if index < disruptions.count - 1 {
                    let horizontalSeprator = HorizontalSeparator.instanceFromNib()
                    stackView.insertArrangedSubview(horizontalSeprator, at: 3)
                }
            }
        }
    }

    //MARK: Waiting

    var waiting: String? = nil {
        didSet {
            guard let waiting = waiting else {
                waitingContainerView.isHidden = true
                return
            }

            waitingContainerView.isHidden = false
            waitingIconLabel.attributedText = NSMutableAttributedString().icon("clock", color: Configuration.Color.darkerGray, size: 15)
            waitingInformationsLabel.attributedText = NSMutableAttributedString().normal(waiting, color: Configuration.Color.darkerGray, size: 12)
        }
    }


    //MARK: Public Transport

    private func initStationStackView() {
        stationStackView = UIStackView(frame: publicTransportStationsStackContainerView.bounds)
        stationStackView.axis = .vertical
        stationStackView.distribution = .fillEqually
        stationStackView.alignment = .fill
        stationStackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        publicTransportStationsStackContainerView.addSubview(stationStackView)
    }

    private var stationsContainerIsHidden: Bool = true {
        didSet {
            publicTransportStationsContainerView.isHidden = stationsContainerIsHidden
            publicTransportStationsContainerTopContraint.isActive = !stationsContainerIsHidden
            publicTransportStationsContainerBottomContraint.isActive = !stationsContainerIsHidden
            stationsStackContainerIsHidden = true
        }
    }

    private var stationsStackContainerIsHidden: Bool = true {
        didSet {
            if stationsStackContainerIsHidden {
                publicTransportStationsFlecheLabel.attributedText = NSMutableAttributedString().icon("arrow-details-down", color: Configuration.Color.gray, size: 13)
            } else {
                publicTransportStationsFlecheLabel.attributedText = NSMutableAttributedString().icon("arrow-details-up", color: Configuration.Color.gray, size: 13)
            }
            
            publicTransportStationsStackContainerView.isHidden = stationsStackContainerIsHidden
            publicTransportStationsStackContainerTopContraint.isActive = !stationsStackContainerIsHidden
            publicTransportStationsStackContainerBottomContraint.isActive = !stationsStackContainerIsHidden
        }
    }

    var transport: (code: String?, color: UIColor?)? {
        didSet {
            guard let code = transport?.code, let color = transport?.color else {
                transportIconView.isHidden = true
                return
            }

            transportIconView.isHidden = false
            transportIconLabel.attributedText = NSMutableAttributedString()
                .bold(code, color: color.contrastColor(), size: 9)
            transportIconView.backgroundColor = color
            publicTransportPinFromView.backgroundColor = color
            publicTransportPinToView.backgroundColor = color
            publicTransportLineView.backgroundColor = color

        }
    }

    var departure: (from: String, time: String)? = nil {
        didSet {
            guard let departure = departure else {
                return
            }

            publicTransportStartTimeLabel.text = departure.time
            publicTransportFromLabel.text = departure.from
        }
    }

    var arrival: (to: String, time: String)? = nil {
        didSet {
            guard let arrival = arrival else {
                return
            }

            publicTransportEndTimeLabel.text = arrival.time
            publicTransportToLabel.text = arrival.to
        }
    }

    var stopDates: [String]? = nil {
        didSet {
            guard let stopDates = stopDates, !stopDates.isEmpty else {
                stationsContainerIsHidden = true
                return
            }

            stationsContainerIsHidden = false
            stopDatesCount = stopDates.count
            publicTransportStationsStackHeightContraint.constant = CGFloat(stopDates.count) * 25
            
            for stopDate in stopDates {
                let view = StationsView(frame: CGRect(x: 0, y: 0, width: stationStackView.frame.size.width, height: 20))
                view.stationColor = transport?.color
                view.stationName = stopDate
                stationStackView.addArrangedSubview(view)
            }
        }
    }

    private var stopDatesCount: Int = 0 {
        didSet {
            publicTransportStationsLabel.attributedText = NSMutableAttributedString()
                .normal(String(format: "%@ %@", String(stopDatesCount + 1), "Arrêts"), color: Configuration.Color.darkerGray, size: 13)
        }
    }
    
    @IBAction func publicTransportButton(_ sender: Any) {
       stationsStackContainerIsHidden = !stationsStackContainerIsHidden
    }
}
