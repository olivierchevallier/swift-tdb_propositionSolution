//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// TransitLine :
//
// Créé par : Olivier Chevallier le 24.09.19
//--------------------------------------------------


import UIKit

class TransitLine {
    //MARK: - Properties
    let transitOperator: String
    let number: String
    let destination: String
    let type: String
    var textColor: UIColor
    var backgroundColor: UIColor
    
    //MARK: Initializer
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
}
