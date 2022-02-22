//
//  ControlsContainer.swift
//  Transitions
//
//  Created by dmitriy Uyanov on 22.02.2022.
//

import Foundation
import UIKit

protocol ControlContainerDelegate: AnyObject {
    func shouldOpenDetailView(from: ControlContainer)
}

// for single icon
class ControlContainer: UIControl {
    
    weak var delegate: ControlContainerDelegate?
    
    let animateTouches: Bool
    
    var isAnimatingTouchIn = false
    
    init(animateTouches: Bool) {
        self.animateTouches = animateTouches
        super.init(frame: .zero)
        viewSetup()
    }
    
    required init?(coder _: NSCoder) {
        fatalError("")
    }
    
    private func viewSetup() {
        layer.cornerRadius = 22
        backgroundColor = .black.withAlphaComponent(0.4)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        animateTouch(begin: true)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animateTouch(begin: false)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
       animateTouch(begin: false)
    }
    


    private func animateTouch(begin: Bool) {
        
        if !animateTouches { return }
        
        let animation = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 0.8) {
            (self as UIView).transform = begin ? .init(scaleX: 0.95, y: 0.95) : .identity
        }
        
        isAnimatingTouchIn = begin
        if begin {
            animation.addCompletion({ [weak self] _ in
                guard let self = self else { return }
                if self.isAnimatingTouchIn {
                    self.delegate?.shouldOpenDetailView(from: self)
                }
            })
        }
        
        animation.startAnimation()
        
    }
}
