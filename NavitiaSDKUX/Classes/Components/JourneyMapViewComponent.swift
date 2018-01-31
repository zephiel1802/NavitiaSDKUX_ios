//
//  MapViewComponent.swift
//  NavitiaSDKUX
//
//  Created by Rachik Abidi on 26/12/2017.
//

import Foundation
import Render
import MapKit
import NavitiaSDK

class JourneyMapViewComponent: StylizedComponent<NilState>, MKMapViewDelegate {
    var journey: Journey?
    var renderedMapView: MKMapView?
    var intermediatePointsCircles = [MKCircle]()
    
    override func render() -> NodeType {
        return Node<MKMapView>(){ view, layout, _ in
            self.applyStyles(view: view, layout: layout)
            self.renderedMapView = view
            view.delegate = self
        };
    }
    
    override func componentDidMount() {
        let journeyPathOverlays = JourneyPathOverlays(journey: self.journey!, intermediatePointCircleRadius: self.getCircleRadiusDependingOnCurrentCameraAltitude(cameraAltitude: self.renderedMapView!.camera.altitude))
        self.renderedMapView!.addOverlays(journeyPathOverlays.sectionsPolylines)
        self.intermediatePointsCircles = journeyPathOverlays.intermediatesPointsCircles
        self.renderedMapView!.addOverlays(self.intermediatePointsCircles)
        
        let departureAnnotation = PlaceAnnotation()
        departureAnnotation.coordinate = self.getJourneyDepartureCoordinates()
        departureAnnotation.title = NSLocalizedString("departure", bundle: self.bundle, comment: "Departure annotation")
        departureAnnotation.annotationType = .Departure
        let arrivalAnnotation = PlaceAnnotation()
        arrivalAnnotation.coordinate = self.getJourneyArrivalCoordinates()
        arrivalAnnotation.title = NSLocalizedString("arrival", bundle: self.bundle, comment: "Arrival annotation")
        arrivalAnnotation.annotationType = .Arrival
        self.renderedMapView!.addAnnotation(departureAnnotation)
        self.renderedMapView!.addAnnotation(arrivalAnnotation)
        
        self.zoomToPolyline(targetPolyline: journeyPathOverlays.journeyPolyline, animated: false)
    }
    
    private func getJourneyDepartureCoordinates() -> CLLocationCoordinate2D {
        for (_, section) in (self.journey?.sections?.enumerated())! {
            if section.geojson != nil {
                return CLLocationCoordinate2DMake(Double((section.geojson?.coordinates![0][1])!), Double((section.geojson?.coordinates![0][0])!))
            }
        }
        return CLLocationCoordinate2DMake(0, 0)
    }
    
    private func getJourneyArrivalCoordinates() -> CLLocationCoordinate2D {
        for section in (self.journey?.sections?.reversed())! {
            if section.geojson != nil {
                let coordinatesLength = section.geojson?.coordinates!.count
                return CLLocationCoordinate2DMake(Double((section.geojson?.coordinates![coordinatesLength! - 1][1])!), Double((section.geojson?.coordinates![coordinatesLength! - 1][0])!))
            }
        }
        return CLLocationCoordinate2DMake(0, 0)
    }
    
    private func zoomToPolyline(targetPolyline: MKPolyline, animated: Bool) {
        self.renderedMapView!.setVisibleMapRect(targetPolyline.boundingMapRect, edgePadding: UIEdgeInsetsMake(50, 10, 50, 10), animated: animated)
    }
    
    private func getCircleRadiusDependingOnCurrentCameraAltitude(cameraAltitude: CLLocationDistance) -> CLLocationDistance {
        let altitudeReferenceValue = 10000.0
        let circleMaxmimumRadius = 100.0
        return cameraAltitude/altitudeReferenceValue * circleMaxmimumRadius
    }
    
    private func redrawIntermediatePointCircles(mapView: MKMapView, cameraAltitude: CLLocationDistance) {
        mapView.removeOverlays(self.intermediatePointsCircles)
        var updatedIntermediatePointsCircles = [MKCircle]()
        for drawnCircle in self.intermediatePointsCircles {
            let updatedCircleView = MKCircle(center: drawnCircle.coordinate, radius: self.getCircleRadiusDependingOnCurrentCameraAltitude(cameraAltitude: cameraAltitude))
            updatedIntermediatePointsCircles.append(updatedCircleView)
        }
        self.intermediatePointsCircles = updatedIntermediatePointsCircles
        mapView.addOverlays(self.intermediatePointsCircles)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        redrawIntermediatePointCircles(mapView: mapView, cameraAltitude: mapView.camera.altitude)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let sectionPolyline = overlay as? SectionPolyline {
            let targetSection = (self.journey?.sections?[sectionPolyline.sectionIndex!])!
            let polylineRenderer = MKPolylineRenderer(polyline: sectionPolyline)
            if targetSection.type == "public_transport" && targetSection.displayInformations?.color != nil {
                polylineRenderer.lineWidth = 5
                polylineRenderer.strokeColor = getUIColorFromHexadecimal(hex: getHexadecimalColorWithFallback(targetSection.displayInformations?.color))
            } else if targetSection.type == "street_network" || targetSection.type == "transfer" {
                polylineRenderer.strokeColor = config.colors.gray
                polylineRenderer.lineWidth = 4
                if targetSection.mode == "walking" {
                    polylineRenderer.lineDashPattern = [0.01, NSNumber(value: Float(2 * polylineRenderer.lineWidth))]
                    polylineRenderer.lineCap = CGLineCap.round
                }
            } else {
                polylineRenderer.lineWidth = 4
                polylineRenderer.strokeColor = UIColor.black
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationIdentifier = "annotationViewIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        if annotationView == nil, let placeAnnotation = annotation as? PlaceAnnotation {
            let annotationPin = UILabel(frame: CGRect(x: 28, y: 27, width: 26, height: 26))
            annotationPin.textColor = placeAnnotation.annotationType == .Departure ? config.colors.origin : config.colors.destination
            annotationPin.text = String.fontString(name: "location-pin")
            annotationPin.font = UIFont.iconFontOfSize(name: "SDKIcons", size: 26)
            
            let annotationLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 25))
            annotationLabel.backgroundColor = .black
            annotationLabel.textColor = .white
            annotationLabel.text = placeAnnotation.title!
            annotationLabel.font = UIFont(descriptor: annotationLabel.font.fontDescriptor, size: 14)
            annotationLabel.textAlignment = NSTextAlignment.center
            annotationLabel.alpha = 0.8
            
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.addSubview(annotationPin)
            annotationView?.addSubview(annotationLabel)
            annotationView?.frame = CGRect(x: 0, y: 0, width: 80, height: 100)
            annotationView?.canShowCallout = false
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
}

class JourneyPathOverlays {
    var journeyPolyline: MKPolyline
    var sectionsPolylines: [MKPolyline]
    var intermediatesPointsCircles: [MKCircle]
    
    init(journey: Journey, intermediatePointCircleRadius: CLLocationDistance) {
        var journeyPolylineCoordinates = [CLLocationCoordinate2D]()
        self.sectionsPolylines = [MKPolyline]()
        self.intermediatesPointsCircles = [MKCircle]()
        for (index , section) in journey.sections!.enumerated() {
            if section.geojson != nil {
                let sectionGeoJSONCoordinates = section.geojson!.coordinates
                var sectionPolylineCoordinates = [CLLocationCoordinate2D]()
                for (_, coordinate) in sectionGeoJSONCoordinates!.enumerated() {
                    sectionPolylineCoordinates.append(CLLocationCoordinate2DMake(Double(coordinate[1]), Double(coordinate[0])))
                }
                let sectionPolyline = SectionPolyline(coordinates: sectionPolylineCoordinates, count: sectionPolylineCoordinates.count, sectionIndex: index)
                sectionsPolylines.append(sectionPolyline)
                let intermediatePointCircle = MKCircle(center: sectionPolylineCoordinates[sectionPolylineCoordinates.count - 1], radius: intermediatePointCircleRadius)
                self.intermediatesPointsCircles.append(intermediatePointCircle)
                journeyPolylineCoordinates.append(contentsOf: sectionPolylineCoordinates)
            }
        }
        self.intermediatesPointsCircles.removeLast()
        self.journeyPolyline = MKPolyline(coordinates: journeyPolylineCoordinates, count: journeyPolylineCoordinates.count)
    }
}

class PlaceAnnotation : MKPointAnnotation {
    enum AnnotationType {
        case Departure
        case Arrival
    }
    var annotationType: AnnotationType = .Departure
}

class SectionPolyline: MKPolyline {
    var sectionIndex: Int?
    
    convenience init(coordinates: UnsafePointer<CLLocationCoordinate2D>, count: Int, sectionIndex: Int) {
        self.init(coordinates: coordinates, count: count)
        self.sectionIndex = sectionIndex
    }
}
