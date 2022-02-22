//
//  UIControl+Command.swift
//  Transitions
//
//  Created by dmitriy Uyanov on 22.02.2022.
//

import UIKit


extension UIControl {
    private enum AssociatedKeys {
        static var commandKey = "uikit_control_command_key"
    }

    private var command: ActionClosure? {
        get { objc_getAssociatedObject(self, &AssociatedKeys.commandKey) as? ActionClosure }
        set {
            guard let cmd = newValue else {
                return
            }
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.commandKey,
                cmd,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }

    func add(command: @escaping ActionClosure, event: UIControl.Event) {
        removeTarget(self, action: #selector(handle(_:)), for: event)
        addTarget(self, action: #selector(handle(_:)), for: event)
        self.command = command
    }

    func removeCommand(for event: UIControl.Event) {
        removeTarget(self, action: #selector(handle(_:)), for: event)
        command = nil
    }

    @objc private func handle(_: Any?) {
        command?()
    }
}
