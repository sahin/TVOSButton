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
          badgeStyle: nil,
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
          badgeStyle: nil, 
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
          badgeStyle: nil,
          textStyle: TVOSButtonLabel.DefaultText(color: UIColor.whiteColor()), 
          titleStyle: nil)
      }
    }

    // Setup content
    button.tvosButtonStateDidChangeAction = { state in
      switch state {
      case .Focused:
        self.button.textLabelText = "Focused"
        self.button.badgeImage = nil
      case .Highlighted:
        self.button.textLabelText = "High"
        self.button.badgeImage = UIImage(named: "share")
      default:
        self.button.textLabelText = "Button"
        self.button.badgeImage = nil
      }
    }
  }

  // Event handler
  func tvosButtonPressed() {
    print("tvos button pressed")
  }
}
