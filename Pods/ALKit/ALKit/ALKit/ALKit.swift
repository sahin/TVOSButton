//
//  ALKit.swift
//  AutolayoutPlayground
//
//  Created by Cem Olcay on 22/10/15.
//  Copyright © 2015 prototapp. All rights reserved.
//
//  https://www.github.com/cemolcay/ALKit
//

import UIKit

public extension UIEdgeInsets {

  /// Equal insets for all edges
  public init (inset: CGFloat) {
    top = inset
    bottom = inset
    left = inset
    right = inset
  }
}

public extension UIView{

  public convenience init (withAutolayout: Bool) {
    self.init(frame: CGRect.zero)
    translatesAutoresizingMaskIntoConstraints = false
  }

  public class func AutoLayout() -> UIView {
    let view = UIView(frame: CGRect.zero)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }

  public func pin(
    edge: NSLayoutAttribute,
    toEdge: NSLayoutAttribute,
    ofView: UIView?,
    withInset: CGFloat = 0) {
      guard let view = superview else {
        return assertionFailure("view must be added as subview in view hierarchy")
      }
      view.addConstraint(NSLayoutConstraint(
        item: self,
        attribute: edge,
        relatedBy: .Equal,
        toItem: ofView,
        attribute: toEdge,
        multiplier: 1,
        constant: withInset))
  }

  // MARK: Pin Super

  public func pinRight(toView toView: UIView, withInset: CGFloat = 0) {
    pin(.Right, toEdge: .Right, ofView: toView, withInset: -withInset)
  }

  public func pinLeft(toView toView: UIView, withInset: CGFloat = 0) {
    pin(.Left, toEdge: .Left, ofView: toView, withInset: withInset)
  }

  public func pinTop(toView toView: UIView, withInset: CGFloat = 0) {
    pin(.Top, toEdge: .Top, ofView: toView, withInset: withInset)
  }

  public func pinBottom(toView toView: UIView, withInset: CGFloat = 0) {
    pin(.Bottom, toEdge: .Bottom, ofView: toView, withInset: -withInset)
  }

  // MARK: Pin To Another View In Super

  public func pinToRight(ofView ofView: UIView, withOffset: CGFloat = 0) {
    pin(.Left, toEdge: .Right, ofView: ofView, withInset: withOffset)
  }

  public func pinToLeft(ofView ofView: UIView, withOffset: CGFloat = 0) {
    pin(.Right, toEdge: .Left, ofView: ofView, withInset: -withOffset)
  }

  public func pinToTop(ofView ofView: UIView, withOffset: CGFloat = 0) {
    pin(.Bottom, toEdge: .Top, ofView: ofView, withInset: -withOffset)
  }

  public func pinToBottom(ofView ofView: UIView, withOffset: CGFloat = 0) {
    pin(.Top, toEdge: .Bottom, ofView: ofView, withInset: withOffset)
  }

  // MARK: Fill In Super

  public func fill(toView view: UIView, withInset: UIEdgeInsets = UIEdgeInsetsZero) {
    pinLeft(toView: view, withInset: withInset.left)
    pinRight(toView: view, withInset: withInset.right)
    pinTop(toView: view, withInset: withInset.top)
    pinBottom(toView: view, withInset: withInset.bottom)
  }

  public func fillHorizontal(toView view: UIView, withInset: CGFloat = 0) {
    pinRight(toView: view, withInset: withInset)
    pinLeft(toView: view, withInset: withInset)
  }

  public func fillVertical(toView view: UIView, withInset: CGFloat = 0) {
    pinTop(toView: view, withInset: withInset)
    pinBottom(toView: view, withInset: withInset)
  }

  // MARK: Size

  public func pinSize(width width: CGFloat, height: CGFloat) {
    pinWidth(width)
    pinHeight(height)
  }

  public func pinWidth(width: CGFloat) {
    pin(.Width, toEdge: .NotAnAttribute, ofView: nil, withInset: width)
  }

  public func pinHeight(height: CGFloat) {
    pin(.Height, toEdge: .NotAnAttribute, ofView: nil, withInset: height)
  }

  // MARK: Center

  public func pinCenter(toView view: UIView) {
    pinCenterX(toView: view)
    pinCenterY(toView: view)
  }

  public func pinCenterX(toView view: UIView) {
    pin(.CenterX, toEdge: .CenterX, ofView: view)
  }

  public func pinCenterY(toView view: UIView) {
    pin(.CenterY, toEdge: .CenterY, ofView: view)
  }
}
