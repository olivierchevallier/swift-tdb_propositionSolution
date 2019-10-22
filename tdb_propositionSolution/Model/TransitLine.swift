//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// TransitLine : Classe représentant une ligne de transports publics
//
// Créé par : Olivier Chevallier le 24.09.19
//--------------------------------------------------


import UIKit

class TransitLine {
    //MARK: - Properties
    //MARK: Immutable
    let transitOperator: String
    let number: String
    let destination: String
    let type: String
    let colors: (background: UIColor, text: UIColor)
    
    //MARK: Mutable
    var textColor: UIColor {
        get {
            return colors.text
        }
    }
    var backgroundColor: UIColor {
        get {
            return colors.background
        }
    }
    
    //MARK: - Initializer
    init(transitOperator: String, number: String, destination: String, type: String) {
        self.transitOperator = transitOperator
        self.number = number
        self.destination = destination
        self.type = type
        self.colors = TransitLine.getColors(transitOperator: transitOperator, number: number)
    }
    
    convenience init(journey: TransitWebService.Journey) {
        self.init(transitOperator: journey.transitOperator, number: journey.number, destination: journey.to, type: journey.category)
    }
    
    //MARK: - Private methods
    private static func getColors(transitOperator: String, number: String) -> (background: UIColor, text: UIColor) {
        if transitOperator == "SBB" {
            return (background: UIColor.red, text: UIColor.black)
        } else {
            for lineColor in TransitLineColorsList.getInstance().lineColors {
                if lineColor.lineCode == number && transitOperator == "TPG" {
                    return (background: UIColor(hex: lineColor.background)!, text: UIColor(hex: lineColor.text)!)
                }
            }
        }
        return (background: UIColor(hex: "0a3689")!, text: UIColor.white)
    }
    
    //MARK: - Public methods
    public func getAvgSpeed() -> Double {
        guard let urlPath = Bundle.main.url(forResource: "TPGAvgSpeed", withExtension: "plist") else {
            fatalError("Could not read average speed file")
        }
        if let avgSpeeds = NSDictionary(contentsOf: urlPath) as? Dictionary<String, Double> {
            guard let avgSpeed = avgSpeeds[self.number] else {
                var total = 0.0
                for value in avgSpeeds.values {
                    total += value
                }
                return total / Double(avgSpeeds.count)
            }
            return avgSpeed
        }
        return 0.0
    }
}
