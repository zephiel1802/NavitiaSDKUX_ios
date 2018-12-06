//
//  AlternativeJourney.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

protocol AlternativeJourneyDelegate: class {
    
    func avoidJourney()
}

class AlternativeJourneyView: UIView {
    
    @IBOutlet weak var friezeView: FriezeView!
    
    weak var delegate: AlternativeJourneyDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateFriezeView()
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    class func instanceFromNib() -> AlternativeJourneyView {
        return UINib(nibName: identifier, bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: nil, options: nil)[0] as! AlternativeJourneyView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //translatesAutoresizingMaskIntoConstraints = false
    }
    
    internal func addFrieze(friezeSection: [FriezePresenter.FriezeSection]) {
        friezeView.addSection(friezeSections: friezeSection)
        friezeView.getCenter()
        frame.size.height = friezeView.frame.size.height + 83
    }
    
    private func updateFriezeView() {
        friezeView.frame.size = CGSize(width: frame.size.width,
                                       height: 27)
        friezeView.updatePositionFriezeSectionView()
        friezeView.getCenter()
        
        frame.size.height = friezeView.frame.size.height + 83
       // delegate?.updateHeight(height: frame.size.height)
    }
    
    @IBAction func avvoidJourneyButton(_ sender: UIButton) {
        delegate?.avoidJourney()
    }
}
