//
//  JourneySolutionView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

public protocol JourneySolutionViewDelegate {
    
    func updateHeight(height: CGFloat)
}

class JourneySolutionView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var durationCenterContraint: NSLayoutConstraint!

    var delegate: JourneySolutionViewDelegate?
    var friezeView = FriezeView()
    let paddingFriezeView = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 70)
    var disruptions: [Disruption]?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateFriezeView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        UINib(nibName: "JourneySolutionView", bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: self, options: nil)
        view.frame = self.bounds
        addSubview(view)
        
        setupFriezeView()
        addShadow()
    }
    
    private func setupFriezeView() {
        friezeView.frame = CGRect(x: paddingFriezeView.left,
                                  y: paddingFriezeView.top,
                                  width: frame.size.width - paddingFriezeView.right -  paddingFriezeView.left,
                                  height: frame.size.height - paddingFriezeView.top - paddingFriezeView.bottom)
        
        addSubview(friezeView)
    }
    
    private func updateFriezeView() {
        friezeView.frame.size = CGSize(width: frame.size.width - paddingFriezeView.right - paddingFriezeView.left,
                                       height: 27)
        friezeView.updatePositionFriezeSectionView()

        frame.size.height = friezeView.frame.size.height + paddingFriezeView.top + paddingFriezeView.bottom
        delegate?.updateHeight(height: frame.size.height)
    }

    func setData(duration: Int32, friezeSection: [FriezePresenter.FriezeSection]) {
        aboutLabel.isHidden = true
        durationCenterContraint.constant = 0
        
        formattedDuration(duration)
        friezeView.addSection(friezeSections: friezeSection)
    }
    
    func setRidesharingData(duration: Int32, friezeSection: [FriezePresenter.FriezeSection]) {
        aboutLabel.isHidden = false
        durationCenterContraint.constant = 7
        
        aboutLabel.attributedText = NSMutableAttributedString()
            .semiBold("about".localized(withComment: "about", bundle: NavitiaSDKUI.shared.bundle), color: Configuration.Color.main)
        formattedDuration(duration)
        
        friezeView.addSection(friezeSections: friezeSection)
    }
    
    private func formattedDuration(prefix: String = "", _ duration: Int32) {
        let formattedStringDuration = NSMutableAttributedString()
            .semiBold(prefix, color: Configuration.Color.main)
        formattedStringDuration.append(duration.toAttributedStringTime(sizeBold: 14, sizeNormal: 10.5))
        self.duration = formattedStringDuration
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
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
