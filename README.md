# GridLayout

&bull; This is a custom UIView object that is organizing views inside of it horizontally or vertically.<br/>
<br/>
&bull; <strong>Framework:</strong> UIKit <br/>
&bull; <strong>Minimum iOS Version:</strong> v11

## Syntax:
&bull; Use the cell type structure to put views inside a Grid when initializing it.<br/>
&bull; The only way to initialize a Grid is to use either "Grid.vertical" or "Grid.horizontal" methods.<br/>
&bull; Cell type structure is taking paramaters by using GridBuilder which is an implementation of resultBuilder attribute.<br/>
&bull; You can use the included UIView extension to create cells by using your UIView objects. <br/>
&bull; **Example:** <br/>
```swift
Grid.vertical {

    constantSizedUIView
        .constant(50)

    autoSizedUILabel
        .auto()

    expandedSizedUIView
        .expanded()
}
```
&bull; Check the simulated examples written in code editor below of this page.

## Cell Types:
<strong>&bull; Auto</strong> -> Automatically resizes the area that is including views.
<br/>&bull; Note: If you want your custom UIView class objects to be able to be auto resized in the Grid then you must override "sizeThatFits" method and provide a size for your custom UIView class.
<br/><strong>&bull; Constant</strong> -> Sets the size of the area to the value that is provided. The value represents Width for the horizontal Grid and Height for the vertical Grid.
<br/><strong>&bull; Expanded</strong> -> Expands the view area to the remaining area from the Auto and Constant cells, propotional to the total defined Expanded cell values. The default Expanded cell value is 1 when it's not provided.

<br/><br/>**Example:** When you have views that have Expanded cell types, then their size proportions are going to be calculated using this formula:
_<br/>ViewSize = ViewExpandedValue / TotalExpandedValue_
<br/>So this means that if you have 2 views that have Expanded cell type and value of the first one is 1 and the value of the second one is 2 then their sizes are going to be proportional to this value:
<br/>_OwnerGridsSize - (TotalAutoCalculatedSizes + TotalConstantSizes)_
<br/>And the proportions are going to be 1/3 and 2/3.

## Cell Type Parameters and Parameter Setter Functions
<strong>&bull; value</strong> -> (CGSize type) (Not available for Auto cell) Sets the cell height or width depending on the Grid type. <br/>
<strong>&bull; maxSize (setter function)</strong> -> (CGSize type) (Only available for Auto cell) Sets the maximum size for the view. <br/>
<strong>&bull; horizontalAlignment (setter function)</strong> -> (enum type) Align the view horizontally in it's allocated space. <br/>
<strong>&bull; verticalAlignment (setter function)</strong> -> (enum type) Align the view vertically in it's allocated space. <br/>
<strong>&bull; margin (setter function)</strong> -> (UIEdgeInset type) Set the margin values for the edges of the view to the edges of the allocated area. <br/>
<br/>**Note:** If the cell type is _Auto_ then the allocated area expands based on the margin values. 
<br/>**Example setter function usage:**
<br/>
```swift
myLabel
    .auto()
    .horizontalAlignment(.autoRight)
    .verticalAlignment(.autoTop)
    .maxSize(75)
    .margin(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
```
# Code examples:

## Image-Title-Body Example:
<img src="https://i.hizliresim.com/2v3hps2.jpg"
data-canonical-src="https://i.hizliresim.com/2v3hps2.jpg"
width="800" height="632" />

## Loop Example: Checkers View:
<img src="https://i.hizliresim.com/gpvyfbx.jpg"
data-canonical-src="https://i.hizliresim.com/gpvyfbx.jpg"
width="800" height="632" />
