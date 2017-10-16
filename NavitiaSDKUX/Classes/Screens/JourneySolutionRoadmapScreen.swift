import Foundation
import Render
import NavitiaSDK

public struct JourneySolutionRoadmapState: StateType {
    public init() {
    }

    var journey: Journey?
}

open class JourneySolutionRoadmapScreen: ComponentView<JourneySolutionRoadmapState> {
    let SectionComponent = Components.Journey.Roadmap.SectionComponent.self
    
    var navigationController: UINavigationController?

    override open func render() -> NodeType {
        return ComponentNode(ScreenComponent(), in: self).add(children: [
            ComponentNode(ScreenHeaderComponent(), in: self, props: { (component: ScreenHeaderComponent, hasKey: Bool) in
                component.navigationController = self.navigationController
                component.styles = self.screenHeaderStyle
            }),
            ComponentNode(ContainerComponent(), in: self, props: { (component: ContainerComponent, hasKey: Bool) in
                component.styles = self.journeySolutionCard
            }).add(children: [
                ComponentNode(JourneySolutionComponent(), in: self, props: { (component: JourneySolutionComponent, hasKey: Bool) in
                    component.journey = self.state.journey!
                })
            ]),
            ComponentNode(ScrollViewComponent(), in: self).add(children: [
                ComponentNode(ListViewComponent(), in: self).add(children:
                    self.state.journey!.sections!.map({ (section: Section) -> NodeType in
                        return ComponentNode(self.SectionComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.SectionComponent, hasKey: Bool) in
                            component.section = section
                        })
                    })
                )
            ])
        ])
    }

    let screenHeaderStyle: [String: Any] = [
        "backgroundColor": config.colors.tertiary,
        "paddingTop": 40
    ]
    let journeySolutionCard: [String: Any] = [
        "marginTop": -40
    ]
}
