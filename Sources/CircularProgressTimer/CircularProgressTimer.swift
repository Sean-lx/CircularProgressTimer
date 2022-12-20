//
//  Created by Sean Li on 2022/12/19.
//

import SwiftUI

@available(iOS 13.0.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public struct CircularProgressTimer: View {
  private let timer = Timer
    .publish(every: 1, on: .main, in: .common)
    .autoconnect()
  @State private(set) var width: CGFloat
  @State private(set) var height: CGFloat
  @State private(set) var borderWidth: CGFloat
  @State private(set) var font: Font
  @State private(set) var fontColor: Color
  @State private(set) var trackColor: Color
  @State private(set) var barColor: Color
  @State private(set) var completionColor: Color
  @State private(set) var min: Int
  private(set) var max: Int
  @Binding private(set) var isCompleted: Bool
  
  public init(min: Int, max: Int,
              width: CGFloat = 250, height: CGFloat = 250,
              borderWidth: CGFloat = 5.0,
              font: Font = .system(size: 20), fontColor: Color = .black,
              trackColor: Color = .black, barColor: Color = .orange,
              completionColor: Color = .green,
              isCompleted: Binding<Bool> = .constant(false)) {
    self.width = width
    self.height = height
    self.min = min
    self.max = max
    self.borderWidth = borderWidth
    self.font = font
    self.fontColor = fontColor
    self.trackColor = trackColor
    self.barColor = barColor
    self.completionColor = completionColor
    self._isCompleted = isCompleted
  }
  
  public var body: some View {
    VStack{
      ZStack{
        ProgressTrack(width: width, height: height,
                      borderWidth: borderWidth,
                      trackColor: trackColor)
        ProgressBar(width: width, height: height,
                    borderWidth: borderWidth,
                    barColor: barColor, completionColor: completionColor,
                    counter: min, countTo: max)
        Clock(font: font, fontColor: fontColor, counter: min, countTo: max)
      }
    }
    .onReceive(timer) { time in
      if (self.min < self.max) {
        self.min += 1
      }
      if self.min == self.max {
        self.isCompleted = true
      }
    }
  }
  
  @ViewBuilder
  public func borderWidth(_ width: CGFloat) -> CircularProgressTimer {
    CircularProgressTimer(min: self.min, max: self.max,
                     width: self.width, height: self.height,
                     borderWidth: width,
                     font: self.font, fontColor: self.fontColor,
                     trackColor: self.trackColor, barColor: self.barColor,
                     completionColor: self.completionColor,
                     isCompleted: self.$isCompleted)
  }
  
  
  public func clockSize(_ size: CGSize) -> CircularProgressTimer {
    var newWidth = size.width
    var newHeight = size.height
    if newWidth != newHeight {
      newWidth = Swift.max(newWidth, newHeight)
      newHeight = Swift.max(newWidth, newHeight)
    }
    return CircularProgressTimer(min: self.min, max: self.max,
                            width: newWidth, height: newHeight,
                            borderWidth: self.borderWidth,
                            font: self.font, fontColor: self.fontColor,
                            trackColor: self.trackColor, barColor: self.barColor,
                            completionColor: self.completionColor,
                            isCompleted: self.$isCompleted)
  }
  
  @ViewBuilder
  public func fontColor(_ color: Color) -> CircularProgressTimer {
    CircularProgressTimer(min: self.min, max: self.max,
                     width: self.width, height: self.height,
                     borderWidth: self.borderWidth,
                     font: self.font, fontColor: color,
                     trackColor: self.trackColor, barColor: self.barColor,
                     completionColor: self.completionColor,
                     isCompleted: self.$isCompleted)
  }
  
  @ViewBuilder
  public func trackColor(_ color: Color) -> CircularProgressTimer {
    CircularProgressTimer(min: self.min, max: self.max,
                     width: self.width, height: self.height,
                     borderWidth: self.borderWidth,
                     font: self.font, fontColor: self.fontColor,
                     trackColor: color, barColor: self.barColor,
                     completionColor: self.completionColor,
                     isCompleted: self.$isCompleted)
  }
  
  @ViewBuilder
  public func barColor(_ color: Color) -> CircularProgressTimer {
    CircularProgressTimer(min: self.min, max: self.max,
                     width: self.width, height: self.height,
                     borderWidth: self.borderWidth,
                     font: self.font, fontColor: self.fontColor,
                     trackColor: self.trackColor, barColor: color,
                     completionColor: self.completionColor,
                     isCompleted: self.$isCompleted)
  }
  
  @ViewBuilder
  public func completionColor(_ color: Color) -> CircularProgressTimer {
    CircularProgressTimer(min: self.min, max: self.max,
                     width: self.width, height: self.height,
                     borderWidth: self.borderWidth,
                     font: self.font, fontColor: self.fontColor,
                     trackColor: self.trackColor, barColor: self.barColor,
                     completionColor: color,
                     isCompleted: self.$isCompleted)
  }
  
  @ViewBuilder
  public func clockFont(_ newFont: Font) -> CircularProgressTimer {
    CircularProgressTimer(min: self.min, max: self.max,
                     width: self.width, height: self.height,
                     borderWidth: self.borderWidth,
                     font: newFont, fontColor: self.fontColor,
                     trackColor: self.trackColor, barColor: self.barColor,
                     completionColor: self.completionColor,
                     isCompleted: self.$isCompleted)
  }
}

@available(iOS 13.0.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
struct CircularProgressTimer_Previews: PreviewProvider {
  static var previews: some View {
    CircularProgressTimer(min: 0, max: 80)
      .clockSize(CGSizeMake(300, 300))
      .borderWidth(18)
      .fontColor(.black)
      .trackColor(.gray.opacity(0.2))
      .barColor(.orange)
      .completionColor(.green)
      .clockFont(.system(size: 70))
  }
}
