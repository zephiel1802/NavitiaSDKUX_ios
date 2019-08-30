//
//  PricedTicket.swift
//  NavitiaSDKUI
//
//  Created by Adeline Hirsch on 29/08/2019.
//

import Foundation
import UIKit

public struct PricedTicket: Codable {
    let productId: String
    let name: String
    let price: Double?
    let priceWithTax: Double?
    let taxRate: Double?
    let currency: String
    
    enum CodingKeys : String, CodingKey {
        case productId = "id_product"
        case name = "name"
        case price = "price"
        case priceWithTax = "price_with_tax"
        case taxRate = "taxe_rate"
        case currency = "currency"
    }
}
