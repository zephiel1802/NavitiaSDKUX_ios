import Foundation

extension Date {
    public static let navitiaDateFormatter: DateFormatter = { () in
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss"
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Paris")
        return dateFormatter
    }()
}
