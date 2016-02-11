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
  case Fit(size: CGSize?, offset: UIEdgeInsets?)
  case Top(size: CGSize?, offset: UIEdgeInsets?)
  case Left(size: CGSize?, offset: UIEdgeInsets?)
  case Right(size: CGSize?, offset: UIEdgeInsets?)
  case Bottom(size: CGSize?, offset: UIEdgeInsets?)
}

public struct TVOSButtonImage {
  public var image: UIImage?
  public var gravity: TVOSButtonImageGravity = .Fill
  public var shadow: TVOSButtonShadow?
  public var cornerRadius: CGFloat = 0
  public var backgroundColor: UIColor?

  func applyImage(onImageView imageView: UIImageView) {
    shadow?.applyShadow(onLayer: imageView.layer)
    imageView.image = image
    imageView.backgroundColor = backgroundColor
    imageView.layer.masksToBounds = true
    imageView.layer.cornerRadius = cornerRadius
  }
}

// MARK: - TVOSButtonText

public struct TVOSButtonText {
  public var text: String?
  public var attributedText: NSAttributedString?
  public var color: UIColor = UIColor.blackColor()
  public var font: UIFont = UIFont.systemFontOfSize(15)
  public var alignment: NSTextAlignment = .Center
  public var shadow: TVOSButtonShadow?

  func applyText(onLabel label: UILabel) {
    shadow?.applyShadow(onLayer: label.layer)
    if let att = attributedText {
      label.attributedText = att
    } else {
      label.text = text
      label.textColor = color
      label.font = font
      label.textAlignment = alignment
    }
  }
}

// MARK: - TVOSButtonState

public enum TVOSButtonState {
  case Normal
  case Focused
  case Highlighted
  case Selected
  case Disabled
}

// MARK: - TVOSButtonStyle

public struct TVOSButtonStyle {
  public var image: TVOSButtonImage?
  public var text: TVOSButtonText?
  public var title: TVOSButtonText?
  public var shadow: TVOSButtonShadow?
  public var cornerRadius: CGFloat = 0
  public var backgroundColor: UIColor?

  public var button: TVOSButtonImage {
    return TVOSButtonImage(
      image: nil,
      gravity: .Fill,
      shadow: shadow,
      cornerRadius: cornerRadius,
      backgroundColor: backgroundColor)
  }
}

// MARK: - TVOSButton

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
    tvosContainerView = UIView()
    tvosContainerView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(tvosContainerView)
    tvosImageView = UIImageView()
    tvosImageView.translatesAutoresizingMaskIntoConstraints = false
    tvosContainerView.addSubview(tvosImageView)
    tvosTextLabel = UILabel()
    tvosTextLabel.translatesAutoresizingMaskIntoConstraints = false
    tvosContainerView.addSubview(tvosTextLabel)
    tvosTitleLabel = UILabel()
    tvosTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    tvosContainerView.addSubview(tvosTitleLabel)
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

// MARK: - State

public extension TVOSButton {

  private func tvosButtonStateDidChange() {
    if let style = tvosButtonStyleForStateAction?(tvosButtonState: tvosState) {
      applyStyle(style)
    }
    setNeedsLayout()
    layoutIfNeeded()
  }

  private func setupConstraintsForStyle(style: TVOSButtonStyle) {
    // Setup container
    let containerHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|[container]|",
      options: NSLayoutFormatOptions(rawValue: 0),
      metrics: nil,
      views: ["container": tvosContainerView])
    addConstraints(containerHorizontalConstraints)
    let containerVertivalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|[container]|",
      options: NSLayoutFormatOptions(rawValue: 0),
      metrics: nil,
      views: ["container": tvosContainerView])
    addConstraints(containerVertivalConstraints)

    // Setup content
    if let imageStyle = style.image {
      switch imageStyle.gravity {
      case .Fill:
        let imageHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
          "H:|[image]|",
          options: NSLayoutFormatOptions(rawValue: 0),
          metrics: nil,
          views: ["image": tvosImageView])
        let imageVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
          "V:|[image]-[title]|",
          options: NSLayoutFormatOptions(rawValue: 0),
          metrics: nil,
          views: [
            "image": tvosImageView,
            "title": tvosTitleLabel
          ])
        let textHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
          "H:|[text]|",
          options: NSLayoutFormatOptions(rawValue: 0),
          metrics: nil,
          views: ["text": tvosTextLabel])
        let textVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
          "V:|[text]-[title]|",
          options: NSLayoutFormatOptions(rawValue: 0),
          metrics: nil,
          views: [
            "text": tvosTextLabel,
            "title": tvosTitleLabel
          ])
        let titleHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
          "H:|[title]|",
          options: NSLayoutFormatOptions(rawValue: 0),
          metrics: nil,
          views: ["title": tvosTitleLabel])
        tvosContainerView.addConstraints(imageHorizontalConstraints)
        tvosContainerView.addConstraints(imageVerticalConstraints)
        tvosContainerView.addConstraints(textHorizontalConstraints)
        tvosContainerView.addConstraints(textVerticalConstraints)
        tvosContainerView.addConstraints(titleHorizontalConstraints)
        tvosImageView.contentMode = .ScaleAspectFill

      case .Fit(let size, let offset):
        // size metrics
        let width = size?.width ?? nil
        let widthFormat = width == nil ? "" : "(\(width!))"
        let height = size?.height ?? nil
        let heightFormat = height == nil ? "" : "(\(height!))"
        // constraints
        let imageHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
          "H:|-left-[image\(widthFormat)]-right-|",
          options: NSLayoutFormatOptions(rawValue: 0),
          metrics: [
            "left": offset?.left ?? 0,
            "right": offset?.right ?? 0
          ],
          views: ["image": tvosImageView])
        let imageVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
          "V:|-top-[image\(heightFormat)]-bottom-|",
          options: NSLayoutFormatOptions(rawValue: 0),
          metrics: [
            "heightFormat": heightFormat,
            "top": offset?.top ?? 0,
            "bottom": offset?.bottom ?? 0
          ],
          views: ["image": tvosImageView])
        let textHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
          "H:|[text]|",
          options: NSLayoutFormatOptions(rawValue: 0),
          metrics: nil,
          views: ["text": tvosTextLabel])
        let textVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
          "V:|[text]-[title]|",
          options: NSLayoutFormatOptions(rawValue: 0),
          metrics: nil,
          views: [
            "text": tvosTextLabel,
            "title": tvosTitleLabel
          ])
        let titleHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
          "H:|[title]|",
          options: NSLayoutFormatOptions(rawValue: 0),
          metrics: nil,
          views: ["title": tvosTitleLabel])
        tvosContainerView.addConstraints(imageHorizontalConstraints)
        tvosContainerView.addConstraints(imageVerticalConstraints)
        tvosContainerView.addConstraints(textHorizontalConstraints)
        tvosContainerView.addConstraints(textVerticalConstraints)
        tvosContainerView.addConstraints(titleHorizontalConstraints)
        tvosImageView.contentMode = .ScaleAspectFit

      case .Top(let size, let offset):
        // size metrics
        let width = size?.width ?? nil
        let widthFormat = width == nil ? "" : "(\(width!))"
        let height = size?.height ?? nil
        let heightFormat = height == nil ? "" : "(\(height!))"
        // constraints
        let imageHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
          "H:|-left-[image\(widthFormat)]-right-|",
          options: NSLayoutFormatOptions(rawValue: 0),
          metrics: [
            "left": offset?.left ?? 0,
            "right": offset?.right ?? 0
          ],
          views: ["image": tvosImageView])
        let imageVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
          "V:|-top-[image\(heightFormat)]-bottom-[text]-[title]|",
          options: NSLayoutFormatOptions(rawValue: 0),
          metrics: [
            "heightFormat": heightFormat,
            "top": offset?.top ?? 0,
            "bottom": offset?.bottom ?? 0
          ],
          views: ["image": tvosImageView])
        let textHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
          "H:|[text]|",
          options: NSLayoutFormatOptions(rawValue: 0),
          metrics: nil,
          views: ["text": tvosTextLabel])
        let textVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
          "V:|[text]-[title]|",
          options: NSLayoutFormatOptions(rawValue: 0),
          metrics: nil,
          views: [
            "text": tvosTextLabel,
            "title": tvosTitleLabel
          ])
        let titleHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
          "H:|[title]|",
          options: NSLayoutFormatOptions(rawValue: 0),
          metrics: nil,
          views: ["title": tvosTitleLabel])
        tvosContainerView.addConstraints(imageHorizontalConstraints)
        tvosContainerView.addConstraints(imageVerticalConstraints)
        tvosContainerView.addConstraints(textHorizontalConstraints)
        tvosContainerView.addConstraints(textVerticalConstraints)
        tvosContainerView.addConstraints(titleHorizontalConstraints)
        tvosImageView.contentMode = .ScaleAspectFit

      case .Left(let size, let offset):
        // size metrics
        let width = size?.width ?? nil
        let widthFormat = width == nil ? "" : "(\(width!))"
        let height = size?.height ?? nil
        let heightFormat = height == nil ? "" : "(\(height!))"
        // constraints
        let imageHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
          "H:|-left-[image\(widthFormat)]-right-|",
          options: NSLayoutFormatOptions(rawValue: 0),
          metrics: [
            "left": offset?.left ?? 0,
            "right": offset?.right ?? 0
          ],
          views: ["image": tvosImageView])
        let imageVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
          "V:|-top-[image\(heightFormat)]-bottom-|",
          options: NSLayoutFormatOptions(rawValue: 0),
          metrics: [
            "heightFormat": heightFormat,
            "top": offset?.top ?? 0,
            "bottom": offset?.bottom ?? 0
          ],
          views: ["image": tvosImageView])
        let textHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
          "H:|[text]|",
          options: NSLayoutFormatOptions(rawValue: 0),
          metrics: nil,
          views: ["text": tvosTextLabel])
        let textVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
          "V:|[text]-[title]|",
          options: NSLayoutFormatOptions(rawValue: 0),
          metrics: nil,
          views: [
            "text": tvosTextLabel,
            "title": tvosTitleLabel
          ])
        let titleHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
          "H:|[title]|",
          options: NSLayoutFormatOptions(rawValue: 0),
          metrics: nil,
          views: ["title": tvosTitleLabel])
        tvosContainerView.addConstraints(imageHorizontalConstraints)
        tvosContainerView.addConstraints(imageVerticalConstraints)
        tvosContainerView.addConstraints(textHorizontalConstraints)
        tvosContainerView.addConstraints(textVerticalConstraints)
        tvosContainerView.addConstraints(titleHorizontalConstraints)
        tvosImageView.contentMode = .ScaleAspectFit

      case .Right(let size, let offset):
        // size metrics
        let width = size?.width ?? nil
        let widthFormat = width == nil ? "" : "(\(width!))"
        let height = size?.height ?? nil
        let heightFormat = height == nil ? "" : "(\(height!))"
        // constraints
        let imageHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
          "H:|-left-[image\(widthFormat)]-right-|",
          options: NSLayoutFormatOptions(rawValue: 0),
          metrics: [
            "left": offset?.left ?? 0,
            "right": offset?.right ?? 0
          ],
          views: ["image": tvosImageView])
        let imageVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
          "V:|-top-[image\(heightFormat)]-bottom-|",
          options: NSLayoutFormatOptions(rawValue: 0),
          metrics: [
            "heightFormat": heightFormat,
            "top": offset?.top ?? 0,
            "bottom": offset?.bottom ?? 0
          ],
          views: ["image": tvosImageView])
        let textHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
          "H:|[text]|",
          options: NSLayoutFormatOptions(rawValue: 0),
          metrics: nil,
          views: ["text": tvosTextLabel])
        let textVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
          "V:|[text]-[title]|",
          options: NSLayoutFormatOptions(rawValue: 0),
          metrics: nil,
          views: [
            "text": tvosTextLabel,
            "title": tvosTitleLabel
          ])
        let titleHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
          "H:|[title]|",
          options: NSLayoutFormatOptions(rawValue: 0),
          metrics: nil,
          views: ["title": tvosTitleLabel])
        tvosContainerView.addConstraints(imageHorizontalConstraints)
        tvosContainerView.addConstraints(imageVerticalConstraints)
        tvosContainerView.addConstraints(textHorizontalConstraints)
        tvosContainerView.addConstraints(textVerticalConstraints)
        tvosContainerView.addConstraints(titleHorizontalConstraints)
        tvosImageView.contentMode = .ScaleAspectFit

      case .Bottom(let size, let offset):
        // size metrics
        let width = size?.width ?? nil
        let widthFormat = width == nil ? "" : "(\(width!))"
        let height = size?.height ?? nil
        let heightFormat = height == nil ? "" : "(\(height!))"
        // constraints
        let imageHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
          "H:|-left-[image\(widthFormat)]-right-|",
          options: NSLayoutFormatOptions(rawValue: 0),
          metrics: [
            "left": offset?.left ?? 0,
            "right": offset?.right ?? 0
          ],
          views: ["image": tvosImageView])
        let imageVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
          "V:|-top-[image\(heightFormat)]-bottom-|",
          options: NSLayoutFormatOptions(rawValue: 0),
          metrics: [
            "heightFormat": heightFormat,
            "top": offset?.top ?? 0,
            "bottom": offset?.bottom ?? 0
          ],
          views: ["image": tvosImageView])
        let textHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
          "H:|[text]|",
          options: NSLayoutFormatOptions(rawValue: 0),
          metrics: nil,
          views: ["text": tvosTextLabel])
        let textVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
          "V:|[text]-[title]|",
          options: NSLayoutFormatOptions(rawValue: 0),
          metrics: nil,
          views: [
            "text": tvosTextLabel,
            "title": tvosTitleLabel
          ])
        let titleHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
          "H:|[title]|",
          options: NSLayoutFormatOptions(rawValue: 0),
          metrics: nil,
          views: ["title": tvosTitleLabel])
        tvosContainerView.addConstraints(imageHorizontalConstraints)
        tvosContainerView.addConstraints(imageVerticalConstraints)
        tvosContainerView.addConstraints(textHorizontalConstraints)
        tvosContainerView.addConstraints(textVerticalConstraints)
        tvosContainerView.addConstraints(titleHorizontalConstraints)
        tvosImageView.contentMode = .ScaleAspectFit
      }
    } else {
      let imageHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
        "H:|[image]|",
        options: NSLayoutFormatOptions(rawValue: 0),
        metrics: nil,
        views: ["image": tvosImageView])
      let imageVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
        "V:|[image]-[title]|",
        options: NSLayoutFormatOptions(rawValue: 0),
        metrics: nil,
        views: [
          "image": tvosImageView,
          "title": tvosTitleLabel
        ])
      let textHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
        "H:|[text]|",
        options: NSLayoutFormatOptions(rawValue: 0),
        metrics: nil,
        views: ["text": tvosTextLabel])
      let textVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
        "V:|[text]-[title]|",
        options: NSLayoutFormatOptions(rawValue: 0),
        metrics: nil,
        views: [
          "text": tvosTextLabel,
          "title": tvosTitleLabel
        ])
      let titleHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
        "H:|[title]|",
        options: NSLayoutFormatOptions(rawValue: 0),
        metrics: nil,
        views: ["title": tvosTitleLabel])
      tvosContainerView.addConstraints(imageHorizontalConstraints)
      tvosContainerView.addConstraints(imageVerticalConstraints)
      tvosContainerView.addConstraints(textHorizontalConstraints)
      tvosContainerView.addConstraints(textVerticalConstraints)
      tvosContainerView.addConstraints(titleHorizontalConstraints)
    }
  }

  private func setupConstraints() {
    // Remove constraints
    removeConstraints(constraints)
    tvosContainerView.removeConstraints(tvosContainerView.constraints)
    tvosImageView.removeConstraints(tvosImageView.constraints)
    tvosTextLabel.removeConstraints(tvosTextLabel.constraints)
    tvosTitleLabel.removeConstraints(tvosTitleLabel.constraints)
    // Add constraints for style
    if let style = tvosButtonStyleForStateAction?(tvosButtonState: tvosState) {
      setupConstraintsForStyle(style)
    }
  }

  public override func updateConstraints() {
    setupConstraints()
    super.updateConstraints()
  }
}

// MARK: - Style

public extension TVOSButton {

  private func applyStyle(style: TVOSButtonStyle) {
    style.image?.applyImage(onImageView: tvosImageView)
    style.text?.applyText(onLabel: tvosTextLabel)
    style.title?.applyText(onLabel: tvosTitleLabel)
  }
}
