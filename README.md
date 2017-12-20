# NavitiaSDKUX

[![Version](https://img.shields.io/cocoapods/v/NavitiaSDKUX.svg?style=flat)](http://cocoapods.org/pods/NavitiaSDKUX)
[![License](https://img.shields.io/cocoapods/l/NavitiaSDKUX.svg?style=flat)](http://cocoapods.org/pods/NavitiaSDKUX)
[![Platform](https://img.shields.io/cocoapods/p/NavitiaSDKUX.svg?style=flat)](http://cocoapods.org/pods/NavitiaSDKUX)
[![Build Status](https://travis-ci.org/CanalTP/NavitiaSDKUX_ios.svg?branch=master)](https://travis-ci.org/CanalTP/NavitiaSDKUX_ios)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

NavitiaSDKUX is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "NavitiaSDKUX"
```

## Getting started

```swift
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Init the token is mandatory
        NavitiaSDKUXConfig.setToken(token: "my-token")

        // Init a set of parameters
        let params = JourneySolutionsController.InParameters(originId: "2.3665844;48.8465337", destinationId: "2.2979169;48.8848719")
        
        let bundle = Bundle(identifier: "org.cocoapods.NavitiaSDKUX")
        let storyboard = UIStoryboard(name: "Journey", bundle: bundle)
        let journeyResultsViewController = storyboard.instantiateInitialViewController() as! JourneySolutionsController
        journeyResultsViewController.setProps(with: params)

        // Invoke the screen using a navigation controller
        navigationController?.pushViewController(journeyResultsViewController, animated: true)
    }
}
```