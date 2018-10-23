//
//  JourneySolutionRoadmapViewController.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

open class JourneySolutionRoadmapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var scrollSubviews = [(view: UIView, margin: UIEdgeInsets)]()
    var margin: CGFloat = 10
    var composentWidth: CGFloat = 0
    var journey: Journey?
    var ridesharingJourney: Journey?
    var intermediatePointsCircles = [SectionCircle]()
    var journeyPolylineCoordinates = [CLLocationCoordinate2D]()
    var ridesharing: Bool = false
    var ridesharingView: RidesharingView!
    var ridesharingDeepLink: String?
    var ridesharingIndex = 0
    var timeRidesharing: Int32?
    var display = false
    var disruptions: [Disruption]?
    var notes: [Note]?
    var sectionsPolylines = [SectionPolyline]()
    let locationManager = CLLocationManager()
    var animationTimer: Timer?
    
    fileprivate var _viewModel = JourneySolutionRoadmapViewModel()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        title = "roadmap".localized(withComment: "Roadmap", bundle: NavitiaSDKUI.shared.bundle)
        
        if #available(iOS 11.0, *) {
            scrollView?.contentInsetAdjustmentBehavior = .always
        }
        scrollView?.bounces = false
        
        locationManager.requestWhenInUseAuthorization()
        
        _setupMapView()
    }
        
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        _startUpdatingUserLocation()

        _viewModel.refreshBikeStands(run: true)
        _animateView()
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        _stopUpdatingUserLocation()

        _viewModel.refreshBikeStands(run: false)
        _stopAnimation()
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        composentWidth = _updateWidth()
        
        if !display {
            _display()
        }
        
        _updateOriginViewScroll()
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    private func _updateWidth(customMargin: CGFloat? = nil) -> CGFloat {
        if let margeCustom = customMargin {
            if #available(iOS 11.0, *) {
                return scrollView.frame.size.width - scrollView.safeAreaInsets.left - scrollView.safeAreaInsets.right - (margeCustom * 2)
            }
            return scrollView.frame.size.width - (margeCustom * 2)
        }
        
        if #available(iOS 11.0, *) {
            return scrollView.frame.size.width - scrollView.safeAreaInsets.left - scrollView.safeAreaInsets.right - (margin * 2)
        }
        
        return scrollView.frame.size.width - (margin * 2)
    }
    
    private func _display() {
        display = true
        
        if let journey = journey {
            _displayHeader(journey)
            _displayDeparture(journey)
            _displayJourneySteps(journey)
            _displayArrival(journey)
            _displayEmission(journey)
        }
    }
    
    private func _displayHeader(_ journey: Journey) {
        let journeySolutionView = JourneySolutionView(frame: CGRect(x: 0, y: 0, width: 0, height: 60))
        journeySolutionView.disruptions = disruptions
        journeySolutionView.setData(journey)
        
        _addViewInScroll(view: journeySolutionView, margin: UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0))
        
        if ridesharing {
            journeySolutionView.setDataRidesharing(journey)
            ridesharingView = RidesharingView(frame: CGRect(x: 0, y: 0, width: 0, height: 255))
            ridesharingView.parentViewController = self
            
            _addViewInScroll(view: ridesharingView, margin: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        }
    }
    
    private func _displayJourneySteps(_ journey: Journey) {
        if let sections = journey.sections {
            for (index, section) in sections.enumerated() {
                if let type = section.type {
                    switch type {
                        case .publicTransport:
                            if index == 0 {
                                _displayPublicTransport(section)
                            }
                            
                            _displayPublicTransport(section, waiting: sections[index - 1])
                            break
                        case .onDemandTransport:
                            if index == 0 {
                                _displayPublicTransport(section)
                            }
                            
                            _displayPublicTransport(section, waiting: sections[index - 1])
                            break
                        case .transfer:
                            _displayTransferStep(section)
                            break
                        case .ridesharing:
                            _updateRidesharingView(section)
                            _displayRidesharingStep(section)
                            break
                        case .crowFly:
                            _displayCrowFlyStep(section)
                            break
                        case .bssRent:
                            _displayBssStep(section)
                            break
                        case .bssPutBack:
                            _displayBssStep(section)
                            break
                        case .streetNetwork:
                            if let mode = section.mode {
                                switch mode {
                                    case .walking:
                                        _displayTransferStep(section)
                                        break
                                    case .car:
                                        _displayTransferStep(section)
                                        break
                                    case .ridesharing:
                                        _updateRidesharingView(section)
                                        if let ridesharingJourneys = section.ridesharingJourneys {
                                            _displayJourneySteps(ridesharingJourneys[ridesharingIndex])
                                        }
                                    default:
                                        _displayBikeStep(section)
                                        break
                                }
                            }
                            break
                        default :
                            continue
                    }
                }
            }
        }
    }
    
    private func _displayDeparture(_ journey: Journey) {
        let viewDeparture = DepartureArrivalStepView(frame: CGRect(x: 0, y: 0, width: composentWidth, height: 70))
        viewDeparture.information = journey.sections?.first?.from?.name ?? ""
        viewDeparture.time = journey.departureDateTime?.toDate(format: Configuration.date)?.toString(format: Configuration.time) ?? ""
        viewDeparture.type = .departure
        
        _addViewInScroll(view: viewDeparture, margin: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
    }
    
    private func _displayArrival(_ journey: Journey) {
        let viewArrival = DepartureArrivalStepView(frame: CGRect(x: 0, y: 0, width: composentWidth, height: 70))
        viewArrival.information = journey.sections?.last?.to?.name ?? ""
        viewArrival.time = journey.arrivalDateTime?.toDate(format: Configuration.date)?.toString(format: Configuration.time) ?? ""
        viewArrival.type = .arrival
        
        if let walkingDistance = journey.distances?.walking, let bikeDistance = journey.distances?.bike {
            viewArrival.calorie = String(format: "%d", Int((Double(walkingDistance) * Configuration.caloriePerSecWalking + Double(bikeDistance) * Configuration.caloriePerSecBike).rounded()))
        }
        
        _addViewInScroll(view: viewArrival, margin: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
    }
    
    private func _displayEmission(_ journey: Journey) {
        let emissionView = EmissionView(frame: CGRect(x: 0, y: 0, width: scrollView.frame.size.width, height: 40))
        emissionView.carbonAmount = journey.co2Emission
        
        _addViewInScroll(view: emissionView, margin: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
    }

    private func _displayTransferStep(_ section: Section) {
        let view = GenericStepView(frame: CGRect(x: 0, y: 0, width: composentWidth, height: 50))
        view.modeString = Modes().getModeIcon(section: section)
        view.time = section.duration?.minuteToString()
        view.direction = section.to?.name ?? ""
        view.paths = section.path
        
        _addViewInScroll(view: view, margin:UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
    }
    
    private func _displayCrowFlyStep(_ section: Section) {
        let view = GenericStepView(frame: CGRect(x: 0, y: 0, width: composentWidth, height: 50))
        view.modeString = Modes().getModeIcon(section: section)
        view.time = ""
        view.direction = section.to?.name ?? ""
        
        _addViewInScroll(view: view, margin: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
    }
    
    private func _displayBikeStep(_ section: Section) {
        let view = GenericStepView(frame: CGRect(x: 0, y: 0, width: composentWidth, height: 50))
        view.modeString = "bike"
        view.time = section.duration?.minuteToString()
        view.direction = section.to?.name ?? ""
        view.paths = section.path
        
        _addViewInScroll(view: view, margin: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
    }
    
    private func _displayBssStep(_ section: Section) {
        let view = BssStepView(frame: CGRect(x: 0, y: 0, width: composentWidth, height: 50))
        view.modeString = Modes().getModeIcon(section: section)
        view.type = section.type
        
        if let poi = section.from?.poi ?? section.to?.poi {
            view.takeName = poi.properties?["network"] ?? ""
            view.origin = poi.name ?? ""
            view.address = poi.address?.name ?? ""
            view.poi = poi
            
            if let sectionDepartureTime = section.departureDateTime?.toDate(format: "yyyyMMdd'T'HHmmss"), let currentDateTime = Date().toLocalDate(format: "yyyyMMdd'T'HHmmss"), abs(sectionDepartureTime.timeIntervalSince(currentDateTime)) <= Configuration.bssApprovalTimeThreshold {
                view.realTimeEnabled = true
            }
            
            if poi.stands != nil {
                _viewModel.bss.append((poi: poi, notify: { (poi) in
                    view.poi = poi
                }))
            }
        }
        
        _addViewInScroll(view: view, margin: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
    }
    
    
    private func _displayRidesharingStep(_ section: Section) {
        let view = RidesharingStepView(frame: CGRect(x: 0, y: 0, width: composentWidth, height: 100))
        view.origin = ridesharingView.addressFrom ?? ""
        view.destination = ridesharingView.addressTo ?? ""
        view.time = section.duration?.minuteToString()
        
        _addViewInScroll(view: view, margin: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
    }
    
    private func _displayPublicTransport(_ section: Section, waiting: Section? = nil) {
        var publicTransportView = PublicTransportView(frame: CGRect(x: 0, y: 0, width: composentWidth, height: 100))
        publicTransportView.modeString = Modes().getModeIcon(section: section)
        publicTransportView.take = section.displayInformations?.commercialMode ?? ""
        publicTransportView.transportColor = section.displayInformations?.color?.toUIColor() ?? UIColor.black
        
        if let code = section.displayInformations?.code, !code.isEmpty {
            publicTransportView.transportName = code
        } else {
            publicTransportView.transportView.isHidden = true 
        }
        
        publicTransportView.origin = section.from?.name ?? ""
        publicTransportView.startTime = section.departureDateTime?.toDate(format: Configuration.date)?.toString(format: Configuration.time) ?? ""
        publicTransportView.directionTransit = section.displayInformations?.direction ?? ""
        publicTransportView.destination = section.to?.name ?? ""
        publicTransportView.endTime = section.arrivalDateTime?.toDate(format: Configuration.date)?.toString(format: Configuration.time) ?? ""

        var stopDate: [String] = []
        if let stopDateTimes = section.stopDateTimes {
            for (index, stop) in stopDateTimes.enumerated() {
                if let name = stop.stopPoint?.name {
                    if index != 0 && index != (stopDateTimes.count - 1) {
                        stopDate.append(name)
                    }
                }
            }
        }
        publicTransportView.stations = stopDate
        if let waiting = waiting {
            if waiting.type == .waiting {
                if let durationWaiting = waiting.duration?.minuteToString() {
                    publicTransportView.waitingTime = durationWaiting
                }
            }
        }
        
        if section.type == .onDemandTransport {
            addOnDemandTransport(publicTransportView: &publicTransportView, section: section)
        }
        
        if let disruptions = disruptions, disruptions.count > 0 {
            let sectionDisruptions = section.disruptions(disruptions: disruptions)
            if sectionDisruptions.count > 0 {
                publicTransportView.setDisruptions(sectionDisruptions)
            }
        }
        
        _addViewInScroll(view: publicTransportView, margin: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
    }
    
    func addOnDemandTransport(publicTransportView: inout PublicTransportView, section: Section) {
        for i in section.selectLinks(type: "notes") {
            if let notes = self.notes, let id = i.id, let note = section.getNote(notes: notes, id: id) {
                publicTransportView.setOnDemandTransport(text: note.value ?? "")
            }
        }
        
        if let firstStopDateTimes = section.stopDateTimes?.first {
            let links = firstStopDateTimes.selectLinks(type: "notes")
            if links.count > 0 {
                for i in links {
                    if let notes = self.notes, let id = i.id, let note = section.getNote(notes: notes, id: id) {
                        publicTransportView.setOnDemandTransport(text: note.value ?? "")
                    }
                }
                return
            }
        }
        
        if let laststopDateTimes = section.stopDateTimes?.last {
            for i in laststopDateTimes.selectLinks(type: "notes") {
                if let notes = self.notes, let id = i.id, let note = section.getNote(notes: notes, id: id) {
                    publicTransportView.setOnDemandTransport(text: note.value ?? "")
                }
            }
        }
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

extension JourneySolutionRoadmapViewController {
    
    private func _setupMapView() {
        self.mapView.showsUserLocation = true
        
        _drawSections(journey: journey)
        
        if journey?.sections?.first?.type == Section.ModelType.crowFly {
            if (journey?.sections?.count)! - 1 >= 1 {
                if journey?.sections![1].type == .ridesharing, let departureCrowflyCoords = _getCrowFlyCoordinates(targetPlace: journey?.sections?.first?.from), let latitude = departureCrowflyCoords.lat, let lat = Double(latitude), let longitude = departureCrowflyCoords.lon, let lon = Double(longitude) {
                   _drawPinAnnotation(coordinates: [lon, lat], annotationType: .PlaceAnnotation, placeType: .Departure)
                } else {
                    _drawPinAnnotation(coordinates: journey?.sections?[1].geojson?.coordinates?.first, annotationType: .PlaceAnnotation, placeType: .Departure)
                }
            }
        } else {
            _drawPinAnnotation(coordinates: journey?.sections?.first?.geojson?.coordinates?.first, annotationType: .PlaceAnnotation, placeType: .Departure)
        }
        
        if journey?.sections?.last?.type == Section.ModelType.crowFly {
            if ((journey?.sections?.count)! - 1 > 1) {
                if journey?.sections![(journey?.sections?.count)! - 2].type == .ridesharing, let arrivalCrowflyCoords = _getCrowFlyCoordinates(targetPlace: journey?.sections?.last?.to), let latitude = arrivalCrowflyCoords.lat, let lat = Double(latitude), let longitude = arrivalCrowflyCoords.lon, let lon = Double(longitude) {
                    _drawPinAnnotation(coordinates: [lon, lat], annotationType: .PlaceAnnotation, placeType: .Arrival)
                } else {
                    _drawPinAnnotation(coordinates: journey?.sections?[(journey?.sections?.count)! - 2].geojson?.coordinates?.last, annotationType: .PlaceAnnotation, placeType: .Arrival)
                }
            }
        } else {
            _drawPinAnnotation(coordinates: journey?.sections?.last?.geojson?.coordinates?.last, annotationType: .PlaceAnnotation, placeType: .Arrival)
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
                                  animated: true)
    }
    
}

extension JourneySolutionRoadmapViewController: MKMapViewDelegate {
    
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

extension JourneySolutionRoadmapViewController {
    
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

extension JourneySolutionRoadmapViewController: AlertViewControllerProtocol {
    
    func onNegativeButtonClicked(_ alertViewController: AlertViewController) {
        alertViewController.dismiss(animated: false, completion: nil)
    }
    
    func onPositiveButtonClicked(_ alertViewController: AlertViewController) {
        openDeepLink()
        alertViewController.dismiss(animated: false, completion: nil)
    }
    
}

extension JourneySolutionRoadmapViewController: CLLocationManagerDelegate {
    
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
