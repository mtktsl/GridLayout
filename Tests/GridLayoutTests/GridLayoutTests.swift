import XCTest
@testable import GridLayout

final class GridLayoutTests: XCTestCase {
    
    func generateString(_ count: Int) -> String {
        return Array.init(repeating: "A", count: count).joined(separator: "")
    }
    
    func testSizeThatFits_singleHorizontalGrid() {
        
        let label = UILabel()
        label.text = "Lorem ipsum dolor sit amet. Lorem ipsun dolor sit amet."
        
        let grid = Grid.horizontal {
            label
                .auto()
                .maxLength(100)
                .horizontalAlignment(.autoLeft)
        }
        
        let testSize: CGSize = .zero
        
        let labelSize = label.sizeThatFits(testSize)
        let gridSize = grid.sizeThatFits(testSize)
        
        XCTAssertTrue(labelSize == gridSize)
    }
    
    func testInnerOrthogonalAutoGrid() {
        let label = UILabel()
        label.numberOfLines = 0
        
        label.text = "Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet."
        
        let innerGrid = Grid.horizontal {
            UIView()
                .expanded()
            label
                .auto()
                .maxLength(100)
        }
        
        let grid = Grid.vertical {
            innerGrid
                .auto()
        }
        
        grid.frame = .init(origin: .zero, size: .init(width: 430, height: 932))
        grid.bounds.size = .init(width: 430, height: 932)
        grid.setNeedsLayout()
        grid.layoutIfNeeded()
        
        //100, 162.33334
        print(innerGrid.frame)
        grid.setContentAlignment(for: label) { view in
            view
                .expanded()
        }
    }
    
    //There was a problem that causes grid to calculate sizeThatFits wrong when inner views collapse to a smaller size after the grid laid out at least once.
    //This test is for guaranteeing that the grid calculates it's sizeThatFits correctly.
    /*func test_sizeThatFits_collapse_back_to_original_size() {
        
        let oneLineTextCount = 50
        let multiLineTextCount = 400
        
        let screenWidth = 383
        
        let screenSize = CGSize(
            width: screenWidth,
            height: .zero
        )
        
        let label = UILabel()
        label.numberOfLines = 0
        label.text = generateString(oneLineTextCount)
        
        let innerGrid = Grid.horizontal {
            UIView()
                .constant(30)
            label
                .expanded()
        }
        
        let initialSize = innerGrid.sizeThatFits(screenSize)
        
        label.text = generateString(multiLineTextCount)
        let expandedSize = innerGrid.sizeThatFits(screenSize)
        
        label.text = generateString(oneLineTextCount)
        let returnedSize = innerGrid.sizeThatFits(screenSize)
        
        XCTAssertTrue(initialSize != expandedSize)
        XCTAssertTrue(expandedSize != returnedSize)
        XCTAssertTrue(returnedSize == initialSize)
    }*/
}
