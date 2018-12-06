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
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var avoidDisruptionButton: UIButton!
    @IBOutlet weak var accessibilityButton: UIButton!
    
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

        descriptionLabel.text = "itinerary_disruption_message".localized()
        avoidDisruptionButton.setTitle("avoid_the_disruption".localized(), for: .normal)
        accessibilityButton.accessibilityLabel = ""
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
    }
    
    @IBAction func avvoidJourneyButton(_ sender: UIButton) {
        delegate?.avoidJourney()
    }
}
