//
//  WalkingSpeedView.swift
//  NavitiaSDKUI
//
//  Created by Adeline Hirsch on 28/08/2019.
//

import Foundation
import UIKit

class WalkingSpeedView: UIView {
    
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var mediumLabel: UILabel!
    @IBOutlet weak var fastLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    internal var isColorInverted: Bool = false {
        didSet {
            setup()
        }
    }
    
    internal var speed: JourneysRequest.Speed = .medium {
        didSet {
            updateProgress()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    class func instanceFromNib() -> WalkingSpeedView {
        
        return UINib(nibName: String(describing: self), bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: nil, options: nil)[0] as! WalkingSpeedView
    }
    
    private func setup() {
        if isColorInverted {
            progressView.progressTintColor = .white
            lowLabel.textColor = .white
            mediumLabel.textColor = .white
            fastLabel.textColor = .white
        } else {
            progressView.progressTintColor = NavitiaSDKUI.shared.mainColor
            lowLabel.textColor = .black
            mediumLabel.textColor = .black
            fastLabel.textColor = .black
        }
        
        updateProgress()
    }
    
    private func updateProgress() {
        let selectedFont = UIFont(name: "Helvetica-Bold", size: 12)
        let unselectedFont = UIFont(name: "Helvetica", size: 12)
        
        lowLabel.font = unselectedFont
        mediumLabel.font = unselectedFont
        fastLabel.font = unselectedFont
        
        switch speed {
        case .slow:
            progressView.progress = 0
            lowLabel.font = selectedFont
        case .medium:
            progressView.progress = 0.5
            mediumLabel.font = selectedFont
        case .fast:
            progressView.progress = 1
            fastLabel.font = selectedFont
        }
    }
    
    @IBAction func lowButtonAction(_ sender: Any) {
        speed = .slow
    }
    
    @IBAction func mediumButtonAction(_ sender: Any) {
        speed = .medium
    }
    
    @IBAction func fastButtonAction(_ sender: Any) {
        speed = .fast
    }
}
