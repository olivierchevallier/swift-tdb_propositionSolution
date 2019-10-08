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
    
    //MARK: Mutable
    var textColor: UIColor
    var backgroundColor: UIColor
    
    //MARK: - Initializer
    init(transitOperator: String, number: String, destination: String, type: String) {
        self.transitOperator = transitOperator
        self.number = number
        self.destination = destination
        self.type = type
        textColor = UIColor.black
        backgroundColor = UIColor.red
        for lineColor in TransitLineColorsList.getInstance().lineColors {
            if lineColor.lineCode == number && transitOperator == "TPG" {
                textColor = UIColor(hex: lineColor.text)!
                backgroundColor = UIColor(hex: lineColor.background)!
            }
        }
    }
    
    convenience init(journey: TransitWebService.Journey) {
        self.init(transitOperator: journey.transitOperator, number: journey.number, destination: journey.to, type: journey.category)
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
