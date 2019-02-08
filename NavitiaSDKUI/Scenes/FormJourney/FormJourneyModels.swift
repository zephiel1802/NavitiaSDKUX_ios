//
//  FormJourneyModels.swift
//  NavitiaSDKUI
//
//  Copyright © 2019 kisio. All rights reserved.
//

import UIKit

enum FormJourney
{
    // MARK: Use cases
    
    enum DisplaySearch {
        struct Request {
            var from: (name: String, id: String)?
            var to: (name: String, id: String)?
        }
        struct Response {
            var fromName: String?
            var toName: String?
        }
        struct ViewModel {
            var fromName: String
            var toName: String
        }
    }
}
