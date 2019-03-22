import Foundation

open class NavitiaSDK: NSObject {
    public let journeysApi: JourneysApi
    public let poisApi: PoisApi
    public let placesApi: PlacesApi
    public let physicalModesApi: PhysicalModesApi
    public let coordApi: CoordApi
    public let coverageApi: CoverageApi

    public init(configuration:NavitiaConfiguration) {
        self.journeysApi = JourneysApi(token: configuration.token)
        self.poisApi = PoisApi(token: configuration.token)
        self.placesApi = PlacesApi(token: configuration.token)
        self.physicalModesApi = PhysicalModesApi(token: configuration.token)
        self.coordApi = CoordApi(token: configuration.token)
        self.coverageApi = CoverageApi(token: configuration.token)
    }
}
