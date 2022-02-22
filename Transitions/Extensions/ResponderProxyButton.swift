//
//  ResponderProxyButton.swift
//  Transitions
//
//  Created by dmitriy Uyanov on 23.02.2022.
//

import Foundation
import UIKit

class ResponderProxyButton: UIButton {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        next?.touchesBegan(touches, with: event)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        next?.touchesCancelled(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        next?.touchesEnded(touches, with: event)
    }
    
}
