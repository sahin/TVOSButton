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
  case Custom(text: String?, color: UIColor?, font: UIFont?, alignment: NSTextAlignment?, shadow: TVOSButtonShadow?)
  case AttributedString(attributedText: NSAttributedString?, alignment: NSTextAlignment?)
  case DefaultText(text: String?, color: UIColor?)
  case DefaultTitle(title: String?, color: UIColor?)

  public func getStyle() -> TVOSButtonLabelStyle {
    switch self {
    case .Custom(let text, let color, let font, let alignment, let shadow):
      return TVOSButtonLabelStyle(
        text: text,
        attributedText: nil,
        color: color, 
        font: font,
        alignment: alignment,
        shadow: shadow)
    case .AttributedString(let attributedText, let alignment):
      return TVOSButtonLabelStyle(
        text: nil,
        attributedText: attributedText,
        color: nil,
        font: nil,
        alignment: alignment,
        shadow: nil)
    case .DefaultText(let text, let color):
      return TVOSButtonLabel.Custom(
        text: text,
        color: color,
        font: nil,
        alignment: nil,
        shadow: nil)
      .getStyle()
    case .DefaultTitle(let text, let color):
      return TVOSButtonLabel.Custom(
        text: text,
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
    label.textAlignment = style.alignment ?? .Center
    if let attributedText = style.attributedText {
      label.attributedText = attributedText
    } else {
      label.text = style.text
      label.textColor = style.color ?? UIColor.whiteColor()
      label.font = style.font ?? UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
    }
  }

  public static func resetStyle(onLabel label: UILabel) {
    TVOSButtonShadow.resetStyle(onLayer: label.layer)
    label.text = nil
  }
}

// MARK: - TVOSButtonLabelStyle

public struct TVOSButtonLabelStyle {
  public var text: String?
  public var attributedText: NSAttributedString?
  public var color: UIColor?
  public var font: UIFont?
  public var alignment: NSTextAlignment?
  public var shadow: TVOSButtonShadow?
}
