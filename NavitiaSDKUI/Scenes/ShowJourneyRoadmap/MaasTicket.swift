//
//  MaasTicket.swift
//  MaasSDK
//
//  Created by Rachik Abidi on 31/07/2019.
//

import Foundation

internal struct MaasTicket: Decodable {
    
    let productId: Int
    
    enum CodingKeys: String, CodingKey {
        
        case productId = "id_product"
    }
}
