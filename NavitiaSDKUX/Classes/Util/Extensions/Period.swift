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
    
    public func contains(_ date: Date) -> Bool {
        if (self.beginDate != nil && self.endDate != nil && self.beginDate! <= date && date <= self.endDate!) {
            return true
        }
        
        return false
    }
    
    public func contains(_ dateString: String) -> Bool {
        let date: Date? = Date.navitiaDateFormatter.date(from: dateString)
        
        return date != nil ? self.contains(date!) : false
    }
}
