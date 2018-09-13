//
//  JourneyRoadmapViewController.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


protocol JourneyRoadmapDisplayLogic: class {
    
    func displaySomething(viewModel: JourneyRoadmap.GetRoadmap.ViewModel)
    func displayMap(viewModel: JourneyRoadmap.GetMap.ViewModel)
}

extension JourneyRoadmapViewController {
    
    private func initArchitecture() {
        let viewController = self
        let interactor = JourneyRoadmapInteractor()
        let presenter = JourneyRoadmapPresenter()
        let router = JourneyRoadmapRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    private func initNavigationBar() {
        title = "roadmap".localized(withComment: "Roadmap", bundle: NavitiaSDKUI.shared.bundle)
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
        _setupMapView()
    }
    
    func displaySomething(viewModel: JourneyRoadmap.GetRoadmap.ViewModel) {
        self.viewModel = viewModel
        
        _updateOriginViewScroll()
        guard let journey = self.viewModel?.journey, let sections = self.viewModel?.sections else {
            return
        }
 
        getHeader(journey)
        getDepartureArrival(data: viewModel.departure)
        getStep(sections: sections)
        getDepartureArrival(data: viewModel.arrival)
        getEmission(emission: viewModel.emission)
    }
    
    func displayMap(viewModel: JourneyRoadmap.GetMap.ViewModel) {
        self.mapViewModel = viewModel
        
        initMapView()
    }
    
    // MARK: - Get roadma
    
    private func getRoadmap() {
        let request = JourneyRoadmap.GetRoadmap.Request()
        self.interactor?.getRoadmap(request: request)
    }
    
    private func getMap() {
        let request = JourneyRoadmap.GetMap.Request()
        self.interactor?.getMap(request: request)
    }
    
    // MARK: Tools
    
    private func getHeader(_ journey: Journey) {
        let journeySolutionView = getJourneySolutionView(journey: journey)
        
        _addViewInScroll(view: journeySolutionView, margin: UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0))
        
        if ridesharing {
            guard let duration = journey.duration, let sections = journey.sections else {
                return
            }
            
            journeySolutionView.setRidesharingData(duration: duration, sections: sections)
            let ridesharingView = getRidesharingView()
            
            _addViewInScroll(view: ridesharingView, margin: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        }
    }
    
    private func getJourneySolutionView(journey: Journey) -> JourneySolutionView {
        let journeySolutionView = JourneySolutionView(frame: CGRect(x: 0, y: 0, width: 0, height: 60))
        journeySolutionView.disruptions = viewModel?.disruptions
        journeySolutionView.setData(journey)
        return journeySolutionView
    }
    
    private func getRidesharingView() -> RidesharingView {
        ridesharingView = RidesharingView(frame: CGRect(x: 0, y: 0, width: 0, height: 255))
        ridesharingView.parentViewController = self
        return ridesharingView
    }
    
    private func getDepartureArrival(data: JourneyRoadmap.GetRoadmap.ViewModel.DepartureArrival) {
        let view = DepartureArrivalStepView(frame: CGRect(x: 0, y: 0, width: 0, height: 70))
        view.information = data.information
        view.time = data.time
        view.type = data.mode
        view.calorie = data.calorie
        
        _addViewInScroll(view: view, margin: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
    }
    
    private func getStep(sections: [JourneyRoadmap.GetRoadmap.ViewModel.Section]) {
        for (_, section) in sections.enumerated() {
            let step = getSectionStep(section: section)
            _addViewInScroll(view: step, margin: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        }
    }
    
    func getPublicTransportStep(section: JourneyRoadmap.GetRoadmap.ViewModel.Section) -> UIView {
        let publicTransportView = PublicTransportView(frame: CGRect(x: 0, y: 0, width: 0, height: 100))
        publicTransportView.modeString = section.icon
        publicTransportView.take = section.displayInformations.commercialMode
        publicTransportView.transportColor = section.displayInformations.color

        if let code = section.displayInformations.code {
            publicTransportView.transportName = code
        } else {
            publicTransportView.transportView.isHidden = true
        }

        publicTransportView.origin = section.from
        publicTransportView.startTime = section.startTime
        publicTransportView.directionTransit = section.displayInformations.directionTransit
        publicTransportView.destination = section.to
        publicTransportView.endTime = section.endTime
        publicTransportView.stations = section.stopDate
        publicTransportView.waitTime = section.waiting
        publicTransportView.setDisruptions(section.disruptions)
        
        return publicTransportView
    }

    func getBssStep(section: JourneyRoadmap.GetRoadmap.ViewModel.Section) -> UIView {
        let view = BssStepView(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        view.modeString = section.icon
        view.type = Section.ModelType.init(rawValue: section.type.rawValue)
        
        if let poi = section.poi {
            view.takeName = poi.properties?["network"] ?? ""
            view.origin = poi.name ?? ""
            view.address = poi.address?.name ?? ""
            view.poi = poi
            
           // if let sectionDepartureTime = section.departureDateTime?.toDate(format: "yyyyMMdd'T'HHmmss"), let currentDateTime = Date().toLocalDate(format: "yyyyMMdd'T'HHmmss"), abs(sectionDepartureTime.timeIntervalSince(currentDateTime)) <= Configuration.bssApprovalTimeThreshold {
                view.realTimeEnabled = true
           // }
            
//            if poi.stands != nil {
//                _viewModel.bss.append((poi: poi, notify: { (poi) in  // Y'a le ridesharing
//                    view.poi = poi
//                }))
//            }
        }
        
        return view
    }
    
    private func _displayRidesharingStep(_ section: Section) {
        let view = RidesharingStepView(frame: CGRect(x: 0, y: 0, width: 0, height: 100))
        view.origin = ridesharingView.addressFrom ?? ""
        view.destination = ridesharingView.addressTo ?? ""
        view.time = section.duration?.minuteToString()
        
        _addViewInScroll(view: view, margin: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
    }
    
    private func getRidesharingStep(section: JourneyRoadmap.GetRoadmap.ViewModel.Section) -> UIView {
        let view = RidesharingStepView(frame: CGRect(x: 0, y: 0, width: 0, height: 100))
        
        view.origin = section.from
        view.destination = section.to
        view.time = section.time
        return view
    }
    
    func getGenericStep(section: JourneyRoadmap.GetRoadmap.ViewModel.Section) -> UIView {
        let view = GenericStepView(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        
        view.modeString = section.icon
        view.time = section.time
        view.direction = section.to
        view.paths = section.path
        return view
    }

    private func getEmission(emission: JourneyRoadmap.GetRoadmap.ViewModel.Emission) {
        let emissionView = EmissionView(frame: CGRect(x: 0, y: 0, width: scrollView.frame.size.width, height: 40))
        
        emissionView.carbon = emission.journeyValue

        _addViewInScroll(view: emissionView, margin: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
    }
    
    func getSectionStep(section: JourneyRoadmap.GetRoadmap.ViewModel.Section) -> UIView {
        switch section.type {
        /* OK */case .publicTransport:
            return getPublicTransportStep(section: section)
        /* OK */case .streetNetwork:
            return getStreetNetworkStep(section: section)
        /* OK */case .transfer:
            return getGenericStep(section: section)
        /* Completer le temps réel */case .bssRent:
            return getBssStep(section: section)
        /* Completer le temps réel */case .bssPutBack:
            return getBssStep(section: section)
        /* OK */ case .crowFly:
            return getGenericStep(section: section)
        /* A completer */case .ridesharing:
            // _updateRidesharingView(section)
            return getRidesharingStep(section: section)
        default:
            return UIView()
        }
    }

    func getStreetNetworkStep(section: JourneyRoadmap.GetRoadmap.ViewModel.Section) -> UIView {
        guard let mode = section.mode else {
            return UIView()
        }
        switch mode {
        case .walking:
            return getGenericStep(section: section)
        case .bike:
            return getGenericStep(section: section)
        case .car:
            return getGenericStep(section: section)
        case .ridesharing:
            // _updateRidesharingView(section)
            return getRidesharingStep(section: section)
        default:
            return UIView()
        }
    }
}

open class JourneyRoadmapViewController: UIViewController, JourneyRoadmapDisplayLogic {

    // Clean Architecture
    internal var router: (NSObjectProtocol & JourneyRoadmapRoutingLogic & JourneyRoadmapDataPassing)?
    private var interactor: JourneyRoadmapBusinessLogic?
    private var viewModel: JourneyRoadmap.GetRoadmap.ViewModel?
    private var mapViewModel: JourneyRoadmap.GetMap.ViewModel?

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // Mettre une classe qui gère le scrollView :D
    var scrollSubviews = [(view: UIView, margin: UIEdgeInsets)]()

    // var journey: Journey?
    var ridesharingJourney: Journey?
    var ridesharing: Bool = false
    var ridesharingView: RidesharingView!
    var ridesharingDeepLink: String?
    var ridesharingIndex = 0
    var timeRidesharing: Int32?
    
    // var Maps
    var intermediatePointsCircles = [SectionCircle]()
    var journeyPolylineCoordinates = [CLLocationCoordinate2D]()
    var sectionsPolylines = [SectionPolyline]()
    let locationManager = CLLocationManager()

    // Other
    var display = false
    var animationTimer: Timer?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initArchitecture()
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigationBar()
        initScrollView()
        initLocation()
    }
        
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        _startUpdatingUserLocation()

        //_viewModel.refreshBikeStands(run: true) // Y'a le ridesharing
        _animateView()
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        _stopUpdatingUserLocation()

        //_viewModel.refreshBikeStands(run: false) // Y'a le ridesharing
        _stopAnimation()
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !display {
            display = true
            getMap()
            getRoadmap()
        }
        _updateOriginViewScroll()
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    

    private func _updateRidesharingView(_ section: Section) {
        if let ridesharingJourneys = section.ridesharingJourneys?[safe: ridesharingIndex] {
            ridesharingView.price = section.ridesharingJourneys?[safe: ridesharingIndex]?.fare?.total?.value ?? ""
            if let sectionRidesharing = ridesharingJourneys.sections?[safe: 1] {
                timeRidesharing = sectionRidesharing.duration
                ridesharingDeepLink = sectionRidesharing.links?[safe: 0]?.href
                ridesharingView.title = sectionRidesharing.ridesharingInformations?.network ?? ""
                ridesharingView.startDate = sectionRidesharing.departureDateTime?.toDate(format: Configuration.date)?.toString(format: Configuration.timeRidesharing) ?? ""
                ridesharingView.login = sectionRidesharing.ridesharingInformations?.driver?.alias ?? ""
                ridesharingView.gender = sectionRidesharing.ridesharingInformations?.driver?.gender?.rawValue ?? ""
                ridesharingView.addressFrom = sectionRidesharing.from?.name ?? ""
                ridesharingView.addressTo = sectionRidesharing.to?.name ?? ""
                ridesharingView.seatCount(sectionRidesharing.ridesharingInformations?.seats?.available)
                ridesharingView.setPicture(url: sectionRidesharing.ridesharingInformations?.driver?.image)
                ridesharingView.setNotation(sectionRidesharing.ridesharingInformations?.driver?.rating?.count)
                ridesharingView.setFullStar(sectionRidesharing.ridesharingInformations?.driver?.rating?.value)
            }
        }
    }
    
    @objc private func _animateView() {
        animationTimer?.invalidate()
        animationTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(_animateView), userInfo: nil, repeats: true)
        
        for subview in scrollSubviews {
            if let bssView = subview.view as? BssStepView {
                bssView.animateRealTime()
            }
        }
    }
    
    private func _stopAnimation() {
        animationTimer?.invalidate()
        
        for subview in scrollSubviews {
            if let bssView = subview.view as? BssStepView {
                bssView.stopRealTimeAnimation()
            }
        }
    }
    
    public func openDeepLink() {
        if let ridesharingDeepLink = ridesharingDeepLink {
            if let urlRidesharingDeepLink = URL(string: ridesharingDeepLink) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(urlRidesharingDeepLink, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(urlRidesharingDeepLink)
                }
            }
        }
    }
    
}

extension JourneyRoadmapViewController {
    
    private func _setupMapView() {
        self.mapView.showsUserLocation = true
        
        _drawSections(journey: mapViewModel?.journey)
        
        if mapViewModel?.journey.sections?.first?.type == Section.ModelType.crowFly {
            if (mapViewModel?.journey.sections?.count)! - 1 >= 1 {
                if mapViewModel?.journey.sections![1].type == .ridesharing, let departureCrowflyCoords = _getCrowFlyCoordinates(targetPlace: mapViewModel?.journey.sections?.first?.from), let latitude = departureCrowflyCoords.lat, let lat = Double(latitude), let longitude = departureCrowflyCoords.lon, let lon = Double(longitude) {
                   _drawPinAnnotation(coordinates: [lon, lat], annotationType: .PlaceAnnotation, placeType: .Departure)
                } else {
                    _drawPinAnnotation(coordinates: mapViewModel?.journey.sections?[1].geojson?.coordinates?.first, annotationType: .PlaceAnnotation, placeType: .Departure)
                }
            }
        } else {
            _drawPinAnnotation(coordinates: mapViewModel?.journey.sections?.first?.geojson?.coordinates?.first, annotationType: .PlaceAnnotation, placeType: .Departure)
        }
        
        if mapViewModel?.journey.sections?.last?.type == Section.ModelType.crowFly {
            if ((mapViewModel?.journey.sections?.count)! - 1 > 1) {
                if mapViewModel?.journey.sections![(mapViewModel?.journey.sections?.count)! - 2].type == .ridesharing, let arrivalCrowflyCoords = _getCrowFlyCoordinates(targetPlace: mapViewModel?.journey.sections?.last?.to), let latitude = arrivalCrowflyCoords.lat, let lat = Double(latitude), let longitude = arrivalCrowflyCoords.lon, let lon = Double(longitude) {
                    _drawPinAnnotation(coordinates: [lon, lat], annotationType: .PlaceAnnotation, placeType: .Arrival)
                } else {
                    _drawPinAnnotation(coordinates: mapViewModel?.journey.sections?[(mapViewModel?.journey.sections?.count)! - 2].geojson?.coordinates?.last, annotationType: .PlaceAnnotation, placeType: .Arrival)
                }
            }
        } else {
            _drawPinAnnotation(coordinates: mapViewModel?.journey.sections?.last?.geojson?.coordinates?.last, annotationType: .PlaceAnnotation, placeType: .Arrival)
        }
        
        _redrawIntermediatePointCircles(mapView: mapView, cameraAltitude: mapView.camera.altitude)
        _zoomOverPolyline(targetPolyline: MKPolyline(coordinates: journeyPolylineCoordinates, count: journeyPolylineCoordinates.count))
    }
    
    private func _drawSections(journey: Journey?) {
        guard let sections = journey?.sections else {
            return
        }
        
        for (index , section) in sections.enumerated() {
            if !_drawRidesharingSection(section: section) {
                var sectionPolylineCoordinates = [CLLocationCoordinate2D]()
                if section.type == .crowFly && ((index - 1 >= 0 && sections[index-1].type == .ridesharing) || (index + 1 < sections.count - 1 && sections[index+1].type == .ridesharing)) {
                    if let departureCrowflyCoords = _getCrowFlyCoordinates(targetPlace: section.from), let latitude = departureCrowflyCoords.lat, let lat = Double(latitude), let longitude = departureCrowflyCoords.lon, let lon = Double(longitude) {
                        sectionPolylineCoordinates.append(CLLocationCoordinate2DMake(lat, lon))
                    }
                    
                    if let arrivalCrowflyCoords = _getCrowFlyCoordinates(targetPlace: section.to), let latitude = arrivalCrowflyCoords.lat, let lat = Double(latitude), let longitude = arrivalCrowflyCoords.lon, let lon = Double(longitude) {
                        sectionPolylineCoordinates.append(CLLocationCoordinate2DMake(lat, lon))
                    }
                } else if let coordinates = section.geojson?.coordinates {
                    for (_, coordinate) in coordinates.enumerated() {
                        if coordinate.count > 1 {
                            sectionPolylineCoordinates.append(CLLocationCoordinate2DMake(Double(coordinate[1]), Double(coordinate[0])))
                        }
                    }
                }
                
                _addSectionCircle(section: section)
                _addSectionPolyline(sectionPolylineCoordinates: sectionPolylineCoordinates, section: section)
            }
        }
    }
    
    private func _drawRidesharingSection(section: Section) -> Bool {
        if let ridesharingJourneys = section.ridesharingJourneys {
            _drawSections(journey: ridesharingJourneys[ridesharingIndex])
            return true
        }
        
        if section.type == .ridesharing {
            _drawPinAnnotation(coordinates: section.geojson?.coordinates?.first, annotationType: .RidesharingAnnotation, placeType: .Other)
            _drawPinAnnotation(coordinates: section.geojson?.coordinates?.last, annotationType: .RidesharingAnnotation, placeType: .Other)
        }
        
        return false
    }
    
    private func _drawPinAnnotation(coordinates: [Double]?, annotationType: CustomAnnotation.AnnotationType, placeType: CustomAnnotation.PlaceType) {
        guard let coordinates = coordinates else {
            return
        }
        
        if coordinates.count > 1 {
            mapView.addAnnotation(CustomAnnotation(coordinate: CLLocationCoordinate2DMake(coordinates[1], coordinates[0]),
                                                   annotationType: annotationType,
                                                   placeType: placeType))
            _getCircle(coordinates: coordinates)
        }
    }
    
    private func _addSectionPolyline(sectionPolylineCoordinates: [CLLocationCoordinate2D], section: Section) {
        var sectionPolyline = SectionPolyline(coordinates: sectionPolylineCoordinates, count: sectionPolylineCoordinates.count)

        switch section.type {
        case .streetNetwork?:
            _streetNetworkPolyline(mode: section.mode, sectionPolyline: &sectionPolyline)
        case .crowFly?:
            _crowFlyPolyline(mode: section.mode, sectionPolyline: &sectionPolyline)
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
        mapView.add(sectionPolyline)
    }
    
    private func _streetNetworkPolyline(mode: Section.Mode?, sectionPolyline: inout SectionPolyline) {
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
    
    private func _crowFlyPolyline(mode: Section.Mode?, sectionPolyline: inout SectionPolyline) {
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
    
    private func _getCrowFlyCoordinates(targetPlace: Place?) -> Coord? {
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
    
    private func _getCircle(coordinates: [Double]?, backgroundColor: UIColor? = Configuration.Color.black) {
        guard let coordinates = coordinates else {
            return
        }
        
        var backgroundColor = backgroundColor
        if backgroundColor == nil {
            backgroundColor = Configuration.Color.black
        }
        
        if coordinates.count > 1 {
            let sectionCircle = SectionCircle(center: CLLocationCoordinate2DMake(coordinates[1], coordinates[0]),
                                              radius: _getCircleRadiusDependingOnCurrentCameraAltitude(cameraAltitude: mapView.camera.altitude))
            sectionCircle.sectionBackgroundColor = backgroundColor
            intermediatePointsCircles.append(sectionCircle)
        }
    }
    
    private func _addSectionCircle(section: Section) {
        if let coordinates = section.geojson?.coordinates {
            var backgroundColor = section.displayInformations?.color?.toUIColor()
            if section.type == .ridesharing {
                backgroundColor = Configuration.Color.black
            }
            
            _getCircle(coordinates: coordinates.first, backgroundColor: backgroundColor)
            _getCircle(coordinates: coordinates.last, backgroundColor: backgroundColor)
        }
    }
    
    private func _getCircleRadiusDependingOnCurrentCameraAltitude(cameraAltitude: CLLocationDistance) -> CLLocationDistance {
        let altitudeReferenceValue = 10000.0
        let circleMaxmimumRadius = 100.0
        return cameraAltitude/altitudeReferenceValue * circleMaxmimumRadius
    }
    
    private func _redrawIntermediatePointCircles(mapView: MKMapView, cameraAltitude: CLLocationDistance) {
        mapView.removeOverlays(intermediatePointsCircles)
        
        var updatedIntermediatePointsCircles = [SectionCircle]()
        for (_, drawnCircle) in intermediatePointsCircles.enumerated() {
            let updatedCircleView = SectionCircle(center: drawnCircle.coordinate,
                                                  radius: _getCircleRadiusDependingOnCurrentCameraAltitude(cameraAltitude: cameraAltitude))
            updatedCircleView.sectionBackgroundColor = drawnCircle.sectionBackgroundColor
            updatedIntermediatePointsCircles.append(updatedCircleView)
        }
        intermediatePointsCircles = updatedIntermediatePointsCircles
        
        mapView.addOverlays(intermediatePointsCircles)
    }
    
    private func _zoomOverPolyline(targetPolyline: MKPolyline) {
        mapView.setVisibleMapRect(targetPolyline.boundingMapRect,
                                  edgePadding: UIEdgeInsetsMake(60, 40, 10, 40),
                                  animated: false)
    }
    
}

extension JourneyRoadmapViewController: MKMapViewDelegate {
    
    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        _redrawIntermediatePointCircles(mapView: mapView, cameraAltitude: mapView.camera.altitude)
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

extension JourneyRoadmapViewController {
    
    private func _addViewInScroll(view: UIView, margin: UIEdgeInsets) {
        if scrollSubviews.isEmpty {
            view.frame.origin.y = margin.top
        } else {
            if let viewBefore = scrollSubviews.last {
                view.frame.origin.y = viewBefore.view.frame.origin.y + viewBefore.view.frame.height + viewBefore.margin.bottom + margin.top
            }
        }
        view.frame.size.width = scrollView.frame.size.width - (margin.left + margin.right)
        view.frame.origin.x = margin.left
        
        scrollSubviews.append((view, margin))
        
        if let last = scrollSubviews.last {
            scrollView.contentSize.height = last.view.frame.origin.y + last.view.frame.height + last.margin.bottom
        }
        scrollView.addSubview(view)
    }
    
    private func _updateOriginViewScroll() {
        for (index, view) in scrollSubviews.enumerated() {
            if index == 0 {
                view.view.frame.origin.y = 0 + view.margin.top
            } else {
                let beforeView = scrollSubviews[index - 1]
                view.view.frame.origin.y = beforeView.view.frame.origin.y + beforeView.view.frame.height + beforeView.margin.bottom + view.margin.top
            }
            view.view.frame.size.width = scrollView.frame.size.width - (view.margin.left + view.margin.right)
            view.view.frame.origin.x = view.margin.left
        }
        
        if let last = scrollSubviews.last {
            scrollView.contentSize.height = last.view.frame.origin.y + last.view.frame.height + last.margin.bottom
        }
    }
    
}

extension JourneyRoadmapViewController: AlertViewControllerProtocol {
    
    func onNegativeButtonClicked(_ alertViewController: AlertViewController) {
        alertViewController.dismiss(animated: false, completion: nil)
    }
    
    func onPositiveButtonClicked(_ alertViewController: AlertViewController) {
        openDeepLink()
        alertViewController.dismiss(animated: false, completion: nil)
    }
    
}

extension JourneyRoadmapViewController: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            _startUpdatingUserLocation()
        }
    }
    
    private func _startUpdatingUserLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    private func _stopUpdatingUserLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.stopUpdatingLocation()
        }
    }
    
}
