//
//  Created by Sean Li on 2022/12/19.
//

import SwiftUI

@available(iOS 13.0.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
struct Clock: View {
  private(set) var counter: Int
  private(set) var countTo: Int
  
  var body: some View {
    VStack {
      Text(counterToMinutes())
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
  
  init(width: CGFloat = 250, height: CGFloat = 250,
       borderWidth: CGFloat) {
    self.width = width
    self.height = height
    self.borderWidth = borderWidth
  }
  
  var body: some View {
    Circle()
      .fill(Color.clear)
      .frame(width: width, height: height)
      .overlay(
        Circle().stroke(Color.black, lineWidth: borderWidth)
      )
  }
}

@available(iOS 13.0.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
struct ProgressBar: View {
  private(set) var width: CGFloat
  private(set) var height: CGFloat
  private(set) var borderWidth: CGFloat
  private(set) var counter: Int
  private(set) var countTo: Int
  
  init(width: CGFloat = 250, height: CGFloat = 250,
       borderWidth: CGFloat,
       counter: Int, countTo: Int) {
    self.width = width
    self.height = height
    self.counter = counter
    self.countTo = countTo
    self.borderWidth = borderWidth
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
            (completed() ? Color.green : Color.orange)
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
  @State private(set) var counter: Int
  private(set) var countTo: Int
  
  init(counter: Int, countTo: Int,
       width: CGFloat = 250, height: CGFloat = 250,
       borderWidth: CGFloat = 5.0) {
    self.width = width
    self.height = height
    self.counter = counter
    self.countTo = countTo
    self.borderWidth = borderWidth
  }
  
  public var body: some View {
    VStack{
      ZStack{
        ProgressTrack(width: width, height: height,
                      borderWidth: borderWidth)
        ProgressBar(width: width, height: height,
                    borderWidth: borderWidth,
                    counter: counter, countTo: countTo)
        Clock(counter: counter, countTo: countTo)
      }
    }
    .onReceive(timer) { time in
      if (self.counter < self.countTo) {
        self.counter += 1
      }
    }
  }
  
  @ViewBuilder
  func borderWidth(_ width: CGFloat) -> CPTCountdownView {
    CPTCountdownView(counter: self.counter, countTo: self.countTo,
                  width: self.width ,height: self.height,
                  borderWidth: width)
  }
  
  @ViewBuilder
  func clockSize(_ size: CGSize) -> CPTCountdownView {
    CPTCountdownView(counter: self.counter, countTo: self.countTo,
                  width: size.width, height: size.height,
                  borderWidth: self.borderWidth)
  }
  
  @ViewBuilder
  func clockFont(_ font: Font) -> some View {
    self.font(font)
  }
}

@available(iOS 13.0.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
struct CPTCountdownView_Previews: PreviewProvider {
  static var previews: some View {
    CPTCountdownView(counter: 0, countTo: 30)
      .clockSize(CGSizeMake(300, 300))
      .borderWidth(20)
      .clockFont(.system(size: 70))
  }
}


