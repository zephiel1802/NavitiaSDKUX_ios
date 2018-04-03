//
//  JourneyPartView.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 27/03/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class JourneySummaryPartView: UIView {
    
    @IBOutlet weak var _view: UIView!
    @IBOutlet weak var _iconTransportImageView: UIImageView!
    @IBOutlet weak var _tagTransportView: UIView!
    @IBOutlet weak var _tagTransportLabel: UILabel!
    @IBOutlet weak var _lineTransportView: UIView!
    
    var _type: TypeTransport?
    var width = 1.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        _setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func _setup() {
        UINib(nibName: "JourneySummaryPartView", bundle:  bundle).instantiate(withOwner: self, options: nil)
        addSubview(_view)
        _view.frame = self.bounds
        
        
    }
    
}

extension JourneySummaryPartView {
    
    var color: UIColor? {
        get {
            return _tagTransportView.backgroundColor
        }
        set {
            _tagTransportView.backgroundColor = newValue
            _lineTransportView.backgroundColor = newValue
        }
    }
    
    var name: String? {
        get {
            return _tagTransportLabel.text
        }
        set {
            _tagTransportLabel.text = newValue
        }
    }
    
    var type: TypeTransport? {
        get {
            return _type
        }
        set {
            if let newValue = newValue {
                _type = newValue
                switch newValue {
                case .metro:
//                    _iconTransportImageView.image = UIImage(named: "metroIcon")
                    break
                case .bus:
//                    _iconTransportImageView.image = UIImage(named: "busIcon")
                    break
                case .tramway:
//                    _iconTransportImageView.image = UIImage(named: "tramwayIcon")
                    break
                case .car:
//                    _iconTransportImageView.image = UIImage(named: "carIcon")
                    break
                case .walk:
//                    _iconTransportImageView.image = UIImage(named: "walkIcon")
                    break
                }
            }
        }
    }
}
