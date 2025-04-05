//
//  TopRoundedRectangle.swift
//  FinePay
//
//  Created by Yunhong on 4/5/25.
//

import SwiftUI

struct TopRoundedRectangle: Shape {
  var cornerRadius: CGFloat = 30
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    path.move(to: CGPoint(x: 0, y: rect.maxY))
    path.addLine(to: CGPoint(x: 0, y: rect.minY + cornerRadius))
    path.addQuadCurve(to: CGPoint(x: cornerRadius, y: rect.minY),
                      control: CGPoint(x: 0, y: rect.minY))
    path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))
    path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY + cornerRadius),
                      control: CGPoint(x: rect.maxX, y: rect.minY))
    path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
    path.closeSubpath()
    
    return path
  }
}
