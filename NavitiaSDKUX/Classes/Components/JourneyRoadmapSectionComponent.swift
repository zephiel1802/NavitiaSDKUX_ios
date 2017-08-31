import Foundation
import Render
import NavitiaSDK

class JourneyRoadmapSectionComponent: ViewComponent {
    var section: Section?

    override func render() -> NodeType {
        let sectionContainer: NodeType = ComponentNode(ViewComponent(), in: self)

        sectionContainer.add(children: [ComponentNode(LabelComponent(), in: self, props: {(component: LabelComponent, hasKey: Bool) in
            if (self.section!.from != nil) {
                component.text = self.section!.from!.name!
            }
        })])
        sectionContainer.add(children: [ComponentNode(LabelComponent(), in: self, props: {(component: LabelComponent, hasKey: Bool) in
            if (self.section!.to != nil) {
                component.text = self.section!.to!.name!
            }
        })])

        return sectionContainer
    }
}
