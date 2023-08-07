import XCTest
@testable import GridLayout

final class GridLayoutTests: XCTestCase {
    
    func generateString(_ count: Int) -> String {
        return Array.init(repeating: "A", count: count).joined(separator: "")
    }
    
    //There was a problem that causes grid to calculate sizeThatFits wrong when inner views collapse to a smaller size after the grid laid out at least once.
    //This test is for guaranteeing that the grid calculates it's sizeThatFits right.
    func test_sizeThatFits_collapse_back_to_original_size() {
        
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
                .Constant(value: 30)
            label
                .Expanded()
        }
        
        let initialSize = innerGrid.sizeThatFits(screenSize)
        
        label.text = generateString(multiLineTextCount)
        let expandedSize = innerGrid.sizeThatFits(screenSize)
        
        label.text = generateString(oneLineTextCount)
        let returnedSize = innerGrid.sizeThatFits(screenSize)
        
        XCTAssertTrue(initialSize != expandedSize)
        XCTAssertTrue(expandedSize != returnedSize)
        XCTAssertTrue(returnedSize == initialSize)
    }
}
