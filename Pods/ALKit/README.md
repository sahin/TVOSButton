ALKit
===

Easy to use AutoLayout wrapper around `NSLayoutConstraints`.

Install
----

#### CocoaPods

``` ruby
use_frameworks!
pod 'ALKit'
```

### Manual

Copy the `ALKit` folder into your project

Usage
----

### Init

Initialzes autolayout ready views.


``` swift
    convenience init (withAutolayout: Bool) {
        self.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
    }
```

``` swift
    class func AutoLayout() -> UIView {
        let view = UIView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
```

### Wraper

The main function of all kit.
Wraps `addConstraint:` method of autolayout.

``` swift
    func pin(
        inView inView: UIView? = nil,
        edge: NSLayoutAttribute,
        toEdge: NSLayoutAttribute,
        ofView: UIView?,
        withInset: CGFloat = 0) {
        let view = inView ?? ofView ?? self
        view.addConstraint(NSLayoutConstraint(
            item: self,
            attribute: edge,
            relatedBy: .Equal,
            toItem: ofView,
            attribute: toEdge,
            multiplier: 1,
            constant: withInset))
    }
```

#### Example

``` swift
  override func viewDidLoad() {
    super.viewDidLoad()

    // setup views

    let box = UIView.AutoLayout()
    box.backgroundColor = UIColor.greenColor()
    view.addSubview(box)

    let blue = UIView.AutoLayout()
    blue.backgroundColor = UIColor.blueColor()
    box.addSubview(blue)

    let red = UIView.AutoLayout()
    red.backgroundColor = UIColor.redColor()
    box.addSubview(red)

    let yellow = UIView.AutoLayout()
    yellow.backgroundColor = UIColor.yellowColor()
    box.addSubview(yellow)

    // setup constraints

    box.fill(toView: view)

    blue.pinTop(toView: box, withInset: 10)
    blue.fillHorizontal(toView: box, withInset: 10)
    blue.pinHeight(90)

    red.pinBottom(toView: box, withInset: 10)
    red.fillHorizontal(toView: box, withInset: 10)
    red.pinHeight(90)

    yellow.pinToTop(ofView: red, withOffset: 10)
    yellow.pinCenterX(toView: red)
    yellow.pinSize(width: 50, height: 50)
  }
```
