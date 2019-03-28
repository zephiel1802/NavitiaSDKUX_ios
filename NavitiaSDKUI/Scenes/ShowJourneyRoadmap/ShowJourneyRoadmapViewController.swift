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
    @IBOutlet weak var alignBottomCenterMapButton: NSLayoutConstraint!
    
    private var ridesharing: ShowJourneyRoadmap.GetRoadmap.ViewModel.Ridesharing?
    private let locationManager = CLLocationManager()
    private var journeyPolylineCoordinates = [CLLocationCoordinate2D]()
    private var slidingScrollView: SlidingScrollView!
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

        initLocation()
        getMap()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !display {
            display = true
            
            initSlidingView()
            getRoadmap()
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
    
    override func viewWillTransition( to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator ) {
        slidingScrollView.updateSlidingViewAfterRotation()
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
    
    private func initLocation() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func initSlidingView() {
        slidingScrollView = SlidingScrollView(frame: self.view.bounds, parentView: self.view)
        slidingScrollView.delegate = self
        view.addSubview(slidingScrollView)
        
        UIApplication.shared.statusBarOrientation.isPortrait ? slidingScrollView.setAnchorPoint(slideState: .anchored, duration: 0) : slidingScrollView.setAnchorPoint(slideState: .collapsed, duration: 0)
    }
    
    func displayRoadmap(viewModel: ShowJourneyRoadmap.GetRoadmap.ViewModel) {
        guard let sections = viewModel.sections else {
            return
        }
        
        ridesharing = viewModel.ridesharing
        
        displayHeader(viewModel: viewModel)
        displayDepartureArrivalStep(viewModel: viewModel.departure)
        displaySteps(sections: sections)
        displayDepartureArrivalStep(viewModel: viewModel.arrival)
        displayEmission(emission: viewModel.emission)
    }
    
    func displayMap(viewModel: ShowJourneyRoadmap.GetMap.ViewModel) {
        initMapView()
        
        displaySections(viewModel: viewModel)
        displayDepartureArrivalPin(viewModel: viewModel)
        displayRidesharingAnnoation(viewModel: viewModel)
        
        zoomOverPolyline(targetPolyline: MKPolyline(coordinates: journeyPolylineCoordinates, count: journeyPolylineCoordinates.count))
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
        
        slidingScrollView.journeySolutionView = journeySolutionView
        
        if viewModel.ridesharing != nil {
            let ridesharingView = displayRidesharingView()

            journeySolutionView.setRidesharingData(duration: viewModel.frieze.duration, friezeSection: viewModel.frieze.friezeSections)
            slidingScrollView.stackScrollView.addSubview(ridesharingView, margin: UIEdgeInsets(top: 10, left: 10, bottom: 5, right: 10))
        } else if viewModel.displayAvoidDisruption {
            let alternativeJourneyView = displayAlternativeJourneyView()

            alternativeJourneyView.addFrieze(friezeSection: viewModel.frieze.friezeSectionsWithDisruption)
            slidingScrollView.stackScrollView.addSubview(alternativeJourneyView, margin: UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10))
        }
    }
    
    private func getJourneySolutionView(viewModel: ShowJourneyRoadmap.GetRoadmap.ViewModel) -> JourneySolutionView {
        let journeySolutionView = JourneySolutionView.instanceFromNib()

        journeySolutionView.frame.size = CGSize(width: slidingScrollView.stackScrollView.frame.size.width, height: 47)
        journeySolutionView.setData(duration: viewModel.frieze.duration, friezeSection: viewModel.frieze.friezeSections)
        
        return journeySolutionView
    }
    
    private func displayAlternativeJourneyView() -> AlternativeJourneyView {
        let alternativeJourneyView = AlternativeJourneyView.instanceFromNib()

        alternativeJourneyView.frame.size = CGSize(width: slidingScrollView.stackScrollView.frame.size.width, height: 110)
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
        
        slidingScrollView.stackScrollView.addSubview(departureArrivalStepView, margin: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
    }
    
    private func displaySteps(sections: [ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel]) {
        for (_, section) in sections.enumerated() {
            if let sectionStep = getSectionStep(section: section) {
                slidingScrollView.stackScrollView.addSubview(sectionStep, margin: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
            }
        }
    }
    
    private func getPublicTransportStepView(section: ShowJourneyRoadmap.GetRoadmap.ViewModel.SectionModel) -> UIView {
        let publicTransportView = PublicTransportStepView.instanceFromNib()
        
        publicTransportView.frame = view.bounds
        publicTransportView.icon = section.icon
        publicTransportView.transport = (code: section.displayInformations.code, textColor: section.displayInformations.textColor, backgroundColor: section.displayInformations.color)
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
    
    // TODO : Add in presenter
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

        emissionView.frame.size = CGSize(width: slidingScrollView.stackScrollView.frame.size.width, height: 60)
        emissionView.accessibilityLabel = emission.accessibility
        emissionView.journeyCarbon = emission.journey
        emissionView.carCarbon = emission.car
        
        slidingScrollView.stackScrollView.addSubview(emissionView, margin: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0), safeArea: false)
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
        guard let ridesharing = ridesharing, let ridesharingView = slidingScrollView.stackScrollView.selectSubviews(type: RidesharingView()).first else {
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

        let stepSubViews = slidingScrollView.stackScrollView.selectSubviews(type: StepView())
        for stepView in stepSubViews {
            stepView.realTimeAnimation = true
        }
    }
    
    private func stopAnimation() {
        animationTimer?.invalidate()
        
        let stepSubViews = slidingScrollView.stackScrollView.selectSubviews(type: StepView())
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
        zoomOverPolyline(targetPolyline: MKPolyline(coordinates: journeyPolylineCoordinates, count: journeyPolylineCoordinates.count),
                         edgePadding: getEdgePaddingForZoom(),
                         animated: true)
    }
}

// MARKS: Sliding

extension ShowJourneyRoadmapViewController: SlidingScrollViewDelegate {
    
    internal func slidingDidMove() {
        UIView.animate(withDuration: 0.3, animations: {
            self.centerMapButton.alpha = 0
        })
    }
    
    internal func slidingEndMove(edgePaddingBottom: CGFloat, slidingState: SlidingScrollView.SlideState) {
        switch slidingState {
        case .anchored,
             .collapsed:
            UIView.animate(withDuration: 0.3, animations: {
                self.centerMapButton.alpha = 1
            }, completion: { (_) in })
            
            zoomOverPolyline(targetPolyline: MKPolyline(coordinates: self.journeyPolylineCoordinates, count: self.journeyPolylineCoordinates.count),
                             edgePadding: UIEdgeInsets(top: 60, left: 40, bottom: edgePaddingBottom + 10, right: 40),
                             animated: true)
            
            self.alignBottomCenterMapButton.constant = -edgePaddingBottom - 5
        case .expanded:
            break
        }
    }
}

// MARKS: Maps

extension ShowJourneyRoadmapViewController {
    
    private func initMapView() {
        mapView.showsUserLocation = true
        mapView.accessibilityElementsHidden = true
        
        displayCenterMapButton()
    }
    
    private func displayCenterMapButton() {
        centerMapButton.setImage(UIImage(named: "location", in: NavitiaSDKUI.shared.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate), for: .normal)
        centerMapButton.tintColor = Configuration.Color.white
        centerMapButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 6, bottom: 6, right: 8)
        centerMapButton.setShadow(color: Configuration.Color.shadow.cgColor,
                                  offset: CGSize(width: -1, height: -1),
                                  opacity: 1,
                                  radius: 2)
    }
    
    private func displayDepartureArrivalPin(viewModel: ShowJourneyRoadmap.GetMap.ViewModel) {
        displayPinAnnotation(coordinate: viewModel.departureCoord, annotationType: .PlaceAnnotation, placeType: .Departure)
        displayPinAnnotation(coordinate: viewModel.arrivalCoord, annotationType: .PlaceAnnotation, placeType: .Arrival)
    }
    
    private func displayRidesharingAnnoation(viewModel: ShowJourneyRoadmap.GetMap.ViewModel) {
        for annotation in viewModel.ridesharingAnnotation {
            displayPinAnnotation(coordinate: annotation, annotationType: .RidesharingAnnotation, placeType: .Other)
        }
    }

    private func displaySections(viewModel: ShowJourneyRoadmap.GetMap.ViewModel) {
        for sectionPolyline in viewModel.sectionPolylines {
            displayPinAnnotation(coordinate: sectionPolyline.coordinates.first, annotationType: .Transfer, placeType: .Other, color: sectionPolyline.color)
            displayPinAnnotation(coordinate: sectionPolyline.coordinates.last, annotationType: .Transfer, placeType: .Other, color: sectionPolyline.color)
            
            displaySectionPolyline(coordinates: sectionPolyline.coordinates, section: sectionPolyline.section)
        }
    }
    
    private func displayPinAnnotation(coordinate: CLLocationCoordinate2D?,
                                      annotationType: CustomAnnotation.AnnotationType,
                                      placeType: CustomAnnotation.PlaceType,
                                      color: UIColor? = nil) {
        guard let coordinate = coordinate else {
            return
        }
        
        let customAnnotation = CustomAnnotation(coordinate: coordinate,
                                                annotationType: annotationType,
                                                placeType: placeType,
                                                color: color)
        
        mapView.addAnnotation(customAnnotation)
    }
    
    private func displaySectionPolyline(coordinates: [CLLocationCoordinate2D], section: Section) {
        var sectionPolyline = SectionPolyline(coordinates: coordinates, count: coordinates.count)

        switch section.type {
        case .streetNetwork?:
            streetNetworkPolyline(mode: section.mode, sectionPolyline: &sectionPolyline)
        case .crowFly?:
            crowFlyPolyline(mode: section.mode, sectionPolyline: &sectionPolyline)
        case .publicTransport?:
            sectionPolyline.sectionStrokeColor = section.displayInformations?.color?.toUIColor() == Configuration.Color.white ? section.displayInformations?.textColor?.toUIColor() : section.displayInformations?.color?.toUIColor()
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
        
        journeyPolylineCoordinates.append(contentsOf: coordinates)
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

    private func getEdgePaddingForZoom() -> UIEdgeInsets {
        return UIEdgeInsets(top: 60, left: 40, bottom: view.frame.size.height - slidingScrollView.frame.origin.y + 10, right: 40)
    }
    
    private func zoomOverPolyline(targetPolyline: MKPolyline,
                                  edgePadding: UIEdgeInsets = UIEdgeInsets(top: 60, left: 40, bottom: 10, right: 40),
                                  animated: Bool = false) {
        mapView.setVisibleMapRect(targetPolyline.boundingMapRect,
                                  edgePadding: edgePadding,
                                  animated: animated)
    }
}

extension ShowJourneyRoadmapViewController: MKMapViewDelegate {
    
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
