//
//  SlidingScrollView.swift
//  NavitiaSDKUI
//
//  Copyright © 2019 kisio. All rights reserved.
//

import UIKit

protocol SlidingScrollViewDelegate {
    
    func slidingDidMove()
    func slidingEndMove(edgePaddingBottom: CGFloat, slidingState: SlidingScrollView.SlideState)
}

internal class SlidingScrollView: UIView {
    
    enum SlideState: Int {
        case roadmap = 0
        case hybrid = 1
        case map = 2
    }
    
    private var currentState: SlideState = .hybrid
    private var marginTop: CGFloat = 0
    private var headerHeight: CGFloat = 60
    private var slidingViewYOrigin: CGFloat = 0
    private var parentViewSafeArea = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    internal var delegate: SlidingScrollViewDelegate?
    internal var parentView: UIView!
    internal var stackScrollView: StackScrollView!
    internal var journeySolutionView: JourneySolutionView! {
        willSet {
            if journeySolutionView == nil {
                newValue.frame.origin.y = 13
                addSubview(newValue)
                newValue.updateFriezeView()
                headerHeight = newValue.frame.size.height + 13
                self.stackScrollView.frame.origin.y = self.headerHeight
            }
        }
    }
    
    init(frame: CGRect, parentView: UIView) {
        super.init(frame: frame)
        
        self.parentView = parentView
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = Configuration.Color.white
        
        if #available(iOS 11.0, *) {
            parentViewSafeArea = parentView.safeAreaInsets
        }
        
        initViewScroll()
        initNotch()
        initStackScrollView()
    }
    
    private func initViewScroll() {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(detectPan(_:)))
    
        self.gestureRecognizers = [panRecognizer]
        self.frame.origin = CGPoint(x: 0, y: slidingViewYOrigin)
        self.backgroundColor = Configuration.Color.white
    }
    
    private func initNotch() {
        let notch = UIView()
        
        notch.layer.cornerRadius = 2
        notch.backgroundColor = Configuration.Color.shadow
        notch.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(notch)
        
        NSLayoutConstraint(item: notch, attribute: NSLayoutConstraint.Attribute.top, relatedBy: .equal,
                           toItem: self, attribute: .top, multiplier: 1, constant: 9).isActive = true
        NSLayoutConstraint(item: notch, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: .equal,
                           toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: notch, attribute: NSLayoutConstraint.Attribute.height, relatedBy: .equal,
                           toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 4).isActive = true
        NSLayoutConstraint(item: notch, attribute: NSLayoutConstraint.Attribute.width, relatedBy: .equal,
                           toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 35).isActive = true
    }
    
    private func initStackScrollView() {
        stackScrollView = StackScrollView(frame: CGRect(x: 0,
                                                        y: headerHeight,
                                                        width: self.frame.size.width,
                                                        height: parentView.frame.size.height - headerHeight - slidingViewYOrigin))
        stackScrollView.backgroundColor = Configuration.Color.background
        stackScrollView.bounces = false
        
        self.addSubview(stackScrollView)
    }

    internal func rotationSlidingView() {
        DispatchQueue.main.async() {
            self.frame.size.width = self.parentView.bounds.size.width
            self.stackScrollView.frame.size.width = self.parentView.bounds.size.width
            self.journeySolutionView.frame.size.width = self.parentView.bounds.size.width

            self.journeySolutionView.updateFriezeView()
            self.headerHeight = self.journeySolutionView.frame.size.height + 13
            
            if self.currentState == .roadmap {
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                    self.stackScrollView.frame.origin.y = self.headerHeight
                })

                self.updatePosition(slideState: .roadmap)
            } else {
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                    self.stackScrollView.frame.origin.y = self.headerHeight + self.parentViewSafeArea.bottom
                })

                self.updatePosition(slideState: .map)
            }

            self.stackScrollView.reloadStack()
        }
    }
    
    @objc private func detectPan(_ recognizer:UIPanGestureRecognizer) {
        if parentViewSafeArea.bottom > 0 && self.stackScrollView.frame.origin.y > headerHeight {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                self.stackScrollView.frame.origin.y = self.headerHeight
            })
        }

        delegate?.slidingDidMove()

        let translation = slidingViewYOrigin + recognizer.translation(in: parentView).y
        let translationY = min(max(self.marginTop, translation), parentView.frame.size.height + self.marginTop)

        translationView(translationY: translationY)

        switch recognizer.state {
        case .began:
            stackScrollView.frame.size.height = parentView.frame.size.height - headerHeight
            frame.size.height = parentView.frame.size.height
        case .ended:
            let marge:CGFloat = recognizer.isDown(theViewYouArePassing: parentView) ? -0.15 : 0.15
            let pourcent = self.frame.origin.y / parentView.frame.size.height
            
            if UIApplication.shared.statusBarOrientation.isPortrait {
                if pourcent < 0.2 + marge {
                    updatePosition(slideState: .roadmap)
                } else if pourcent < 0.7 + marge {
                    updatePosition(slideState: .hybrid)
                } else {
                    updatePosition(slideState: .map)
                }
            } else {
                if pourcent < 0.5 + marge {
                    updatePosition(slideState: .roadmap)
                } else {
                    updatePosition(slideState: .map)
                }
            }
        default:
            translationView(translationY: translationY)
        }

    }

    internal func updatePosition(slideState: SlideState, duration: TimeInterval = 0.3) {
        currentState = slideState
        
        switch slideState {
        case .roadmap:
            slidingViewYOrigin = 0
        case .hybrid:
            slidingViewYOrigin = parentView.frame.size.height * 0.4
            
        case .map:
            animationForSafeAreaBottom()
            
            slidingViewYOrigin = parentView.frame.size.height - headerHeight
        }
        
        delegate?.slidingEndMove(edgePaddingBottom:parentView.frame.size.height - slidingViewYOrigin + parentViewSafeArea.bottom, slidingState: slideState)
        translationView(translationY: slidingViewYOrigin, duration: duration, completion: {
            let translationY = max(0, self.slidingViewYOrigin - self.parentViewSafeArea.bottom)
            let height = self.parentView.frame.size.height - translationY - self.headerHeight
            
            self.stackScrollView.frame.size.height = max(0, height)
            self.frame.size.height = self.parentView.frame.size.height - translationY

        })
    }
    
    private func translationView(translationY: CGFloat, duration: TimeInterval = 0, completion: (() -> Void)? = nil) {
        let translationY = max(0, translationY - parentViewSafeArea.bottom)

        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            self.frame.origin.y = translationY
        }, completion: { (_) in
            completion?()
        })
    }
    
    private func animationForSafeAreaBottom() {
        if parentViewSafeArea.bottom > 0 {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                self.stackScrollView.frame.origin.y = self.headerHeight + self.parentViewSafeArea.bottom
            }, completion: { (_) in })
        }
    }
}
