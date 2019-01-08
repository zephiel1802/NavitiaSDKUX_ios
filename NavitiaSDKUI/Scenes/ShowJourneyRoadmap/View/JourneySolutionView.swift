//
//  JourneySolutionView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

public protocol JourneySolutionViewDelegate: class {
    
    func updateHeight(height: CGFloat)
}

class JourneySolutionView: UIView {
    
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var durationCenterContraint: NSLayoutConstraint!
    
    private let paddingFriezeView = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 70)
    private var friezeView = FriezeView()
    private var disruptions: [Disruption]?
    internal weak var delegate: JourneySolutionViewDelegate?

    // MARK: - UINib
    
    static var identifier: String {
        return String(describing: self)
    }
    
    class func instanceFromNib() -> JourneySolutionView {
        return UINib(nibName: identifier, bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: nil, options: nil)[0] as! JourneySolutionView
    }
    
    // MARK: - Initialization

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    override func awakeAfter(using aDecoder: NSCoder) -> Any? {
        guard subviews.isEmpty else {
            return self
        }
        
        let journeySolutionView = JourneySolutionView.instanceFromNib()
        
        journeySolutionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        journeySolutionView.frame = self.bounds
        
        return journeySolutionView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateFriezeView()
    }
    
    // MARK: - Function
    
    private func setup() {
        setupFriezeView()
    }
    
    private func setupFriezeView() {
        friezeView.frame = CGRect(x: paddingFriezeView.left,
                                  y: paddingFriezeView.top,
                                  width: frame.size.width - paddingFriezeView.right -  paddingFriezeView.left,
                                  height: frame.size.height - paddingFriezeView.top - paddingFriezeView.bottom)
        
        addSubview(friezeView)
    }
    
    internal func updateFriezeView() {
        if #available(iOS 11.0, *) {
            friezeView.frame.origin.x = safeAreaInsets.left + paddingFriezeView.left
        }
        
        friezeView.frame.size = CGSize(width: frame.size.width - paddingFriezeView.right - paddingFriezeView.left,
                                       height: 27)
        friezeView.updatePositionFriezeSectionView()

        frame.size.height = friezeView.frame.size.height + paddingFriezeView.top + paddingFriezeView.bottom
        delegate?.updateHeight(height: frame.size.height)
    }

    private func formattedDuration(prefix: String = "", _ duration: Int32) {
        let formattedStringDuration = NSMutableAttributedString()
            .semiBold(prefix, color: Configuration.Color.main)
        formattedStringDuration.append(duration.toAttributedStringTime(sizeBold: 14, sizeNormal: 10.5))
        self.duration = formattedStringDuration
    }
    
    internal func setData(duration: Int32, friezeSection: [FriezePresenter.FriezeSection]) {
        aboutLabel.isHidden = true
        durationCenterContraint.constant = 0
        
        formattedDuration(duration)
        friezeView.addSection(friezeSections: friezeSection)
        updateFriezeView()
    }
    
    internal func setRidesharingData(duration: Int32, friezeSection: [FriezePresenter.FriezeSection]) {
        aboutLabel.isHidden = false
        durationCenterContraint.constant = 7
        
        aboutLabel.attributedText = NSMutableAttributedString()
            .semiBold("about".localized(), color: Configuration.Color.main)
        formattedDuration(duration)
        
        friezeView.addSection(friezeSections: friezeSection)
    }
}

extension JourneySolutionView {
    
    var duration: NSAttributedString? {
        get {
            return durationLabel.attributedText
        }
        set {
            durationLabel.attributedText = newValue
        }
    }
}
