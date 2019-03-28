//
//  SlidingScrollView.swift
//  NavitiaSDKUI
//
//  Copyright © 2019 kisio. All rights reserved.
//

import UIKit

protocol SlidingScrollViewDelegate: class {
    
    func slidingDidMove()
    func slidingEndMove(edgePaddingBottom: CGFloat, slidingState: SlidingScrollView.SlideState)
}

internal class SlidingScrollView: UIView {
    
    enum SlideState: Int {
        case expanded = 0
        case anchored = 1
        case collapsed = 2
    }
    
    private var notchFrame = CGRect(x: 0, y: 9, width: 35, height: 4)
    private var headerHeight: CGFloat = 60
    private var lastOrigin = CGPoint.zero
    private var parentViewSafeArea = UIEdgeInsets.zero
    private var currentState: SlideState = .anchored
    internal weak var delegate: SlidingScrollViewDelegate?
    internal weak var parentView: UIView!
    internal var stackScrollView: StackScrollView!
    internal var journeySolutionView: JourneySolutionView! {
        willSet {
            if journeySolutionView == nil {
                initJourneySolutionView(journeySolutionView: newValue)
            }
        }
    }
    
    init(frame: CGRect, parentView: UIView) {
        super.init(frame: frame)
        
        self.parentView = parentView
        if #available(iOS 11.0, *) {
            parentViewSafeArea = parentView.safeAreaInsets
        }
        
        backgroundColor = Configuration.Color.white
        
        initGesture()
        initNotch()
        initStackScrollView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initGesture() {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(moveViewWithGestureRecognizer(_:)))
    
        gestureRecognizers = [panRecognizer]
    }
    
    private func initNotch() {
        let notch = UIView()
        
        addSubview(notch)
        
        notch.layer.cornerRadius = 2
        notch.backgroundColor = Configuration.Color.shadow
        notch.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: notch, attribute: NSLayoutConstraint.Attribute.top, relatedBy: .equal,
                           toItem: self, attribute: .top, multiplier: 1, constant: notchFrame.origin.y).isActive = true
        NSLayoutConstraint(item: notch, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: .equal,
                           toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: notch, attribute: NSLayoutConstraint.Attribute.height, relatedBy: .equal,
                           toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: notchFrame.size.height).isActive = true
        NSLayoutConstraint(item: notch, attribute: NSLayoutConstraint.Attribute.width, relatedBy: .equal,
                           toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: notchFrame.size.width).isActive = true
    }
    
    private func initStackScrollView() {
        stackScrollView = StackScrollView(frame: CGRect(x: 0,
                                                        y: headerHeight,
                                                        width: self.frame.size.width,
                                                        height: parentView.frame.size.height - headerHeight - lastOrigin.y))
        stackScrollView.backgroundColor = Configuration.Color.background
        stackScrollView.bounces = false
        
        addSubview(stackScrollView)
    }
    
    private func initJourneySolutionView(journeySolutionView: JourneySolutionView) {
        journeySolutionView.frame.origin.y = notchFrame.origin.y + notchFrame.size.height
        journeySolutionView.setShadow(offset: CGSize(width: 0, height: 5), radius: 3)
        journeySolutionView.updateFriezeView()
        
        headerHeight = journeySolutionView.frame.size.height + journeySolutionView.frame.origin.y
        stackScrollView.frame.origin.y = headerHeight
        
        addSubview(journeySolutionView)
    }

    internal func updateSlidingViewAfterRotation() {
        DispatchQueue.main.async() {
            self.frame.size.width = self.parentView.bounds.size.width
            self.stackScrollView.frame.size.width = self.parentView.bounds.size.width
            self.journeySolutionView.frame.size.width = self.parentView.bounds.size.width

            self.journeySolutionView.updateFriezeView()
            self.headerHeight = self.journeySolutionView.frame.size.height + self.notchFrame.origin.y + self.notchFrame.size.height
            
            if self.currentState == .expanded {
                self.animationBottom()
                self.setAnchorPoint(slideState: .expanded)
            } else {
                self.animationBottom(withSafeArea: true)
                self.setAnchorPoint(slideState: .collapsed)
            }

            self.stackScrollView.reloadStack()
        }
    }
    
    @objc private func moveViewWithGestureRecognizer(_ recognizer:UIPanGestureRecognizer) {
        delegate?.slidingDidMove()

        switch recognizer.state {
        case .began:
            addShadowInJourneySolutionView()
            animationBottom()
            reinitSize()
        case .ended:
            let tolerance:CGFloat = recognizer.isDown(theViewYouArePassing: parentView) ? -0.15 : 0.15
            let percentagePosition = frame.origin.y / parentView.frame.size.height
            
            checkedAnchor(percentagePosition: percentagePosition, tolerance: tolerance)
        default:
            let translationForSliding = min(max(0, lastOrigin.y + recognizer.translation(in: parentView).y), parentView.frame.size.height)
            
            translationView(translationY: translationForSliding)
        }
    }
    
    private func reinitSize() {
        stackScrollView.frame.size.height = parentView.frame.size.height - headerHeight
        frame.size.height = parentView.frame.size.height
    }
    
    private func checkedAnchor(percentagePosition: CGFloat, tolerance: CGFloat = 0) {
        if UIApplication.shared.statusBarOrientation.isPortrait  {
            if percentagePosition < 0.2 + tolerance {
                setAnchorPoint(slideState: .expanded)
            } else if percentagePosition < 0.7 + tolerance {
                setAnchorPoint(slideState: .anchored)
            } else {
                setAnchorPoint(slideState: .collapsed)
            }
        } else {
            if percentagePosition < 0.5 + tolerance {
                setAnchorPoint(slideState: .expanded)
            } else {
                setAnchorPoint(slideState: .collapsed)
            }
        }
    }

    internal func setAnchorPoint(slideState: SlideState, duration: TimeInterval = 0.3) {
        switch slideState {
        case .expanded:
            lastOrigin = getPourcentagePosition(value: 0)
        case .anchored:
            lastOrigin = getPourcentagePosition(value: 0.4)
        case .collapsed:
            removeShadowInJourneySolutionView()
            animationBottom(withSafeArea: true)
            lastOrigin = getPourcentagePosition(value: 1)
        }

        translationView(translationY: lastOrigin.y, duration: duration, completion: {
            self.stackScrollView.frame.size.height = max(0, self.parentView.frame.size.height - self.lastOrigin.y - self.headerHeight)
            self.frame.size.height = self.parentView.frame.size.height - self.lastOrigin.y
        })
        
        currentState = slideState
        
        delegate?.slidingEndMove(edgePaddingBottom:parentView.frame.size.height - lastOrigin.y, slidingState: slideState)
    }
    
    private func removeShadowInJourneySolutionView() {
        if journeySolutionView != nil {
            journeySolutionView.removeShadow()
        }
    }
    
    private func addShadowInJourneySolutionView() {
        if journeySolutionView != nil {
            journeySolutionView.setShadow(offset: CGSize(width: 0, height: 5), radius: 3)
        }
    }
    
    private func getPourcentagePosition(value: CGFloat) -> CGPoint {
        var y = parentView.frame.size.height * value
        
        y = min(y, parentView.frame.size.height - headerHeight - parentViewSafeArea.bottom)
        y = max(y, 0)
        
        return CGPoint(x: 0, y: y)
    }
    
    private func translationView(translationY: CGFloat, duration: TimeInterval = 0, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            self.frame.origin.y = translationY
        }, completion: { (_) in
            completion?()
        })
    }
    
    private func animationBottom(withSafeArea safeArea: Bool = false) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            if safeArea {
                self.stackScrollView.frame.origin.y = self.headerHeight + self.parentViewSafeArea.bottom
            } else {
                self.stackScrollView.frame.origin.y = self.headerHeight
            }
        }, completion: { (_) in })
    }
}
