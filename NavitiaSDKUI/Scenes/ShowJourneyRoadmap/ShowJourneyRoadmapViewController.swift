//
//  ShowJourneyRoadmapViewController.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol ShowJourneyRoadmapDisplayLogic: class {
    
    func displayRoadmap(viewModel: ShowJourneyRoadmap.GetRoadmap.ViewModel)
    func displayMap(viewModel: ShowJourneyRoadmap.GetMap.ViewModel)
}

internal class ShowJourneyRoadmapViewController: UIViewController, ShowJourneyRoadmapDisplayLogic {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var centerMapButton: UIButton!
    @IBOutlet weak var scrollView: StackScrollView!
    
    private var mapViewModel: ShowJourneyRoadmap.GetMap.ViewModel?
    private var ridesharing: ShowJourneyRoadmap.GetRoadmap.ViewModel.Ridesharing?
    private var ridesharingJourneys: Journey?
    private let locationManager = CLLocationManager()
    private var intermediatePointsCircles = [SectionCircle]()
    private var journeyPolylineCoordinates = [CLLocationCoordinate2D]()
    private var sectionsPolylines = [SectionPolyline]()
    private var animationTimer: Timer?
    private var bssRealTimer: Timer?
    private var parkRealTimer: Timer?
    private var bssTuple = [(poi: ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel.Poi?, type: String, view: StepView)]()
    private var parkTuple = [(poi: ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel.Poi?, view: StepView)]()
    private var display = false
    internal var router: (NSObjectProtocol & ShowJourneyRoadmapRoutingLogic & ShowJourneyRoadmapDataPassing)?
    internal var interactor: ShowJourneyRoadmapBusinessLogic?

    static var identifier: String {
        return String(describing: self)
    }
    
    // MARK: - Initialization
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initArchitecture()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "roadmap".localized()

        initScrollView()
        initLocation()

        getRoadmap()
        getMap()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !display {
            display = true
            zoomOverPolyline(targetPolyline: MKPolyline(coordinates: journeyPolylineCoordinates, count: journeyPolylineCoordinates.count))
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        startUpdatingUserLocation()

        refreshFetchBss(run: true)
        refreshFetchPark(run: true)
        startAnimation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        stopUpdatingUserLocation()
        
        refreshFetchBss(run: false)
        refreshFetchPark(run: false)
        stopAnimation()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        navigationController?.navigationBar.setNeedsLayout()
    }
    
    // MARK: - Function
    
    private func initArchitecture() {
        let viewController = self
        let interactor = ShowJourneyRoadmapInteractor()
        let presenter = ShowJourneyRoadmapPresenter()
        let router = ShowJourneyRoadmapRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    private func initScrollView() {
        if #available(iOS 11.0, *) {
            scrollView?.contentInsetAdjustmentBehavior = .always
        }
        scrollView?.bounces = false
    }
    
    private func initLocation() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func initMapView() {
        setupMapView()
    }
    
    func displayRoadmap(viewModel: ShowJourneyRoadmap.GetRoadmap.ViewModel) {
        guard let sections = viewModel.sections else {
            return
        }
        
        ridesharing = viewModel.ridesharing
        ridesharingJourneys = viewModel.ridesharingJourneys
        
        displayHeader(viewModel: viewModel)
        displayDepartureArrivalStep(viewModel: viewModel.departure)
        displaySteps(sections: sections)
        displayDepartureArrivalStep(viewModel: viewModel.arrival)
        displayEmission(emission: viewModel.emission)
    }
    
    func displayMap(viewModel: ShowJourneyRoadmap.GetMap.ViewModel) {
        self.mapViewModel = viewModel
        
        initMapView()
    }
    
    // MARK: - Get roadmap
    
    private func getRoadmap() {
        let request = ShowJourneyRoadmap.GetRoadmap.Request()
        
        self.interactor?.getRoadmap(request: request)
    }
    
    private func getMap() {
        let request = ShowJourneyRoadmap.GetMap.Request()
        
        self.interactor?.getMap(request: request)
    }
    
    @objc private func fetchBss() {
        for elem in bssTuple {
            guard let lat = elem.poi?.lat, let lon = elem.poi?.lont, let addressId = elem.poi?.addressId else {
                return
            }
            
            let request = ShowJourneyRoadmap.FetchBss.Request(lat: lat, lon: lon, distance: 10, id: addressId, type: elem.type) { (stands) in
                elem.view.stands = stands
            }
            
            self.interactor?.fetchBss(request: request)
        }
    }
    
    @objc private func fetchPark() {
        for elem in parkTuple {
            guard let lat = elem.poi?.lat, let lon = elem.poi?.lont, let addressId = elem.poi?.addressId else {
                return
            }
            
            let request = ShowJourneyRoadmap.FetchPark.Request(lat: lat, lon: lon, distance: 10, id: addressId) { (stands) in
                elem.view.stands = stands
            }

            self.interactor?.fetchPark(request: request)
        }
    }
    
    private func refreshFetchBss(run: Bool = true) {
        bssRealTimer?.invalidate()
        
        if !bssTuple.isEmpty && run {
            bssRealTimer = Timer.scheduledTimer(timeInterval: Configuration.bssTimeInterval, target: self, selector: #selector(fetchBss), userInfo: nil, repeats: true)
            bssRealTimer?.fire()
        }
    }
    
    private func refreshFetchPark(run: Bool = true) {
        parkRealTimer?.invalidate()
        
        if !parkTuple.isEmpty && run {
            parkRealTimer = Timer.scheduledTimer(timeInterval: Configuration.parkTimeInterval, target: self, selector: #selector(fetchPark), userInfo: nil, repeats: true)
            parkRealTimer?.fire()
        }
    }
    
    // MARK: Tools
    
    private func displayHeader(viewModel: ShowJourneyRoadmap.GetRoadmap.ViewModel) {
        let journeySolutionView = getJourneySolutionView(viewModel: viewModel)

        scrollView.addSubview(journeySolutionView, margin: UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0))

        if viewModel.journey.isRidesharing {
            let ridesharingView = displayRidesharingView()

            journeySolutionView.setRidesharingData(duration: viewModel.frieze.duration, friezeSection: viewModel.frieze.friezeSections)

            scrollView.addSubview(ridesharingView, margin: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        } else if viewModel.displayAvoidDisruption {
            let alternativeJourneyView = displayAlternativeJourneyView()

            alternativeJourneyView.addFrieze(friezeSection: viewModel.frieze.friezeSectionsWithDisruption)

            scrollView.addSubview(alternativeJourneyView, margin: UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10))
        }
    }
    
    private func getJourneySolutionView(viewModel: ShowJourneyRoadmap.GetRoadmap.ViewModel) -> JourneySolutionView {
        let journeySolutionView = JourneySolutionView.instanceFromNib()
        
        journeySolutionView.frame.size = CGSize(width: scrollView.frame.size.width, height: 47)
        journeySolutionView.setData(duration: viewModel.frieze.duration, friezeSection: viewModel.frieze.friezeSections)
        
        return journeySolutionView
    }
    
    private func displayAlternativeJourneyView() -> AlternativeJourneyView {
        let alternativeJourneyView = AlternativeJourneyView.instanceFromNib()
        
        alternativeJourneyView.frame.size = CGSize(width: scrollView.frame.size.width, height: 110)
        alternativeJourneyView.delegate = self
        
        return alternativeJourneyView
    }
    
    private func displayRidesharingView() -> RidesharingView {
        let ridesharingView = RidesharingView(frame: CGRect(x: 0, y: 0, width: 0, height: 255))

        ridesharingView.parentViewController = self
        
        return ridesharingView
    }
    
    private func displayDepartureArrivalStep(viewModel: ShowJourneyRoadmap.GetRoadmap.ViewModel.DepartureArrival) {
        let departureArrivalStepView = DepartureArrivalStepView.instanceFromNib()
        
        departureArrivalStepView.frame = view.bounds
        departureArrivalStepView.type = viewModel.mode
        departureArrivalStepView.information = viewModel.information
        departureArrivalStepView.time = viewModel.time
        departureArrivalStepView.calorie = viewModel.calorie
        departureArrivalStepView.accessibilityLabel = viewModel.accessibility
        
        scrollView.addSubview(departureArrivalStepView, margin: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
    }
    
    private func displaySteps(sections: [ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel]) {
        for (_, section) in sections.enumerated() {
            if let sectionStep = getSectionStep(section: section) {
                scrollView.addSubview(sectionStep, margin: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
            }
        }
    }
    
    private func getPublicTransportStepView(section: ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel) -> UIView {
        let publicTransportView = PublicTransportStepView.instanceFromNib()
        
        publicTransportView.frame = view.bounds
        publicTransportView.icon = section.icon
        publicTransportView.transport = (code: section.displayInformations.code, color: section.displayInformations.color)
        publicTransportView.actionDescription = section.actionDescription
        publicTransportView.network = section.displayInformations.network
        publicTransportView.informations = (from: section.from, direction: section.displayInformations.directionTransit)
        publicTransportView.departure = (from: section.from, time: section.startTime)
        publicTransportView.arrival = (to: section.to, time: section.endTime)
        publicTransportView.stopDates = section.stopDate
        publicTransportView.notes = section.notes
        publicTransportView.disruptions = section.disruptions
        publicTransportView.waiting = section.waiting
        publicTransportView.updateAccessibility()
        
        return publicTransportView
    }
    
    private func getInformationsStepView(section: ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel) -> NSAttributedString {
        let informations = NSMutableAttributedString()
        
        if let actionDescription = section.actionDescription {
            if section.type == .ridesharing {
                informations.append(NSMutableAttributedString().normal(String(format: "%@ ", actionDescription), color: Configuration.Color.black, size: 15))
                informations.append(NSMutableAttributedString().bold(String(format: "%@ ", section.from), color: Configuration.Color.black, size: 15))
                informations.append(NSMutableAttributedString().normal(String(format: "%@ ", "to".localized()), color: Configuration.Color.black, size: 15))
                informations.append(NSMutableAttributedString().bold(String(format: "%@", section.to), color: Configuration.Color.black, size: 15))
            } else if section.type == .bssPutBack || section.type == .bssRent || section.type == .park {
                if let name = section.poi?.name {
                    informations.append(NSMutableAttributedString().normal(String(format: "%@ ", actionDescription), color: Configuration.Color.black, size: 15))
                    informations.append(NSMutableAttributedString().bold(String(format: "%@", name), color: Configuration.Color.black, size: 15))
                }
            } else {
                informations.append(NSMutableAttributedString().normal(String(format: "%@ ", actionDescription), color: Configuration.Color.black, size: 15))
                informations.append(NSMutableAttributedString().bold(String(format: "%@", section.to), color: Configuration.Color.black, size: 15))
            }
        }
        
        if let addressName = section.poi?.addressName {
            informations.append(NSMutableAttributedString().bold(String(format: "\n%@", addressName), color: Configuration.Color.black, size: 13))
        }
        
        if let duration = section.duration {
            informations.append(NSMutableAttributedString().normal(String(format: "\n%@", duration), color: Configuration.Color.black, size: 15))
        }
        
        return informations
    }
    
    private func getRealTime(section: ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel, view: StepView) {
        if section.poi?.stands != nil && section.realTime {
            switch section.type {
            case .park:
                parkTuple.append((poi: section.poi, view: view))
            case .bssRent,
                 .bssPutBack:
                bssTuple.append((poi: section.poi, type: section.type.rawValue, view: view))
            default:
                break
            }
        }
    }
    
    private func getStepView(section: ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel) -> UIView {
        let stepView = StepView.instanceFromNib()

        stepView.frame = view.bounds
        stepView.enableBackground = section.background
        stepView.iconInformations = section.icon
        stepView.informationsAttributedString = getInformationsStepView(section: section)
        stepView.stands = section.poi?.stands
        stepView.paths = section.path

        getRealTime(section: section, view: stepView)

        return stepView
    }
    
    private func displayEmission(emission: ShowJourneyRoadmap.GetRoadmap.ViewModel.Emission) {
        let emissionView = EmissionView.instanceFromNib()
        
        emissionView.frame.size = CGSize(width: scrollView.frame.size.width, height: 60)
        emissionView.accessibilityLabel = emission.accessibility
        emissionView.journeyCarbon = emission.journey
        emissionView.carCarbon = emission.car
        
        scrollView.addSubview(emissionView, margin: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
    }
    
    private func getSectionStep(section: ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel) -> UIView? {
        switch section.type {
        case .publicTransport,
             .onDemandTransport:
            return getPublicTransportStepView(section: section)
        case .streetNetwork,
             .bssRent,
             .bssPutBack,
             .crowFly,
             .transfer,
             .park:
            return getStepView(section: section)
        case .ridesharing:
            updateRidesharingView()
            return getStepView(section: section)
        default:
            return nil
        }
    }
    
    private func updateRidesharingView() {
        guard let ridesharing = ridesharing, let ridesharingView = scrollView.selectSubviews(type: RidesharingView()).first else {
            return
        }
        
        ridesharingView.price = ridesharing.price
        ridesharingView.network = ridesharing.network
        ridesharingView.departure = ridesharing.departure
        ridesharingView.driverNickname = ridesharing.driverNickname
        ridesharingView.driverGender = ridesharing.driverGender
        ridesharingView.departureAddress = ridesharing.departureAddress
        ridesharingView.arrivalAddress = ridesharing.arrivalAddress
        ridesharingView.setSeatsCount(ridesharing.seatsCount)
        ridesharingView.setDriverPictureURL(url: ridesharing.driverPictureURL)
        ridesharingView.setRatingCount(ridesharing.ratingCount)
        ridesharingView.setRating(ridesharing.rating)
        ridesharingView.accessiblity = ridesharing.accessibility
    }
    
    // MARKS: Update BSS

    @objc private func startAnimation() {
        animationTimer?.invalidate()
        animationTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(startAnimation), userInfo: nil, repeats: true)

        let stepSubViews = scrollView.selectSubviews(type: StepView())
        for stepView in stepSubViews {
            stepView.realTimeAnimation = true
        }
    }
    
    private func stopAnimation() {
        animationTimer?.invalidate()
        
        let stepSubViews = scrollView.selectSubviews(type: StepView())
        for stepView in stepSubViews {
            stepView.realTimeAnimation = false
        }
    }
    
    // MARKS: Ridesharing Open Link
    
    public func openDeepLink() {
        if let deepLink = ridesharing?.deepLink {
            if let urlDeepLink = URL(string: deepLink) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(urlDeepLink, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(urlDeepLink)
                }
            }
        }
    }
    
    @IBAction func actionCenterMap(_ sender: Any) {
        zoomOverPolyline(targetPolyline: MKPolyline(coordinates: journeyPolylineCoordinates, count: journeyPolylineCoordinates.count), animated: true)
    }
}

// MARKS: Maps

extension ShowJourneyRoadmapViewController {
    
    private func setupMapView() {
        mapView.showsUserLocation = true
        mapView.accessibilityElementsHidden = true
        
        drawSections(journey: mapViewModel?.journey)
        
        if mapViewModel?.journey.sections?.first?.type == Section.ModelType.crowFly {
            if (mapViewModel?.journey.sections?.count)! - 1 >= 1 {
                if mapViewModel?.journey.sections![1].type == .ridesharing, let departureCrowflyCoords = getCrowFlyCoordinates(targetPlace: mapViewModel?.journey.sections?.first?.from), let latitude = departureCrowflyCoords.lat, let lat = Double(latitude), let longitude = departureCrowflyCoords.lon, let lon = Double(longitude) {
                   drawPinAnnotation(coordinates: [lon, lat], annotationType: .PlaceAnnotation, placeType: .Departure)
                } else {
                    drawPinAnnotation(coordinates: mapViewModel?.journey.sections?[1].geojson?.coordinates?.first, annotationType: .PlaceAnnotation, placeType: .Departure)
                }
            }
        } else {
            drawPinAnnotation(coordinates: mapViewModel?.journey.sections?.first?.geojson?.coordinates?.first, annotationType: .PlaceAnnotation, placeType: .Departure)
        }
        
        if mapViewModel?.journey.sections?.last?.type == Section.ModelType.crowFly {
            if ((mapViewModel?.journey.sections?.count)! - 1 > 1) {
                if mapViewModel?.journey.sections![(mapViewModel?.journey.sections?.count)! - 2].type == .ridesharing, let arrivalCrowflyCoords = getCrowFlyCoordinates(targetPlace: mapViewModel?.journey.sections?.last?.to), let latitude = arrivalCrowflyCoords.lat, let lat = Double(latitude), let longitude = arrivalCrowflyCoords.lon, let lon = Double(longitude) {
                    drawPinAnnotation(coordinates: [lon, lat], annotationType: .PlaceAnnotation, placeType: .Arrival)
                } else {
                    drawPinAnnotation(coordinates: mapViewModel?.journey.sections?[(mapViewModel?.journey.sections?.count)! - 2].geojson?.coordinates?.last, annotationType: .PlaceAnnotation, placeType: .Arrival)
                }
            }
        } else {
            drawPinAnnotation(coordinates: mapViewModel?.journey.sections?.last?.geojson?.coordinates?.last, annotationType: .PlaceAnnotation, placeType: .Arrival)
        }
        
        redrawIntermediatePointCircles(mapView: mapView, cameraAltitude: mapView.camera.altitude)
        zoomOverPolyline(targetPolyline: MKPolyline(coordinates: journeyPolylineCoordinates, count: journeyPolylineCoordinates.count))
        
        setupCenterMapButton()
    }
    
    private func setupCenterMapButton() {
        centerMapButton.setImage(UIImage(named: "location", in: NavitiaSDKUI.shared.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate), for: .normal)
        centerMapButton.tintColor = Configuration.Color.white
        centerMapButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 6, bottom: 6, right: 8)
        centerMapButton.addShadow(color: Configuration.Color.shadow.cgColor,
                                  offset: CGSize(width: -1, height: -1),
                                  opacity: 1,
                                  radius: 2)
    }
    
    private func drawSections(journey: Journey?) {
        guard let sections = journey?.sections else {
            return
        }
        
        for (index , section) in sections.enumerated() {
            if !drawRidesharingSection(section: section) {
                var sectionPolylineCoordinates = [CLLocationCoordinate2D]()
                if section.type == .crowFly && ((index - 1 >= 0 && sections[index-1].type == .ridesharing) || (index + 1 < sections.count - 1 && sections[index+1].type == .ridesharing)) {
                    if let departureCrowflyCoords = getCrowFlyCoordinates(targetPlace: section.from), let latitude = departureCrowflyCoords.lat, let lat = Double(latitude), let longitude = departureCrowflyCoords.lon, let lon = Double(longitude) {
                        sectionPolylineCoordinates.append(CLLocationCoordinate2DMake(lat, lon))
                    }
                    
                    if let arrivalCrowflyCoords = getCrowFlyCoordinates(targetPlace: section.to), let latitude = arrivalCrowflyCoords.lat, let lat = Double(latitude), let longitude = arrivalCrowflyCoords.lon, let lon = Double(longitude) {
                        sectionPolylineCoordinates.append(CLLocationCoordinate2DMake(lat, lon))
                    }
                } else if let coordinates = section.geojson?.coordinates {
                    for (_, coordinate) in coordinates.enumerated() {
                        if coordinate.count > 1 {
                            sectionPolylineCoordinates.append(CLLocationCoordinate2DMake(Double(coordinate[1]), Double(coordinate[0])))
                        }
                    }
                }
                
                addSectionCircle(section: section)
                addSectionPolyline(sectionPolylineCoordinates: sectionPolylineCoordinates, section: section)
            }
        }
    }
    
    private func drawRidesharingSection(section: Section) -> Bool {
        if let _ = section.ridesharingJourneys, let ridesharingJourney = ridesharingJourneys {
            drawSections(journey: ridesharingJourney)
            
            return true
        }
        
        if section.type == .ridesharing {
            drawPinAnnotation(coordinates: section.geojson?.coordinates?.first, annotationType: .RidesharingAnnotation, placeType: .Other)
            drawPinAnnotation(coordinates: section.geojson?.coordinates?.last, annotationType: .RidesharingAnnotation, placeType: .Other)
        }
        
        return false
    }
    
    private func drawPinAnnotation(coordinates: [Double]?, annotationType: CustomAnnotation.AnnotationType, placeType: CustomAnnotation.PlaceType) {
        guard let coordinates = coordinates else {
            return
        }
        
        if coordinates.count > 1 {
            let customAnnotation = CustomAnnotation(coordinate: CLLocationCoordinate2DMake(coordinates[1], coordinates[0]),
                                                    annotationType: annotationType,
                                                    placeType: placeType)
            
            mapView.addAnnotation(customAnnotation)
            getCircle(coordinates: coordinates)
        }
    }
    
    private func addSectionPolyline(sectionPolylineCoordinates: [CLLocationCoordinate2D], section: Section) {
        var sectionPolyline = SectionPolyline(coordinates: sectionPolylineCoordinates, count: sectionPolylineCoordinates.count)

        switch section.type {
        case .streetNetwork?:
            streetNetworkPolyline(mode: section.mode, sectionPolyline: &sectionPolyline)
        case .crowFly?:
            crowFlyPolyline(mode: section.mode, sectionPolyline: &sectionPolyline)
        case .publicTransport?:
            sectionPolyline.sectionStrokeColor = section.displayInformations?.color?.toUIColor()
            sectionPolyline.sectionLineWidth = 5
        case .transfer?:
            sectionPolyline.sectionStrokeColor = Configuration.Color.gray
            sectionPolyline.sectionLineWidth = 4
        case .ridesharing?:
            sectionPolyline.sectionStrokeColor = UIColor.black
            sectionPolyline.sectionLineWidth = 4
        default:
            sectionPolyline.sectionStrokeColor = UIColor.black
            sectionPolyline.sectionLineWidth = 4
        }
        
        sectionsPolylines.append(sectionPolyline)
        journeyPolylineCoordinates.append(contentsOf: sectionPolylineCoordinates)
        mapView.addOverlay(sectionPolyline)
    }
    
    private func streetNetworkPolyline(mode: Section.Mode?, sectionPolyline: inout SectionPolyline) {
        sectionPolyline.sectionStrokeColor = Configuration.Color.gray
        sectionPolyline.sectionLineWidth = 4
        
        switch mode {
        case .walking?:
            sectionPolyline.sectionLineDashPattern = [0.01, NSNumber(value: Float(2 * sectionPolyline.sectionLineWidth))]
            sectionPolyline.sectionLineCap = CGLineCap.round
        default:
            break
        }
    }
    
    private func crowFlyPolyline(mode: Section.Mode?, sectionPolyline: inout SectionPolyline) {
        sectionPolyline.sectionStrokeColor = Configuration.Color.gray
        sectionPolyline.sectionLineWidth = 4
        
        switch mode {
        case .walking?:
            sectionPolyline.sectionLineDashPattern = [0.01, NSNumber(value: Float(2 * sectionPolyline.sectionLineWidth))]
            sectionPolyline.sectionLineCap = CGLineCap.round
        default:
            break
        }
    }
    
    private func getCrowFlyCoordinates(targetPlace: Place?) -> Coord? {
        guard let targetPlace = targetPlace else {
            return nil;
        }
        
        switch targetPlace.embeddedType {
        case .stopPoint?:
            return targetPlace.stopPoint?.coord
        case .stopArea?:
            return targetPlace.stopArea?.coord
        case .poi?:
            return targetPlace.poi?.coord
        case .address?:
            return targetPlace.address?.coord
        case .administrativeRegion?:
            return targetPlace.administrativeRegion?.coord
        default:
            return nil
        }
    }
    
    private func getCircle(coordinates: [Double]?, backgroundColor: UIColor? = Configuration.Color.black) {
        guard let coordinates = coordinates else {
            return
        }
        
        var backgroundColor = backgroundColor
        if backgroundColor == nil {
            backgroundColor = Configuration.Color.black
        }
        
        if coordinates.count > 1 {
            let sectionCircle = SectionCircle(center: CLLocationCoordinate2DMake(coordinates[1], coordinates[0]),
                                              radius: getCircleRadiusDependingOnCurrentCameraAltitude(cameraAltitude: mapView.camera.altitude))
            sectionCircle.sectionBackgroundColor = backgroundColor
            sectionCircle.accessibilityElementsHidden = true
            intermediatePointsCircles.append(sectionCircle)
        }
    }
    
    private func addSectionCircle(section: Section) {
        if let coordinates = section.geojson?.coordinates {
            var backgroundColor = section.displayInformations?.color?.toUIColor()
            if section.type == .ridesharing {
                backgroundColor = Configuration.Color.black
            }
            
            getCircle(coordinates: coordinates.first, backgroundColor: backgroundColor)
            getCircle(coordinates: coordinates.last, backgroundColor: backgroundColor)
        }
    }
    
    private func getCircleRadiusDependingOnCurrentCameraAltitude(cameraAltitude: CLLocationDistance) -> CLLocationDistance {
        let altitudeReferenceValue = 10000.0
        let circleMaxmimumRadius = 100.0
        return cameraAltitude/altitudeReferenceValue * circleMaxmimumRadius
    }
    
    private func redrawIntermediatePointCircles(mapView: MKMapView, cameraAltitude: CLLocationDistance) {
        mapView.removeOverlays(intermediatePointsCircles)
        
        var updatedIntermediatePointsCircles = [SectionCircle]()
        for (_, drawnCircle) in intermediatePointsCircles.enumerated() {
            let updatedCircleView = SectionCircle(center: drawnCircle.coordinate,
                                                  radius: getCircleRadiusDependingOnCurrentCameraAltitude(cameraAltitude: cameraAltitude))
            updatedCircleView.sectionBackgroundColor = drawnCircle.sectionBackgroundColor
            updatedIntermediatePointsCircles.append(updatedCircleView)
        }
        intermediatePointsCircles = updatedIntermediatePointsCircles
        
        mapView.addOverlays(intermediatePointsCircles)
    }
    
    private func zoomOverPolyline(targetPolyline: MKPolyline, animated: Bool = false) {
        mapView.setVisibleMapRect(targetPolyline.boundingMapRect,
                                  edgePadding: UIEdgeInsets(top: 60, left: 40, bottom: 10, right: 40),
                                  animated: animated)
    }
    
}

extension ShowJourneyRoadmapViewController: MKMapViewDelegate {
    
    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        redrawIntermediatePointCircles(mapView: mapView, cameraAltitude: mapView.camera.altitude)
    }
    
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let sectionPolyline = overlay as? SectionPolyline {
            let polylineRenderer = MKPolylineRenderer(polyline: sectionPolyline)
            polylineRenderer.lineWidth = sectionPolyline.sectionLineWidth
            polylineRenderer.strokeColor = sectionPolyline.sectionStrokeColor
            if let sectionLineDashPattern = sectionPolyline.sectionLineDashPattern {
                polylineRenderer.lineDashPattern = sectionLineDashPattern
            }
            if let sectionLineCap = sectionPolyline.sectionLineCap {
                polylineRenderer.lineCap = sectionLineCap
            }
            
            return polylineRenderer
        } else if let circle = overlay as? SectionCircle {
            let circleRenderer = MKCircleRenderer(circle: circle)
            circleRenderer.lineWidth = 1.5
            circleRenderer.strokeColor = circle.sectionBackgroundColor
            circleRenderer.fillColor = UIColor.white
            
            return circleRenderer
        }
        
        return MKOverlayRenderer()
    }
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let customAnnotation = annotation as? CustomAnnotation {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: customAnnotation.identifier)
            if annotationView == nil {
                annotationView = customAnnotation.getAnnotationView(annotationIdentifier: customAnnotation.identifier, bundle: NavitiaSDKUI.shared.bundle)
            } else {
                annotationView?.annotation = annotation
            }
            
            return annotationView
        } else {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationViewIdentifier")
            annotationView?.annotation = annotation
            
            return annotationView
        }
    }
    
}

extension ShowJourneyRoadmapViewController: AlertViewControllerProtocol {
    
    func onNegativeButtonClicked(_ alertViewController: AlertViewController) {
        alertViewController.dismiss(animated: false, completion: nil)
    }
    
    func onPositiveButtonClicked(_ alertViewController: AlertViewController) {
        openDeepLink()
        alertViewController.dismiss(animated: false, completion: nil)
    }
    
}

extension ShowJourneyRoadmapViewController: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            startUpdatingUserLocation()
        }
    }
    
    private func startUpdatingUserLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    private func stopUpdatingUserLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.stopUpdatingLocation()
        }
    }
}

extension ShowJourneyRoadmapViewController: AlternativeJourneyDelegate {
    
    func avoidJourney() {
        var selector: Selector?
        
        selector = NSSelectorFromString("routeToListJourneys")
        
        if let router = router, router.responds(to: selector) {
            router.perform(selector)
        }
    }
}
