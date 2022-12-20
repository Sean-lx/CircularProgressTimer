//
//  Created by Sean Li on 2022/12/19.
//

import SwiftUI

@available(iOS 13.0.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
struct Clock: View {
  private(set) var fontColor: Color
  private(set) var counter: Int
  private(set) var countTo: Int
  
  var body: some View {
    VStack {
      Text(counterToMinutes())
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

@available(iOS 13.0.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
struct ProgressTrack: View {
  private(set) var width: CGFloat
  private(set) var height: CGFloat
  private(set) var borderWidth: CGFloat
  private(set) var trackColor: Color
  
  init(width: CGFloat = 250, height: CGFloat = 250,
       borderWidth: CGFloat,
       trackColor: Color) {
    self.width = width
    self.height = height
    self.borderWidth = borderWidth
    self.trackColor = trackColor
  }
  
  var body: some View {
    Circle()
      .fill(Color.clear)
      .frame(width: width, height: height)
      .overlay(
        Circle().stroke(trackColor, lineWidth: borderWidth)
      )
  }
}

@available(iOS 13.0.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
struct ProgressBar: View {
  private(set) var width: CGFloat
  private(set) var height: CGFloat
  private(set) var borderWidth: CGFloat
  private(set) var barColor: Color
  private(set) var completionColor: Color
  private(set) var counter: Int
  private(set) var countTo: Int
  
  init(width: CGFloat = 250, height: CGFloat = 250,
       borderWidth: CGFloat,
       barColor: Color, completionColor: Color,
       counter: Int, countTo: Int) {
    self.width = width
    self.height = height
    self.counter = counter
    self.countTo = countTo
    self.borderWidth = borderWidth
    self.barColor = barColor
    self.completionColor = completionColor
  }
  
  var body: some View {
    Circle()
      .fill(Color.clear)
      .frame(width: width, height: height)
      .overlay(
        Circle().trim(from:0, to: progress())
          .stroke(
            style: StrokeStyle(
              lineWidth: borderWidth,
              lineCap: .round,
              lineJoin:.round
            )
          )
          .foregroundColor(
            (completed() ? completionColor : barColor)
          )
          .animation(.easeInOut(duration: 0.2), value: completed())
      )
  }
  
  private func completed() -> Bool {
    return progress() == 1
  }
  
  private func progress() -> CGFloat {
    return (CGFloat(counter) / CGFloat(countTo))
  }
}

@available(iOS 13.0.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public struct CPTCountdownView: View {
  private let timer = Timer
    .publish(every: 1, on: .main, in: .common)
    .autoconnect()
  @State private(set) var width: CGFloat
  @State private(set) var height: CGFloat
  @State private(set) var borderWidth: CGFloat
  @State private(set) var fontColor: Color
  @State private(set) var trackColor: Color
  @State private(set) var barColor: Color
  @State private(set) var completionColor: Color
  @State private(set) var min: Int
  private(set) var max: Int
  
  public init(min: Int, max: Int,
       width: CGFloat = 250, height: CGFloat = 250,
       borderWidth: CGFloat = 5.0,
       fontColor: Color = .black,
       trackColor: Color = .black, barColor: Color = .orange,
       completionColor: Color = .green) {
    self.width = width
    self.height = height
    self.min = min
    self.max = max
    self.borderWidth = borderWidth
    self.fontColor = fontColor
    self.trackColor = trackColor
    self.barColor = barColor
    self.completionColor = completionColor
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
        Clock(fontColor: fontColor, counter: min, countTo: max)
      }
    }
    .onReceive(timer) { time in
      if (self.min < self.max) {
        self.min += 1
      }
    }
  }
  
  @ViewBuilder
  public func borderWidth(_ width: CGFloat) -> CPTCountdownView {
    CPTCountdownView(min: self.min, max: self.max,
                     width: self.width, height: self.height,
                     borderWidth: width,
                     fontColor: self.fontColor,
                     trackColor: self.trackColor, barColor: self.barColor,
                     completionColor: self.completionColor)
  }
  
  @ViewBuilder
  public func clockSize(_ size: CGSize) -> CPTCountdownView {
    CPTCountdownView(min: self.min, max: self.max,
                     width: size.width, height: size.height,
                     borderWidth: self.borderWidth,
                     fontColor: self.fontColor,
                     trackColor: self.trackColor, barColor: self.barColor,
                     completionColor: self.completionColor)
  }
  
  @ViewBuilder
  public func fontColor(_ color: Color) -> CPTCountdownView {
    CPTCountdownView(min: self.min, max: self.max,
                     width: self.width, height: self.height,
                     borderWidth: self.borderWidth,
                     fontColor: color,
                     trackColor: self.trackColor, barColor: self.barColor,
                     completionColor: self.completionColor)
  }
  
  @ViewBuilder
  public func trackColor(_ color: Color) -> CPTCountdownView {
    CPTCountdownView(min: self.min, max: self.max,
                     width: self.width, height: self.height,
                     borderWidth: self.borderWidth,
                     fontColor: self.fontColor,
                     trackColor: color, barColor: self.barColor,
                     completionColor: self.completionColor)
  }
  
  @ViewBuilder
  public func barColor(_ color: Color) -> CPTCountdownView {
    CPTCountdownView(min: self.min, max: self.max,
                     width: self.width, height: self.height,
                     borderWidth: self.borderWidth,
                     fontColor: self.fontColor,
                     trackColor: self.trackColor, barColor: color,
                     completionColor: self.completionColor)
  }
  
  @ViewBuilder
  public func completionColor(_ color: Color) -> CPTCountdownView {
    CPTCountdownView(min: self.min, max: self.max,
                     width: self.width, height: self.height,
                     borderWidth: self.borderWidth,
                     fontColor: self.fontColor,
                     trackColor: self.trackColor, barColor: self.barColor,
                     completionColor: color)
  }
  
  @ViewBuilder
  public func clockFont(_ font: Font) -> some View {
    self.font(font)
  }
}

@available(iOS 13.0.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
struct CPTCountdownView_Previews: PreviewProvider {
  static var previews: some View {
    CPTCountdownView(min: 0, max: 30)
      .clockSize(CGSizeMake(300, 300))
      .borderWidth(10)
      .fontColor(.red)
      .trackColor(.blue)
      .barColor(.pink)
      .completionColor(.purple)
      .clockFont(.system(size: 70))
  }
}


