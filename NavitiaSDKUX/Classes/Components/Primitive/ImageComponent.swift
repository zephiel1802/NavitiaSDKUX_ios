//
//  ImageComponent.swift
//  NavitiaSDKUX
//
//  Created by Rachik Abidi on 21/02/2018.
//

import Foundation

class ImageComponent: StylizedComponent<NilState> {
    var image: UIImage?
    var imageURL: String?
    
    override func render() -> NodeType {
        return Node<UIImageView>() { view, layout, size in
            self.applyStyles(view: view, layout: layout)
            
            if self.image != nil {
                view.image = self.image
            }
            
            if self.imageURL != nil {
                view.loadImageFromURL(urlString: self.imageURL!)
            }
        }
    }
}
