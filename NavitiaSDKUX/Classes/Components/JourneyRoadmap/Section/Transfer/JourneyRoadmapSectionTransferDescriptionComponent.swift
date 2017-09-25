import Foundation
import Render
import NavitiaSDK

class JourneyRoadmapSectionTransferDescriptionComponent: ViewComponent {
    var section: Section?

    override func render() -> NodeType {
        return ComponentNode(ViewComponent(), in: self).add(children: [
            ComponentNode(DescriptionComponent(), in: self, props: { (component: DescriptionComponent, hasKey: Bool) in
                component.section = self.section
            })
        ])
    }

    private class DescriptionComponent: ViewComponent {
        var section: Section?

        override func render() -> NodeType {
            return ComponentNode(JourneyRoadmapSectionLayoutComponent(), in: self, props: { (component: JourneyRoadmapSectionLayoutComponent, hasKey: Bool) in
                component.styles = self.styles

                component.firstComponent = ComponentNode(DescriptionModeIconComponent(), in: self, props: { (component: DescriptionModeIconComponent, hasKey: Bool) in
                    component.section = self.section
                })

                component.secondComponent = ComponentNode(LineDiagramComponent(), in: self, props: { (component: LineDiagramComponent, hasKey: Bool) in
                    component.color = "808080"
                })

                component.thirdComponent = ComponentNode(DescriptionContentComponent(), in: self, props: { (component: DescriptionContentComponent, hasKey: Bool) in
                    component.section = self.section
                })
            })
        }
    }

    private class DescriptionContentComponent: ViewComponent {
        var section: Section?

        override func render() -> NodeType {
            return ComponentNode(ContentContainerComponent(), in: self).add(children: [
                ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                    component.styles = [
                        "flexDirection": YGFlexDirection.row,
                    ]
                }).add(children: [
                    ComponentNode(LabelComponent(), in: self, props: { (component: LabelComponent, hasKey: Bool) in
                        component.styles = [
                            "fontSize": 15,
                            "marginRight": 5,
                        ]

                        let durationInMinutes:Int = Int.init(self.section!.duration!/60)
                        let unit =  NSLocalizedString("units.minute\((durationInMinutes > 1) ? ".plural" : "")",
                                bundle: self.bundle,
                                comment: "Unit for walking duration"
                        )
                        let action = NSLocalizedString("journey.roadmap.action.walk",
                                bundle: self.bundle,
                                comment: "Action description"
                        )
                        component.text = "\(durationInMinutes) \(unit) \(action)"
                    }),
                ]),
            ])
        }
    }

    // COMMON
    private class LineDiagramComponent: ViewComponent {
        var color: String?

        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = [
                    "backgroundColor": UIColor.white,
                    "flexGrow": 1,
                    "alignItems": YGAlign.center,
                ]
            }).add(children: [
                ComponentNode(DottedLineDiagramComponent(), in: self, props: { (component: DottedLineDiagramComponent, hasKey: Bool) in
                    component.styles = [
                        "flexGrow": 1,
                    ]

                    component.color = getUIColorFromHexadecimal(hex: "808080")
                    component.lineWidth = 6
                    component.pattern = [0, 12]
                    component.dashPhase = 6
                })
            ])
        }
    }

    private class ContentContainerComponent: ViewComponent {
        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = [
                    "backgroundColor": UIColor.white,
                    "paddingHorizontal": 5,
                    "paddingTop": 14,
                    "paddingBottom": 18,
                ]
            })
        }
    }
}
