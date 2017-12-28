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
    var journeyPolyline: MKPolyline?
    var sectionsPolylines = [MKPolyline]()
    var intermediatePointsCircles = [MKCircle]()
    let altitudeReferenceValue = 10000.0
    let circleMaxmimumRadius = 100.0
    let circleMinimumRadius = 10.0
    
    override func render() -> NodeType {
        return Node<MKMapView>(){ view, layout, _ in
            self.applyStyles(view: view, layout: layout)
            self.renderedMapView = view
            view.delegate = self
        };
    }
    
    override func componentDidMount() {
        self.journeyPolyline = self.drawJourneyPath(self.renderedMapView!)
        let sourceMarker = MKPointAnnotation()
        sourceMarker.coordinate = self.getJourneyDepartureCoordinates()
        sourceMarker.title = NSLocalizedString("component.JourneyMapViewComponent.departure", bundle: self.bundle, comment: "Departure annotation")
        let destinationMarker = MKPointAnnotation()
        destinationMarker.coordinate = self.getJourneyArrivalCoordinates()
        destinationMarker.title = NSLocalizedString("component.JourneyMapViewComponent.arrival", bundle: self.bundle, comment: "Arrival annotation")
        self.renderedMapView!.addAnnotation(sourceMarker)
        self.renderedMapView!.addAnnotation(destinationMarker)
        self.zoomToPolyline(targetPolyline: self.journeyPolyline!, animated: false)
    }
    
    func drawJourneyPath(_ mapView: MKMapView) -> MKPolyline {
        var journeyPolylineCoordinates = [CLLocationCoordinate2D]()
        for (_ , section) in self.journey!.sections!.enumerated() {
            if section.type! == "street_network" || section.type! == "public_transport" || section.type! == "transfer" {
                let sectionGeoJSONCoordinates = section.geojson?.coordinates
                var sectionPolylineCoordinates = [CLLocationCoordinate2D]()
                for (_, coordinate) in sectionGeoJSONCoordinates!.enumerated() {
                    sectionPolylineCoordinates.append(CLLocationCoordinate2DMake(Double(coordinate[1]), Double(coordinate[0])))
                    journeyPolylineCoordinates.append(CLLocationCoordinate2DMake(Double(coordinate[1]), Double(coordinate[0])))
                }
                let sectionPolyline = MKPolyline(coordinates: &sectionPolylineCoordinates, count: sectionPolylineCoordinates.count)
                self.sectionsPolylines.append(sectionPolyline)
                let intermediatePointCircle = MKCircle(center: sectionPolylineCoordinates[sectionPolylineCoordinates.count - 1], radius: self.getCircleRadiusDependingOnCurrentCameraAltitude(cameraAltitude: mapView.camera.altitude))
                self.intermediatePointsCircles.append(intermediatePointCircle)
            }
        }
        mapView.addOverlays(self.sectionsPolylines)
        self.intermediatePointsCircles.removeLast()
        mapView.addOverlays(self.intermediatePointsCircles)
        return MKPolyline(coordinates: &journeyPolylineCoordinates, count: journeyPolylineCoordinates.count)
    }
    
    func getJourneyDepartureCoordinates() -> CLLocationCoordinate2D {
        for section in self.journey!.sections! {
            if section.type! == "street_network" || section.type! == "public_transport" || section.type! == "transfer" {
                return CLLocationCoordinate2DMake(Double((section.geojson?.coordinates![0][1])!), Double((section.geojson?.coordinates![0][0])!))
            }
        }
        return CLLocationCoordinate2DMake(0, 0)
    }
    
    func getJourneyArrivalCoordinates() -> CLLocationCoordinate2D {
        for section in self.journey!.sections!.reversed() {
            if section.type! == "street_network" || section.type! == "public_transport" || section.type! == "transfer" {
                return CLLocationCoordinate2DMake(Double((section.geojson?.coordinates![(section.geojson?.coordinates?.count)! - 1][1])!), Double((section.geojson?.coordinates![(section.geojson?.coordinates?.count)! - 1][0])!))
            }
        }
        return CLLocationCoordinate2DMake(0, 0)
    }
    
    func zoomToPolyline(targetPolyline: MKPolyline, animated: Bool) {
        self.renderedMapView!.setVisibleMapRect(targetPolyline.boundingMapRect, edgePadding: UIEdgeInsetsMake(50, 10, 50, 10), animated: animated)
    }
    
    func getCircleRadiusDependingOnCurrentCameraAltitude(cameraAltitude: CLLocationDistance) -> CLLocationDistance {
        if cameraAltitude > altitudeReferenceValue {
            return circleMaxmimumRadius
        } else if cameraAltitude/altitudeReferenceValue * circleMaxmimumRadius < circleMinimumRadius {
            return circleMinimumRadius
        } else {
            return cameraAltitude/altitudeReferenceValue * circleMaxmimumRadius
        }
    }
    
    func redrawIntermediatePointCircles(mapView: MKMapView, cameraAltitude: CLLocationDistance) {
        mapView.removeOverlays(self.intermediatePointsCircles)
        var updatedIntermediatePointsCircles = [MKCircle]()
        for drawnCircle in self.intermediatePointsCircles {
            let updatedCircleView = MKCircle(center: drawnCircle.coordinate, radius: self.getCircleRadiusDependingOnCurrentCameraAltitude(cameraAltitude: cameraAltitude))
            updatedIntermediatePointsCircles.append(updatedCircleView)
        }
        self.intermediatePointsCircles.removeAll()
        self.intermediatePointsCircles.append(contentsOf: updatedIntermediatePointsCircles)
        mapView.addOverlays(self.intermediatePointsCircles)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        redrawIntermediatePointCircles(mapView: mapView, cameraAltitude: mapView.camera.altitude)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let polylineRenderer = MKPolylineRenderer(polyline: polyline)
            polylineRenderer.strokeColor = UIColor.purple
            polylineRenderer.lineWidth = 3
            return polylineRenderer
        } else if let circle = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(circle: circle)
            circleRenderer.lineWidth = 1
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
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            let annotationPin = UILabel(frame: CGRect(x: 28, y: 27, width: 26, height: 26))
            annotationPin.textColor = UIColor.red
            annotationPin.text = String.fontString(name: "location-pin")
            annotationPin.font = UIFont.iconFontOfSize(name: "SDKIcons", size: 26)
            annotationView?.addSubview(annotationPin)
            let annotationLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 25))
            annotationLabel.backgroundColor = .black
            annotationLabel.textColor = .white
            annotationLabel.font = UIFont(descriptor: annotationLabel.font.fontDescriptor, size: 14)
            annotationLabel.textAlignment = NSTextAlignment.center
            annotationLabel.alpha = 0.8
            annotationLabel.tag = 1
            annotationLabel.layer.cornerRadius = 5
            annotationLabel.layer.masksToBounds = true
            annotationView?.addSubview(annotationLabel)
            annotationView?.frame = CGRect(x: 0, y: 0, width: 80, height: 100)
        } else {
            annotationView?.annotation = annotation
        }
        
        let annotationLabel = annotationView?.viewWithTag(1) as! UILabel
        annotationLabel.text = annotation.title!
        
        return annotationView
    }
}
