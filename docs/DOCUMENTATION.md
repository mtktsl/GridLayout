
## Grid Cell Structure

UIView objects inside a Grid are alligned into Grid Cell areas. These areas are declared by using UIView extensions included with the package.

```swift
public extension UIView {
    public func constant(_ value: CGFloat) -> GridContentProtocol
    public func auto() -> GridAutoCellProtocol
    public func expanded(_ value: CGFloat = 1) -> GridExpandedCellProtocol
}
```

### Cell Types

| Grid Cell Type  | Parameter | Description |
| ------------- | :--------------: | ------------- |
| **Constant**  | CGFloat | Used for reserving constant height or width. |
| **Auto**  | - | Used for reserving the area by calculating inner view's minimum fitting size. Frequently used for `UILabel` objects. |
| **Expanded**  | CGFloat | Used for reserving the remaining width or remaining height that is left from total of Consant and Auto cell areas inside the grid's bounds. The area that is being reserved is proportional to total of Expanded type cell areas' values. |

The length of the cell areas orthogonal to the grid direction will be equal to the bounds of the grid.

When grid orientation is **vertical**, then the width of the cell areas will be equal to `bounds.width` of the parent grid.

When grid orientation is **horizontal**, then the height of the cell areas will be equal to `bounds.height` of the parent grid.



### Cell Size Calculations

#### **Constant Cell:**

| Grid Orientation | Cell Size |
|  :------------ |  ------------ |
| **Vertical** | Provided value is going to determine the height of the area.|
| **Horizontal** | Provided value is going to determine the width of the area.|


#### **Auto Cell:**

| Grid Orientation | Cell Size |
|  :------------ |  ------------ |
| **Vertical** | A height will be reserved that is returned by the calculation of the view's minimum fitting size based on the grid's `bounds.width`.|
| **Horizontal** | A width will be reserved that is returned by the calculation of the view's minimum fitting size based on the grid's `bounds.height`.|


**Important Note:** When you want to use your custom `UIView` objects with `Auto` type cells, you need to override `sizeThatFits` method and provide a `CGSize` for your custom `UIView` in order for parent grid to be able to calculate the custom `UIView` object's size properly.

#### **Expanded Cell:**

| Grid Orientation | Cell Size | Formula |
|  :------------ |  ------------ | ---------- |
| **Vertical** | A height proportional to the provided value will be reserved that is left from the total of **Auto** and **Constant** cell heights inside parent grid's ```bounds```.| $(bounds.height - (totalConstant + totalAuto)) * expandedValue / totalExpandedValues$ |
| **Horizontal** | A width proportional to the provided value will be reserved that is left from the total of **Auto** and **Constant** cell widths inside parent grid's ```bounds```. | $(bounds.width - (totalConstant + totalAuto)) * expandedValue / totalExpandedValues$ |

**Important Note:** If the area is calculated as zero or less then Expanded type cells are going to act like Auto cells. This behavior can be chanded by using `canCollapse` setter function. If `canCollapse` is true then `expanded` type cells will be able to have 0 size without trying to act like auto type cells. Setter function usages will be explained in the next section.

### Alignment Inside Grid Cells

UIView objects are aligned inside the grid cell areas. Alignment options can be set by using setter functions when declaring view alignments inside grid.

#### Alignment Methods:

| Method  | Available Cells | Parameter | Default Value | Description |
| ------------- | :---------: | :------------ | :---------: | ------------- |
| margin | All | UIEdgeInsets | .zero | The views inside Grid Cell areas are pushed from their edges by the values provided as margin. |
| horizontalAlignment | All | GridHorizontalAlignment | .fill | The views are aligned inside Grid Cell areas horizontally based on the horizontalAlignment option. |
| verticalAlignment | All | GridVerticalAlignment | .fill | The views are aligned inside Grid Cell areas vertically based on the horizontalAlignment option. |
| minLength | Auto | CGFloat | .zero | When a Grid Cell type is chosen as Auto then the area's length parallel to parent GridOrientation cannot be less than minLength. |
| maxLength | Auto | CGFloat | .infinity | When a Grid Cell type is chosen as Auto then the area's length parallel to parent GridOrientation cannot be bigger than maxLength. |
| canCollapse | Expanded | Bool | false | When an Expanded Grid Cell's length parallel to GridOrientation is calculated as 0 or less, then the area gets recalculated to be minimum fitting size of the inner UIView by default. This behaviour is not the case when canCollapse is set to true. |

#### GridHorizontalAlignment

| Value  | Parameter | Description |
| ------------- | :---------: | :------------ | 
| .fill | - | Snaps the view's edges to cell area's edges by offsetting them based on the related margin values. |
| .constantCenter | width: CGFloat | Centers the view on the horizontal axis inside the grid cell area by offsetting the center based on left and right margin values and sets a constant width to the view. |
| .autoCenter | - | Centers the view on the horizontal axis inside the grid cell area by offsetting the center based on left and right margin values and sets minimum fitting width for the view. |
| .constantLeft | width: CGFloat | Snaps the view to the left edge of the grid cell area by offsetting it horizontally based on the left and right margin values and sets a constant width to the view. |
| .autoLeft | - | Snaps the view to the left edge of the grid cell area by offsetting it horizontally based on the left and right margin values and sets minimum fitting width for the view. |
| .constantRight | width: CGFloat | Snaps the view to the right edge of the grid cell area by offsetting it horizontally based on the left and right margin values and sets a constant width to the view. |
| .autoRight | - | Snaps the view to the right edge of the grid cell area by offsetting it horizontally based on the left and right margin values and sets minimum fitting width for the view. |

#### GridVerticalAlignment

| Value  | Parameter | Description |
| ------------- | :---------: | :------------ | 
| .fill | - | Snaps the view's edges to cell area's edges by offsetting them based on the related margin values. |
| .constantCenter | height: CGFloat | Centers the view on the vertical axis inside the grid cell area by offsetting the center based on top and bottom margin values and sets a constant height to the view. |
| .autoCenter | - | Centers the view on the vertical axis inside the grid cell area by offsetting the center based on top and bottom margin values and sets minimum fitting height for the view. |
| .constantTop | height: CGFloat | Snaps the view to the top edge of the grid cell area by offsetting it vertically based on the top and bottom margin values and sets a constant height to the view. |
| .autoTop | - | Snaps the view to the top edge of the grid cell area by offsetting it vertically based on the top and bottom margin values and sets minimum fitting height for the view. |
| .constantBottom | height: CGFloat | Snaps the view to the bottom edge of the grid cell area by offsetting it vertically based on the top and bottom margin values and sets a constant height to the view. |
| .autoBottom | - | Snaps the view to the bottom edge of the grid cell area by offsetting it vertically based on the top and bottom margin values and sets minimum fitting height for the view. |

**Important Note:** When "auto" alignment options are used, the UIView object's class must override "sizeThatFits" method in order for grid to be able to calculate the view's fitting size properly.

### How To Use Alignment Methods On UIViews

```swift
myView
    .auto()
    .minLength(50)
    .maxLength(100)
    .horizontalAlignment(.autoLeft)
    .verticalAlignment(.constantTop(height: 65))
    .margin( UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5) )
```

Alignment methods starting from "minLength" in this example are not mandatory since they all have default values.


## Grid Orientation

There are 2 types of orientation for Grid objects for positioning UIViews inside a grid.

| GridOrientation  | Description |
| ------------- | ------------- |
| **.vertical** | UIViews are arranged from top to bottom.  |
| **.horizontal**  | UIViews are arranged from left to right.  |

Grid orientation can be set to a different value any time by setting "orientation" variable for the desired `Grid` object.

#### Example:
```swift
myGrid.orientation = .horizontal
```


## Usage

There are 2 static builder functions `(.vertical and .horizontal)` for building grid layouts with specified orientation types seamlessly.
These functions take `@GridBuilder` closure as a parameter which is an implementation of `@resultBuilder` attribute. This way, we can use declarative approach for aligning subviews or subgrids inside a parent grid.

#### Methods:
```swift
public static func vertical( @GridBuilder content() -> [GridContentBase] ) -> Grid
public static func horizontal( @GridBuilder content() -> [GridContentBase] ) -> Grid
```

#### Usage:
```swift
let myGrid = Grid.vertical {
    myFirstView
        .auto()

    mySecondView
        .constant(50)

    Grid.horizontal {
        myThirdView
            .expanded()
        
        myFourthView
            .constant(25)
    }
    .auto()
}
```

### Loop Support:
`@GridBuilder` supports `for` loops inside its closure.

```swift
let myGrid = Grid.vertical {
    for _ in 0 ..< 10 {
        UIView()
            .constant()
        UIView()
            .auto()
        UIView()
            .expanded()
    }
}
```
Note that if you declare a `for` loop inside a builder closure you cannot declare anything else directly outside of the `for` loop. You need to containerize loops inside different builder closures in order to use with other declarations.

#### Example:

```swift
let myGrid = Grid.vertical {
    Grid.vertical {
        for _ in 0 ..< 10 {
            UIView()
                .constant()
            UIView()
                .auto()
            UIView()
                .expanded()
        }
    }
    .auto()

    Grid.horizontal {
        for _ in 0 ..< 10 {
            UIView()
                .constant()
            UIView()
                .auto()
            UIView()
                .expanded()
        }
    }
    .auto()
}
```

## Post-Initialization Configuration

### setNeedsGridLayout
Call this method when one or more views needs to be laid out based on their new content sizes. For example when UILabel is laid out by using `Auto grid cell` and it's `text` value changes, parent Grid's `setNeedsGridLayout` method should be called.

Calling `setNeedsLayout` instead of `setNeedsGridLayout` will not have the same effect. Since `Grid` class is using a caching mechanism in order to improve performance, the right way for marking the grid for recalculating its content size and alignment is calling `setNeedsGridLayout` instead of `setNeedsLayout`.

### swapArrangement(of:with:)
```swift
public func swapArrangement(
    of subview: UIView,
    with targetView: UIView
)
```
#### Discussion
This method swaps the arrangement of 2 views that are provided as parameters. There is no need to call `setNeedsGridLayout` after using this method.

From starting 0.8.5 version, `setNeedsGridLayout` will be deprecated and Grid will use `setNeedsLayout` instead of it.

**Example**:

#### Before swapping:
```swift
let myGrid = Grid.vertical {
    firstView
        .auto()

    secondView
        .expanded()
} 
```

#### After calling ```swapArrangement(of:with:)```: 
```swift
myGrid.swapArrangement(of: firstView, with: secondView)
``` 

#### Result will act like:

```swift
Grid.vertical {
    secondView
        .expanded()

    firstView
        .auto()
} 
```

#### **Supports swapping subviews arranged in different subgrids:**

**Example**:

#### Before swapping:
```swift
let myGrid = Grid.vertical {
    firstView
        .auto()

    Grid.horizontal {
        secondView
            .expanded()
    }
    .constant(100)
} 
```

#### After calling ```swapArrangement(of:with:)```: 
```swift
myGrid.swapArrangement(of: firstView, with: secondView)
``` 

#### Result will act like:
```swift
Grid.vertical {
    secondView
        .expanded()

    Grid.horizontal {
        firstView
            .auto()
    }
    .constant(100)
} 
```

### setContentAlignment(for:alignmentClosure:)

```swift
public func setContentAlignment(
    for: UIView,
    alignmentClosure: @escaping (_ view: UIView) -> GridContentProtocol
)
```

#### Discussion
Call this method when you want your arranged subview inside a Grid needs to be aligned in a different way.

There is no need for calling `setNeedsGridLayout` after calling this method.

**Example:**

#### Initial alignment:
```swift
let myGrid = Grid.vertical {
    firstView
        .auto()

    secondView
        .expanded()
}
```

#### After calling `setContentAlignment(for:alignmentClosure:)`
```swift
myGrid.setContentAlignment(for: firstView) { view in
    view
        .constant(100)
        .horizontalAlignment(.autoLeft)
}
```

#### Result will act like:

```swift
Grid.vertical {
    firstView
        .constant(100)
        .horizontalAlignment(.autoLeft)

    secondView
        .expanded()
}
```

#### **Supports setting alignment for subviews arranged in different subgrids:**

**Example:**

#### Initial alignment:
```swift
let myGrid = Grid.vertical {
    Grid.horizontal {
        firstView
            .auto()
    }
    .auto()
    
    secondView
        .expanded()
} 
```

#### After calling `setContentAlignment(for:alignmentClosure:)`
```swift
myGrid.setContentAlignment(for: firstView) { view in
    view
        .constant(100)
        .horizontalAlignment(.autoLeft)
}
```

#### Result will act like:

```swift
Grid.vertical {
    Grid.horizontal {
        firstView
            .constant(100)
            .horizontalAlignment(.autoLeft)
    }
    .auto()
    
    secondView
        .expanded()
} 
```

### addGridContent(at:components:)
```swift
public func addGridContent(
    at index: Int = .min,
    @GridBuilder components: () -> [GridContentBase]
)
```

#### Discussion
This method is used for adding new content into a `Grid` object.

There is no need to call `setNeedsGridLayout` after calling this method.

**Example**:

#### Initial alignment:
```swift
let myGrid = Grid.vertical {
     firstView
        .constant(100)
} 
```

#### After calling `addGridContent(at:components:)`:

```swift
myGrid.addGridContent {
    secondView
        .auto()

    thirdView
        .expanded()
}
```

#### Result will act like:

```swift
Grid.vertical {
    firstView
        .constant(100)
    
    secondView
        .auto()

    thirdView
        .expanded()
} 
```

### removeSubcontent(subviewToBeRemoved:)
```swift
public func removeSubcontent(
    subviewToBeRemoved: UIView
)
```

#### Discussion
This method is used for removing subviews and its arranged cell area from a `Grid` object.

There is no need to call `setNeedsGridLayout` after calling this method.

**Example**:

#### Initial alignment:
```swift
let myGrid = Grid.vertical {
    firstView
        .constant(100)

    secondView
        .auto()
} 
```

#### After calling `removeSubcontent(subviewToBeRemoved:)`:

```swift
myGrid.removeSubcontent(firstView)
```

#### Result will act like:

```swift
Grid.vertical {
    secondView
        .auto()
} 
```
