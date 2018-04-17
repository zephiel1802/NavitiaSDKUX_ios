//
//  JourneySolutionRoadmapViewController.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 23/03/2018.
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
        self.setupMapView()
        
        composentWidth = updateWidth()
        
        if #available(iOS 11.0, *) {
            scrollView?.contentInsetAdjustmentBehavior = .always
        }
        display()
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateOriginViewScroll()
    }
    
    func updateWidth() -> CGFloat {
        if #available(iOS 11.0, *) {
            return scrollView.frame.size.width - scrollView.safeAreaInsets.left - scrollView.safeAreaInsets.right - (marge * 2)
        }
        return scrollView.frame.size.width - (marge * 2)
    }
    

    func addViewInScroll(view: UIView) {
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
    
    func updateOriginViewScroll() {
        for (index, view) in viewScroll.enumerated() {
            if index == 0 {
                view.frame.origin.y = marge
            } else {
                view.frame.origin.y = viewScroll[index - 1].frame.origin.y + viewScroll[index - 1].frame.height + marge
            }
            composentWidth = updateWidth()
            view.frame.size.width = updateWidth()
        }
        if let last = viewScroll.last {
            scrollView.contentSize.height = last.frame.origin.y + last.frame.height + marge
        }
    }
    
    private func display() {
        if ridesharing {
            if let journey = journey {
                let tc = JourneySolutionView(frame: CGRect(x: 0, y: 0, width: 0, height: 97))
                tc.setDataRidesharing(journey)
                addViewInScroll(view: tc)
            }
            ridesharingView = RidesharingView(frame: CGRect(x: 0, y: 0, width: 0, height: 260))
            addViewInScroll(view: ridesharingView)

        } else {
            if let journey = journey {
                let tc = JourneySolutionView(frame: CGRect(x: 0, y: 0, width: 0, height: 130))
                tc.setData(journey)
                addViewInScroll(view: tc)
            }
        }
        
        _displayDeparture(journey)
        
        if let sections = journey?.sections {
            for (index, section) in sections.enumerated() {
                if let type = section.type {
                    if type == "public_transport" {
                        if index == 0 {
                            _displayPublicTransport(section)
                        }
                        _displayPublicTransport(section, waiting: sections[index - 1])
                    } else if type == "transfer" {
                        _displayTransferStep(section, mode: section.transferType ?? "")
                    } else if type == "street_network" {
                        if let mode = section.mode {
                            if mode == "walking" || mode == "car" {
                                _displayTransferStep(section, mode: mode)
                            } else {
                                if mode == "ridesharing" {
                                    _updateRidesharingView(section)
                                    let view = BikeStepView(frame: CGRect(x: 0, y: 0, width: composentWidth, height: 50))
                                    view.typeString = mode
                                    view.takeName = ""
                                    view.origin = ridesharingView.addressFrom ?? ""
                                    view.destination = ridesharingView.addressTo ?? ""
                                    view.time = timeRidesharing?.minuteToString() ?? ""
                                    addViewInScroll(view: view)
                                } else {
                                    _displayBikeStep(section, mode: mode)
                                }
                            }
                        }
                        
                    }
                }
            }
        }
        _displayArrival(journey)
    }
    
    func _displayDeparture(_ journey: Journey?) {
        let viewDeparture = DepartureArrivalStepView(frame: CGRect(x: 0, y: 0, width: composentWidth, height: 70))
        viewDeparture.information = journey?.sections?.first?.from?.name ?? ""
        viewDeparture.time = journey?.departureDateTime?.toDate(format: "yyyyMMdd'T'HHmmss")?.toString(format: "HH:mm") ?? ""
        viewDeparture.type = .departure
        addViewInScroll(view: viewDeparture)
    }
    
    func _displayArrival(_ journey: Journey?) {
        let viewArrival = DepartureArrivalStepView(frame: CGRect(x: 0, y: 0, width: composentWidth, height: 70))
        viewArrival.information = journey?.sections?.last?.to?.name ?? ""
        viewArrival.time = journey?.arrivalDateTime?.toDate(format: "yyyyMMdd'T'HHmmss")?.toString(format: "HH:mm") ?? ""
        viewArrival.type = .arrival
        addViewInScroll(view: viewArrival)
    }
    
    func _displayTransferStep(_ section: Section, mode: String) {
        let view = TransferStepView(frame: CGRect(x: 0, y: 0, width: composentWidth, height: 50))
        view.typeString = mode
        view.time = section.duration?.minuteToString()
        view.direction = section.to?.name ?? ""
        addViewInScroll(view: view)
    }
    
    func _displayBikeStep(_ section: Section, mode: String) {
        let view = BikeStepView(frame: CGRect(x: 0, y: 0, width: composentWidth, height: 50))
        view.typeString = mode
        view.takeName = ""
        view.origin = section.from?.name ?? ""
        view.destination = section.to?.name ?? ""
        view.time = section.duration?.minuteToString()
        addViewInScroll(view: view)
    }
    
    func _updateRidesharingView(_ section: Section) {
        ridesharingView.title = section.ridesharingJourneys?[ridesharingIndex].sections?[1].ridesharingInformations?._operator ?? ""
        ridesharingView.startDate = section.ridesharingJourneys?[ridesharingIndex].sections?[1].departureDateTime?.toDate(format: "yyyyMMdd'T'HHmmss")?.toString(format: "HH:mm") ?? ""
        ridesharingView.login = section.ridesharingJourneys?[ridesharingIndex].sections?[1].ridesharingInformations?.driver?.alias ?? ""
        ridesharingView.gender = section.ridesharingJourneys?[ridesharingIndex].sections?[1].ridesharingInformations?.driver?.gender ?? ""
        ridesharingView.addressFrom = section.ridesharingJourneys?[ridesharingIndex].sections?[1].from?.name ?? ""
        ridesharingView.addressTo = section.ridesharingJourneys?[ridesharingIndex].sections?[1].to?.name ?? ""
        ridesharingView.seatCount = section.ridesharingJourneys?[ridesharingIndex].sections?[1].ridesharingInformations?.seats?.available?.toString() ?? ""
        ridesharingView.price = section.ridesharingJourneys?[ridesharingIndex].fare?.total?.value ?? ""
        ridesharingView.setPicture(url: section.ridesharingJourneys?[ridesharingIndex].sections?[1].ridesharingInformations?.driver?.image)
        ridesharingView.setNotation(section.ridesharingJourneys?[ridesharingIndex].sections?[1].ridesharingInformations?.driver?.rating?.count)
        ridesharingView.setFullStar(section.ridesharingJourneys?[ridesharingIndex].sections?[1].ridesharingInformations?.driver?.rating?.value)
        ridesharingView._parent = self
        ridesharingDeepLink = section.ridesharingJourneys?[ridesharingIndex].sections?[1].links?[0].href
        timeRidesharing = section.ridesharingJourneys?[ridesharingIndex].sections?[1].duration
        // Url section.ridesharingJourneys?[0].sections?[1].links?[0].href ?? ""
    }
    
    func _displayPublicTransport(_ section: Section, waiting: Section? = nil) {
        let publicTransportView = PublicTransportView(frame: CGRect(x: 0, y: 0, width: composentWidth, height: 100))
        publicTransportView.typeString = Modes().getModeIcon(section: section)
        publicTransportView.take = section.displayInformations?.commercialMode ?? ""
        publicTransportView.transportColor = section.displayInformations?.color?.toUIColor() ?? UIColor.black
        publicTransportView.transportName = section.displayInformations?.label ?? ""
        
        // publicTransportView.disruptionType = .blocking
        // publicTransportView.disruptionInformation = "Suite à un incident d’exploitation, le trafic est interrompu sur l’ensemble de la ligne."
        // publicTransportView.disruptionDate = "Du 01/08/17 au 17/08/17"
        // publicTransportView.waitTime = "7"
        
        publicTransportView.origin = section.from?.name ?? ""
        publicTransportView.startTime = section.departureDateTime?.toDate(format: "yyyyMMdd'T'HHmmss")?.toString(format: "HH:mm") ?? ""
        publicTransportView.directionTransit = section.displayInformations?.direction ?? ""
        publicTransportView.destination = section.to?.name ?? ""
        publicTransportView.endTime = section.arrivalDateTime?.toDate(format: "yyyyMMdd'T'HHmmss")?.toString(format: "HH:mm") ?? ""
        
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
            if waiting.type == "waiting" {
                if let durationWaiting = waiting.duration?.minuteToString() {
                    publicTransportView.waitTime = durationWaiting
                }
            }
        }

        addViewInScroll(view: publicTransportView)
    }
    
}

extension JourneySolutionRoadmapViewController: AlertViewControllerProtocol {
    
    func onNegativeButtonClicked(_ alertViewController: AlertViewController) {
        alertViewController.dismiss(animated: false, completion: nil)
    }
    
    func onPositiveButtonClicked(_ alertViewController: AlertViewController) {
        self.openDeepLink()
        alertViewController.dismiss(animated: false, completion: nil)
    }
    
    func openDeepLink() {
        if let ridesharingDeepLink = self.ridesharingDeepLink {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: ridesharingDeepLink)!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(URL(string: ridesharingDeepLink)!)
            }
        }
    }
    
}

extension JourneySolutionRoadmapViewController: MKMapViewDelegate {
    
    func setupMapView() {
        title = "roadmap".localized(withComment: "Roadmap", bundle: NavitiaSDKUIConfig.shared.bundle)
        
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
            if section.type != "crow_fly" && section.geojson != nil {
                return CLLocationCoordinate2DMake(Double((section.geojson?.coordinates![0][1])!), Double((section.geojson?.coordinates![0][0])!))
            }
        }
        return CLLocationCoordinate2DMake(0, 0)
    }
    
    func getJourneyArrivalCoordinates() -> CLLocationCoordinate2D {
        for section in (self.journey?.sections?.reversed())! {
            if section.type != "crow_fly" && section.geojson != nil {
                let coordinatesLength = section.geojson!.coordinates!.count
                return CLLocationCoordinate2DMake(Double((section.geojson?.coordinates![coordinatesLength - 1][1])!), Double((section.geojson?.coordinates![coordinatesLength - 1][0])!))
            }
        }
        return CLLocationCoordinate2DMake(0, 0)
    }
    
    func getRidesharingJourneyCoordinates(journey: Journey) -> [CLLocationCoordinate2D] {
        var ridesharingJourneyCoordinates = [CLLocationCoordinate2D]()
        for (_ , section) in journey.sections!.enumerated() {
            if section.type == "street_network" && section.mode != nil && section.mode == "ridesharing" {
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
            if (journey.sections![ridesharingIndex].type == "street_network" && journey.sections![ridesharingIndex].mode == "ridesharing") {
                return ridesharingIndex
            } else if (journey.sections![ridesharingIndex].type != "crow_fly") {
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
        self.mapView.setVisibleMapRect(targetPolyline.boundingMapRect, edgePadding: UIEdgeInsetsMake(70, 60, 60, 60), animated: animated)
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
        let annotationIdentifier = "annotationViewIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        if annotationView == nil, let customAnnotation = annotation as? CustomAnnotation {
            annotationView = customAnnotation.getAnnotationView(annotationIdentifier: annotationIdentifier, bundle: NavitiaSDKUIConfig.shared.bundle)
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
}

extension JourneySolutionRoadmapViewController: UIScrollViewDelegate {
    
}


class JourneyPathOverlays {
    var journeyPolyline: MKPolyline
    var sectionsPolylines: [MKPolyline]
    var intermediatesPointsCircles: [MKCircle]
    
    init(journey: Journey, ridesharingJourneyCoordinates: [CLLocationCoordinate2D], intermediatePointCircleRadius: CLLocationDistance) {
        var journeyPolylineCoordinates = [CLLocationCoordinate2D]()
        self.sectionsPolylines = [MKPolyline]()
        self.intermediatesPointsCircles = [MKCircle]()
        for (_ , section) in journey.sections!.enumerated() {
            if section.type != "crow_fly" && section.geojson != nil {
                var sectionPolylineCoordinates = [CLLocationCoordinate2D]()
                let sectionGeoJSONCoordinates = section.geojson!.coordinates
                if section.type == "street_network" && section.mode != nil && section.mode == "ridesharing" {
                    let sectionPolyline = SectionPolyline(coordinates: ridesharingJourneyCoordinates, count: ridesharingJourneyCoordinates.count)
                    sectionPolyline.sectionLineWidth = 4
                    sectionPolyline.sectionStrokeColor = UIColor.black
                    
                    sectionsPolylines.append(sectionPolyline)
                    sectionPolylineCoordinates.append(contentsOf: ridesharingJourneyCoordinates)
                } else {
                    for (_, coordinate) in sectionGeoJSONCoordinates!.enumerated() {
                        sectionPolylineCoordinates.append(CLLocationCoordinate2DMake(Double(coordinate[1]), Double(coordinate[0])))
                    }
                    
                    let sectionPolyline = SectionPolyline(coordinates: sectionPolylineCoordinates, count: sectionPolylineCoordinates.count)
                    if section.type == "public_transport" && section.displayInformations?.color != nil {
                        sectionPolyline.sectionLineWidth = 5
                        sectionPolyline.sectionStrokeColor = section.displayInformations?.color?.toUIColor()
                    } else if section.type == "street_network" || section.type == "transfer" {
                        sectionPolyline.sectionLineWidth = 4
                        sectionPolyline.sectionStrokeColor = NavitiaSDKUIConfig.shared.color.gray
                        if section.mode == "walking" {
                            sectionPolyline.sectionLineDashPattern = [0.01, NSNumber(value: Float(2 * sectionPolyline.sectionLineWidth))]
                            sectionPolyline.sectionLineCap = CGLineCap.round
                        }
                    } else {
                        sectionPolyline.sectionLineWidth = 4
                        sectionPolyline.sectionStrokeColor = UIColor.black
                    }
                    
                    sectionsPolylines.append(sectionPolyline)
                }
                if sectionPolylineCoordinates.count > 0 {
                    let intermediatePointCircle = MKCircle(center: sectionPolylineCoordinates[sectionPolylineCoordinates.count - 1], radius: intermediatePointCircleRadius)
                    self.intermediatesPointsCircles.append(intermediatePointCircle)
                    journeyPolylineCoordinates.append(contentsOf: sectionPolylineCoordinates)
                }
            }
        }
        if self.intermediatesPointsCircles.count > 0 {
            self.intermediatesPointsCircles.removeLast()
        }
        self.journeyPolyline = MKPolyline(coordinates: journeyPolylineCoordinates, count: journeyPolylineCoordinates.count)
    }
}

class CustomAnnotation: MKPointAnnotation {
    enum AnnotationType {
        case PlaceAnnotation
        case RidesharingAnnotation
    }
    enum PlaceType {
        case Departure
        case Arrival
        case Other
    }
    
    var annotationType: AnnotationType?
    var placeType: PlaceType?
    
    init(coordinate: CLLocationCoordinate2D, title: String = "", annotationType: AnnotationType = .PlaceAnnotation, placeType: PlaceType = .Departure) {
        super.init()
        self.coordinate = coordinate
        self.title = title
        self.annotationType = annotationType
        self.placeType = placeType
    }
    
    func getAnnotationView(annotationIdentifier: String, bundle: Bundle) -> MKAnnotationView {
        let annotationView = MKAnnotationView(annotation: self, reuseIdentifier: annotationIdentifier)
        annotationView.canShowCallout = false
        
        if placeType == .Departure || placeType == .Arrival {
            let annotationLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 25))
            annotationLabel.backgroundColor = UIColor.black
            annotationLabel.layer.masksToBounds = true
            annotationLabel.layer.cornerRadius = 4.0
            annotationLabel.textColor = .white
            annotationLabel.text = self.title!
            annotationLabel.font = UIFont(descriptor: annotationLabel.font.fontDescriptor, size: 14)
            annotationLabel.textAlignment = NSTextAlignment.center
            annotationLabel.alpha = 0.8
            if annotationType == .RidesharingAnnotation {
                let annotationImage = UIImageView(frame: CGRect(x: 30, y: 27, width: 20, height: 30))
                annotationImage.image = UIImage(named: "ridesharing_pin", in: bundle, compatibleWith: nil)
                annotationView.addSubview(annotationImage)
            } else {
                let annotationPin = UILabel(frame: CGRect(x: 28, y: 27, width: 26, height: 26))
                annotationPin.textColor = self.placeType == .Departure ? NavitiaSDKUIConfig.shared.color.origin : NavitiaSDKUIConfig.shared.color.destination
                annotationPin.text = Icon("location-pin").iconFontCode
                annotationPin.font = UIFont(name: "SDKIcons", size: 26)
                annotationView.addSubview(annotationPin)
            }
            
            annotationView.addSubview(annotationLabel)
            annotationView.frame = CGRect(x: 0, y: 0, width: 80, height: 100)
        } else {
            if annotationType == .RidesharingAnnotation {
                let annotationImage = UIImageView(frame: CGRect(x: 0, y: -15, width: 20, height: 30))
                annotationImage.image = UIImage(named: "ridesharing_pin", in: bundle, compatibleWith: nil)
                
                annotationView.addSubview(annotationImage)
                annotationView.frame = CGRect(x: 0, y: 0, width: 20, height: 30)
            }
        }
        
        return annotationView
    }
}

class SectionPolyline: MKPolyline {
    var sectionLineWidth: CGFloat = 0
    var sectionStrokeColor: UIColor?
    var sectionLineDashPattern: [NSNumber]?
    var sectionLineCap: CGLineCap?
}









import UIKit

@IBDesignable
public class ScrollableStackView: UIView {
    
    fileprivate var didSetupConstraints = false
    @IBInspectable open var spacing: CGFloat = 8
    open var durationForAnimations:TimeInterval = 1.45
    
    public lazy var scrollView: UIScrollView = {
        let instance = UIScrollView(frame: CGRect.zero)
        instance.translatesAutoresizingMaskIntoConstraints = false
        instance.layoutMargins = .zero
        return instance
    }()
    
    public lazy var stackView: UIStackView = {
        let instance = UIStackView(frame: CGRect.zero)
        instance.translatesAutoresizingMaskIntoConstraints = false
        instance.axis = .vertical
        instance.spacing = self.spacing
        instance.distribution = .equalSpacing
        return instance
    }()
    
    //MARK: View life cycle
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        setupUI()
    }
    
    //MARK: UI
    func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        setNeedsUpdateConstraints() // Bootstrap auto layout
    }
    
    // Scrolls to item at index
    public func scrollToItem(index: Int) {
        if stackView.arrangedSubviews.count > 0 {
            let view = stackView.arrangedSubviews[index]
            
            UIView.animate(withDuration: durationForAnimations, animations: {
                self.scrollView.setContentOffset(CGPoint(x: 0, y:view.frame.origin.y), animated: true)
            })
        }
    }
    
    // Used to scroll till the end of scrollview
    public func scrollToBottom() {
        if stackView.arrangedSubviews.count > 0 {
            UIView.animate(withDuration: durationForAnimations, animations: {
                self.scrollView.scrollToBottom(true)
            })
        }
    }
    
    // Scrolls to top of scrollable area
    public func scrollToTop() {
        if stackView.arrangedSubviews.count > 0 {
            UIView.animate(withDuration: durationForAnimations, animations: {
                self.scrollView.setContentOffset(CGPoint(x: 0, y:0), animated: true)
            })
        }
    }
    
    override public func updateConstraints() {
        super.updateConstraints()
        
        if !didSetupConstraints {
            scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
            
            // Set the width of the stack view to the width of the scroll view for vertical scrolling
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
            
            didSetupConstraints = true
        }
    }
}

// Used to scroll till the end of scrollview
extension UIScrollView {
    func scrollToBottom(_ animated: Bool) {
        if self.contentSize.height < self.bounds.size.height { return }
        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
        self.setContentOffset(bottomOffset, animated: animated)
    }
}
