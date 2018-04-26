//
//  BookShopViewModel.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 23/04/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class BookShopViewModel: NSObject {
    
    var bookShopDidChange: ((BookShopViewModel) -> ())?
    var ticket: [(name: String, count: Int)] = [(name: "Ticket 1", count: 0),
                                                (name: "Ticket 10", count: 0),
                                                (name: "Ticket Semaine", count: 0),
                                                (name: "Ticket Mois", count: 0),
                                                (name: "Ticket Groupe", count: 0),
                                                (name: "Ticket Pas Groupe", count: 0)] {
        didSet {
            bookShopDidChange!(self)
        }
    }
    
    var abonnement: [(name: String, count: Int)] = [(name: "Abonnement Etudiant", count: 0),
                                                    (name: "Abonnement annuel", count: 0),
                                                    (name: "Abonnement vieux", count: 0)] {
        didSet {
            bookShopDidChange!(self)
        }
    }
    
    func didDisplayValidateTicket() -> Bool {
        if let _ = ticket.index(where: { $1 > 0 }) {
            return true
        }
        if let _ = abonnement.index(where: { $1 > 0 }) {
            return true
        }
        return false
    }
    
    
    
}
