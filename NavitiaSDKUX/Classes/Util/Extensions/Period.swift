import Foundation

import NavitiaSDK

extension Period {
    public var beginDate: Date? {
        if (self.begin != nil) {
            return Date.navitiaDateFormatter.date(from: self.begin!)
        } else {
            return nil
        }
    }
    
    public var endDate: Date? {
        if (self.end != nil) {
            return Date.navitiaDateFormatter.date(from: self.end!)
        } else {
            return nil
        }
    }
}
