//
//  TVOSButtonImage.swift
//  TVOSButton
//
//  Created by Cem Olcay on 12/02/16.
//  Copyright © 2016 MovieLaLa. All rights reserved.
//

import UIKit

public enum TVOSButtonImageGravity {
  case Fill
  case Fit
  case Top
  case Left
  case Right
  case Bottom
}

public enum TVOSButtonImage {
  case Custom(gravity: TVOSButtonImageGravity?, size: CGSize?, offsets: UIEdgeInsets?, cornerRadius: CGFloat?, backgroundColor: UIColor?)
  case Fill
  case Fit
  case Top
  case Left
  case Right
  case Bottom

  public func getStyle() -> TVOSButtonImageStyle {
    switch self {
    case .Custom(let gravity, let size, let offsets, let cornerRadius, let backgroundColor):
      return TVOSButtonImageStyle(
        gravity: gravity,
        size: size,
        offsets: offsets,
        cornerRadius: cornerRadius,
        backgroundColor: backgroundColor)

    case .Fill:
      return TVOSButtonImage.Custom(
        gravity: .Fill,
        size: nil,
        offsets: nil,
        cornerRadius: nil,
        backgroundColor: nil)
      .getStyle()

    case .Fit:
      return TVOSButtonImage.Custom(
        gravity: .Fit,
        size: nil,
        offsets: nil,
        cornerRadius: nil,
        backgroundColor: nil)
      .getStyle()

    case .Top:
      return TVOSButtonImage.Custom(
        gravity: .Top,
        size: nil,
        offsets: UIEdgeInsets(inset: 40), 
        cornerRadius: nil,
        backgroundColor: nil)
      .getStyle()

    case .Left:
      return TVOSButtonImage.Custom(
        gravity: .Left,
        size: nil,
        offsets: UIEdgeInsets(inset: 40),
        cornerRadius: nil,
        backgroundColor: nil)
      .getStyle()

    case .Right:
      return TVOSButtonImage.Custom(
        gravity: .Right, 
        size: nil, 
        offsets: UIEdgeInsets(inset: 40), 
        cornerRadius: nil, 
        backgroundColor: nil)
      .getStyle()

    case .Bottom:
      return TVOSButtonImage.Custom(
        gravity: .Bottom,
        size: nil,
        offsets: UIEdgeInsets(inset: 40),
        cornerRadius: nil, 
        backgroundColor: nil)
      .getStyle()
    }
  }

  public func applyStyle(onImageView imageView: UIImageView) {
    let style = getStyle()
    imageView.backgroundColor = style.backgroundColor
    imageView.layer.cornerRadius = style.cornerRadius ?? 0
    imageView.layer.masksToBounds = true
    switch self {
    case .Fill(_):
      imageView.contentMode = .ScaleAspectFill
    default:
      imageView.contentMode = .ScaleAspectFit
    }
  }

  public static func resetStyle(onImageView imageView: UIImageView) {
    imageView.image = nil
    imageView.backgroundColor = nil
    imageView.layer.cornerRadius = 0
  }
}

public struct TVOSButtonImageStyle {
  public var gravity: TVOSButtonImageGravity?
  public var size: CGSize?
  public var offsets: UIEdgeInsets?
  public var cornerRadius: CGFloat?
  public var backgroundColor: UIColor?
}
