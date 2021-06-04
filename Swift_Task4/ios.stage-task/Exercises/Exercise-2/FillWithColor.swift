import Foundation

final class FillWithColor {
    
    func fillWithColor(_ image: [[Int]], _ row: Int, _ column: Int, _ newColor: Int) -> [[Int]] {
        if image.count < 1, row > 50, image[row][column] < 0, newColor >= 65536 {
            return image
        }
        
        var pixelsToBeColored = image
        let initialPixelValue = image[row][column]
        pixelsToBeColored[row][column] = newColor
        let nearestPixels = [(row + 1, column), (row - 1, column), (row, column + 1), (row, column - 1)]
        
        for (row, column) in nearestPixels {
            if row >= 0, row < image.count, column >= 0, column < image[row].count {
                if image[row][column] == initialPixelValue {
                    pixelsToBeColored = fillWithColor(pixelsToBeColored, row, column, newColor)
                }
            }
            
        }
        
        return pixelsToBeColored
    }
}
