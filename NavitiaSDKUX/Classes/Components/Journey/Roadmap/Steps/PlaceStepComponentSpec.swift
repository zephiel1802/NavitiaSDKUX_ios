import Foundation

extension Components.Journey.Roadmap.Steps {
    class PlaceStepComponent: ViewComponent {
        let JourneyRoadmap3ColumnsLayout: Components.Journey.Roadmap.Steps.JourneyRoadmap3ColumnsLayout.Type = Components.Journey.Roadmap.Steps.JourneyRoadmap3ColumnsLayout.self
        let TimePart: Components.Journey.Roadmap.Steps.Parts.TimePart.Type = Components.Journey.Roadmap.Steps.Parts.TimePart.self
        
        var placeType: String?
        var placeLabel: String?
        var backgroundColorProp: UIColor?
        var datetime: String?
        
        override func render() -> NodeType {
            let colorStyles: [String: Any] = [
                "color": contrastColor(color: self.backgroundColorProp!),
            ]
            let textStepStyles = mergeDictionaries(dict1: self.textStyles, dict2: self.textStepBaseStyles)
            
            return ComponentNode(CardComponent(), in: self, props: {(component, _) in
                component.styles = mergeDictionaries(dict1: self.containerStyles, dict2: [
                    "backgroundColor": self.backgroundColorProp!
                ])
            }).add(children: [
                ComponentNode(JourneyRoadmap3ColumnsLayout.init(), in: self, props: {(component, _) in
                    component.leftChildren = [
                        ComponentNode(self.TimePart.init(), in: self, props: {(component, _) in
                            component.dateTime = self.datetime
                            component.labelStyles = colorStyles
                        })
                    ]
                    component.middleChildren = [
                        ComponentNode(ViewComponent(), in: self, props: {(component, _) in
                            component.styles = self.iconContainerStyles
                        }).add(children: [
                            ComponentNode(IconComponent(), in: self, props: {(component, _) in
                                component.styles = mergeDictionaries(dict1: self.iconStyles, dict2: colorStyles)
                                component.name = "location-pin"
                                component.autoresizingMask = UIViewAutoresizing.flexibleWidth
                            })
                        ])
                    ]
                    component.rightChildren = [
                        ComponentNode(ViewComponent(), in: self, props: {(component, _) in
                            component.styles = self.textContainerStyles
                        }).add(children: [
                            ComponentNode(TextComponent(), in: self, props: {(component, _) in
                                component.text = self.placeType!
                                component.styles = mergeDictionaries(dict1: textStepStyles, dict2: colorStyles)
                            }),
                            ComponentNode(TextComponent(), in: self, props: {(component, _) in
                                component.text = self.placeLabel!
                                component.styles = mergeDictionaries(dict1: self.textStyles, dict2: colorStyles)
                            }),
                        ])
                    ]
                })
            ])
        }
        
        let containerStyles: [String: Any] = [
            "paddingVertical": config.metrics.margin,
        ]
        let iconContainerStyles: [String: Any] = [
            "flexGrow": 1,
            "justifyContent": YGJustify.center,
        ]
        let iconStyles: [String: Any] = [
            "fontSize": 21,
        ]
        let textStyles: [String: Any] = [
            "fontSize": config.metrics.text,
        ]
        let textStepBaseStyles: [String: Any] = [
            "fontWeight": "bold",
        ]
        let textContainerStyles: [String: Any] = [
            "paddingHorizontal": 10,
        ]
    }
}
