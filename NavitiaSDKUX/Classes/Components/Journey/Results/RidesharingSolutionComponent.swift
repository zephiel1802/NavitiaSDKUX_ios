//
//  RidesharingSolutionComponent.swift
//  NavitiaSDKUX
//
//  Created by Rachik Abidi on 16/02/2018.
//

import Foundation

extension Components.Journey.Results {
    class RidesharingSolutionComponent: ViewComponent, AlertViewControllerProtocol {
        
        let JourneyRidesharing2ColumnsLayout: Components.Journey.Results.SolutionComponentParts.JourneyRidesharing2ColumnsLayout.Type = Components.Journey.Results.SolutionComponentParts.JourneyRidesharing2ColumnsLayout.self
        let SeparatorPart: Components.Journey.Results.Parts.SeparatorPart.Type = Components.Journey.Results.Parts.SeparatorPart.self
        
        var navigationController: UINavigationController?
        var journey: Journey?
        var ridesharingJourney: Journey?
        var disruptions: [Disruption]?
        var network: String = ""
        var departureDate: String = ""
        var driverImageURL: String = ""
        var driverNickname: String = ""
        var driverGender: String = ""
        var driverRating: Float = 0
        var driverRateCount: Int32 = 0
        var seatsAvailable: String = ""
        var tripFareText: String?
        var isRoadmapComponent: Bool = false
        
        required init() {
            super.init()
            tripFareText = NSLocalizedString("free", bundle: self.bundle, comment: "Free")
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func render() -> NodeType {
            let mainNode = ComponentNode(CardComponent(), in: self, props: {(component, _) in
                component.styles = self.ridesharingCardStyles
            })
            if self.isRoadmapComponent {
                mainNode.add(children: [
                    ComponentNode(ActionComponent(), in: self, props: {(component, _) in
                        component.onTap = { _ in
                            if UserDefaults.standard.bool(forKey: "navitiaSdkShowRedirectionDialog") {
                                let alertController = AlertViewController(nibName: "AlertView", bundle: self.bundle)
                                alertController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                                alertController.keyState = "navitiaSdkShowRedirectionDialog"
                                alertController.alertMessage = NSLocalizedString("redirection_message", bundle: self.bundle, comment: "Redirection Message")
                                alertController.checkBoxText = NSLocalizedString("dont_show_this_message_again", bundle: self.bundle, comment: "Don't show this message again")
                                alertController.negativeButtonText = NSLocalizedString("cancel", bundle: self.bundle, comment: "Cancel").uppercased()
                                alertController.positiveButtonText = NSLocalizedString("proceed", bundle: self.bundle, comment: "Continue").uppercased()
                                alertController.alertViewDelegate = self
                                
                                self.navigationController?.visibleViewController?.present(alertController, animated: false, completion: nil)
                            } else {
                                self.openDeepLink()
                            }
                        }
                    }).add(children: [
                        ComponentNode(ViewComponent(), in: self, props: {(component, _) in
                            component.styles = self.actionButtonStyles
                        }).add(children: [
                            ComponentNode(TextComponent(), in: self, props: {(component, _) in
                                component.styles = self.actionButtonTextStyles
                                component.text = NSLocalizedString("book", bundle: self.bundle, comment: "Book")
                            })
                        ])
                    ]),
                    ComponentNode(SeparatorPart.init(), in: self, props: {(component, _) in
                        component.styles = self.topSeparatorStyles
                    })
                ])
            }
            mainNode.add(children: [
                ComponentNode(JourneyRidesharing2ColumnsLayout.init(), in: self, props: {(component, _) in
                    component.leftChildren = [
                        ComponentNode(TextComponent(), in: self, props: {(component, _) in
                            component.styles = self.networkStyles
                            component.text = self.network
                        })
                    ]
                    
                    let localizedDepartureResource = NSLocalizedString("departure_with_colon", bundle: self.bundle, comment: "Departure:")
                    let ridesharingDepartureText = NSMutableAttributedString.init(string: "\(localizedDepartureResource) \(self.departureDate)")
                    ridesharingDepartureText.setAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightBold)], range: NSMakeRange(localizedDepartureResource.characters.count + 1, self.departureDate.characters.count))
                    component.rightChildren = [
                        ComponentNode(LabelComponent(), in: self, props: {(component, _) in
                            component.styles = self.departureDateStyles
                            component.attributedText = ridesharingDepartureText
                        })
                    ]
                }),
                ComponentNode(JourneyRidesharing2ColumnsLayout.init(), in: self, props: {(component, _) in
                    component.styles = self.driverInfoStyles
                    component.showSeparator = true
                    
                    component.leftChildren = [
                        ComponentNode(ViewComponent(), in: self, props: {(component, _) in
                            component.styles = self.driverInfoLeftPartStyles
                        }).add(children: [
                            ComponentNode(ImageComponent(), in: self, props: {(component, _) in
                                component.styles = self.driverImageStyles
                                component.image = UIImage(named: "driver_image_placeholder", in: self.bundle, compatibleWith: nil)
                                if self.driverImageURL != "" {
                                    component.imageURL = self.driverImageURL
                                }
                            }),
                            ComponentNode(ViewComponent(), in: self, props: {(component, _) in
                                component.styles = self.driverPersonalInfoStyles
                            }).add(children: [
                                ComponentNode(TextComponent(), in: self, props: {(component, _) in
                                    component.styles = self.driverNicknameStyles
                                    component.text = self.driverNickname
                                }),
                                ComponentNode(TextComponent(), in: self, props: {(component, _) in
                                    component.styles = self.driverGenderStyles
                                    component.text = self.driverGender
                                })
                            ])
                        ])
                    ]
                    
                    component.rightChildren = [
                        ComponentNode(ViewComponent(), in: self, props: {(component, _) in
                            component.styles = self.driverInfoRightPartStyles
                        }).add(children: [
                            Node<FloatRatingView>(){ view, layout, _ in
                                layout.width = 88
                                layout.height = 16
                                
                                view.backgroundColor = UIColor.clear
                                view.contentMode = UIViewContentMode.scaleAspectFit
                                view.emptyImage = UIImage(named: "star_empty", in: self.bundle, compatibleWith: nil)
                                view.fullImage = UIImage(named: "star_full", in: self.bundle, compatibleWith: nil)
                                view.type = .floatRatings
                                view.editable = false
                                view.rating = Double(self.driverRating)
                                view.starsInterspace = 2
                            },
                            ComponentNode(TextComponent(), in: self, props: {(component, _) in
                                component.styles = self.driverRateCountStyles
                                component.text = self.driverRateCount == 1 ? String(format: NSLocalizedString("rating", bundle: self.bundle, comment: "x rating"), self.driverRateCount) : String(format: NSLocalizedString("rating_plural", bundle: self.bundle, comment: "x rating"), self.driverRateCount)
                            })
                        ])
                    ]
                }),
                ComponentNode(SeparatorPart.init(), in: self),
                ComponentNode(ViewComponent(), in: self, props: {(component, _) in
                    component.styles = self.ridsharingInfoSectionStyles
                }).add(children: [
                    ComponentNode(ViewComponent(), in: self, props: {(component, _) in
                        component.styles = self.ridesharingInfoStyles
                    }).add(children: [
                        ComponentNode(TextComponent(), in: self, props: {(component, _) in
                            component.styles = self.seatsAvailableStyles
                            component.text = self.seatsAvailable
                        }),
                        ComponentNode(TextComponent(), in: self, props: {(component, _) in
                            component.styles = self.priceTextStyles
                            component.text = self.tripFareText!
                        })
                    ]),
                    ComponentNode(ViewComponent(), in: self, props: {(component, _) in
                        component.styles = self.ridesharingActionStyles
                    }).add(children: getButtonComponentNode())
                ])
            ])
            
            return mainNode
        }
        
        func initRidesharingJourneyInfo() {
            for (_, section) in (self.ridesharingJourney!.sections?.enumerated())! {
                if section.type == "ridesharing" && section.ridesharingInformations != nil {
                    self.network = section.ridesharingInformations!.network != nil ? section.ridesharingInformations!.network! : self.network
                    self.departureDate = section.departureDateTime != nil ? timeText(isoString: section.departureDateTime!, useCharacterFormat: true) : self.departureDate
                    
                    if section.ridesharingInformations!.driver != nil {
                        let driverInformation = section.ridesharingInformations!.driver!
                        self.driverNickname = driverInformation.alias != nil ? driverInformation.alias! : self.driverNickname
                        self.driverImageURL = driverInformation.image != nil ? driverInformation.image! : self.driverImageURL
                        self.driverGender = driverInformation.gender != nil ? String(format: "(%@)", arguments:[NSLocalizedString(driverInformation.gender!, bundle: self.bundle, comment: "Gender")]) : self.driverGender
                        self.driverRating = driverInformation.rating != nil ? self.getDriverRatingValue(individualRating: driverInformation.rating!, numberOfStars: 5) : self.driverRating
                        self.driverRateCount = driverInformation.rating != nil ? driverInformation.rating!.count! : self.driverRateCount
                    }
                    
                    self.seatsAvailable = (section.ridesharingInformations!.seats != nil && section.ridesharingInformations!.seats!.available != nil) ? String(format: NSLocalizedString("available_seats", bundle: self.bundle, comment: "Available seats: x"), section.ridesharingInformations!.seats!.available!) : NSLocalizedString("no_available_seats", bundle: self.bundle, comment: "Available seats: N/A")
                    self.tripFareText = (self.ridesharingJourney!.fare != nil && self.ridesharingJourney!.fare!.found != nil && self.ridesharingJourney!.fare!.found!) ? self.getRidesharingTripFareText(tripCost: self.ridesharingJourney!.fare!.total!) : NSLocalizedString("price_not_available", bundle: self.bundle, comment: "Price not available")
                }
            }
        }
        
        func getButtonComponentNode() -> [NodeType] {
            var buttonComponentNode = [NodeType]()
            
            if !self.isRoadmapComponent {
                buttonComponentNode.append(ComponentNode(ActionComponent(), in: self, props: {(component, _) in
                    component.onTap = { _ in
                        let journeyRidesharingRoadmapViewController: JourneyRidesharingRoadmapViewController = JourneyRidesharingRoadmapViewController()
                        journeyRidesharingRoadmapViewController.journey = self.journey
                        journeyRidesharingRoadmapViewController.ridesharingJourney = self.ridesharingJourney
                        journeyRidesharingRoadmapViewController.disruptions = self.disruptions
                        self.navigationController?.pushViewController(journeyRidesharingRoadmapViewController, animated: true)
                    }
                }).add(children: [
                    ComponentNode(ViewComponent(), in: self, props: {(component, _) in
                        component.styles = self.actionButtonStyles
                    }).add(children: [
                        ComponentNode(TextComponent(), in: self, props: {(component, _) in
                            component.styles = self.actionButtonTextStyles
                            component.text = NSLocalizedString("view_on_the_map", bundle: self.bundle, comment: "View on the map")
                        })
                    ])
                ]))
            }
            
            return buttonComponentNode
        }
        
        func getDriverRatingValue(individualRating: IndividualRating, numberOfStars: Float) -> Float {
            return (individualRating.value! / individualRating.scaleMax!) * numberOfStars
        }
        
        func getRidesharingTripFareText(tripCost: Cost) -> String {
            if Float(tripCost.value!)! == 0 {
                return NSLocalizedString("free", bundle: self.bundle, comment: "Free")
            }
            
            if tripCost.currency == "centime" {
                return String(format: "%.2f €", Float(tripCost.value!)!/100)
            } else {
                return String(format: "%.2f €", Float(tripCost.value!)!)
            }
        }
        
        func getRidesharingDeepLink() -> URL? {
            for (_, section) in self.ridesharingJourney!.sections!.enumerated() {
                if section.type == "ridesharing" && section.links != nil && section.links!.count > 0 {
                    for (_, linkSchema) in (section.links?.enumerated())! {
                        if linkSchema.type == "ridesharing_ad" && linkSchema.href != nil {
                            return URL(string: linkSchema.href!)
                        }
                    }
                }
            }
            return nil
        }
        
        func onNegativeButtonClicked(_ alertViewController: AlertViewController) {
            alertViewController.dismiss(animated: false, completion: nil)
        }
        
        func onPositiveButtonClicked(_ alertViewController: AlertViewController) {
            self.openDeepLink()
            alertViewController.dismiss(animated: false, completion: nil)
        }
        
        func openDeepLink() {
            if let ridesharingDeepLink = getRidesharingDeepLink() {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(ridesharingDeepLink, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(ridesharingDeepLink)
                }
            }
        }
        
        let ridesharingCardStyles:[String: Any] = [
            "backgroundColor": config.colors.white,
            "padding": 10,
            "borderRadius": config.metrics.radius,
            "marginBottom": config.metrics.margin,
            "shadowRadius": 2.0,
            "shadowOpacity": 0.12,
            "shadowOffset": [0, 0],
            "shadowColor": UIColor.black,
        ]
        let networkStyles: [String: Any] = [
            "fontWeight": "bold",
            "color": config.colors.darkGray,
            "fontSize": 14,
        ]
        let departureDateStyles: [String: Any] = [
            "color": config.colors.tertiary,
            "fontWeight": "bold",
            "fontSize": 9,
        ]
        let driverInfoStyles: [String: Any] = [
            "marginVertical": 10,
        ]
        let driverInfoLeftPartStyles: [String: Any] = [
            "flexDirection": YGFlexDirection.row,
        ]
        let driverImageStyles: [String: Any] = [
            "width": 60,
            "aspectRatio": 1,
        ]
        let driverPersonalInfoStyles: [String: Any] = [
            "paddingTop": 10,
            "paddingLeft": 10,
            "flexShrink": 1,
        ]
        let driverNicknameStyles: [String: Any] = [
            "color": config.colors.darkGray,
            "fontWeight": "semi-bold",
            "fontSize": 13,
            "numberOfLines": 2,
        ]
        let driverGenderStyles: [String: Any] = [
            "marginTop": 2,
            "color": config.colors.gray,
            "fontSize": 12,
        ]
        let driverInfoRightPartStyles: [String: Any] = [
            "flexGrow": 1,
            "width": 105,
            "justifyContent": YGJustify.center,
            "alignItems": YGAlign.center,
        ]
        let driverRateCountStyles: [String: Any] = [
            "marginTop": 5,
            "color": config.colors.gray,
            "fontSize": 10,
        ]
        let ridsharingInfoSectionStyles: [String: Any] = [
            "marginTop" : 10,
            "flexDirection": YGFlexDirection.row,
        ]
        let ridesharingInfoStyles: [String: Any] = [
            "justifyContent": YGJustify.center,
        ]
        let seatsAvailableStyles: [String: Any] = [
            "color": config.colors.darkGray,
            "fontWeight": "semi-bold",
            "fontSize": 13,
        ]
        let priceTextStyles: [String: Any] = [
            "marginTop": 3,
            "color": config.colors.orange,
            "fontWeight": "semi-bold",
            "fontSize": 10,
        ]
        let ridesharingActionStyles: [String: Any] = [
            "flexDirection": YGFlexDirection.row,
            "flexGrow": 1,
            "justifyContent": YGJustify.flexEnd,
        ]
        let actionButtonStyles: [String: Any] = [
            "padding": 10,
            "backgroundColor": config.colors.orange,
            "alignItems": YGAlign.center,
            "justifyContent": YGJustify.center,
            "borderRadius": 3,
        ]
        let actionButtonTextStyles: [String: Any] = [
            "color": UIColor.white,
            "fontWeight": "bold",
            "fontSize": 13,
        ]
        let topSeparatorStyles: [String: Any] = [
            "marginVertical": 10
        ]
    }
}
