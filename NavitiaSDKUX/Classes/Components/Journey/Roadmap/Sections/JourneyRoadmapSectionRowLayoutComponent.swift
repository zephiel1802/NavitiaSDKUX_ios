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

            var firstComponentChildren: [NodeType] = []
            if (self.firstComponent != nil) {
                firstComponentChildren.append(self.firstComponent!)
            }
            container.add(children: [
                ComponentNode(ViewComponent(), in: self, props: { (component, hasKey: Bool) in
                    component.styles = self.firstComponentStyles
                }).add(children: firstComponentChildren)
            ])
            
            var secondComponentChildren: [NodeType] = []
            if (self.secondComponent != nil) {
                secondComponentChildren.append(self.secondComponent!)
            }
            container.add(children: [
                ComponentNode(ViewComponent(), in: self, props: { (component, hasKey: Bool) in
                    component.styles = self.secondComponentStyles
                }).add(children: secondComponentChildren)
            ])

            var thirdComponentChildren: [NodeType] = []
            if (self.thirdComponent != nil) {
                thirdComponentChildren.append(self.thirdComponent!)
            }
            container.add(children: [
                ComponentNode(ViewComponent(), in: self, props: { (component, hasKey: Bool) in
                    component.styles = self.thirdComponentStyles
                }).add(children: thirdComponentChildren)
            ])
            
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
