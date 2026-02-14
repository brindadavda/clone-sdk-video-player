//
//  View+Ext.swift
//  UnityVideoPlugin
//
//  Created by Brinda Davda on 16/05/25.
//

import SwiftUI

public extension View {
  
  public func isHidden(_ bool: Bool) -> some View {
    modifier(HiddenViewModifier(isHidden: bool))
  }
  
  public func isDisabled(_ bool: Bool) -> some View {
    modifier(DissabledViewModifier(isDisable: bool))
  }
}
