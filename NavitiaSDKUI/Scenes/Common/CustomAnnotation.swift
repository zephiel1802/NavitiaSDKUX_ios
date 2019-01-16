//
//  CustomAnnotation.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit
import MapKit

class CustomAnnotation: MKPointAnnotation {
    
    enum AnnotationType: Int {
        case PlaceAnnotation = 0
        case RidesharingAnnotation = 1
        case Transfer = 2
    }
    
    enum PlaceType: String {
        case Departure = "departure"
        case Arrival = "arrival"
        case Other = "other"
    }
    
    var annotationType: AnnotationType?
    var placeType: PlaceType?
    var identifier = "annotationViewIdentifier"
    var color: UIColor!
    
    init(coordinate: CLLocationCoordinate2D, title: String = "", annotationType: AnnotationType = .PlaceAnnotation, placeType: PlaceType = .Other, color: UIColor? = nil) {
        super.init()
        
        self.color = color ?? .black
        self.coordinate = coordinate
        self.annotationType = annotationType
        self.placeType = placeType
        self.identifier = String(format: "%d %d %@", annotationType.rawValue, placeType.hashValue, self.color)
        self.title = title
    }
    
    private func getPin() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 7
        view.layer.borderWidth = 2
        view.layer.borderColor = color.cgColor
        view.layer.zPosition = 0
        
        return view
    }
    
    internal func getAnnotationView(annotationIdentifier: String, bundle: Bundle) -> MKAnnotationView {
        let annotationView = MKAnnotationView(annotation: self, reuseIdentifier: annotationIdentifier)
        
        annotationView.canShowCallout = false
        
        if annotationType == .Transfer {
            let view = getPin()
            
            view.center = CGPoint(x: 0, y: 0)

            annotationView.addSubview(view)
        } else {
            if placeType == .Departure || placeType == .Arrival {
                let annotationLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 25))
                
                annotationLabel.backgroundColor = Configuration.Color.main
                annotationLabel.layer.masksToBounds = true
                annotationLabel.layer.cornerRadius = 4.0
                annotationLabel.textColor = .white
                annotationLabel.font = UIFont(descriptor: annotationLabel.font.fontDescriptor, size: 14)
                annotationLabel.textAlignment = NSTextAlignment.center
                annotationLabel.alpha = 1
                
                if let title = title, !title.isEmpty {
                    annotationLabel.text = title
                } else {
                    annotationLabel.text = placeType?.rawValue.localized()
                }
                
                if annotationType == .RidesharingAnnotation {
                    let annotationImage = UIImageView(frame: CGRect(x: 30, y: 29, width: 20, height: 30))
                    annotationImage.image = UIImage(named: "ridesharing_pin", in: bundle, compatibleWith: nil)
                    annotationImage.layer.zPosition = 1
                    
                    annotationView.addSubview(annotationImage)
                } else {
                    let view = getPin()
                    
                    view.center = CGPoint(x: 40, y: 52)
                    
                    annotationView.addSubview(view)

                    let annotationPin = UILabel(frame: CGRect(x: 27, y: 27, width: 26, height: 26))
                    annotationPin.attributedText = NSMutableAttributedString()
                        .icon("location-pin",
                              color: self.placeType == .Departure ? Configuration.Color.origin : Configuration.Color.destination,
                              size: 26)
                    
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
        }

        return annotationView
    }
}
