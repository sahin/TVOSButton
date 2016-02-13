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
    button.tvosButtonStyleForStateAction = { state in
      switch state {
      case .Focused:
        return TVOSButtonStyle(
          backgroundColor: UIColor.whiteColor(),
          backgroundImage: nil,
          cornerRadius: 10,
          scale: 1.1,
          shadow: .Focused,
          badge: nil,
          text: TVOSButtonLabel.DefaultText(text: "Focused", color: UIColor.blackColor()),
          title: TVOSButtonLabel.DefaultTitle(title: "Title", color: nil))
      case .Highlighted:
        return TVOSButtonStyle(
          backgroundColor: UIColor.whiteColor(),
          backgroundImage: nil,
          cornerRadius: 10,
          scale: 1.05,
          shadow: nil,
          badge: nil,
          text: TVOSButtonLabel.DefaultText(text: "Highlighted", color: UIColor.blackColor()),
          title: nil)
      default:
        return TVOSButtonStyle(
          backgroundColor: UIColor.redColor(),
          backgroundImage: nil,
          cornerRadius: 10,
          scale: nil,
          shadow: nil,
          badge: TVOSButtonImage.Top(image: UIImage(named: "share")!),
          text: TVOSButtonLabel.DefaultText(text: "Button", color: nil),
          title: TVOSButtonLabel.DefaultTitle(title: "Title", color: nil))
      }
    }
  }
}

