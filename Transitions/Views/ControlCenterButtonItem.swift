//
//  ControlCenterButtonItem.swift
//  Transitions
//
//  Created by dmitriy Uyanov on 22.02.2022.
//

import Foundation
import UIKit
import SnapKit

class ControlCenterButtonItem: UIView {
    
    let button: ResponderProxyButton
    
    init(item: ControlCenterItem, touchHandler: UIView, isLeft: Bool) {
        
        button = ResponderProxyButton()
        
        super.init(frame: .zero)
        
        button.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.equalTo(40)
        }
        
        button.setImage(UIImage(named: item.icon)!, for: .normal)
        button.add(command: item.action, event: .touchUpInside)
        
        let v = UIView()
        v.addSubview(button)
        addSubview(v)
        v.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        button.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview().multipliedBy( isLeft ? 1.15 : 0.85)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
