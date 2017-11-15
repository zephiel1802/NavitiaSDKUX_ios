import Render
import NavitiaSDK

class LineCodeWithDisruptionStatus: ViewComponent {
    var section: Section?
    var disruptions: [Disruption]?

    override func render() -> NodeType {
        return ComponentNode(ViewComponent(), in: self)
            .add(children: [
                ComponentNode(LineCodeComponent(), in: self, props: { (component: LineCodeComponent, _: Bool) in
                    component.section = self.section
                }),
                ComponentNode(DisruptionBadge(), in: self, props: { (component: DisruptionBadge, _: Bool) in
                    component.disruptions = self.disruptions
                })
            ])
    }
}

class DisruptionBadge: ViewComponent {
    var disruptions: [Disruption]?

    override func render() -> NodeType {
        return ComponentNode(IconComponent(), in: self, props: { (component: IconComponent, _) in
            component.name = "circle-filled"
            component.styles = self.disruptionBadgeStyle
        })
    }

    let disruptionBadgeStyle: [String: Any] = [
        "position": YGPositionType.absolute,
        "end": -11,
        "top": -9,
        "color": UIColor.red,
        "fontSize": 18,
    ]
}

class LineCodeComponent: ViewComponent {
    var section: Section?

    override func render() -> NodeType {
        var lineTextComponents: [NodeType] = []
        var computedStyles = self.styles

        if (self.section!.displayInformations != nil && self.section!.displayInformations!.code != nil) {
            let codeStyles: [String: Any] = [
                "backgroundColor": getUIColorFromHexadecimal(hex: getHexadecimalColorWithFallback(self.section!.displayInformations?.color)),
                "borderRadius": 3,
                "padding": 6,
            ]
            let textStyles: [String: Any] = [
                "color": getUIColorFromHexadecimal(hex: getHexadecimalColorWithFallback(self.section!.displayInformations?.textColor)),
                "fontSize": 12,
                "fontWeight": "bold",
            ]
            computedStyles = mergeDictionaries(dict1: codeStyles, dict2: computedStyles)

            lineTextComponents.append(ComponentNode(TextComponent(), in: self, props: { (component, hasKey: Bool) in
                component.text = self.section!.displayInformations!.code!
                component.styles = textStyles
            }))
        }

        return ComponentNode(ViewComponent(), in: self, props: { (component, hasKey: Bool) in
            component.styles = computedStyles
        }).add(children: lineTextComponents)
    }
}
