//
//  JourneyRoadmapViewController.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//


import UIKit
import MapKit

//protocol JourneyRoadmapDisplayLogic: class {
//    
//  func displaySomething(viewModel: JourneyRoadmap.GetMap.ViewModel)
//}

//class JourneyRoadmapViewController: UIViewController, JourneyRoadmapDisplayLogic {
//    
//  var interactor: JourneyRoadmapBusinessLogic?
//  var router: (NSObjectProtocol & JourneyRoadmapRoutingLogic & JourneyRoadmapDataPassing)?
//
//  // MARK: Object lifecycle
//  
//  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//    setup()
//  }
//  
//  required init?(coder aDecoder: NSCoder) {
//    super.init(coder: aDecoder)
//    setup()
//  }
//  
//  // MARK: Setup
//  
//  private func setup() {
//    let viewController = self
//    let interactor = JourneyRoadmapInteractor()
//    let presenter = JourneyRoadmapPresenter()
//    let router = JourneyRoadmapRouter()
//    viewController.interactor = interactor
//    viewController.router = router
//    interactor.presenter = presenter
//    presenter.viewController = viewController
//    router.viewController = viewController
//    router.dataStore = interactor
//  }
//  
//  // MARK: Routing
//  
//  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    if let scene = segue.identifier {
//      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
//      if let router = router, router.responds(to: selector) {
//        router.perform(selector, with: segue)
//      }
//    }
//  }
//  
//  // MARK: View lifecycle
//  
//  override func viewDidLoad()
//  {
//    super.viewDidLoad()
//    doSomething()
//  }
//  
//  // MARK: Do something
//  
//  //@IBOutlet weak var nameTextField: UITextField!
//  
//  func doSomething()
//  {
//    let request = JourneyRoadmap.GetMap.Request()
//    interactor?.doSomething(request: request)
//  }
//  
//  func displaySomething(viewModel: JourneyRoadmap.GetMap.ViewModel)
//  {
//    //nameTextField.text = viewModel.name
//  }
//}
//
//extension JourneyRoadmapViewController: MKMapViewDelegate {
//    
//    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        
//    }
//    
//    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        return MKOverlayRenderer()
//    }
//    
//    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        return MKAnnotationView()
//    }
//}
//
//extension JourneyRoadmapViewController: CLLocationManagerDelegate {
//    
//    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//
//    }
//    
//    private func _startUpdatingUserLocation() {
//
//    }
//    
//    private func _stopUpdatingUserLocation() {
//
//    }
//}
