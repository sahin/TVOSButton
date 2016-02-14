//
//  ViewController.swift
//  TVOSButtonExample
//
//  Created by Cem Olcay on 11/02/16.
//  Copyright © 2016 MovieLaLa. All rights reserved.
//

import UIKit
import TVOSButton

// Just override `tvosButtonStateDidChange` and `tvosButtonStyleForState:tvosButtonState:` functions

class ExampleButton: TVOSButton {

  override func tvosButtonStateDidChange(tvosButtonState: TVOSButtonState) {
    print("\(tvosButtonState)")
  }

  override func tvosButtonStyleForState(tvosButtonState: TVOSButtonState) -> TVOSButtonStyle? {
    switch tvosButtonState {
    case .Focused:
      return TVOSButtonStyle(
        backgroundColor: UIColor.whiteColor(),
        backgroundImage: nil,
        cornerRadius: 10,
        scale: 1.1,
        shadow: TVOSButtonShadow.Focused,
        contentView: nil,
        badgeStyle: TVOSButtonImage.Fit,
        textStyle: TVOSButtonLabel.DefaultText(color: UIColor.blackColor()),
        titleStyle: nil)

    case .Highlighted:
      return TVOSButtonStyle(
        backgroundColor: UIColor.whiteColor(),
        backgroundImage: nil,
        cornerRadius: 10,
        scale: 0.9,
        shadow: TVOSButtonShadow.Highlighted,
        contentView: nil,
        badgeStyle: TVOSButtonImage.Fit,
        textStyle: TVOSButtonLabel.DefaultText(color: UIColor.blackColor()),
        titleStyle: nil)

    default:
      return TVOSButtonStyle(
        backgroundColor: UIColor.redColor(),
        backgroundImage: nil,
        cornerRadius: 10,
        scale: nil,
        shadow: nil,
        contentView: nil,
        badgeStyle: TVOSButtonImage.Fit,
        textStyle: TVOSButtonLabel.DefaultText(color: UIColor.whiteColor()),
        titleStyle: TVOSButtonLabel.DefaultTitle(color: UIColor.blackColor()))
    }
  }
}

class ViewController: UIViewController {

  @IBOutlet var button: ExampleButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Setup button
    button.textLabelText = "Button"
    button.titleLabelText = "Title"
    button.addTarget(self, action: "tvosButtonPressed", forControlEvents: .PrimaryActionTriggered)
  }

  // Event handler
  func tvosButtonPressed() {
    print("tvos button pressed")
  }
}
