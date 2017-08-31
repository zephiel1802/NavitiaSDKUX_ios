import Foundation
import Render
import NavitiaSDK

public struct JourneySolutionRoadBookState: StateType {
    public init() { }
    var journey: Journey?
}

open class JourneySolutionRoadBookScreen: ComponentView<JourneySolutionRoadBookState> {
    override open func render() -> NodeType {
        let screenContainer = ComponentNode(ScreenComponent(), in: self)

        let headerContainer = ComponentNode(ScreenHeaderComponent(), in: self)
        screenContainer.add(children: [headerContainer])

        headerContainer.add(children: [ComponentNode(JourneySolutionComponent(), in: self, props: {(component: JourneySolutionComponent, hasKey: Bool) in
            component.journey = self.state.journey!
        })])

        let scrollViewComponentContainer = ComponentNode(ScrollViewComponent(), in: self)
        screenContainer.add(children: [scrollViewComponentContainer])

        for section:Section in self.state.journey!.sections! {
            scrollViewComponentContainer.add(children: [ComponentNode(LabelComponent(), in: self, props: {(component: LabelComponent, hasKey: Bool) in
                component.text = section.from!.name!
            })])
            scrollViewComponentContainer.add(children: [ComponentNode(LabelComponent(), in: self, props: {(component: LabelComponent, hasKey: Bool) in
                component.text = section.to!.name!
            })])
        }

        return screenContainer
    }
}
