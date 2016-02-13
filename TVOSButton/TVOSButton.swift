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
  // Badge Style
  public var badge: TVOSButtonImage?
  // Text Label Style
  public var text: TVOSButtonLabel?
  // Title Label Style
  public var title: TVOSButtonLabel?

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
    // badge
    if let badge = badge {
      badge.applyStyle(onImageView: button.tvosBadge)
    } else {
      TVOSButtonImage.resetStyle(onImageView: button.tvosBadge)
    }
    // text
    if let text = text {
      text.applyStyle(onLabel: button.tvosTextLabel)
    } else {
      TVOSButtonLabel.resetStyle(onLabel: button.tvosTextLabel)
    }
    // title
    if let title = title {
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
    badge: TVOSButtonImage? = nil,
    text: TVOSButtonLabel? = nil,
    title: TVOSButtonLabel? = nil) {
      self.backgroundColor = backgroundColor
      self.backgroundImage = backgroundImage
      self.cornerRadius = cornerRadius
      self.scale = scale
      self.shadow = shadow
      self.badge = badge
      self.text = text
      self.title = title
  }
}

// MARK: - TVOSButton

public typealias TVOSButtonDidPressed = (tvosButton: TVOSButton) -> Void
public typealias TVOSButtonStateDidChange = (tvosButtonState: TVOSButtonState) -> Void
public typealias TVOSButtonStyleForState = (tvosButtonState: TVOSButtonState) -> TVOSButtonStyle

public class TVOSButton: UIButton {

  // MARK: Properties

  private var tvosButton: UIView!
  private var tvosButtonBackgroundImageView: UIImageView!
  private var tvosBadge: UIImageView!
  private var tvosTextLabel: UILabel!
  private var tvosTitleLabel: UILabel!

  private(set) var tvosButtonState: TVOSButtonState = .Normal {
    didSet {
      tvosButtonStateDidChange()
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

  public var tvosButtonDidPressedAction: TVOSButtonDidPressed?

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
    // finalize
    layer.masksToBounds = false
    tvosButtonStateDidChange()
  }

  // MARK: State

  private func tvosButtonStateDidChange() {
    tvosButtonStateDidChangeAction?(tvosButtonState: tvosButtonState)
    if let style = tvosButtonStyleForStateAction?(tvosButtonState: tvosButtonState) {
      UIView.animateWithDuration(0.3,
        delay: 0,
        usingSpringWithDamping: 1,
        initialSpringVelocity: 0,
        options: UIViewAnimationOptions.AllowAnimatedContent,
        animations: {
          style.applyStyle(onButton: self)
          self.setNeedsLayout()
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

  private func setupButtonContentConstraintsForImage(image: TVOSButtonImage?) {
    // default constraints
    func setupDefaultConstraints() {
      tvosBadge.contentMode = .ScaleAspectFit
      tvosBadge.fill(toView: tvosButton)
      tvosTextLabel.fill(toView: tvosButton)
    }

    // get style
    guard let image = image else { return setupDefaultConstraints() }
    let style = image.getStyle()
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
        case (.Some(let s), .Some(_)):
          tvosBadge.pinSize(width: s.width, height: s.height)
        case (.Some(let s), .None):
          tvosBadge.pinSize(width: s.width, height: s.height)
        default:
          tvosBadge.pinTop(inView: nil, toView: tvosButton, withInset: offsets?.top ?? 0)
          tvosBadge.fillHorizontal(toView: tvosButton, withInset: offsets?.left ?? 0)
          tvosBadge.pinToTop(inView: tvosButton, toView: tvosTextLabel, withOffset: offsets?.bottom ?? 0)
        }
        tvosTextLabel.fillHorizontal(toView: tvosButton)
        tvosTextLabel.pinBottom(toView: tvosButton)

      case .Left:
        tvosBadge.contentMode = .ScaleAspectFit
        switch (size, offsets) {
        case (.Some(let s), .Some(_)):
          tvosBadge.pinSize(width: s.width, height: s.height)
        case (.Some(let s), .None):
          tvosBadge.pinSize(width: s.width, height: s.height)
        default:
          tvosBadge.pinTop(inView: nil, toView: tvosButton, withInset: offsets?.top ?? 0)
          tvosBadge.pinLeft(inView: nil, toView: tvosButton, withInset: offsets?.left ?? 0)
          tvosBadge.pinBottom(inView: nil, toView: tvosButton, withInset: offsets?.bottom ?? 0)
          tvosBadge.pinToLeft(inView: tvosButton, toView: tvosTextLabel, withOffset: offsets?.right ?? 0)
        }
        tvosTextLabel.pinTop(toView: tvosButton)
        tvosTextLabel.pinRight(toView: tvosButton)
        tvosTextLabel.pinBottom(toView: tvosButton)

      case .Right:
        tvosBadge.contentMode = .ScaleAspectFit
        switch (size, offsets) {
        case (.Some(let s), .Some(_)):
          tvosBadge.pinSize(width: s.width, height: s.height)
        case (.Some(let s), .None):
          tvosBadge.pinSize(width: s.width, height: s.height)
        default:
          tvosBadge.pinTop(inView: nil, toView: tvosButton, withInset: offsets?.top ?? 0)
          tvosBadge.pinRight(inView: nil, toView: tvosButton, withInset: offsets?.right ?? 0)
          tvosBadge.pinBottom(inView: nil, toView: tvosButton, withInset: offsets?.bottom ?? 0)
          tvosBadge.pinToRight(inView: tvosButton, toView: tvosButton, withOffset: offsets?.right ?? 0)
        }
        tvosTextLabel.pinTop(toView: tvosButton)
        tvosTextLabel.pinLeft(toView: tvosButton)
        tvosTextLabel.pinBottom(toView: tvosButton)

      case .Bottom:
        tvosBadge.contentMode = .ScaleAspectFit
        switch (size, offsets) {
        case (.Some(let s), .Some(_)):
          tvosBadge.pinSize(width: s.width, height: s.height)
        case (.Some(let s), .None):
          tvosBadge.pinSize(width: s.width, height: s.height)
        default:
          tvosBadge.fillHorizontal(toView: tvosButton, withInset: offsets?.left ?? 0)
          tvosBadge.pinBottom(toView: tvosButton)
          tvosBadge.pinToTop(inView: tvosButton, toView: tvosTextLabel, withOffset: offsets?.top ?? 0)
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

  private func setupConstraintsForStyle(style: TVOSButtonStyle) {
    // setup button constraints
    tvosButton.fill(toView: self)
    tvosButtonBackgroundImageView.fill(toView: tvosButton)
    // setup title constraints label
    tvosTitleLabel.pinToBottom(toView: self)
    tvosTitleLabel.fillHorizontal(toView: self)
    tvosTitleLabel.pinHeight(50)
    // setup content constraints
    setupButtonContentConstraintsForImage(style.badge)
  }

  private func setupConstraints() {
    // Remove constraints
    tvosTextLabel.removeConstraints(tvosTextLabel.constraints)
    tvosBadge.removeConstraints(tvosBadge.constraints)
    tvosButtonBackgroundImageView.removeConstraints(tvosButtonBackgroundImageView.constraints)
    tvosButton.removeConstraints(tvosButton.constraints)
    tvosTitleLabel.removeConstraints(tvosTitleLabel.constraints)
    removeConstraints(constraints)
    // Add constraints for style
    if let style = tvosButtonStyleForStateAction?(tvosButtonState: tvosButtonState) {
      setupConstraintsForStyle(style)
    }
  }

  public override func updateConstraints() {
    setupConstraints()
    super.updateConstraints()
  }
}
