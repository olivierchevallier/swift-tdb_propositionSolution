//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// TransitLineControl :
//
// Créé par : Olivier Chevallier le 24.09.19
//--------------------------------------------------


import UIKit

class TransitLineControl: UILabel {
    var line: TransitLine? {
        didSet {
            setup()
        }
    }
    
    private func setup() {
        if line != nil {
            self.backgroundColor = line!.backgroundColor
            self.textColor = line!.textColor
            clipsToBounds = true
            //layer.backgroundColor = line!.backgroundColor.cgColor
            textAlignment = .center
            if line!.transitOperator != "TPG" {
                text = line!.type + line!.number
                sizeToFit()
                widthAnchor.constraint(equalToConstant: frame.size.width + 10).isActive = true
            } else {
                text = line!.number
                layer.cornerRadius = 10
                heightAnchor.constraint(equalToConstant: 20).isActive = true
                widthAnchor.constraint(equalToConstant: 35).isActive = true
            }
        } else {
            text = "🚶‍♂️"
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
