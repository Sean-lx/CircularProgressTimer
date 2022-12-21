//
//  Created by Sean Li on 2022/12/20.
//

import Foundation
import SwiftUI
import Combine

public extension View {
  /// A backwards compatible wrapper for iOS 14 `onChange`
  @ViewBuilder
  func valueChanged<T: Equatable>
  (value: T, onChange: @escaping (T) -> Void) -> some View {
    if #available(iOS 14.0.0, macOS 11.0, tvOS 14.0, watchOS 7.0, macCatalyst 14.0, *)
    {
      self.onChange(of: value, perform: onChange)
    } else {
      self.onReceive(Just(value)) { (value) in
        onChange(value)
      }
    }
  }
}
