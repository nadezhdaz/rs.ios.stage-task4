import Foundation

public extension Int {
    var roman: String? {
        let romanDictionary: KeyValuePairs = [1000 : "M", 900: "CM", 500 : "D", 400: "CD", 100 : "C", 90 : "XC", 50 : "L", 40 : "XL", 10 : "X", 9 : "IX", 5 : "V", 4 : "IV", 1 : "I"]
        
        var input = self
        
        if input >= 1 && input <= 3999 {
            var result = ""
            for (number, roman) in romanDictionary {
                while input >= number {
                    input -= number
                    result += roman
                }
            }
            return result
        } else {
            return nil
        }
    }
}
