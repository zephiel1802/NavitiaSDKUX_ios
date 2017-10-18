import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Sections {
    class SectionLayoutComponent: ViewComponent {
        var header: NodeType?
        var body: NodeType?
        var footer: NodeType?

        override func render() -> NodeType {
            let container = ComponentNode(ViewComponent(), in: self)

            if (self.header != nil) {
                container.add(children: [
                    ComponentNode(ViewComponent(), in: self).add(children: [self.header!])
                ])
            }
            if (self.body != nil) {
                container.add(children: [
                    ComponentNode(ViewComponent(), in: self).add(children: [self.body!])
                ])
            }
            if (self.footer != nil) {
                container.add(children: [
                    ComponentNode(ViewComponent(), in: self).add(children: [self.footer!])
                ])
            }

            return container
        }
    }
}
