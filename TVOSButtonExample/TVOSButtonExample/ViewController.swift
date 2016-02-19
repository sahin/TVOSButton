//
//  ViewController.swift
//  TVOSButtonExample
//
//  Created by Cem Olcay on 11/02/16.
//  Copyright © 2016 MovieLaLa. All rights reserved.
//

import UIKit
import TVOSButton

// MARK: - PosterButton

class PosterButton: TVOSButton {

  var posterImage: UIImage? {
    didSet {
      badgeImage = posterImage
    }
  }

  var posterImageURL: String? {
    didSet {
      if let posterImageURL = posterImageURL {
        NSURLSession.sharedSession().dataTaskWithURL(
          NSURL(string: posterImageURL)!,
          completionHandler: { data, response, error in
            if error == nil {
              if let data = data, image = UIImage(data: data) {
                dispatch_async(dispatch_get_main_queue(), {
                  self.posterImage = image
                })
              }
            }
        }).resume()
      }
    }
  }

  override func tvosButtonStyleForState(tvosButtonState: TVOSButtonState) -> TVOSButtonStyle {
    switch tvosButtonState {
    case .Focused:
      return TVOSButtonStyle(
        scale: 1.1,
        shadow: TVOSButtonShadow.Focused,
        badgeStyle: TVOSButtonImage.Fill(adjustsImageWhenAncestorFocused: true),
        titleStyle: TVOSButtonLabel.DefaultTitle(color: UIColor.whiteColor()))
    case .Highlighted:
      return TVOSButtonStyle(
        scale: 0.95,
        shadow: TVOSButtonShadow.Highlighted,
        badgeStyle: TVOSButtonImage.Fill(adjustsImageWhenAncestorFocused: true),
        titleStyle: TVOSButtonLabel.DefaultTitle(color: UIColor.whiteColor()))
    default:
      return TVOSButtonStyle(
        badgeStyle: TVOSButtonImage.Fill(adjustsImageWhenAncestorFocused: true),
        titleStyle: TVOSButtonLabel.DefaultTitle(color: UIColor.blackColor()))
    }
  }
}

// MARK: - IconButton

class IconButton: TVOSButton {

  var iconName: String? {
    didSet {
      handleStateDidChange()
    }
  }

  override func tvosButtonStyleForState(tvosButtonState: TVOSButtonState) -> TVOSButtonStyle {

    // custom content
    let icon = UIImageView(frame: CGRect(x: 20, y: 0, width: 40, height: 40))
    icon.center.y = 50
    if let iconName = iconName {
      let color = tvosButtonState == .Highlighted || tvosButtonState == .Focused ? "Black" : "White"
      icon.image = UIImage(named: "\(iconName)\(color)")
    }

    switch tvosButtonState {
    case .Focused:
      return TVOSButtonStyle(
        backgroundColor: UIColor.whiteColor(),
        cornerRadius: 10,
        scale: 1.1,
        shadow: TVOSButtonShadow.Focused,
        contentView: icon,
        textStyle: TVOSButtonLabel.DefaultText(color: UIColor.blackColor()))
    case .Highlighted:
      return TVOSButtonStyle(
        backgroundColor: UIColor.whiteColor(),
        cornerRadius: 10,
        scale: 0.95,
        shadow: TVOSButtonShadow.Highlighted,
        contentView: icon,
        textStyle: TVOSButtonLabel.DefaultText(color: UIColor.blackColor()))
    default:
      return TVOSButtonStyle(
        backgroundColor: UIColor(red: 198/255.0, green: 44/255.0, blue: 48/255.0, alpha: 1),
        cornerRadius: 10,
        contentView: icon,
        textStyle: TVOSButtonLabel.DefaultText(color: UIColor.whiteColor()))
    }
  }
}

// MARK: - View Controller

class ViewController: UIViewController {

  @IBOutlet var posterButton: PosterButton!
  @IBOutlet var toggleButton: TVOSToggleButton!
  @IBOutlet var iconButton: IconButton!

  override func viewDidLoad() {
    super.viewDidLoad()

    // Setup poster button
    posterButton.titleLabelText = "Poster"
    posterButton.posterImageURL = "https://placeholdit.imgix.net/~text?txtsize=33&txt=240x360&w=240&h=360"
    posterButton.addTarget(self, action: "tvosButtonPressed", forControlEvents: .PrimaryActionTriggered)

    // Setup toggle button
    toggleButton.didToggledAction = toggleButtonDidToggledActionHandler

    // Setup icon button
    iconButton.textLabelText = "Share"
    iconButton.iconName = "share"
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
