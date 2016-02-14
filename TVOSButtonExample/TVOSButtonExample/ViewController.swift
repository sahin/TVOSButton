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

  override func viewDidLoad() {
    super.viewDidLoad()

    // Add target
    button.addTarget(self, action: "tvosButtonPressed", forControlEvents: .PrimaryActionTriggered)

    // Setup style
    button.tvosButtonStyleForStateAction = { state in
      switch state {
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
          titleStyle: nil)
      }
    }

    // Setup content
    button.badgeImage = UIImage(named: "shareSmall")
    button.textLabelText = "Button"
  }

  // Event handler
  func tvosButtonPressed() {
    print("tvos button pressed")
  }
}
