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

Documentation
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

### Pin

Pins the same edges.

``` swift
func pinRight(inView inView: UIView? = nil, toView: UIView, withInset: CGFloat = 0)
```

``` swift
func pinLeft(inView inView: UIView? = nil, toView: UIView, withInset: CGFloat = 0)
```

``` swift
func pinTop(inView inView: UIView? = nil, toView: UIView, withInset: CGFloat = 0)
```

``` swift
func pinBottom(inView inView: UIView? = nil, toView: UIView, withInset: CGFloat = 0)
```

### Pin To

Pins the opposite edeges.

``` swift
func pinToRight(inView inView: UIView? = nil, toView: UIView, withOffset: CGFloat = 0)
```

``` swift
func pinToLeft(inView inView: UIView? = nil, toView: UIView, withOffset: CGFloat = 0)
```

``` swift
func pinToTop(inView inView: UIView? = nil, toView: UIView, withOffset: CGFloat = 0)
```

``` swift
func pinToBottom(inView inView: UIView? = nil, toView: UIView, withOffset: CGFloat = 0)
```

### Fill

Fills in view horizontally, vertically or both.

``` swift
func fill(toView view: UIView, withInset: UIEdgeInsets = UIEdgeInsetsZero)
```

``` swift
func fillHorizontal(toView view: UIView, withInset: CGFloat = 0)
```

``` swift
func fillVertical(toView view: UIView, withInset: CGFloat = 0)
```

### Size

Sets the size by width, height or both.

``` swift
func pinSize(width width: CGFloat, height: CGFloat) 
```

``` swift
func pinWidht(width: CGFloat)
```

``` swift
func pinHeight(height: CGFloat)
```

### Center

Centers horizontally, vertically or both.

``` swift
func pinCenter(toView view: UIView)
```

``` swift
func pinCenterX(toView view: UIView)
```

``` swift
func pinCenterY(toView view: UIView)
```
