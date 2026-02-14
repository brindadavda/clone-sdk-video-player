//
//  HiddenViewModifier.swift
//  UnityVideoPlugin
//
//  Created by Brinda Davda on 16/05/25.
//

import SwiftUI

public struct HiddenViewModifier: ViewModifier {
  let isHidden: Bool
  
  public func body(content: Content) -> some View {
    if !isHidden {
      content
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.25), value: isHidden)
    }
  }
}

