//
//  DeviceOrientationViewModifier.swift
//  UnityVideoPlugin
//
//  Created by Brinda Davda on 16/05/25.
//

import SwiftUI

class OrientationObserver: ObservableObject {
    @Published var orientation: UIInterfaceOrientation = .unknown

    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateOrientation),
            name: UIApplication.didChangeStatusBarOrientationNotification,
            object: nil
        )
        updateOrientation()
    }

    @objc private func updateOrientation() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            orientation = windowScene.interfaceOrientation
        }
    }
}



extension UIInterfaceOrientation {
    var isLandscape: Bool {
        return self == .landscapeLeft || self == .landscapeRight
    }
    var isPortrait: Bool {
        return self == .portrait || self == .portraitUpsideDown
    }
}
