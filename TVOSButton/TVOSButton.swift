//
//  TVOSButton.swift
//  TVOSButton
//
//  Created by Cem Olcay on 10/02/16.
//  Copyright © 2016 MovieLaLa. All rights reserved.
//

import UIKit

// MARK: - TVOSButtonShadow

public struct TVOSButtonShadow {
  public var color: UIColor = UIColor.blackColor()
  public var offset: CGSize = CGSize.zero
  public var opacity: Float = 0
  public var path: UIBezierPath?
  public var radius: CGFloat = 0

  public func applyShadow(onLayer layer: CALayer) {
    layer.shadowColor = color.CGColor
    layer.shadowOffset = offset
    layer.shadowOpacity = opacity
    layer.shadowPath = path?.CGPath
    layer.shadowRadius = radius
  }
}

// MARK: - TVOSButtonImage

public enum TVOSButtonImageGravity {
  case Fill
  case Fit(size: CGSize?, origin: CGPoint?, offset: UIEdgeInsets?)
  case Top(size: CGSize?, origin: CGPoint?, offset: UIEdgeInsets?)
  case Left(size: CGSize?, origin: CGPoint?, offset: UIEdgeInsets?)
  case Right(size: CGSize?, origin: CGPoint?, offset: UIEdgeInsets?)
  case Bottom(size: CGSize?, origin: CGPoint?, offset: UIEdgeInsets?)
}

public struct TVOSButtonImage {
  public var image: UIImage?
  public var gravity: TVOSButtonImageGravity = .Fill
  public var shadow: TVOSButtonShadow?
}

// MARK: - TVOSButtonText

public struct TVOSButtonText {
  public var text: String?
  public var attributedText: NSAttributedString?
  public var color: UIColor = UIColor.blackColor()
  public var font: UIFont = UIFont.systemFontOfSize(15)
  public var alignment: NSTextAlignment = .Center
  public var shadow: TVOSButtonShadow?
}

// MARK: - TVOSButton

public enum TVOSButtonState {
  case Normal
  case Focused
  case Highlighted
  case Selected
  case Disabled
}

public struct TVOSButtonStyle {
  public var image: TVOSButtonImage?
  public var text: TVOSButtonText?
  public var title: TVOSButtonText?
}

public typealias TVOSButtonStateDidChange = (tvosButtonState: TVOSButtonState) -> Void
public typealias TVOSButtonStyleForState = (tvosButtonState: TVOSButtonState) -> TVOSButtonStyle

public class TVOSButton: UIButton {

  private var tvosContainerView: UIView!
  private var tvosImageView: UIImageView!
  private var tvosTextLabel: UILabel!
  private var tvosTitleLabel: UILabel!

  private(set) var tvosState: TVOSButtonState = .Normal {
    didSet {
      tvosButtonStateDidChange()
    }
  }

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

  public init(frame: CGRect,
    styleForState: TVOSButtonStyleForState? = nil,
    stateDidChange: TVOSButtonStateDidChange? = nil) {
    super.init(frame: frame)
    tvosButtonStyleForStateAction = styleForState
    tvosButtonStateDidChangeAction = stateDidChange
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }

  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }

  private func commonInit() {
    // setup subviews
    // add state observer
    addObserver(self, forKeyPath: "state", options: .New, context: nil)
    // finalize
    tvosButtonStateDidChange()
  }
}

// MARK: - Observer

public extension TVOSButton {

  public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
    super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
    UIControlState.Reserved
    if keyPath == "state" {
      switch state {
      case UIControlState.Normal, UIControlState.Reserved, UIControlState.Application:
        tvosState = .Normal
      case UIControlState.Focused:
        tvosState = .Focused
      case UIControlState.Selected:
        tvosState = .Selected
      case UIControlState.Highlighted:
        tvosState = .Highlighted
      case UIControlState.Selected:
        tvosState = .Selected
      case UIControlState.Disabled:
        tvosState = .Disabled
      default:
        tvosState = .Normal
      }
    }
  }
}

// MARK: - TVOSButtonState

public extension TVOSButton {

  private func tvosButtonStateDidChange() {
    if let style = tvosButtonStyleForStateAction?(tvosButtonState: tvosState) {
      applyStyle(style)
    }
    setNeedsLayout()
    layoutIfNeeded()
  }

  public override func updateConstraints() {
    removeConstraints(constraints)
    tvosImageView.removeConstraints(tvosImageView.constraints)
    tvosTextLabel.removeConstraints(tvosTextLabel.constraints)
    tvosTitleLabel.removeConstraints(tvosTitleLabel.constraints)
    // TODO: Add Constraints
    super.updateConstraints()
  }
}

// MARK: - TVOSButtonStyle

public extension TVOSButton {

  private func applyStyle(style: TVOSButtonStyle) {
    // TODO: Apply Style
  }
}