//
//  TVOSToggleButton.swift
//  TVOSButton
//
//  Created by Cem Olcay on 15/02/16.
//  Copyright © 2016 MovieLaLa. All rights reserved.
//

import UIKit

public typealias TVOSToggleButtonDidToggledAction = (currentState: TVOSToggleButtonState, newState: (newState: TVOSToggleButtonState) -> Void) -> Void

public enum TVOSToggleButtonState {
  case Waiting(text: String?)
  case On(text: String?)
  case Off(text: String?)
}

public class TVOSToggleButton: TVOSButton {

  // MARK; Properties

  public var didToggledAction: TVOSToggleButtonDidToggledAction?
  public var toggleState: TVOSToggleButtonState = .Waiting(text: nil) {
    didSet {
      toggleStateDidChange()
    }
  }

  // MARK: Init

  public init(initialState: TVOSToggleButtonState, didToggledAction: TVOSToggleButtonDidToggledAction?) {
    super.init(frame: CGRect.zero)
    self.toggleState = initialState
    self.didToggledAction = didToggledAction
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

  public func commonInit() {
    addTarget(self, action: "didToggled:", forControlEvents: .PrimaryActionTriggered)
    toggleStateDidChange()
  }

  // MARK: Toggle

  public func didToggled(sender: TVOSToggleButton) {
    didToggledAction?(
      currentState: toggleState,
      newState: { state in
        self.toggleState = state
      })
  }

  private func toggleStateDidChange() {
    switch toggleState {
    case .Waiting(let text):
      textLabelText = text
    case .On(let text):
      textLabelText = text
    case .Off(let text):
      textLabelText = text
    }
  }
}
