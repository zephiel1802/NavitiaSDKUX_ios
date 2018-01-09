import Render
import NavitiaSDK

extension Components.LineCodeWithDisruptionStatusComponentParts {
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
                    "fontSize": config.metrics.textS,
                    "fontWeight": "bold",
                ]
                computedStyles = mergeDictionaries(dict1: codeStyles, dict2: computedStyles)

                lineTextComponents.append(ComponentNode(TextComponent(), in: self, props: { (component: TextComponent, _) in
                    component.text = self.section!.displayInformations!.code!
                    component.styles = textStyles
                }))
            }

            return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, _) in
                component.styles = computedStyles
            }).add(children: lineTextComponents)
        }
    }
}
