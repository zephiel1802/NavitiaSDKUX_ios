//
//  PublicTransportStepView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

@objc public protocol PublicTransportStepViewDelegate: class {
    
    @objc func viewTicketClicked(maasTicketId: Int, maasTicketsJson: String)
    func showError()
}

class PublicTransportStepView: UIView {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var publicTransportModeImageView: UIImageView!
    @IBOutlet weak var informationsLabel: UILabel!
    @IBOutlet weak var transportIconView: UIView!
    @IBOutlet weak var transportIconLabel: UILabel!
    @IBOutlet weak var disruptionImage: UIImageView!
    @IBOutlet weak var networkContainerView: UIView!
    @IBOutlet weak var networkLabel: UILabel!
    @IBOutlet weak var waitingContainerView: UIView!
    @IBOutlet weak var waitingIconImageView: UIImageView!
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
    @IBOutlet weak var publicTransportStationsArrowImageView: UIImageView!
    @IBOutlet var publicTransportStationsStackContainerView: UIView!
    @IBOutlet weak var publicTransportEndTimeLabel: UILabel!
    @IBOutlet weak var publicTransportToLabel: UILabel!
    @IBOutlet var publicTransportStationsContainerTopContraint: NSLayoutConstraint!
    @IBOutlet var publicTransportStationsContainerBottomContraint: NSLayoutConstraint!
    @IBOutlet var publicTransportStationsStackContainerTopContraint: NSLayoutConstraint!
    @IBOutlet var publicTransportStationsStackContainerBottomContraint: NSLayoutConstraint!
    @IBOutlet var publicTransportStationsStackHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var publicTransportFromToContraint: NSLayoutConstraint!
    
    @IBOutlet weak var showTicketView: UIView!
    @IBOutlet weak var viewTicketContainer: UIView!
    @IBOutlet weak var viewTicketButton: UIButton!
    @IBOutlet weak var noTicketAvailableContainer: UIView!
    @IBOutlet weak var noTicketAvailableImage: UIImageView!
    @IBOutlet weak var noTicketAvailableLabel: UILabel!
    
    private var stationStackView: UIStackView!
    
    weak internal var delegate: PublicTransportStepViewDelegate?
    
    internal var ticketViewConfig: (availableTicketId: Int?, maasTicketsJson: String?, viewTicketLocalized: String, ticketNotAvailableLocalized: String)? {
        didSet {
            if let ticketViewConfig = ticketViewConfig {
                if ticketViewConfig.availableTicketId != nil {
                    let ticketImage = "ticket".getIcon(customizable: true)
                    viewTicketButton.setImage(ticketImage, for: .normal)
                    viewTicketButton.tintColor = Configuration.Color.secondary.contrastColor()
                    viewTicketButton.imageView?.contentMode = .scaleAspectFit
                    viewTicketButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                    viewTicketButton.setTitle(ticketViewConfig.viewTicketLocalized, for: .normal)
                    viewTicketButton.setTitleColor(Configuration.Color.secondary.contrastColor(), for: .normal)
                    
                    viewTicketContainer.backgroundColor = Configuration.Color.secondary
                    viewTicketContainer.isHidden = false
                } else {
                    let ticketNotAvailableImage = "ticket_not_available".getIcon(customizable: true)
                    noTicketAvailableImage.image = ticketNotAvailableImage
                    noTicketAvailableImage.tintColor = UIColor.white
                    
                    noTicketAvailableLabel.text = ticketViewConfig.ticketNotAvailableLocalized
                    noTicketAvailableContainer.isHidden = false
                }
                
                showTicketView.isHidden = false
            }
        }
    }
    
    var borderColor: UIColor? {
        didSet {
            guard let color = borderColor?.cgColor else {
                transportIconView.layer.borderWidth = 0
                return
            }
            
            transportIconView.layer.borderWidth = 1
            transportIconView.layer.borderColor = color
        }
    }
    
    // MARK: - UINib
    
    static var identifier: String {
        return String(describing: self)
    }
    
    class func instanceFromNib() -> PublicTransportStepView {
        return UINib(nibName: identifier, bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: nil, options: nil)[0] as! PublicTransportStepView
    }
    
    // MARK: - Initialization

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        frame.size.height = stackView.frame.origin.y + stackView.frame.size.height
        if let superview = superview as? StackScrollView {
            superview.reloadStack()
        }
    }
    
    // MARK: - Function
    
    private func setup() {
        transport = nil
        disruptions = nil
        network = nil
        waiting = nil
        stopDates = nil
        
        initStationStackView()
        setShadow(opacity: 0.28)
    }
    
    internal func updateAccessibility() {
        guard let informations = informationsLabel.text else {
            return
        }
        
        var accessibilityLabel = ""
        
        if let code = transportIconLabel.text {
            accessibilityLabel.append(String(format: "%@ ", code))
        }
        
        accessibilityLabel.append(String(format: "%@.", informations))
        if let to = publicTransportToLabel.text {
            accessibilityLabel.append(String(format: "get_of_at".localized(), to))
        }
        
        if let network = networkLabel.text {
            accessibilityLabel.append(String(format: "%@.", network))
        }
        
        if let waiting = waitingInformationsLabel.text, !waitingContainerView.isHidden {
            accessibilityLabel.append(String(format: "%@.", waiting))
        }
        
        for item in stackView.arrangedSubviews {
            if let itemDisruption = item as? DisruptionItemView,
                let accessibility = itemDisruption.accessibility {
                accessibilityLabel.append(accessibility)
            } else if let itemOnDemandTransport = item as? OnDemandItemView,
                let title = itemOnDemandTransport.titleLabel.text,
                let information = itemOnDemandTransport.informationLabel.text {
                accessibilityLabel.append(String(format: "%@ : %@.", title, information))
            }
        }
        
        self.accessibilityLabel = accessibilityLabel
    }
    
    // MARK: Common
    
    internal var icon: String? {
        didSet {
            guard let icon = icon else {
                return
            }
            
            publicTransportModeImageView.image = icon.getIcon(prefix: "journey_mode_", renderingMode: .alwaysOriginal, customizable: true)
        }
    }

    internal var informations: (action: String, from: String, direction: String)? = nil {
        didSet {
            guard let informations = informations else {
                return
            }

            informationsLabel.attributedText = NSMutableAttributedString()
                .normal(informations.action, size: 15)
                .normal(" ", size: 15)
                .normal("at".localized(), size: 15)
                .normal(" ", size: 15)
                .bold(informations.from, size: 15)
                .normal(" ", size: 15)
                .normal("in_the_direction_of".localized(), size: 15)
                .normal(" ", size: 15)
                .bold(informations.direction, size: 15)
        }
    }

    // MARK: Network
    
    internal var network: String? = nil {
        didSet {
            guard let network = network else {
                networkContainerView.isHidden = true
                networkLabel.attributedText = NSMutableAttributedString()
                
                return
            }

            networkContainerView.isHidden = false
            networkLabel.attributedText = NSMutableAttributedString()
                .semiBold(String(format: "%@ ", "network".localized()), color: Configuration.Color.darkerGray, size: 12)
                .semiBold(network, color: Configuration.Color.main, size: 12)
        }
    }

    // MARK: OnDemandeTransport
    
    internal var notes: [ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel.Note]? = nil {
        didSet {
            guard let onDemandTransports = notes else {
                return
            }

            for onDemandTransport in onDemandTransports {
                let onDemandItemView = OnDemandItemView.instanceFromNib()

                onDemandItemView.setInformation(text: onDemandTransport.content)
                stackView.insertArrangedSubview(onDemandItemView, at: 2)
            }
        }
    }

    // MARK: Disruption
    
    internal var disruptions: [ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel.Disruption]? = nil {
        didSet {
            guard let disruptions = disruptions, disruptions.count > 0 else {
                disruptionImage.isHidden = true
                return
            }

            if let image = Disruption().levelImage(name: disruptions.first?.icon ?? ""), !transportIconView.isHidden {
                disruptionImage.image = image
                disruptionImage.isHidden = false
            }

            for (index, disruption) in disruptions.enumerated().reversed() {
                let disruptionItemView = DisruptionItemView.instanceFromNib()

                disruptionItemView.setIcon(icon: disruption.icon)
                disruptionItemView.setDisruptionTitle(title: disruption.title, color: disruption.color)
                disruptionItemView.disruptionInformation = disruption.information
                disruptionItemView.disruptionDate = disruption.date
                disruptionItemView.accessibility = disruption.accessibility

                stackView.insertArrangedSubview(disruptionItemView, at: 3)
                
                if index < disruptions.count && index != 0 {
                    let horizontalSeprator = HorizontalSeparator.instanceFromNib()
                    stackView.insertArrangedSubview(horizontalSeprator, at: 3)
                }
            }
        }
    }

    // MARK: Waiting

    internal var waiting: String? = nil {
        didSet {
            guard let waiting = waiting else {
                waitingContainerView.isHidden = true
                return
            }

            waitingContainerView.isHidden = false
            waitingIconImageView.image = "waiting".getIcon()
            waitingIconImageView.tintColor = Configuration.Color.darkerGray
            waitingInformationsLabel.attributedText = NSMutableAttributedString().normal(waiting, color: Configuration.Color.darkerGray, size: 12)
        }
    }

    // MARK: Public Transport

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
            let arrowImage = stationsStackContainerIsHidden ? "arrow_down".getIcon() : "arrow_up".getIcon()
            publicTransportStationsArrowImageView.image = arrowImage
            publicTransportStationsArrowImageView.tintColor = Configuration.Color.gray
            
            publicTransportStationsStackContainerView.isHidden = stationsStackContainerIsHidden
            publicTransportStationsStackContainerTopContraint.isActive = !stationsStackContainerIsHidden
            publicTransportStationsStackContainerBottomContraint.isActive = !stationsStackContainerIsHidden
        }
    }

    internal var transport: (mode: String?, code: String?, backgroundColor: UIColor?, textColor: UIColor?)? {
        didSet {
            guard let backgroundColor = transport?.backgroundColor, let textColor = transport?.textColor else {
                transportIconView.isHidden = true
                
                return
            }

            publicTransportPinFromView.backgroundColor = backgroundColor == Configuration.Color.white ? textColor : backgroundColor
            publicTransportPinToView.backgroundColor = backgroundColor == Configuration.Color.white ? textColor : backgroundColor
            publicTransportLineView.backgroundColor = backgroundColor == Configuration.Color.white ? textColor : backgroundColor
            
            borderColor = backgroundColor == Configuration.Color.white ? textColor : nil
            
            if let mode = transport?.mode, let code = transport?.code {
                transportIconView.isHidden = false
                transportIconLabel.attributedText = NSMutableAttributedString()
                    .bold(mode.uppercased(), color: .black, size: 12)
                    .normal(" ")
                    .bold(code.uppercased(), color: .black, size: 12)
                transportIconView.backgroundColor = .white
            }
        }
    }

    internal var departure: (from: String, time: String)? = nil {
        didSet {
            guard let departure = departure else {
                return
            }

            publicTransportStartTimeLabel.text = departure.time
            publicTransportFromLabel.text = departure.from
        }
    }

    internal var arrival: (to: String, time: String)? = nil {
        didSet {
            guard let arrival = arrival else {
                return
            }

            publicTransportEndTimeLabel.text = arrival.time
            publicTransportToLabel.text = arrival.to
        }
    }

    internal var stopDates: [String]? = nil {
        didSet {
            guard let stopDates = stopDates,
                !stopDates.isEmpty,
                let backgroundColor = transport?.backgroundColor,
                let textColor = transport?.textColor else {
                stationsContainerIsHidden = true
                return
            }

            stationsContainerIsHidden = false
            stopDatesCount = stopDates.count
            publicTransportStationsStackHeightContraint.constant = CGFloat(stopDates.count) * 25
            
            for stopDate in stopDates {
                let stationView = StationsView.instanceFromNib()
                
                stationView.bounds = CGRect(x: 0, y: 0, width: stationStackView.frame.size.width, height: 20)
                stationView.color = backgroundColor == Configuration.Color.white ? textColor : backgroundColor
                stationView.name = stopDate
                
                stationStackView.addArrangedSubview(stationView)
            }
        }
    }

    private var stopDatesCount: Int = 0 {
        didSet {
            publicTransportStationsLabel.attributedText = NSMutableAttributedString()
                .normal(String(format: "%@ %@", String(stopDatesCount + 1), "Arrêts"), color: Configuration.Color.darkerGray, size: 13)
        }
    }
    
    // MARK: - Action
    
    @IBAction func publicTransportButton(_ sender: Any) {
       stationsStackContainerIsHidden = !stationsStackContainerIsHidden
    }
    
    @IBAction func viewTicketClicked(_ sender: Any) {
        if let ticketViewConfig = ticketViewConfig,
            let maasTicketId = ticketViewConfig.availableTicketId,
            let maasTicketsJson = ticketViewConfig.maasTicketsJson {
            delegate?.viewTicketClicked(maasTicketId: maasTicketId, maasTicketsJson: maasTicketsJson)
        } else {
            delegate?.showError()
        }
    }
}
