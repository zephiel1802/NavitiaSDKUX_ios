//
//  VSCTBookOffer.swift
//  NavitiaSDKPartners
//
//  Created by Valentin COUSIEN on 19/04/2018.
//  Copyright © 2018 Kisio. All rights reserved.
//

import Foundation

@objc(VSCTBookOffer) public class VSCTBookOffer : NSObject, BookOffer {
    
    public private(set) var id : String = ""
    public private(set) var productId : String = ""
    public private(set) var title : String = ""
    public private(set) var shortDescription : String = ""
    public private(set) var price : Float = 0.0
    public private(set) var currency : String = ""
    public private(set) var maxQuantity : Int = 10
    public private(set) var type : BookOfferType = .Unknown
    public private(set) var VATRate : Float = 0.0
    public private(set) var saleable : Bool = false
    public private(set) var displayOrder : Int = 9999
    public private(set) var legalInfos : String = ""
    public private(set) var imageUrl : String = ""
    
    public var VAT : Float {
        get {
            return price - (price / (1 + VATRate / 100))
        }
    }
    
    private let imageCache = NSCache<NSString, AnyObject>()
  
    init(id : String, productId : String, title : String, shortDescription : String, price : Float, currency : String, maxQuantity : Int, type : BookOfferType, VATRate : Float, saleable : Bool, displayOrder : Int, legalInfos : String, imageUrl : String) {
        self.id = id
        self.productId = productId
        self.title = title
        self.shortDescription = shortDescription
        self.price = price
        self.currency = currency
        self.maxQuantity = maxQuantity
        self.type = type
        self.VATRate = VATRate
        self.saleable = saleable
        self.displayOrder = displayOrder
        self.legalInfos = legalInfos
        self.imageUrl = imageUrl
    }
    
    @objc public func toDictionnary() -> [String : Any] {
        return [ "id" : self.id,
                 "title" : self.title,
                 "shortDescription" : self.shortDescription,
                 "price" : self.price,
                 "imageUrl" : self.imageUrl,
                 "currency" : self.currency,
                 "maxQuantity" : self.maxQuantity]
    }
    
    public func getImage( callbackSuccess : @escaping (UIImage) -> Void,
                          callbackError : @escaping () -> Void) {
        
        let url = URL(string: "\((NavitiaSDKPartners.shared.getBookManagement() as! VSCTBookManagement)._getUrl())/\(imageUrl)")
        if let cachedImage = imageCache.object(forKey: imageUrl as NSString) as? UIImage {
            callbackSuccess(cachedImage)
            return
        }
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            DispatchQueue.main.async {
                
                if error != nil {
                    callbackError()
                    return
                }
            
                if let image = UIImage(data: data!) {
                    self.imageCache.setObject(image, forKey: self.imageUrl as NSString)
                    callbackSuccess(image)
                    return
                }
            }
        }).resume()
    }
}
