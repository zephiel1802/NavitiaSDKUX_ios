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
    @IBOutlet weak var tableView: UITableView!
    
    var journey: Journey?
    var ridesharingJourney: Journey?
    var intermediatePointsCircles = [MKCircle]()
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        self.setupMapView()

    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension JourneySolutionRoadmapViewController: MKMapViewDelegate {
    
    func setupMapView() {
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
                self.mapView.addAnnotation(CustomAnnotation(coordinate: self.getJourneyDepartureCoordinates(), title: NSLocalizedString("departure", bundle: bundle, comment: "Departure annotation"), annotationType: .RidesharingAnnotation, placeType: .Departure))

                if drawnPathsCount == 1 {
                    self.mapView.addAnnotation(CustomAnnotation(coordinate: self.getJourneyArrivalCoordinates(), title: NSLocalizedString("arrival", bundle: bundle, comment: "Arrival annotation"), annotationType: .RidesharingAnnotation, placeType: .Arrival))
                } else {
                    self.mapView.addAnnotation(CustomAnnotation(coordinate: ridesharingJourneyCoordinates[1], annotationType: .RidesharingAnnotation, placeType: .Other))
                    self.mapView.addAnnotation(CustomAnnotation(coordinate: self.getJourneyArrivalCoordinates(), title: NSLocalizedString("arrival", bundle: bundle, comment: "Arrival annotation"), annotationType: .PlaceAnnotation, placeType: .Arrival))
                }
            } else if ridesharingJourneyIndex == drawnPathsCount - 1 {
                self.mapView.addAnnotation(CustomAnnotation(coordinate: self.getJourneyDepartureCoordinates(), title: NSLocalizedString("departure", bundle: bundle, comment: "Departure annotation"), annotationType: .PlaceAnnotation, placeType: .Departure))
                self.mapView.addAnnotation(CustomAnnotation(coordinate: ridesharingJourneyCoordinates[0], annotationType: .RidesharingAnnotation, placeType: .Other))
                self.mapView.addAnnotation(CustomAnnotation(coordinate: self.getJourneyArrivalCoordinates(), title: NSLocalizedString("arrival", bundle: bundle, comment: "Arrival annotation"), annotationType: .RidesharingAnnotation, placeType: .Arrival))
            } else {
                self.mapView.addAnnotation(CustomAnnotation(coordinate: self.getJourneyDepartureCoordinates(), title: NSLocalizedString("departure", bundle: bundle, comment: "Departure annotation"), annotationType: .PlaceAnnotation, placeType: .Departure))
                self.mapView.addAnnotation(CustomAnnotation(coordinate: ridesharingJourneyCoordinates[0], annotationType: .RidesharingAnnotation, placeType: .Other))
                self.mapView.addAnnotation(CustomAnnotation(coordinate: ridesharingJourneyCoordinates[1], annotationType: .RidesharingAnnotation, placeType: .Other))
                self.mapView.addAnnotation(CustomAnnotation(coordinate: self.getJourneyArrivalCoordinates(), title: NSLocalizedString("arrival", bundle: bundle, comment: "Arrival annotation"), annotationType: .PlaceAnnotation, placeType: .Arrival))
            }
        } else {
            self.mapView.addAnnotation(CustomAnnotation(coordinate: self.getJourneyDepartureCoordinates(), title: NSLocalizedString("departure", bundle: bundle, comment: "Departure annotation"), annotationType: .PlaceAnnotation, placeType: .Departure))
            self.mapView.addAnnotation(CustomAnnotation(coordinate: self.getJourneyArrivalCoordinates(), title: NSLocalizedString("arrival", bundle: bundle, comment: "Arrival annotation"), annotationType: .PlaceAnnotation, placeType: .Arrival))
        }
    }
    
    func zoomToPolyline(targetPolyline: MKPolyline, animated: Bool) {
        self.mapView.setVisibleMapRect(targetPolyline.boundingMapRect, edgePadding: UIEdgeInsetsMake(60, 20, 20, 20), animated: animated)
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
            annotationView = customAnnotation.getAnnotationView(annotationIdentifier: annotationIdentifier, bundle: bundle)
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
}

extension JourneySolutionRoadmapViewController: UITableViewDelegate {
    
}

extension JourneySolutionRoadmapViewController: UITableViewDataSource {
    
//    public func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView:UIView =  UIView()
//        return headerView
//    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
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
                        sectionPolyline.sectionStrokeColor = UIColor.gray//config.colors.gray
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
                annotationPin.textColor = self.placeType == .Departure ? UIColor.red/*config.colors.origin*/ : UIColor.blue/*config.colors.destination*/
                annotationPin.text = "\u{ea15}"//String.fontString(name: "location-pin")
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
