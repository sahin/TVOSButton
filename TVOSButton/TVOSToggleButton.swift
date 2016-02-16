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
  case Waiting
  case On
  case Off
}

public class TVOSToggleButton: TVOSButton {

  // MARK; Properties

  public var toggleState: TVOSToggleButtonState = .Waiting
  public var didToggledAction: TVOSToggleButtonDidToggledAction? {
    didSet {
      didToggled(self)
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
  }

  // MARK: Toggle

  public func didToggled(sender: TVOSToggleButton) {
    didToggledAction?(
      currentState: toggleState,
      newState: { state in
        self.toggleState = state
      })
  }
}
