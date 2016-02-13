//
//  TVOSButtonText.swift
//  TVOSButton
//
//  Created by Cem Olcay on 12/02/16.
//  Copyright © 2016 MovieLaLa. All rights reserved.
//

import UIKit

// MARK: TVOSButtonLabel

public enum TVOSButtonLabel {
  case Custom(color: UIColor?, font: UIFont?, alignment: NSTextAlignment?, shadow: TVOSButtonShadow?)
  case DefaultText(color: UIColor?)
  case DefaultTitle(color: UIColor?)

  public func getStyle() -> TVOSButtonLabelStyle {
    switch self {
    case .Custom(let color, let font, let alignment, let shadow):
      return TVOSButtonLabelStyle(
        color: color, 
        font: font,
        alignment: alignment,
        shadow: shadow)
    case .DefaultText(let color):
      return TVOSButtonLabel.Custom(
        color: color,
        font: nil,
        alignment: nil,
        shadow: nil)
      .getStyle()
    case .DefaultTitle(let color):
      return TVOSButtonLabel.Custom(
        color: color,
        font: nil,
        alignment: nil,
        shadow: TVOSButtonShadow.Title)
        .getStyle()
    }
  }

  public func applyStyle(onLabel label: UILabel) {
    let style = getStyle()
    style.shadow?.applyStyle(onLayer: label.layer)
    label.textColor = style.color ?? UIColor.whiteColor()
    label.font = style.font ?? UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
    label.textAlignment = style.alignment ?? .Center
  }

  public static func resetStyle(onLabel label: UILabel) {
    TVOSButtonShadow.resetStyle(onLayer: label.layer)
  }
}

// MARK: - TVOSButtonLabelStyle

public struct TVOSButtonLabelStyle {
  public var color: UIColor?
  public var font: UIFont?
  public var alignment: NSTextAlignment?
  public var shadow: TVOSButtonShadow?
}
