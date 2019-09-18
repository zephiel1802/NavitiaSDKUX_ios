//
//  WalkingSpeedView.swift
//  NavitiaSDKUI
//
//  Created by Adeline Hirsch on 28/08/2019.
//

import Foundation
import UIKit

class WalkingSpeedView: UIView {
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var leftCircleView: UIView!
    @IBOutlet weak var middleCircleView: UIView!
    @IBOutlet weak var rightCircleView: UIView!
    @IBOutlet weak var slowItemView: UIView!
    @IBOutlet weak var slowImageView: UIImageView!
    @IBOutlet weak var normalItemView: UIView!
    @IBOutlet weak var normalImageView: UIImageView!
    @IBOutlet weak var fastItemView: UIView!
    @IBOutlet weak var fastImageView: UIImageView!
    @IBOutlet weak var slowLabel: UILabel!
    @IBOutlet weak var normalLabel: UILabel!
    @IBOutlet weak var fastLabel: UILabel!
    
    internal var isColorInverted: Bool = false {
        didSet {
            colorSetup()
        }
    }
    
    internal var speed: JourneysRequest.Speed = .medium {
        didSet {
            updateButtons()
        }
    }
    
    internal var isActive: Bool = true {
        didSet {
            colorSetup()
        }
    }
    
    internal var slowImage: UIImage? {
        didSet {
            if let image = slowImage {
                slowImageView.image = image
            }
        }
    }
    
    internal var mediumImage: UIImage? {
        didSet {
            if let image = mediumImage {
                normalImageView.image = image
            }
        }
    }
    
    internal var fastImage: UIImage? {
        didSet {
            if let image = fastImage {
                fastImageView.image = image
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initSetup()
        colorSetup()
    }
    
    class func instanceFromNib() -> WalkingSpeedView {
        return UINib(nibName: String(describing: self), bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: nil, options: nil)[0] as! WalkingSpeedView
    }
    
    private func initSetup() {
        speed = .medium
        setupShadow(view: slowItemView)
        setupShadow(view: normalItemView)
        setupShadow(view: fastItemView)
    }
    
    private func colorSetup() {
        var backgroundColor: UIColor = .groupTableViewBackground
        var textColor: UIColor = .black
        
        if isActive && isColorInverted {
            backgroundColor = .white
            textColor = .white
        } else if isColorInverted {
            backgroundColor = .darkGray
            textColor = .darkGray
        } else if !isActive {
            backgroundColor = .groupTableViewBackground
            textColor = .lightGray
        }
        
        lineView.backgroundColor = backgroundColor
        leftCircleView.backgroundColor = backgroundColor
        middleCircleView.backgroundColor = backgroundColor
        rightCircleView.backgroundColor = backgroundColor
        slowItemView.backgroundColor = backgroundColor
        normalItemView.backgroundColor = backgroundColor
        fastItemView.backgroundColor = backgroundColor
        
        slowLabel.textColor = textColor
        normalLabel.textColor = textColor
        fastLabel.textColor = textColor
    }
    
    private func setupShadow(view: UIView) {
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = 1
    }
    
    private func updateButtons() {
        switch speed {
        case .slow:
            slowItemView.isHidden = false
            normalItemView.isHidden = true
            fastItemView.isHidden = true
        case .medium:
            slowItemView.isHidden = true
            normalItemView.isHidden = false
            fastItemView.isHidden = true
        case .fast:
            slowItemView.isHidden = true
            normalItemView.isHidden = true
            fastItemView.isHidden = false
        }
        
        slowImageView.tintColor = isActive ? Configuration.Color.main : Configuration.Color.shadow
        normalItemView.tintColor = isActive ? Configuration.Color.main : Configuration.Color.shadow
        fastItemView.tintColor = isActive ? Configuration.Color.main : Configuration.Color.shadow
    }
    
    @IBAction func slowButtonAction(_ sender: Any) {
        if isActive {
            speed = .slow
        }
    }
    
    @IBAction func mediumButtonAction(_ sender: Any) {
        if isActive {
            speed = .medium
        }
    }
    
    @IBAction func fastButtonAction(_ sender: Any) {
        if isActive {
            speed = .fast
        }
    }
}
