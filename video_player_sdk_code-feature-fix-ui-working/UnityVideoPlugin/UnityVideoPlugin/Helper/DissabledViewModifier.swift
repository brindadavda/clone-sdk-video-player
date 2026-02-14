//
//  DissabledViewModifier.swift
//  UnityVideoPlugin
//
//  Created by Brinda Davda on 19/05/25.
//

import Foundation
import SwiftUI

public struct DissabledViewModifier: ViewModifier {
  let isDisable: Bool
  
  public func body(content: Content) -> some View {
      content
        .disabled(isDisable)
  }
}
