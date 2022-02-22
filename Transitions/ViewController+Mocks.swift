//
//  ViewController+Mocks.swift
//  Transitions
//
//  Created by dmitriy Uyanov on 23.02.2022.
//

import Foundation
import UIKit

extension ViewController {
    var firstBlock: [ControlCenterItem] {
        return [
            .init(icon: "airdrop", action: {}, title: "Airplane"),
            .init(icon: "airdrop", action: {}, title: "Wifi"),
            .init(icon: "airdrop", action: {}, title: "Cellular"),
            .init(icon: "airdrop", action: {}, title: "Bluetooth")
        ]
    }
    
    var secondBlock: [ControlCenterItem] {
        return [
            .init(icon: "airdrop", action: {}, title: "Airplane"),
            .init(icon: "airdrop", action: {}, title: "Wifi"),
            .init(icon: "airdrop", action: {}, title: "Cellular"),
            .init(icon: "airdrop", action: {}, title: "Bluetooth")
        ]
    }
    
    var expandedBlock: [ControlCenterItem] {
        return [
            .init(icon: "airdrop", action: {}, title: "Airplane"),
            .init(icon: "airdrop", action: {}, title: "Wifi"),
            .init(icon: "airdrop", action: {}, title: "Cellular"),
            .init(icon: "airdrop", action: {}, title: "Bluetooth"),
            .init(icon: "airdrop", action: {}, title: "Some siri extensions"),
            .init(icon: "airdrop", action: {}, title: "AirDrop")
        ]
    }
}
