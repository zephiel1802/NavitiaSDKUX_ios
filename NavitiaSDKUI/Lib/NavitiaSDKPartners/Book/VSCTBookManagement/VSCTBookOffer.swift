//
//  VSCTBookOffer.swift
//  NavitiaSDKPartners
//
//  Created by Valentin COUSIEN on 19/04/2018.
//  Copyright © 2018 Kisio. All rights reserved.
//

import Foundation

@objc(VSCTBookOffer) public class VSCTBookOffer : NSObject, BookOffer {

    
    public var id : String = ""
    public var productId : String = ""
    public var title : String = ""
    public var shortDescription : String = ""
    public var price : Float = 0.0
    public var currency : String = ""
    public var maxQuantity : Int = 10
    public var type : BookOfferType = .Unknown
    public var VAT : Float = 0.0
    public var saleable : Bool = false
    public var displayOrder : Int = 9999
    public var legalInfos : String = ""
    
    var imageUrl : String = ""
    let imageCache = NSCache<NSString, AnyObject>()
  
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
