//
//  TVOSButton.swift
//  TVOSButton
//
//  Created by Cem Olcay on 10/02/16.
//  Copyright © 2016 MovieLaLa. All rights reserved.
//

import UIKit
import ALKit

//
// -------------- \
// |  tvosBadge | } tvosButton
// |  tvosText  | } inside UIButton bounds
// -------------- /
//    tvosTitle   = outside UIButton bounds
//

// MARK: - TVOSButtonState

public enum TVOSButtonState: CustomStringConvertible {
  case Normal
  case Focused
  case Highlighted
  case Disabled

  public var description: String {
    switch self {
    case .Normal:
      return "Normal"
    case .Focused:
      return "Focused"
    case .Highlighted:
      return "Highlighted"
    case .Disabled:
      return "Disabled"
    }
  }
}

// MARK: - TVOSButtonStyle

public struct TVOSButtonStyle {

  // Button Style
  public var backgroundColor: UIColor?
  public var backgroundImage: UIImage?
  public var cornerRadius: CGFloat?
  public var scale: CGFloat?
  public var shadow: TVOSButtonShadow?

  // Button Content Style
  public var contentView: UIView?
  public var badgeStyle: TVOSButtonImage?
  public var textStyle: TVOSButtonLabel?
  public var titleStyle: TVOSButtonLabel?

  public func applyStyle(onButton button: TVOSButton) {
    // button
    button.tvosButton.backgroundColor = backgroundColor
    button.tvosButtonBackgroundImageView.image = backgroundImage
    button.tvosButton.layer.cornerRadius = cornerRadius ?? 0
    button.tvosButton.transform = CGAffineTransformMakeScale(scale ?? 1, scale ?? 1)

    // shadow
    if let shadow = shadow {
      shadow.applyStyle(onLayer: button.tvosButton.layer)
    } else {
      TVOSButtonShadow.resetStyle(onLayer: button.tvosButton.layer)
    }

    // content view
    if let contentView = contentView {
      button.tvosCustomContentView.addSubview(contentView)
    } else {
      for subview in button.tvosCustomContentView.subviews {
        subview.removeFromSuperview()
      }
    }

    // badge
    if let badge = badgeStyle {
      badge.applyStyle(onImageView: button.tvosBadge)
      button.tvosBadge.image = button.badgeImage
    } else {
      TVOSButtonImage.resetStyle(onImageView: button.tvosBadge)
      button.tvosBadge.image = nil
    }

    // text
    if let text = textStyle {
      text.applyStyle(onLabel: button.tvosTextLabel)
      button.tvosTextLabel.text = button.textLabelText
    } else {
      TVOSButtonLabel.resetStyle(onLabel: button.tvosTextLabel)
      button.tvosTextLabel.text = nil
    }

    // title
    if let title = titleStyle {
      title.applyStyle(onLabel: button.tvosTitleLabel)
      button.tvosTitleLabel.text = button.titleLabelText
    } else {
      TVOSButtonLabel.resetStyle(onLabel: button.tvosTitleLabel)
    }
  }

  public init(
    backgroundColor: UIColor? = nil,
    backgroundImage: UIImage? = nil,
    cornerRadius: CGFloat? = nil,
    scale: CGFloat? = nil,
    shadow: TVOSButtonShadow? = nil,
    contentView: UIView? = nil,
    badgeStyle: TVOSButtonImage? = nil,
    textStyle: TVOSButtonLabel? = nil,
    titleStyle: TVOSButtonLabel? = nil) {
      self.backgroundColor = backgroundColor
      self.backgroundImage = backgroundImage
      self.cornerRadius = cornerRadius
      self.scale = scale
      self.shadow = shadow
      self.contentView = contentView
      self.badgeStyle = badgeStyle
      self.textStyle = textStyle
      self.titleStyle = titleStyle
  }
}

// MARK: - TVOSButton

public class TVOSButton: UIButton {

  // MARK: Private Properties

  private var tvosButton: UIView!
  private var tvosButtonBackgroundImageView: UIImageView!
  private var tvosCustomContentView: UIView!
  private var tvosBadge: UIImageView!
  private var tvosTextLabel: UILabel!
  private var tvosTitleLabel: UILabel!
  private var tvosTitleLabelTopConstraint: NSLayoutConstraint!

  private(set) var tvosButtonState: TVOSButtonState = .Normal {
    didSet {
      handleStateDidChange()
    }
  }

  // MARK: Public Properties

  public var textLabelText: String?
  public var titleLabelText: String?
  public var badgeImage: UIImage?

  public override var enabled: Bool {
    didSet {
      tvosButtonState = enabled ? .Normal : .Disabled
    }
  }

  public override var highlighted: Bool {
    didSet {
      tvosButtonState = highlighted ? .Highlighted : .Focused
    }
  }

  // MARK: Init

  public override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }

  private func commonInit() {
    // remove super's subviews if set
    imageView?.image = nil
    titleLabel?.text = nil
    // tvosButton
    tvosButton = UIView()
    tvosButton.translatesAutoresizingMaskIntoConstraints = false
    addSubview(tvosButton)
    // tvosButtonBackgroundImage
    tvosButtonBackgroundImageView = UIImageView()
    tvosButtonBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
    tvosButton.addSubview(tvosButtonBackgroundImageView)
    // tvosCustomContentView
    tvosCustomContentView = UIView()
    tvosCustomContentView.translatesAutoresizingMaskIntoConstraints = false
    tvosButton.addSubview(tvosCustomContentView)
    // tvosBadge
    tvosBadge = UIImageView()
    tvosBadge.translatesAutoresizingMaskIntoConstraints = false
    tvosButton.addSubview(tvosBadge)
    // tvosTextLabel
    tvosTextLabel = UILabel()
    tvosTextLabel.translatesAutoresizingMaskIntoConstraints = false
    tvosButton.addSubview(tvosTextLabel)
    // tvosTitleLabel
    tvosTitleLabel = UILabel()
    tvosTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    addSubview(tvosTitleLabel)
    // add button constraints
    tvosButton.fill(toView: self)
    tvosButtonBackgroundImageView.fill(toView: tvosButton)
    tvosCustomContentView.fill(toView: tvosButton)
    tvosBadge.fill(toView: tvosButton)
    tvosTextLabel.fill(toView: tvosButton)
    // add title constraints
    tvosTitleLabel.fillHorizontal(toView: self)
    tvosTitleLabel.pinHeight(50)
    tvosTitleLabelTopConstraint = NSLayoutConstraint(
      item: tvosTitleLabel,
      attribute: .Top,
      relatedBy: .Equal,
      toItem: self,
      attribute: .Bottom,
      multiplier: 1, 
      constant: 0)
    addConstraint(tvosTitleLabelTopConstraint)
    // finalize
    layer.masksToBounds = false
    handleStateDidChange()
  }

  // MARK: Focus

  public override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
    if context.nextFocusedView == self {
      tvosButtonState = .Focused
    } else if context.previouslyFocusedView == self {
      tvosButtonState = .Normal
    }
  }

  // MARK: Handlers

  /// Override this function if you want to get notified about state changes.
  public func tvosButtonStateDidChange(tvosButtonState: TVOSButtonState) { }

  /// Override this function for style your subclass TVOSButton.
  public func tvosButtonStyleForState(tvosButtonState: TVOSButtonState) -> TVOSButtonStyle? {
    return nil
  }

  private func handleStateDidChange() {
    tvosButtonStateDidChange(tvosButtonState)
    if let style = tvosButtonStyleForState(tvosButtonState) {
      layoutIfNeeded()
      UIView.animateWithDuration(0.3,
        delay: 0,
        usingSpringWithDamping: 1,
        initialSpringVelocity: 0,
        options: .AllowAnimatedContent,
        animations: {
          self.tvosTitleLabelTopConstraint.constant = self.tvosButtonState == .Focused ? 20 : 0
          style.applyStyle(onButton: self)
          self.layoutIfNeeded()
        },
        completion: nil)
    }
  }
}
