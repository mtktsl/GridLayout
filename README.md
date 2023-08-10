# GridLayout

&bull; This is a custom UIView object that is organizing views inside of it horizontally or vertically.

## Syntax:
&bull; Use the cell type structure to put views inside a Grid when initializing it.<br/>
&bull; The only way to initialize a Grid is to use either "Grid.vertical" or "Grid.horizontal" methods.<br/>
&bull; Cell type structure is taking paramaters by using GridBuilder which is an implementation of resultBuilder attribute.<br/>
&bull; You can use Auto, Constant or Expanded keywords and open code blocks then put your UIViews inside of a Grid.vertical or Grid.horizontal blocks. <br/>
&bull; Example: Auto { myView } <br/>
&bull; Or you can use the included UIView extension to create cells by using your UIView object. Example: myView.Auto() <br/>
&bull; Check the examples written in code editor below of this page.

## Cell Types:
<strong>&bull; Auto</strong> -> Automatically resizes the area that is including views.
<br/>&bull; Note: If you want your custom UIView class objects to be able to auto resized in the Grid then you must override "sizeThatFits" method and provide a size for your custom UIView class.
<br/><strong>&bull; Constant</strong> -> Sets the size of the area to the value that is provided. The value represents Width for the horizontal Grid and Height for the vertical Grid.
<br/><strong>&bull; Expanded</strong> -> Expands the view area to the remaining area from the Auto and Constant cells, propotional to the total defined Expanded cell values. The default Expanded cell value is 1 when it's not provided.

<br/><br/>**Example:** When you have views that have Expanded cell types, then their size proportions are going to be calculated using this formula:
_<br/>ViewSize = ViewExpandedValue / TotalExpandedValue_
<br/>So this means that if you have 2 views that have Expanded cell type and value of the first one is 1 and the value of the second one is 2 then their sizes are going to be proportional to this value:
<br/>_OwnerGridsSize - (TotalAutoCalculatedSizes + TotalConstantSizes)_
<br/>And the proportions are going to be 1/3 and 2/3.  

# Code examples:

## Image-Title-Body Example:
<img src="https://i.hizliresim.com/43v4hpk.jpg"
data-canonical-src="https://i.hizliresim.com/43v4hpk.jpg"
width="800" height="553" />

## Loop Example: Checkers View:
<img src="https://i.hizliresim.com/leufzyl.jpg"
data-canonical-src="https://i.hizliresim.com/leufzyl.jpg"
width="800" height="633" />
