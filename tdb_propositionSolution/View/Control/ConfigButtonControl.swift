//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// GoButtonControl : Control basé sur un bouton avec bords arrondis et status de chargement
//
// Créé par : Olivier Chevallier le 20.09.19
//--------------------------------------------------


import UIKit

class ConfigButtonControl: UIButton {
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setStyle()
    }
    
    //MARK: - Private methods
    private func setStyle() {
        layer.cornerRadius = 10
    }
}
