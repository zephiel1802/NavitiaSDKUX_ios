import Foundation
import Render
import NavitiaSDK

public struct JourneySolutionRoadmapState: StateType {
    public init() {
    }

    var journey: Journey?
}

open class JourneySolutionRoadmapScreen: ComponentView<JourneySolutionRoadmapState> {
    var navigationController: UINavigationController?

    override open func render() -> NodeType {
        return ComponentNode(ScreenComponent(), in: self)
            .add(children: [ComponentNode(ScreenHeaderComponent(), in: self, props: { (component, hasKey: Bool) in
                component.styles = self.headerStyles
            })])
            .add(children: [ComponentNode(JourneySolutionComponent(), in: self, props: { (component: JourneySolutionComponent, hasKey: Bool) in
                component.journey = self.state.journey!
            })])
            .add(children: [ComponentNode(ScrollViewComponent(), in: self)
                .add(children: [ComponentNode(ListViewComponent(), in: self)
                    .add(children: self.state.journey!.sections!.map({ (section: Section) -> NodeType in
                        return ComponentNode(JourneyRoadmapSectionComponent(), in: self, props: { (component: JourneyRoadmapSectionComponent, hasKey: Bool) in
                            component.section = section
                        })
                    }))
                ])
            ])
    }

    let headerStyles: [String: Any] = [
        "paddingTop": 50
    ]
}
