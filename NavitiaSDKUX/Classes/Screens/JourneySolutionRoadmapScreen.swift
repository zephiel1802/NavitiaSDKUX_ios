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
        return ComponentNode(ScreenComponent(), in: self).add(children: [
            ComponentNode(ScreenHeaderComponent(), in: self, props: { (component: ScreenHeaderComponent, hasKey: Bool) in
                component.navigationController = self.navigationController
                component.styles = [
                    "backgroundColor": config.colors.tertiary,
                    "paddingTop": 40
                ]
            }),
            ComponentNode(ContainerComponent(), in: self, props: { (component: ContainerComponent, hasKey: Bool) in
                component.styles = [
                    "marginTop": -40
                ]
            }).add(children: [
                ComponentNode(JourneySolutionComponent(), in: self, props: { (component: JourneySolutionComponent, hasKey: Bool) in
                    component.journey = self.state.journey!
                })
                ]),
            ComponentNode(ScrollViewComponent(), in: self).add(children: [
                ComponentNode(ListViewComponent(), in: self).add(children:
                    self.state.journey!.sections!.map({ (section: Section) -> NodeType in
                        return ComponentNode(JourneyRoadmapSectionComponent(), in: self, props: { (component: JourneyRoadmapSectionComponent, hasKey: Bool) in
                            component.section = section
                        })
                    })
                )
            ])
        ])
    }
}
