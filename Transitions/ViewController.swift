//
//  ViewController.swift
//  Transitions
//
//  Created by dmitriy Uyanov on 22.02.2022.
//

import Foundation
import UIKit

class ViewController: UIViewController {

    enum State {
        case global
        case dialog
    }
    
    static let animationDurationKey = 0.2
    
    weak var presentedDialogContainer: MultipleControlContainer?
    weak var oririnalContainer: MultipleControlContainer?
    
    var state: State = .global
    
    let containerStack = UIStackView()
    
    var linesStacks: [UIStackView] = []
    
    var blurEffectView: UIVisualEffectView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let imageView = UIImageView(image: UIImage(named: "background"))
        imageView.contentMode = .scaleToFill
        view.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        self.blurEffectView = blurEffectView
        
        containerStack.alignment = .fill
        containerStack.axis = .vertical
        
        let line = UIStackView()
        let block = MultipleControlContainer(controls: firstBlock)
        
        line.snp.makeConstraints({
            $0.height.equalTo(140)
        })
        block.multipleContainerDelegate = self
        
        let block2 = MultipleControlContainer(controls: secondBlock)
        block2.multipleContainerDelegate = self
        
        line.axis = .horizontal
        line.alignment = .fill
        line.distribution = .fillEqually
        line.spacing = 20
        line.addArrangedSubview(block)
        line.addArrangedSubview(block2)
        
        let press = UITapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
        //UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        self.view.addGestureRecognizer(press)
        press.delegate = self
        
        containerStack.addArrangedSubview(line)
     //   line.backgroundColor = .red
        view.addSubview(containerStack)
        containerStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().inset(20)
        }
    }

    // close dialog
    @objc func onTap(_ sender: UITapGestureRecognizer? = nil) {
        
        
        guard state == .dialog else { return }
        
        guard let original = oririnalContainer, let dialog = presentedDialogContainer else {
            return
        }
        
        let frame = original.convert(original.bounds, to: self.view)
        let center = CGPoint(x: frame.origin.x + (frame.size.width/2), y: frame.origin.y + (frame.size.height/2))
        
        UIView.animate(withDuration: Self.animationDurationKey, animations: {
            
            self.state = .global
            
            dialog.layer.cornerRadius = 22
            
            self.containerStack.layer.opacity = 1.0
            
            dialog.leadingTopConstaint?.isActive = false
            dialog.lineStacksConstraints.forEach({
                $0.isActive = true
            })
            
            dialog.snp.remakeConstraints({
                $0.size.equalTo(original.bounds.size)
                $0.center.equalTo(center)
            })
           self.view.layoutIfNeeded()
        }, completion: { _ in
            original.layer.opacity = 1.0
            dialog.removeFromSuperview()
        })
        
    }

}

extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == blurEffectView
    }
}

extension ViewController: MultipleControlContainerDelegate {
    func didPressContainer(container: MultipleControlContainer) {
        
        self.state = .dialog
        
        let newContainer = MultipleControlContainer(controls: expandedBlock, embeded: false)
            
        oririnalContainer = container
        presentedDialogContainer = newContainer
        
        newContainer.transform = container.transform
        
        let frame = container.convert(container.bounds, to: self.view)
        let center = CGPoint(x: frame.origin.x + (frame.size.width/2), y: frame.origin.y + (frame.size.height/2))

        view.addSubview(newContainer)
        newContainer.snp.makeConstraints({
            $0.center.equalTo(center)
            $0.size.equalTo(CGSize(width: container.bounds.width, height: container.bounds.height))
        })
        
        container.layer.opacity = 0.0
        newContainer.layer.opacity = 1.0
        
        // calc height
        newContainer.lineStacksConstraints.forEach({
            $0.isActive = false
        })
        newContainer.leadingTopConstaint?.isActive = true
        
        let height = newContainer.stack.systemLayoutSizeFitting(
            CGSize(width: view.bounds.width - 60, height: 0),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height
        newContainer.lineStacksConstraints.forEach({
            $0.isActive = true
        })
        newContainer.leadingTopConstaint?.isActive = false
        
        // update layout
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        // transition animation
        UIView.animate(withDuration: Self.animationDurationKey, delay: 0, options: [.curveEaseInOut], animations: {
            self.containerStack.layer.opacity = 0.0
            newContainer.layer.cornerRadius = 36
            newContainer.lineStacksConstraints.forEach({
                $0.isActive = false
            })
            newContainer.leadingTopConstaint?.isActive = true

            newContainer.snp.remakeConstraints({
                $0.size.equalTo(CGSize(width: self.view.bounds.width - 60, height: height + 20))
                $0.center.equalToSuperview()
            })
            
           newContainer.transform = .identity
           self.view.layoutIfNeeded()
        }, completion: nil)
        
        
    }
}

