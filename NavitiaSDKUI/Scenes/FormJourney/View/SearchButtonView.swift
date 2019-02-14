//
//  SearchButtonView.swift
//  NavitiaSDKUI
//
//  Copyright © 2019 kisio. All rights reserved.
//

import UIKit

protocol SearchButtonViewDelegate: class {
    
    func search()
}

class SearchButtonView: UIView {
    
    @IBOutlet weak var searchButton: UIButton!
    
    weak var delegate: SearchButtonViewDelegate?
    
    var isEnabled: Bool = true {
        didSet {
            searchButton.isEnabled = isEnabled
            
            if isEnabled {
                searchButton.backgroundColor = Configuration.Color.main
            } else {
                searchButton.backgroundColor = Configuration.Color.shadow
            }
        }
    }
    
    // MARK: - UINib
    
    static var identifier: String {
        return String(describing: self)
    }
    
    class func instanceFromNib() -> SearchButtonView {
        return UINib(nibName: identifier, bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: nil, options: nil)[0] as! SearchButtonView
    }
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
    }
    
    // MARK: - Function
    
    private func setup() {
        searchButton.backgroundColor = Configuration.Color.main
    }
    
    @IBAction func searchButtonClicked(_ sender: Any) {
        delegate?.search()
    }
}
