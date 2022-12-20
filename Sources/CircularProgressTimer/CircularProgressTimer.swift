//
//  Created by Sean Li on 2022/12/19.
//

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
  @Binding var isCompleted: Bool
  
  init(width: CGFloat = 250, height: CGFloat = 250,
       borderWidth: CGFloat,
       barColor: Color, completionColor: Color,
       counter: Int, countTo: Int,
       isCompleted: Binding<Bool>) {
    self.width = width
    self.height = height
    self.counter = counter
    self.countTo = countTo
    self.borderWidth = borderWidth
    self.barColor = barColor
    self.completionColor = completionColor
    self._isCompleted = isCompleted
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
    isCompleted = progress() == 1
    return isCompleted
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
  @State private(set) var font: Font
  @State private(set) var fontColor: Color
  @State private(set) var trackColor: Color
  @State private(set) var barColor: Color
  @State private(set) var completionColor: Color
  @State private(set) var min: Int
  private(set) var max: Int
  @State private(set) var isCompleted: Bool = false
  
  public init(min: Int, max: Int,
              width: CGFloat = 250, height: CGFloat = 250,
              borderWidth: CGFloat = 5.0,
              font: Font = .system(size: 20), fontColor: Color = .black,
              trackColor: Color = .black, barColor: Color = .orange,
              completionColor: Color = .green) {
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
                    counter: min, countTo: max, isCompleted: $isCompleted)
        Clock(font: font, fontColor: fontColor, counter: min, countTo: max)
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
                     font: self.font, fontColor: self.fontColor,
                     trackColor: self.trackColor, barColor: self.barColor,
                     completionColor: self.completionColor)
  }
  
  @ViewBuilder
  public func clockSize(_ size: CGSize) -> CPTCountdownView {
    CPTCountdownView(min: self.min, max: self.max,
                     width: size.width, height: size.height,
                     borderWidth: self.borderWidth,
                     font: self.font, fontColor: self.fontColor,
                     trackColor: self.trackColor, barColor: self.barColor,
                     completionColor: self.completionColor)
  }
  
  @ViewBuilder
  public func fontColor(_ color: Color) -> CPTCountdownView {
    CPTCountdownView(min: self.min, max: self.max,
                     width: self.width, height: self.height,
                     borderWidth: self.borderWidth,
                     font: self.font, fontColor: color,
                     trackColor: self.trackColor, barColor: self.barColor,
                     completionColor: self.completionColor)
  }
  
  @ViewBuilder
  public func trackColor(_ color: Color) -> CPTCountdownView {
    CPTCountdownView(min: self.min, max: self.max,
                     width: self.width, height: self.height,
                     borderWidth: self.borderWidth,
                     font: self.font, fontColor: self.fontColor,
                     trackColor: color, barColor: self.barColor,
                     completionColor: self.completionColor)
  }
  
  @ViewBuilder
  public func barColor(_ color: Color) -> CPTCountdownView {
    CPTCountdownView(min: self.min, max: self.max,
                     width: self.width, height: self.height,
                     borderWidth: self.borderWidth,
                     font: self.font, fontColor: self.fontColor,
                     trackColor: self.trackColor, barColor: color,
                     completionColor: self.completionColor)
  }
  
  @ViewBuilder
  public func completionColor(_ color: Color) -> CPTCountdownView {
    CPTCountdownView(min: self.min, max: self.max,
                     width: self.width, height: self.height,
                     borderWidth: self.borderWidth,
                     font: self.font, fontColor: self.fontColor,
                     trackColor: self.trackColor, barColor: self.barColor,
                     completionColor: color)
  }
  
  @ViewBuilder
  public func clockFont(_ font: Font) -> CPTCountdownView {
    CPTCountdownView(min: self.min, max: self.max,
                     width: self.width, height: self.height,
                     borderWidth: self.borderWidth,
                     font: font, fontColor: self.fontColor,
                     trackColor: self.trackColor, barColor: self.barColor,
                     completionColor: self.completionColor)
  }
  
  @ViewBuilder
  public func onCompletion(_ handler: @escaping (Bool) -> ()) -> some View {
    self.valueChanged(value: self.isCompleted) { completed in
      handler(completed)
    }
  }
}

@available(iOS 13.0.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
struct CPTCountdownView_Previews: PreviewProvider {
  static var previews: some View {
    CPTCountdownView(min: 0, max: 80)
      .clockSize(CGSizeMake(300, 300))
      .borderWidth(18)
      .fontColor(.black)
      .trackColor(.gray.opacity(0.2))
      .barColor(.orange)
      .completionColor(.green)
      .clockFont(.system(size: 70))
      .onCompletion { completed in
        if completed {
          /// Handle countdown completion
        }
      }
  }
}


