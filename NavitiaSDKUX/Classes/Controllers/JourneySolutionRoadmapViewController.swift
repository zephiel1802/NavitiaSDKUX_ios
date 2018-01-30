import Render
import NavitiaSDK

open class JourneySolutionRoadmapController: ViewController, ComponentController {
    var journey: Journey?
    var disruptions: [Disruption]?

    public var component: JourneySolutionRoadmapScreen = JourneySolutionRoadmapScreen()

    override open func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("roadmap", bundle: bundle, comment: "Navigation bar title for journey solutions screen")
        addComponentToViewControllerHierarchy()
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override open func viewDidLayoutSubviews() {
        renderComponent(options: [.preventViewHierarchyDiff])
    }

    public func configureComponentProps() {
        component.state.journey = self.journey
        component.state.disruptions = self.disruptions
        component.navigationController = navigationController
    }
}
    
