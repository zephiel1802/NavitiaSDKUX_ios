import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Steps.PublicTransportStepComponentParts {
    class DisruptionDescriptionPart: ViewComponent {
        var section: Section?
        var disruptions: [Disruption]?

        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self, props: { (component, _) in
                component.styles = self.styles
            }).add(children: disruptions!.map { disruption -> NodeType in
                var disruptionBlocks: [NodeType] = []
                disruptionBlocks.append(
                    ComponentNode(ViewComponent(), in: self, props: { (component, _) in
                        component.styles = self.disruptionTitleStyles
                    }).add(children: [
                        ComponentNode(IconComponent(), in: self, props: { (component, _) in
                            component.name = Disruption.getIconName(of: disruption.level)
                            self.iconStyles["color"] = getUIColorFromHexadecimal(hex: Disruption.getLevelColor(of: disruption.level))
                            component.styles = self.iconStyles
                        }),
                        ComponentNode(ViewComponent(), in: self, props: { (component, _) in
                            component.styles = self.containerCauseStyles
                        }).add(children: [
                            ComponentNode(LabelComponent(), in: self, props: { (component, _) in
                                component.styles = self.causeStyles
                                component.styles["color"] = getUIColorFromHexadecimal(hex: Disruption.getLevelColor(of: disruption.level))
                                component.text = disruption.cause!
                            })
                        ])
                    ])
                )

                if (disruption.messages != nil && disruption.messages!.first != nil && disruption.messages!.first!.escapedText != nil) {
                    disruptionBlocks.append(
                        ComponentNode(ViewComponent(), in: self, props: { (component, _) in
                            component.styles = self.disruptionTextContainerStyles
                        }).add(children: [
                            ComponentNode(LabelComponent(), in: self, props: { (component, _) in
                                component.styles = self.disruptionTextStyles
                                component.text = disruption.messages!.first!.escapedText!
                            })
                        ])
                    )
                }

                let periodDateFormatter: DateFormatter = DateFormatter()
                periodDateFormatter.dateStyle = .short
                let fromText: String = NSLocalizedString(
                    "from",
                    bundle: self.bundle,
                    comment: "Disruption period from"
                )
                let toText: String = NSLocalizedString(
                    "to_period",
                    bundle: self.bundle,
                    comment: "Disruption period to"
                )
                let undefinedToText: String = NSLocalizedString(
                    "until_further_notice",
                    bundle: self.bundle,
                    comment: "Disruption period to fallback"
                )

                disruption.applicationPeriods?.filter { period in
                    return period != nil
                }.map { period in
                    disruptionBlocks.append(
                        ComponentNode(ViewComponent(), in: self, props: { (component, _) in
                            component.styles = self.disruptionPeriodContainerStyles
                        }).add(children: [
                            ComponentNode(LabelComponent(), in: self, props: { (component, _) in
                                component.styles = self.disruptionPeriodStyles
                                if (period.endDate != nil) {
                                    component.text = "\(fromText) \(periodDateFormatter.string(from: period.beginDate!)) \(toText) \(periodDateFormatter.string(from: period.endDate!))"
                                } else {
                                    component.text = "\(fromText) \(periodDateFormatter.string(from: period.beginDate!)) \(undefinedToText)"
                                }
                            })
                        ])
                    )
                }

                return ComponentNode(ViewComponent(), in: self, props: { (component, _) in
                    component.styles = self.containerStyles
                }).add(children: disruptionBlocks)
            })
        }

        let containerStyles: [String: Any] = [
            "marginTop": config.metrics.margin,
        ]
        let disruptionTitleStyles: [String: Any] = [
            "alignItems": YGAlign.center,
            "flexDirection": YGFlexDirection.row,
        ]
        var iconStyles: [String: Any] = [
            "fontSize": 18,
        ]
        let containerCauseStyles: [String: Any] = [
            "marginLeft": 3,
            "alignItems": YGAlign.center,
        ]
        let causeStyles: [String: Any] = [
            "fontSize": config.metrics.textS,
            "fontWeight": "bold",
        ]
        let disruptionTextContainerStyles: [String: Any] = [
            "marginLeft": 18,
            "marginTop": config.metrics.margin,
            "marginBottom": config.metrics.margin,
        ]
        let disruptionTextStyles: [String: Any] = [
            "color": UIColor.lightGray,
            "fontSize": config.metrics.textS,
            "numberOfLines": 0,
            "lineBreakMode": NSLineBreakMode.byWordWrapping,
        ]
        let disruptionPeriodContainerStyles: [String: Any] = [
            "marginLeft": 18,
            "marginTop": config.metrics.margin,
        ]
        let disruptionPeriodStyles: [String: Any] = [
            "fontSize": config.metrics.textS,
            "fontWeight": "bold",
            "numberOfLines": 0,
            "lineBreakMode": NSLineBreakMode.byWordWrapping,
        ]
    }
}
