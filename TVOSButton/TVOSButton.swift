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
    } else {
      TVOSButtonImage.resetStyle(onImageView: button.tvosBadge)
    }
    // text
    if let text = textStyle {
      text.applyStyle(onLabel: button.tvosTextLabel)
    } else {
      TVOSButtonLabel.resetStyle(onLabel: button.tvosTextLabel)
    }
    // title
    if let title = titleStyle {
      title.applyStyle(onLabel: button.tvosTitleLabel)
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

public typealias TVOSButtonStateDidChange = (tvosButtonState: TVOSButtonState) -> Void
public typealias TVOSButtonStyleForState = (tvosButtonState: TVOSButtonState) -> TVOSButtonStyle

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
      tvosButtonStateDidChange()
    }
  }

  // MARK: Public Properties

  public var textLabelText: String? {
    didSet {
      tvosTextLabel.text = textLabelText
    }
  }

  public var titleLabelText: String? {
    didSet {
      tvosTitleLabel.text = titleLabelText
    }
  }

  public var badgeImage: UIImage? {
    didSet {
      tvosBadge.image = badgeImage
    }
  }

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

  // MARK: Actions

  public var tvosButtonStateDidChangeAction: TVOSButtonStateDidChange? {
    didSet {
      tvosButtonStateDidChange()
    }
  }

  public var tvosButtonStyleForStateAction: TVOSButtonStyleForState? {
    didSet {
      tvosButtonStateDidChange()
    }
  }

  // MARK: Init

  public init(frame: CGRect,
    styleForState: TVOSButtonStyleForState? = nil,
    stateDidChange: TVOSButtonStateDidChange? = nil) {
    super.init(frame: frame)
    tvosButtonStyleForStateAction = styleForState
    tvosButtonStateDidChangeAction = stateDidChange
    commonInit()
  }

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
    // add title constraints
    tvosTitleLabel.fillHorizontal(toView: self)
    tvosTitleLabel.pinHeight(50)
    tvosTitleLabelTopConstraint = NSLayoutConstraint(item: tvosTitleLabel, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0)
    addConstraint(tvosTitleLabelTopConstraint)
    // finalize
    layer.masksToBounds = false
    tvosButtonStateDidChange()
  }

  // MARK: State

  private func tvosButtonStateDidChange() {
    tvosButtonStateDidChangeAction?(tvosButtonState: tvosButtonState)
    if let style = tvosButtonStyleForStateAction?(tvosButtonState: tvosButtonState) {
      layoutIfNeeded()
      UIView.animateWithDuration(0.3,
        delay: 0,
        usingSpringWithDamping: 1,
        initialSpringVelocity: 0,
        options: UIViewAnimationOptions.AllowAnimatedContent,
        animations: {
          self.tvosTitleLabelTopConstraint.constant = self.tvosButtonState == .Focused ? 20 : 0
          style.applyStyle(onButton: self)
          self.layoutIfNeeded()
        },
        completion: nil)
    }
  }
}

// MARK: - Focus

public extension TVOSButton {

  public override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
    if context.nextFocusedView == self {
      tvosButtonState = .Focused
    } else if context.previouslyFocusedView == self {
      tvosButtonState = .Normal
    }
  }
}

// MARK: - Layout

public extension TVOSButton {

  private func setupButtonContentConstraintsForBadgeStyle(badge: TVOSButtonImage?) {
    // default constraints
    func setupDefaultConstraints() {
      tvosBadge.contentMode = .ScaleAspectFit
      tvosBadge.fill(toView: tvosButton)
      tvosTextLabel.fill(toView: tvosButton)
    }

    // Remove constraints
    tvosTextLabel.removeConstraints(tvosTextLabel.constraints)
    tvosBadge.removeConstraints(tvosBadge.constraints)

    // get style
    guard let badge = badge else { return setupDefaultConstraints() }
    let style = badge.getStyle()
    let gravity = style.gravity
    let size = style.size
    let offsets = style.offsets

    // apply constraints for style
    if let badgeGravity = gravity {
      switch badgeGravity {
      case .Fill:
        tvosBadge.contentMode = .ScaleAspectFill
        tvosBadge.fill(toView: tvosButton)
        tvosTextLabel.fill(toView: tvosButton)

      case .Top:
        tvosBadge.contentMode = .ScaleAspectFit
        switch (size, offsets) {
        case (.Some(let s), .Some(let o)):
          tvosBadge.pinTop(toView: tvosButton, withInset: o.top)
          tvosBadge.pinSize(width: s.width, height: s.height)
        case (.Some(let s), .None):
          tvosBadge.pinTop(toView: tvosButton, withInset: offsets?.top ?? 0)
          tvosBadge.pinSize(width: s.width, height: s.height)
        default:
          tvosBadge.pinTop(toView: tvosButton, withInset: offsets?.top ?? 0)
          tvosBadge.fillHorizontal(toView: tvosButton)
          tvosBadge.pinToTop(ofView: tvosTextLabel, withOffset: offsets?.bottom ?? 0)
        }
        tvosTextLabel.fillHorizontal(toView: tvosButton)
        tvosTextLabel.pinBottom(toView: tvosButton)

      case .Left:
        tvosBadge.contentMode = .ScaleAspectFit
        switch (size, offsets) {
        case (.Some(let s), .Some(let o)):
          tvosBadge.pinLeft(toView: tvosButton, withInset: o.left)
          tvosBadge.pinSize(width: s.width, height: s.height)
        case (.Some(let s), .None):
          tvosBadge.pinLeft(toView: tvosButton)
          tvosBadge.pinSize(width: s.width, height: s.height)
        default:
          tvosBadge.pinTop(toView: tvosButton, withInset: offsets?.top ?? 0)
          tvosBadge.pinLeft(toView: tvosButton, withInset: offsets?.left ?? 0)
          tvosBadge.pinBottom(toView: tvosButton, withInset: offsets?.bottom ?? 0)
          tvosBadge.pinToLeft(ofView: tvosTextLabel, withOffset: offsets?.right ?? 0)
        }
        tvosTextLabel.pinTop(toView: tvosButton)
        tvosTextLabel.pinRight(toView: tvosButton)
        tvosTextLabel.pinBottom(toView: tvosButton)

      case .Right:
        tvosBadge.contentMode = .ScaleAspectFit
        switch (size, offsets) {
        case (.Some(let s), .Some(let o)):
          tvosBadge.pinRight(toView: tvosButton, withInset: o.right)
          tvosBadge.pinSize(width: s.width, height: s.height)
        case (.Some(let s), .None):
          tvosBadge.pinRight(toView: tvosButton)
          tvosBadge.pinSize(width: s.width, height: s.height)
        default:
          tvosBadge.pinTop(toView: tvosButton, withInset: offsets?.top ?? 0)
          tvosBadge.pinRight(toView: tvosButton, withInset: offsets?.right ?? 0)
          tvosBadge.pinBottom(toView: tvosButton, withInset: offsets?.bottom ?? 0)
          tvosBadge.pinToRight(ofView: tvosButton, withOffset: offsets?.right ?? 0)
        }
        tvosTextLabel.pinTop(toView: tvosButton)
        tvosTextLabel.pinLeft(toView: tvosButton)
        tvosTextLabel.pinBottom(toView: tvosButton)

      case .Bottom:
        tvosBadge.contentMode = .ScaleAspectFit
        switch (size, offsets) {
        case (.Some(let s), .Some(let o)):
          tvosBadge.pinBottom(toView: tvosButton, withInset: o.bottom)
          tvosBadge.pinSize(width: s.width, height: s.height)
        case (.Some(let s), .None):
          tvosBadge.pinBottom(toView: tvosButton)
          tvosBadge.pinSize(width: s.width, height: s.height)
        default:
          tvosBadge.fillHorizontal(toView: tvosButton, withInset: offsets?.left ?? 0)
          tvosBadge.pinBottom(toView: tvosButton)
          tvosBadge.pinToTop(ofView: tvosTextLabel, withOffset: offsets?.top ?? 0)
        }
        tvosTextLabel.pinTop(toView: tvosButton)
        tvosTextLabel.fillHorizontal(toView: tvosButton)

      default:
        setupDefaultConstraints()
      }
    } else {
      setupDefaultConstraints()
    }
  }

  public override func updateConstraints() {
    if let style = tvosButtonStyleForStateAction?(tvosButtonState: tvosButtonState) {
      setupButtonContentConstraintsForBadgeStyle(style.badgeStyle)
    }
    super.updateConstraints()
  }
}
