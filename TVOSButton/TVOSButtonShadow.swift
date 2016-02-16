//
//  TVOSButtonShadow.swift
//  TVOSButton
//
//  Created by Cem Olcay on 12/02/16.
//  Copyright © 2016 MovieLaLa. All rights reserved.
//

import UIKit

public enum TVOSButtonShadow {
  case Custom(color: UIColor?, offset: CGSize?, opacity: Float?, radius: CGFloat?, path: UIBezierPath?)
  case Default(offsetX: CGFloat, offsetY: CGFloat, radius: CGFloat)
  case Focused
  case Highlighted
  case TitleLabel

  public func getStyle(withHeight height: CGFloat) -> TVOSButtonShadowStyle {
    switch self {
    case .Custom(let color, let offset, let opacity, let radius, let path):
      return TVOSButtonShadowStyle(
        color: color,
        offset: offset,
        opacity: opacity,
        radius: radius,
        path: path)

    case .Default(let x, let y, let r):
      return TVOSButtonShadowStyle(
        color: UIColor.blackColor(),
        offset: CGSize(width: x, height: y),
        opacity: 0.2,
        radius: r,
        path: nil)

    case .Focused:
      return TVOSButtonShadow.Default(
        offsetX: 0,
        offsetY: 25,
        radius: 10)
        .getStyle(withHeight: height)

    case .Highlighted:
      return TVOSButtonShadow.Default(
        offsetX: 0,
        offsetY: 5,
        radius: 10)
        .getStyle(withHeight: height)

    case .TitleLabel:
      return TVOSButtonShadow.Default(
        offsetX: 0,
        offsetY: 2,
        radius: 3)
      .getStyle(withHeight: height)
    }
  }

  public func applyStyle(onLayer layer: CALayer?) {
    guard let layer = layer else { return }
    let style = getStyle(withHeight: layer.frame.height)
    layer.shadowColor = style.color?.CGColor
    layer.shadowOffset = style.offset ?? CGSize.zero
    layer.shadowOpacity = style.opacity ?? 1
    layer.shadowPath = style.path?.CGPath
    layer.shadowRadius = style.radius ?? 0
  }

  public static func resetStyle(onLayer layer: CALayer?) {
    guard let layer = layer else { return }
    layer.shadowColor = nil
    layer.shadowOffset = CGSize.zero
    layer.shadowOpacity = 0
    layer.shadowPath = nil
    layer.shadowRadius = 0
  }
}

public struct TVOSButtonShadowStyle {
  public var color: UIColor?
  public var offset: CGSize?
  public var opacity: Float?
  public var radius: CGFloat?
  public var path: UIBezierPath?
}
