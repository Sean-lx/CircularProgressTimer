//
//  SwiftUIView.swift
//  
//
//  Created by Sean Li on 2022/12/20.
//

import SwiftUI

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
