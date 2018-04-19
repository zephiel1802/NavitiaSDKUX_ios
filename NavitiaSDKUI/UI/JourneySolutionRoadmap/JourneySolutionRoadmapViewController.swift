//
//  JourneySolutionRoadmapViewController.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit
import MapKit

open class JourneySolutionRoadmapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var viewScroll: [UIView] = []
    
    var marge: CGFloat = 10
    var composentWidth: CGFloat = 0
    
    var journey: Journey?
    var ridesharingJourney: Journey?
    var intermediatePointsCircles = [MKCircle]()
    
    var ridesharing: Bool = false
    var ridesharingView: RidesharingView!
    
    var ridesharingDeepLink: String?
    var ridesharingIndex = 0

    var timeRidesharing: Int32?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        title = "roadmap".localized(withComment: "Roadmap", bundle: NavitiaSDKUIConfig.shared.bundle)
        
        if #available(iOS 11.0, *) {
            scrollView?.contentInsetAdjustmentBehavior = .always
        }
        composentWidth = _updateWidth()
        _setupMapView()
        _display()
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        _updateOriginViewScroll()
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    private func _updateWidth() -> CGFloat {
        if #available(iOS 11.0, *) {
            return scrollView.frame.size.width - scrollView.safeAreaInsets.left - scrollView.safeAreaInsets.right - (marge * 2)
        }
        return scrollView.frame.size.width - (marge * 2)
    }
    
    private func _display() {
        if let journey = journey {
            _displayHeader(journey)
            _displayDeparture(journey)
            _displayStep(journey)
            _displayArrival(journey)
        }
    }
    
    private func _displayHeader(_ journey: Journey) {
        let journeySolutionView = JourneySolutionView(frame: CGRect(x: 0, y: 0, width: 0, height: 130))
        journeySolutionView.setData(journey)
        _addViewInScroll(view: journeySolutionView)
        if ridesharing {
            journeySolutionView.frame.size.height = 97
            journeySolutionView.setDataRidesharing(journey)
            ridesharingView = RidesharingView(frame: CGRect(x: 0, y: 0, width: 0, height: 255))
            ridesharingView.parentViewController = self
            _addViewInScroll(view: ridesharingView)
        }
    }
    
    private func _displayStep(_ journey: Journey) {
        if let sections = journey.sections {
            for (index, section) in sections.enumerated() {
                if let type = section.type {
                    switch type {
                    case TypeTransport.publicTransport.rawValue:
                        if index == 0 {
                            _displayPublicTransport(section)
                        }
                        _displayPublicTransport(section, waiting: sections[index - 1])
                    case TypeTransport.transfer.rawValue:
                        _displayTransferStep(section)
                    case TypeTransport.streetNetwork.rawValue:
                        if let mode = section.mode {
                            switch mode {
                            case ModeTransport.walking.rawValue:
                                _displayTransferStep(section)
                            case ModeTransport.car.rawValue:
                                _displayTransferStep(section)
                            case ModeTransport.ridesharing.rawValue:
                                _updateRidesharingView(section)
                                _displayRidesharingStep(section)
                            default:
                                _displayBikeStep(section)
                            }
                        }
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
        viewDeparture.time = journey.departureDateTime?.toDate(format: FormatConfiguration.date)?.toString(format: FormatConfiguration.time) ?? ""
        viewDeparture.type = .departure
        _addViewInScroll(view: viewDeparture)
    }
    
    private func _displayArrival(_ journey: Journey) {
        let viewArrival = DepartureArrivalStepView(frame: CGRect(x: 0, y: 0, width: composentWidth, height: 70))
        viewArrival.information = journey.sections?.last?.to?.name ?? ""
        viewArrival.time = journey.arrivalDateTime?.toDate(format: FormatConfiguration.date)?.toString(format: FormatConfiguration.time) ?? ""
        viewArrival.type = .arrival
        _addViewInScroll(view: viewArrival)
    }
    
    private func _displayTransferStep(_ section: Section) {
        let view = TransferStepView(frame: CGRect(x: 0, y: 0, width: composentWidth, height: 50))
        view.modeString = Modes().getModeIcon(section: section)
        view.time = section.duration?.minuteToString()
        view.direction = section.to?.name ?? ""
        _addViewInScroll(view: view)
    }
    
    private func _displayBikeStep(_ section: Section) {
        let view = BikeStepView(frame: CGRect(x: 0, y: 0, width: composentWidth, height: 50))
        view.modeString = Modes().getModeIcon(section: section)
        view.origin = section.from?.name ?? ""
        view.destination = section.to?.name ?? ""
        view.time = section.duration?.minuteToString()
        _addViewInScroll(view: view)
    }
    
    private func _displayRidesharingStep(_ section: Section) {
        let view = BikeStepView(frame: CGRect(x: 0, y: 0, width: composentWidth, height: 100))
        view.modeString = Modes().getModeIcon(section: section)
        view.origin = ridesharingView.addressFrom ?? ""
        view.destination = ridesharingView.addressTo ?? ""
        view.time = timeRidesharing?.minuteToString() ?? ""
        _addViewInScroll(view: view)
    }
    
    private func _displayPublicTransport(_ section: Section, waiting: Section? = nil) {
        let publicTransportView = PublicTransportView(frame: CGRect(x: 0, y: 0, width: composentWidth, height: 100))
        publicTransportView.modeString = Modes().getModeIcon(section: section)
        publicTransportView.take = section.displayInformations?.commercialMode ?? ""
        publicTransportView.transportColor = section.displayInformations?.color?.toUIColor() ?? UIColor.black
        publicTransportView.transportName = section.displayInformations?.label ?? ""
        
        // publicTransportView.disruptionType = .blocking
        // publicTransportView.disruptionInformation = "Suite à un incident d’exploitation, le trafic est interrompu sur l’ensemble de la ligne."
        // publicTransportView.disruptionDate = "Du 01/08/17 au 17/08/17"
        // publicTransportView.waitTime = "7"
        
        publicTransportView.origin = section.from?.name ?? ""
        publicTransportView.startTime = section.departureDateTime?.toDate(format: FormatConfiguration.date)?.toString(format: FormatConfiguration.time) ?? ""
        publicTransportView.directionTransit = section.displayInformations?.direction ?? ""
        publicTransportView.destination = section.to?.name ?? ""
        publicTransportView.endTime = section.arrivalDateTime?.toDate(format: FormatConfiguration.date)?.toString(format: FormatConfiguration.time) ?? ""
        
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
            if waiting.type == TypeTransport.waiting.rawValue {
                if let durationWaiting = waiting.duration?.minuteToString() {
                    publicTransportView.waitTime = durationWaiting
                }
            }
        }
        _addViewInScroll(view: publicTransportView)
    }
    
    private func _updateRidesharingView(_ section: Section) {
        if let ridesharingJourneys = section.ridesharingJourneys?[safe: ridesharingIndex] {
            ridesharingView.price = section.ridesharingJourneys?[safe: ridesharingIndex]?.fare?.total?.value ?? ""
            if let sectionRidesharing = ridesharingJourneys.sections?[safe: 1] {
                timeRidesharing = sectionRidesharing.duration
                ridesharingDeepLink = sectionRidesharing.links?[safe: 0]?.href
                ridesharingView.title = sectionRidesharing.ridesharingInformations?._operator ?? ""
                ridesharingView.startDate = sectionRidesharing.departureDateTime?.toDate(format: FormatConfiguration.date)?.toString(format: FormatConfiguration.timeRidesharing) ?? ""
                ridesharingView.login = sectionRidesharing.ridesharingInformations?.driver?.alias ?? ""
                ridesharingView.gender = sectionRidesharing.ridesharingInformations?.driver?.gender ?? ""
                ridesharingView.addressFrom = sectionRidesharing.from?.name ?? ""
                ridesharingView.addressTo = sectionRidesharing.to?.name ?? ""
                ridesharingView.seatCount(sectionRidesharing.ridesharingInformations?.seats?.available)
                ridesharingView.setPicture(url: sectionRidesharing.ridesharingInformations?.driver?.image)
                ridesharingView.setNotation(sectionRidesharing.ridesharingInformations?.driver?.rating?.count)
                ridesharingView.setFullStar(sectionRidesharing.ridesharingInformations?.driver?.rating?.value)
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
    
    private func _addViewInScroll(view: UIView) {
        view.frame.origin.x = marge
        if viewScroll.isEmpty {
            view.frame.origin.y = 0
        } else {
            if let viewBefore = viewScroll.last {
                view.frame.origin.y = viewBefore.frame.origin.y + viewBefore.frame.size.height
            }
        }
        viewScroll.append(view)
        if let last = viewScroll.last {
            scrollView.contentSize.height = last.frame.origin.y + last.frame.height
        }
        scrollView.addSubview(view)
    }
    
    private func _updateOriginViewScroll() {
        for (index, view) in viewScroll.enumerated() {
            if index == 0 {
                view.frame.origin.y = marge
            } else {
                view.frame.origin.y = viewScroll[index - 1].frame.origin.y + viewScroll[index - 1].frame.height + marge
            }
            composentWidth = _updateWidth()
            view.frame.size.width = _updateWidth()
        }
        if let last = viewScroll.last {
            scrollView.contentSize.height = last.frame.origin.y + last.frame.height + marge
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

extension JourneySolutionRoadmapViewController: MKMapViewDelegate {
    
    private func _setupMapView() {
        
        let ridesharingJourneyCoordinates = getRidesharingJourneyCoordinates(journey: self.journey!)
        
        let journeyPathOverlays = JourneyPathOverlays(journey: self.journey!, ridesharingJourneyCoordinates: ridesharingJourneyCoordinates, intermediatePointCircleRadius: self.getCircleRadiusDependingOnCurrentCameraAltitude(cameraAltitude: self.mapView.camera.altitude))
        self.mapView.addOverlays(journeyPathOverlays.sectionsPolylines)
        self.intermediatePointsCircles = journeyPathOverlays.intermediatesPointsCircles
        self.mapView.addOverlays(self.intermediatePointsCircles)
        
        self.drawJourneyAnnotations(ridesharingJourneyCoordinates: ridesharingJourneyCoordinates, drawnPathsCount: journeyPathOverlays.sectionsPolylines.count)
        
        self.zoomToPolyline(targetPolyline: journeyPathOverlays.journeyPolyline, animated: false)
    }
    
    func getJourneyDepartureCoordinates() -> CLLocationCoordinate2D {
        for (_, section) in (self.journey?.sections?.enumerated())! {
            if section.type != TypeTransport.crowFly.rawValue && section.geojson != nil {
                return CLLocationCoordinate2DMake(Double((section.geojson?.coordinates![0][1])!), Double((section.geojson?.coordinates![0][0])!))
            }
        }
        return CLLocationCoordinate2DMake(0, 0)
    }
    
    func getJourneyArrivalCoordinates() -> CLLocationCoordinate2D {
        for section in (self.journey?.sections?.reversed())! {
            if section.type != TypeTransport.crowFly.rawValue && section.geojson != nil {
                let coordinatesLength = section.geojson!.coordinates!.count
                return CLLocationCoordinate2DMake(Double((section.geojson?.coordinates![coordinatesLength - 1][1])!), Double((section.geojson?.coordinates![coordinatesLength - 1][0])!))
            }
        }
        return CLLocationCoordinate2DMake(0, 0)
    }
    
    func getRidesharingJourneyCoordinates(journey: Journey) -> [CLLocationCoordinate2D] {
        var ridesharingJourneyCoordinates = [CLLocationCoordinate2D]()
        for (_ , section) in journey.sections!.enumerated() {
            if section.type == TypeTransport.streetNetwork.rawValue && section.mode != nil && section.mode == ModeTransport.ridesharing.rawValue {
                let coordinatesLength = section.geojson!.coordinates!.count
                ridesharingJourneyCoordinates.append(CLLocationCoordinate2DMake(Double((section.geojson?.coordinates![0][1])!), Double((section.geojson?.coordinates![0][0])!)))
                ridesharingJourneyCoordinates.append(CLLocationCoordinate2DMake(Double((section.geojson?.coordinates![coordinatesLength - 1][1])!), Double((section.geojson?.coordinates![coordinatesLength - 1][0])!)))
            }
        }
        return ridesharingJourneyCoordinates
    }
    
    func getRidesharingJourneyIndex(journey: Journey) -> Int {
        var ridesharingIndex: Int = 0
        while ridesharingIndex < journey.sections!.count {
            if (journey.sections![ridesharingIndex].type == TypeTransport.streetNetwork.rawValue &&
                journey.sections![ridesharingIndex].mode == ModeTransport.ridesharing.rawValue) {
                return ridesharingIndex
            } else if (journey.sections![ridesharingIndex].type != TypeTransport.crowFly.rawValue) {
                ridesharingIndex += 1
            }
        }
        
        return 0
    }
    
    func drawJourneyAnnotations(ridesharingJourneyCoordinates: [CLLocationCoordinate2D], drawnPathsCount: Int) {
        if ridesharingJourneyCoordinates.count == 2 {
            let ridesharingJourneyIndex = self.getRidesharingJourneyIndex(journey: self.journey!)
            
            if ridesharingJourneyIndex == 0 {
                self.mapView.addAnnotation(CustomAnnotation(coordinate: self.getJourneyDepartureCoordinates(),
                                                            title: "departure".localized(withComment: "Departure annotation", bundle: NavitiaSDKUIConfig.shared.bundle),
                                                            annotationType: .RidesharingAnnotation,
                                                            placeType: .Departure))
                if drawnPathsCount == 1 {
                    self.mapView.addAnnotation(CustomAnnotation(coordinate: self.getJourneyArrivalCoordinates(),
                                                                title: "arrival".localized(withComment: "Arrival annotation", bundle: NavitiaSDKUIConfig.shared.bundle),
                                                                annotationType: .RidesharingAnnotation,
                                                                placeType: .Arrival))
                } else {
                    self.mapView.addAnnotation(CustomAnnotation(coordinate: ridesharingJourneyCoordinates[1], annotationType: .RidesharingAnnotation, placeType: .Other))
                    self.mapView.addAnnotation(CustomAnnotation(coordinate: self.getJourneyArrivalCoordinates(),
                                                                title: "arrival".localized(withComment: "Arrival annotation", bundle: NavitiaSDKUIConfig.shared.bundle),
                                                                annotationType: .PlaceAnnotation,
                                                                placeType: .Arrival))
                }
            } else if ridesharingJourneyIndex == drawnPathsCount - 1 {
                self.mapView.addAnnotation(CustomAnnotation(coordinate: self.getJourneyDepartureCoordinates(),
                                                            title: "departure".localized(withComment: "Departure annotation", bundle: NavitiaSDKUIConfig.shared.bundle),
                                                            annotationType: .PlaceAnnotation,
                                                            placeType: .Departure))
                self.mapView.addAnnotation(CustomAnnotation(coordinate: ridesharingJourneyCoordinates[0],
                                                            annotationType: .RidesharingAnnotation,
                                                            placeType: .Other))
                self.mapView.addAnnotation(CustomAnnotation(coordinate: self.getJourneyArrivalCoordinates(),
                                                            title: "arrival".localized(withComment: "Arrival annotation", bundle: NavitiaSDKUIConfig.shared.bundle),
                                                            annotationType: .RidesharingAnnotation,
                                                            placeType: .Arrival))
            } else {
                self.mapView.addAnnotation(CustomAnnotation(coordinate: self.getJourneyDepartureCoordinates(),
                                                            title: "departure".localized(withComment: "Departure annotation", bundle: NavitiaSDKUIConfig.shared.bundle),
                                                            annotationType: .PlaceAnnotation,
                                                            placeType: .Departure))
                self.mapView.addAnnotation(CustomAnnotation(coordinate: ridesharingJourneyCoordinates[0],
                                                            annotationType: .RidesharingAnnotation,
                                                            placeType: .Other))
                self.mapView.addAnnotation(CustomAnnotation(coordinate: ridesharingJourneyCoordinates[1],
                                                            annotationType: .RidesharingAnnotation,
                                                            placeType: .Other))
                self.mapView.addAnnotation(CustomAnnotation(coordinate: self.getJourneyArrivalCoordinates(),
                                                            title: "arrival".localized(withComment: "Arrival annotation", bundle: NavitiaSDKUIConfig.shared.bundle),
                                                            annotationType: .PlaceAnnotation,
                                                            placeType: .Arrival))
            }
        } else {
            self.mapView.addAnnotation(CustomAnnotation(coordinate: self.getJourneyDepartureCoordinates(),
                                                        title: "departure".localized(withComment: "Departure annotation", bundle: NavitiaSDKUIConfig.shared.bundle),
                                                        annotationType: .PlaceAnnotation,
                                                        placeType: .Departure))
            self.mapView.addAnnotation(CustomAnnotation(coordinate: self.getJourneyArrivalCoordinates(),
                                                        title: "arrival".localized(withComment: "Arrival annotation", bundle: NavitiaSDKUIConfig.shared.bundle), annotationType: .PlaceAnnotation,
                                                        placeType: .Arrival))
        }
    }
    
    func zoomToPolyline(targetPolyline: MKPolyline, animated: Bool) {
        self.mapView.setVisibleMapRect(targetPolyline.boundingMapRect, edgePadding: UIEdgeInsetsMake(90, 40, 40, 40), animated: animated)
    }
    
    func getCircleRadiusDependingOnCurrentCameraAltitude(cameraAltitude: CLLocationDistance) -> CLLocationDistance {
        let altitudeReferenceValue = 10000.0
        let circleMaxmimumRadius = 100.0
        return cameraAltitude/altitudeReferenceValue * circleMaxmimumRadius
    }
    
    func redrawIntermediatePointCircles(mapView: MKMapView, cameraAltitude: CLLocationDistance) {
        mapView.removeOverlays(self.intermediatePointsCircles)
        var updatedIntermediatePointsCircles = [MKCircle]()
        for drawnCircle in self.intermediatePointsCircles {
            let updatedCircleView = MKCircle(center: drawnCircle.coordinate, radius: getCircleRadiusDependingOnCurrentCameraAltitude(cameraAltitude: cameraAltitude))
            updatedIntermediatePointsCircles.append(updatedCircleView)
        }
        self.intermediatePointsCircles = updatedIntermediatePointsCircles
        mapView.addOverlays(self.intermediatePointsCircles)
    }
    
    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        redrawIntermediatePointCircles(mapView: mapView, cameraAltitude: mapView.camera.altitude)
    }
    
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let sectionPolyline = overlay as? SectionPolyline {
            let polylineRenderer = MKPolylineRenderer(polyline: sectionPolyline)
            polylineRenderer.lineWidth = sectionPolyline.sectionLineWidth
            polylineRenderer.strokeColor = sectionPolyline.sectionStrokeColor
            if sectionPolyline.sectionLineDashPattern != nil {
                polylineRenderer.lineDashPattern = sectionPolyline.sectionLineDashPattern!
            }
            if sectionPolyline.sectionLineCap != nil {
                polylineRenderer.lineCap = sectionPolyline.sectionLineCap!
            }
            return polylineRenderer
        } else if let circle = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(circle: circle)
            circleRenderer.lineWidth = 1.5
            circleRenderer.strokeColor = UIColor.black
            circleRenderer.fillColor = UIColor.white
            
            return circleRenderer
        }
        return MKOverlayRenderer()
    }
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: CustomAnnotation.identifier)
        if annotationView == nil, let customAnnotation = annotation as? CustomAnnotation {
            annotationView = customAnnotation.getAnnotationView(annotationIdentifier: CustomAnnotation.identifier, bundle: NavitiaSDKUIConfig.shared.bundle)
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
}
