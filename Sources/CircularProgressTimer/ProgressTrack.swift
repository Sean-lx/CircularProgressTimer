//
//  SwiftUIView.swift
//  
//
//  Created by Sean Li on 2022/12/20.
//

import SwiftUI

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
