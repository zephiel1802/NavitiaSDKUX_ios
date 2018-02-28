import Foundation

extension Components.Journey.Roadmap.Steps.Parts {
    class TimePart: ViewComponent {
        var labelStyles: [String: Any] = [:]
        var dateTime: String?

        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self, props: { (component, _) in
                component.styles = self.containerStyles
            }).add(children: [
                ComponentNode(ViewComponent(), in: self, props: { (component, _) in
                    component.styles = self.paddingCenteringStyles
                }),
                ComponentNode(LabelComponent(), in: self, props: { (component, _) in
                    component.styles = mergeDictionaries(dict1: self.labelBaseStyles, dict2: self.labelStyles)
                    component.text = timeText(isoString: self.dateTime!)
                }),
                ComponentNode(ViewComponent(), in: self, props: { (component, _) in
                    component.styles = self.paddingCenteringStyles
                })
            ])
        }

        let containerStyles: [String: Any] = [
            "flexGrow": 1,
            "alignItems": YGAlign.center,
            "justifyContent": YGJustify.center,
        ]
        let paddingCenteringStyles: [String: Any] = [
            "flexGrow": 1,
        ]
        let labelBaseStyles: [String: Any] = [
            "color": config.colors.darkText,
            "fontSize": config.metrics.textS,
        ]
    }
}
