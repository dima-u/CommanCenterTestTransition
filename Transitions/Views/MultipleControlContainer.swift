//
//  ControlGroupView.swift
//  Transitions
//
//  Created by dmitriy Uyanov on 22.02.2022.
//

import Foundation
import UIKit
import SnapKit


protocol MultipleControlContainerDelegate: AnyObject {
    func didPressContainer(container: MultipleControlContainer)
}

class MultipleControlContainer: ControlContainer {
    
    weak var multipleContainerDelegate: MultipleControlContainerDelegate?
    
    let items: [ControlCenterItem]
    
    let stack = UIStackView()
    
    var leadingTopConstaint: Constraint?
    
    var lineStacksConstraints: [Constraint] = []
    
    private lazy var impactFeedback = UIImpactFeedbackGenerator()
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(controls: [ControlCenterItem], embeded: Bool = true) {
        items = controls

        super.init(animateTouches: embeded)
    
        clipsToBounds = true
        
        self.delegate = self

        stack.axis = .vertical

        let leadingView = UIView()
        leadingView.snp.makeConstraints {
            leadingTopConstaint = $0.height.equalTo(20).constraint
        }
        leadingTopConstaint?.deactivate()
        stack.addArrangedSubview(leadingView)

        for i in 0..<(controls.count/2) {
            let firstLine = UIStackView()
            firstLine.axis = .horizontal
            firstLine.alignment = .fill
            firstLine.distribution = .fillEqually

            firstLine.addArrangedSubview(ControlCenterButtonItem(item: controls[i*2], touchHandler: self, isLeft: true))
            firstLine.addArrangedSubview(ControlCenterButtonItem(item: controls[i*2+1], touchHandler: self, isLeft: false))
            stack.addArrangedSubview(firstLine)
            stack.addArrangedSubview(buildLabelsLine(items: [controls[i*2], controls[i*2+1]]))
        }
        
        addSubview(stack)
        stack.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
    }
    

    
}


extension MultipleControlContainer: ControlContainerDelegate {
    func shouldOpenDetailView(from: ControlContainer) {
        impactFeedback.impactOccurred(intensity: 1.0)
        self.multipleContainerDelegate?.didPressContainer(container: self)
    }
}

extension MultipleControlContainer {
    
    private func buildLabelsLine(items: [ControlCenterItem]) -> UIStackView {
        
        let firstLine = UIStackView()
        firstLine.clipsToBounds = true

        firstLine.axis = .horizontal
        firstLine.alignment = .fill
        firstLine.distribution = .fillEqually
        
        for (index, item) in items.enumerated() {
            let v = UIView()
            
            let label = VerticalAlignLabel()
            label.text = item.title
            label.textColor = .white
            label.numberOfLines = 0
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 12, weight: .bold)
            label.clipsToBounds = true
            v.addSubview(label)
            v.clipsToBounds = true
            v.snp.makeConstraints {
                $0.height.equalTo(40).priority(900)
                let titleHeightConstraint = $0.height.equalTo(0).priority(1000).constraint
                lineStacksConstraints.append(titleHeightConstraint)
            }
            
            label.snp.makeConstraints({
                $0.top.equalToSuperview().offset(5)
                $0.width.equalTo(120)
                $0.centerX.equalToSuperview().multipliedBy( index == 0 ? 1.15 : 0.85)
            })
            firstLine.addArrangedSubview(v)
        }
        return firstLine
    }
    
}
