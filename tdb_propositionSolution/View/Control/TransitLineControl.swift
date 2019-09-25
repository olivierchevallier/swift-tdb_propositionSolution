//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// TransitLineControl : Control basé sur un label permettant d'afficher correctement une ligne de transports publics
//
// Créé par : Olivier Chevallier le 24.09.19
//--------------------------------------------------


import UIKit

class TransitLineControl: UILabel {
    //MARK: - Properties
    var line: TransitLine? {
        didSet {
            setup()
        }
    }
    
    //MARK: - Private methods
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        if line != nil {
            self.backgroundColor = line!.backgroundColor
            self.textColor = line!.textColor
            clipsToBounds = true
            textAlignment = .center
            if line!.transitOperator != "TPG" {
                text = line!.type + line!.number
                sizeToFit()
                widthAnchor.constraint(equalToConstant: frame.size.width + 10).isActive = true
            } else {
                text = line!.number
                layer.cornerRadius = 10
                widthAnchor.constraint(equalToConstant: 35).isActive = true
            }
        } else {
            text = "🚶‍♂️"
        }
    }
}
