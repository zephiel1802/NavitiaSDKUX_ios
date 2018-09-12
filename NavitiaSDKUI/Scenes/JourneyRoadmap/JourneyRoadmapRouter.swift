//
//  JourneyRoadmapRouter.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//


import UIKit

@objc protocol JourneyRoadmapRoutingLogic
{
  //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol JourneyRoadmapDataPassing
{
  var dataStore: JourneyRoadmapDataStore? { get }
}

class JourneyRoadmapRouter: NSObject, JourneyRoadmapRoutingLogic, JourneyRoadmapDataPassing
{
  weak var viewController: JourneyRoadmapViewController?
  var dataStore: JourneyRoadmapDataStore?
  
  // MARK: Routing
  
  //func routeToSomewhere(segue: UIStoryboardSegue?)
  //{
  //  if let segue = segue {
  //    let destinationVC = segue.destination as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //  } else {
  //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
  //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //    navigateToSomewhere(source: viewController!, destination: destinationVC)
  //  }
  //}

  // MARK: Navigation
  
  //func navigateToSomewhere(source: JourneyRoadmapViewController, destination: SomewhereViewController)
  //{
  //  source.show(destination, sender: nil)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: JourneyRoadmapDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}
