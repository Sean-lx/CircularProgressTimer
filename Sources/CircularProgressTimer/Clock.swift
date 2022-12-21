//
//  Created by Sean Li on 2022/12/20.
//

import SwiftUI

@available(iOS 13.0.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
struct Clock: View {
  private(set) var font: Font
  private(set) var fontColor: Color
  private(set) var counter: Int
  private(set) var countTo: Int
  
  var body: some View {
    VStack {
      Text(counterToMinutes())
        .font(font)
        .foregroundColor(fontColor)
    }
  }
  
  private func counterToMinutes() -> String {
    let currentTime = countTo - counter
    let seconds = currentTime % 60
    let minutes = Int(currentTime / 60)
    
    return "\(minutes):\(seconds < 10 ? "0" : "")\(seconds)"
  }
}
