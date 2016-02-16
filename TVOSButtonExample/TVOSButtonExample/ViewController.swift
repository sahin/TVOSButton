//
//  ViewController.swift
//  TVOSButtonExample
//
//  Created by Cem Olcay on 11/02/16.
//  Copyright © 2016 MovieLaLa. All rights reserved.
//

import UIKit
import TVOSButton

class ViewController: UIViewController {

  @IBOutlet var button: TVOSButton!
  @IBOutlet var toggleButton: TVOSToggleButton!

  override func viewDidLoad() {
    super.viewDidLoad()

    // Setup button
    button.textLabelText = "TVOSButton"
    button.titleLabelText = "Title"
    button.addTarget(self, action: "tvosButtonPressed", forControlEvents: .PrimaryActionTriggered)

    // Setup toggleButton
    toggleButton.didToggledAction = toggleButtonDidToggledActionHandler
    toggleButton.toggleState = .On
  }

  func toggleButtonDidToggledActionHandler(
    currentState: TVOSToggleButtonState,
    updateNewState: (newState: TVOSToggleButtonState) -> Void) {
      switch currentState {
      case .Waiting:
        toggleButton.textLabelText = "..."
        requestSomething({
        self.toggleButton.textLabelText = "Add"
        self.toggleButton.toggleState = .On
        }, failure: {
          self.toggleButton.textLabelText = "Remove"
          self.toggleButton.toggleState = .Off
        })

      case .On:
        toggleButton.textLabelText = "Adding"
        updateNewState(newState: .Waiting)
        removeSomething({
          self.toggleButton.textLabelText = "Remove"
          updateNewState(newState: .Off)
        }, failure: {
          self.toggleButton.textLabelText = "Add"
          updateNewState(newState: .On)
        })

      case .Off:
        toggleButton.textLabelText = "Removing"
        updateNewState(newState: .Waiting)
        addSomethingToServer({
          self.toggleButton.textLabelText = "Add"
          updateNewState(newState: .On)
        }, failure: {
          self.toggleButton.textLabelText = "Remove"
          updateNewState(newState: .Off)
        })
      }
  }

  // Example request methods for simulate waiting for network

  func addSomethingToServer(success: () -> Void, failure: () -> Void) {
    requestSomething(success, failure: failure)
  }

  func removeSomething(success: () -> Void, failure: () -> Void) {
    requestSomething(success, failure: failure)
  }

  func requestSomething(success: () -> Void, failure: () -> Void) {
    dispatch_after(
      dispatch_time(
        DISPATCH_TIME_NOW,
        Int64(0.5 * Double(NSEC_PER_SEC))
      ),
      dispatch_get_main_queue(), success)
  }

  // Event handler
  func tvosButtonPressed() {
    print("tvos button pressed")
  }
}
