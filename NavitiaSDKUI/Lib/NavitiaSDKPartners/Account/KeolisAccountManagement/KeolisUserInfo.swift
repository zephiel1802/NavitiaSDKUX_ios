//
//  KeolisUserInfo.swift
//
//  Created by Valentin COUSIEN on 12/03/2018.
//  Copyright © 2018 Valentin COUSIEN. All rights reserved.
//

import Foundation

@objc(KeolisUserInfo) public class KeolisUserInfo : NSObject, NSCoding, NavitiaUserInfo {
    
    public var firstName : String = "" // "prenom"
    public var lastName : String = "" // "nom"
    public var network : String = "" // "filiale"
    public var idTechPortal : String = "" // "idTechPortail"
    public var idTechPortalPerson : String = "" // "idTechPortailPersonne"
    public var accountStatus : KeolisAccountStatus = KeolisAccountStatus(rawValue: 0)! // "statutCompte"
    public var email : String = ""// "email"
    public var courtesy : NavitiaSDKPartnersCourtesy = .Unknown // "civilite"
    public var country : String = "" // "pays"
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(network, forKey: "network")
        aCoder.encode(idTechPortal, forKey: "idTechPortal")
        aCoder.encode(idTechPortalPerson, forKey: "idTechPortalPerson")
        aCoder.encode(String(accountStatus.rawValue), forKey: "accountStatus")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(courtesy.toKeolis(), forKey: "courtesy")
        aCoder.encode(country, forKey: "country")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.firstName = aDecoder.decodeObject(forKey: "firstName") as! String
        self.lastName = aDecoder.decodeObject(forKey: "lastName") as! String
        self.network = aDecoder.decodeObject(forKey: "network") as! String
        self.idTechPortal = aDecoder.decodeObject(forKey: "idTechPortal") as! String
        self.idTechPortalPerson = aDecoder.decodeObject(forKey: "idTechPortalPerson") as! String
        self.accountStatus = KeolisAccountStatus(rawValue: Int(aDecoder.decodeObject(forKey: "accountStatus") as! String)!)!
        self.email = aDecoder.decodeObject(forKey: "email") as! String
        self.courtesy = NavitiaSDKPartnersCourtesy.fromKeolis(str: aDecoder.decodeObject(forKey: "courtesy") as! String)
        self.country = aDecoder.decodeObject(forKey: "country") as! String
    }
    
    public override init() {
        
    }
    
    @objc public func toDictionnary() -> [String : Any] {
        return [ "firstName" : self.firstName,
                 "lastName" : self.lastName,
                 "network" : self.network,
                 "idTechPortal" : self.idTechPortal,
                 "idTechPortalPerson" : self.idTechPortalPerson,
                 "accountStatus" : self.accountStatus.getStatus(),
                 "email" : self.email,
                 "courtesy" : self.courtesy.toKeolis(),
                 "country" : self.country ]
    }
}
