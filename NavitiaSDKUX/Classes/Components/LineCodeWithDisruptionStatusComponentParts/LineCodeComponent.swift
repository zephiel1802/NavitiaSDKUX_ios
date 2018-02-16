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
                    "color": self.getLineCodeTextColor(lineColorHex: getHexadecimalColorWithFallback(self.section!.displayInformations?.color), lineCodeColorHex: getHexadecimalColorWithFallback(self.section!.displayInformations?.textColor)),
                    "fontSize": config.metrics.textS,
                    "fontWeight": "bold",
                ]
                computedStyles = mergeDictionaries(dict1: codeStyles, dict2: computedStyles)

                lineTextComponents.append(ComponentNode(TextComponent(), in: self, props: { (component, _) in
                    component.text = self.section!.displayInformations!.code!
                    component.styles = textStyles
                }))
            }

            return ComponentNode(ViewComponent(), in: self, props: { (component, _) in
                component.styles = computedStyles
            }).add(children: lineTextComponents)
        }
        
        private func getLineCodeTextColor(lineColorHex: String, lineCodeColorHex: String) -> UIColor {
            var cString:String = lineCodeColorHex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            if (cString.hasPrefix("#")) {
                cString.remove(at: cString.startIndex)
            }
            
            if ((cString.characters.count) != 6) {
                return contrastColor(color: getUIColorFromHexadecimal(hex: lineColorHex), brightColor: UIColor.white, darkColor: UIColor.black)
            } else {
                return getUIColorFromHexadecimal(hex: lineCodeColorHex)
            }
        }
    }
}
