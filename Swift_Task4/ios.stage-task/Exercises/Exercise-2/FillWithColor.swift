import Foundation

final class FillWithColor {
    
    func fillWithColor(_ image: [[Int]], _ row: Int, _ column: Int, _ newColor: Int) -> [[Int]] {
        guard let columns = image.first else {
            return image
        }
        
        let isImageAlreadyPainted = image.allSatisfy{ $0 == image.first && $0.allSatisfy{ $0 == newColor} }
        
        if image.count < 1 || row < 0 || row >= image.count || row > 50 || column < 0 || columns.count < 1 || column >= columns.count || newColor >= 65536 || image[row][column] < 0 || isImageAlreadyPainted {
            return image
        }
        
        var pixelsToBeColored = image
        let initialPixelValue = image[row][column]
        
        pixelsToBeColored[row][column] = newColor
        let nearestPixels = [(row + 1, column), (row - 1, column), (row, column + 1), (row, column - 1)]
        
        for (row, column) in nearestPixels {
            if row >= 0 && row < image.count && column >= 0 && column < image[row].count {
                if image[row][column] == initialPixelValue {
                    pixelsToBeColored = fillWithColor(pixelsToBeColored, row, column, newColor)
                }
            }
            
        }
        
        return pixelsToBeColored
    }
}
