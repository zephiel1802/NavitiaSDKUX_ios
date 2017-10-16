import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Sections {
    class SectionRowLayoutComponent: ViewComponent {
        var firstComponent: NodeType?
        var secondComponent: NodeType?
        var thirdComponent: NodeType?

        override func render() -> NodeType {
            let computedStyles = mergeDictionaries(dict1: containerStyles, dict2: self.styles)

            let container = ComponentNode(ViewComponent(), in: self, props: { (component, hasKey: Bool) in
                component.styles = computedStyles
            })

            if (self.firstComponent != nil) {
                container.add(children: [
                    ComponentNode(ViewComponent(), in: self, props: { (component, hasKey: Bool) in
                        component.styles = self.firstComponentStyles
                    }).add(children: [self.firstComponent!])
                ])
            }
            if (self.secondComponent != nil) {
                container.add(children: [
                    ComponentNode(ViewComponent(), in: self, props: { (component, hasKey: Bool) in
                        component.styles = self.secondComponentStyles
                    }).add(children: [self.secondComponent!])
                ])
            }
            if (self.thirdComponent != nil) {
                container.add(children: [
                    ComponentNode(ViewComponent(), in: self, props: { (component, hasKey: Bool) in
                        component.styles = self.thirdComponentStyles
                    }).add(children: [self.thirdComponent!])
                ])
            }

            return container
        }

        let firstComponentStyles: [String: Any] = [
            "width": 50,
        ]
        let secondComponentStyles: [String: Any] = [
            "width": 20,
        ]
        let thirdComponentStyles: [String: Any] = [
            "flexGrow": 1,
            "flexShrink": 1,
        ]
        let containerStyles: [String: Any] = [
            "flexDirection": YGFlexDirection.row,
        ]
    }
}
