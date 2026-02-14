//
//  UIApplication+Ext.swift
//  UnityVideoPlugin
//
//  Created by Brinda Davda on 16/05/25.
//

import UIKit

public extension UIApplication {
  public func topMostViewController() -> UIViewController? {
    guard var topController = self.connectedScenes
      .compactMap({ $0 as? UIWindowScene })
      .first?.windows
      .first(where: { $0.isKeyWindow })?.rootViewController else { return nil }
    
    while let presented = topController.presentedViewController {
      topController = presented
    }
    
    return topController
  }
}
