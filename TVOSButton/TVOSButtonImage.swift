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
  case Custom(image: UIImage?, gravity: TVOSButtonImageGravity?, size: CGSize?, offsets: UIEdgeInsets?, cornerRadius: CGFloat?, backgroundColor: UIColor?)
  case Fill(image: UIImage)
  case Fit(image: UIImage)
  case Top(image: UIImage)
  case Left(image: UIImage)
  case Right(image: UIImage)
  case Bottom(image: UIImage)

  public func getStyle() -> TVOSButtonImageStyle {
    switch self {
    case .Custom(let image, let gravity, let size, let offsets, let cornerRadius, let backgroundColor):
      return TVOSButtonImageStyle(image: image, gravity: gravity, size: size, offsets: offsets, cornerRadius: cornerRadius, backgroundColor: backgroundColor)
    case .Fill(let image):
      return TVOSButtonImage.Custom(image: image, gravity: .Fill, size: nil, offsets: nil, cornerRadius: nil, backgroundColor: nil).getStyle()
    case .Fit(let image):
      return TVOSButtonImage.Custom(image: image, gravity: .Fit, size: nil, offsets: nil, cornerRadius: nil, backgroundColor: nil).getStyle()
    case .Top(let image):
      return TVOSButtonImage.Custom(image: image, gravity: .Top, size: nil, offsets: UIEdgeInsets(inset: 40), cornerRadius: nil, backgroundColor: nil).getStyle()
    case .Left(let image):
      return TVOSButtonImage.Custom(image: image, gravity: .Left, size: nil, offsets: UIEdgeInsets(inset: 40), cornerRadius: nil, backgroundColor: nil).getStyle()
    case .Right(let image):
      return TVOSButtonImage.Custom(image: image, gravity: .Right, size: nil, offsets: UIEdgeInsets(inset: 40), cornerRadius: nil, backgroundColor: nil).getStyle()
    case .Bottom(let image):
      return TVOSButtonImage.Custom(image: image, gravity: .Bottom, size: nil, offsets: UIEdgeInsets(inset: 40), cornerRadius: nil, backgroundColor: nil).getStyle()
    }
  }

  public func applyStyle(onImageView imageView: UIImageView) {
    let style = getStyle()
    imageView.image = style.image
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
  public var image: UIImage?
  public var gravity: TVOSButtonImageGravity?
  public var size: CGSize?
  public var offsets: UIEdgeInsets?
  public var cornerRadius: CGFloat?
  public var backgroundColor: UIColor?
}
