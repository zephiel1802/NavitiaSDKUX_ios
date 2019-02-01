import Foundation

open class NavitiaSDK: NSObject {
    public let journeysApi: JourneysApi
    public let poisApi: PoisApi
    public let placesApi: PlacesApi

    public init(configuration:NavitiaConfiguration) {
        self.journeysApi = JourneysApi(token: configuration.token)
        self.poisApi = PoisApi(token: configuration.token)
        self.placesApi = PlacesApi(token: configuration.token)
    }
}
