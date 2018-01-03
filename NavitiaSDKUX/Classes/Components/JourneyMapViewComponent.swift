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
        let journeyPathOverlays = self.getJourneyPathOverlays(self.renderedMapView!)
        let journeyPolyline = journeyPathOverlays["journey_polyline"] as! MKPolyline
        let sectionsPolylines = journeyPathOverlays["sections_polylines"] as! [MKPolyline]
        self.intermediatePointsCircles = journeyPathOverlays["intermediate_circles"] as! [MKCircle]
        self.renderedMapView!.addOverlays(sectionsPolylines)
        self.renderedMapView!.addOverlays(self.intermediatePointsCircles)
        
        let sourceMarker = MKPointAnnotation()
        sourceMarker.coordinate = self.getJourneyDepartureCoordinates()
        sourceMarker.title = NSLocalizedString("component.JourneyMapViewComponent.departure", bundle: self.bundle, comment: "Departure annotation")
        sourceMarker.subtitle = "Departure"
        let destinationMarker = MKPointAnnotation()
        destinationMarker.coordinate = self.getJourneyArrivalCoordinates()
        destinationMarker.title = NSLocalizedString("component.JourneyMapViewComponent.arrival", bundle: self.bundle, comment: "Arrival annotation")
        destinationMarker.subtitle = "Arrival"
        self.renderedMapView!.addAnnotation(sourceMarker)
        self.renderedMapView!.addAnnotation(destinationMarker)
        
        self.zoomToPolyline(targetPolyline: journeyPolyline, animated: false)
    }
    
    private func getJourneyPathOverlays(_ mapView: MKMapView) -> [String: Any] {
        var journeyPolylineCoordinates = [CLLocationCoordinate2D]()
        var sectionsPolylines = [MKPolyline]()
        var intermediatePointsCircles = [MKCircle]()
        for (_ , section) in self.journey!.sections!.enumerated() {
            if section.geojson != nil {
                let sectionGeoJSONCoordinates = section.geojson?.coordinates
                var sectionPolylineCoordinates = [CLLocationCoordinate2D]()
                for (_, coordinate) in sectionGeoJSONCoordinates!.enumerated() {
                    sectionPolylineCoordinates.append(CLLocationCoordinate2DMake(Double(coordinate[1]), Double(coordinate[0])))
                }
                let sectionPolyline = MKPolyline(coordinates: sectionPolylineCoordinates, count: sectionPolylineCoordinates.count)
                sectionsPolylines.append(sectionPolyline)
                let intermediatePointCircle = MKCircle(center: sectionPolylineCoordinates[sectionPolylineCoordinates.count - 1], radius: self.getCircleRadiusDependingOnCurrentCameraAltitude(cameraAltitude: mapView.camera.altitude))
                intermediatePointsCircles.append(intermediatePointCircle)
                journeyPolylineCoordinates.append(contentsOf: sectionPolylineCoordinates)
            }
        }
        intermediatePointsCircles.removeLast()
        
        var pathOverlays = [String: Any]()
        pathOverlays["journey_polyline"] = MKPolyline(coordinates: journeyPolylineCoordinates, count: journeyPolylineCoordinates.count)
        pathOverlays["sections_polylines"] = sectionsPolylines
        pathOverlays["intermediate_circles"] = intermediatePointsCircles
        return pathOverlays
    }
    
    private func getJourneyDepartureCoordinates() -> CLLocationCoordinate2D {
        var lat: Double = 0
        var lon: Double = 0
        if let coordinates = self.journey?.sections?[0].geojson?.coordinates {
            lat = Double(coordinates[0][1])
            lon = Double(coordinates[0][0])
        }
        
        return CLLocationCoordinate2DMake(lat, lon)
    }
    
    private func getJourneyArrivalCoordinates() -> CLLocationCoordinate2D {
        var lat: Double = 0
        var lon: Double = 0
        if let sectionLength = self.journey?.sections?.count, let coordinates = self.journey?.sections?[sectionLength - 1].geojson?.coordinates {
            let coordinatesLength = coordinates.count
            lat = Double(coordinates[coordinatesLength - 1][1])
            lon = Double(coordinates[coordinatesLength - 1][0])
        }
        
        return CLLocationCoordinate2DMake(lat, lon)
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
        if let polyline = overlay as? MKPolyline {
            let polylineRenderer = MKPolylineRenderer(polyline: polyline)
            polylineRenderer.strokeColor = UIColor.black
            polylineRenderer.lineWidth = 3
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
        if annotationView == nil {
            let annotationPin = UILabel(frame: CGRect(x: 28, y: 27, width: 26, height: 26))
            annotationPin.textColor = annotation.subtitle! == "Departure" ? config.colors.origin : config.colors.destination
            annotationPin.text = String.fontString(name: "location-pin")
            annotationPin.font = UIFont.iconFontOfSize(name: "SDKIcons", size: 26)
            
            let annotationLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 25))
            annotationLabel.backgroundColor = .black
            annotationLabel.textColor = .white
            annotationLabel.text = annotation.title!
            annotationLabel.font = UIFont(descriptor: annotationLabel.font.fontDescriptor, size: 14)
            annotationLabel.textAlignment = NSTextAlignment.center
            annotationLabel.alpha = 0.8
            annotationLabel.layer.cornerRadius = 5
            annotationLabel.layer.masksToBounds = true
            
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
