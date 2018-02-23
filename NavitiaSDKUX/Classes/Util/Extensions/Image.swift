//
//  Image.swift
//  NavitiaSDKUX
//
//  Created by Rachik Abidi on 19/02/2018.
//

import Foundation

extension UIImageView {
    public func loadImageFromURL(urlString: String) {
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
        }).resume()
    }
}

