//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// GoButtonControl : Control basé sur un bouton avec bords arrondis et status de chargement
//
// Créé par : Olivier Chevallier le 20.09.19
//--------------------------------------------------


import UIKit

class GoButtonControl: UIButton {
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
    
    //MARK: - Public methods
    /// Affiche / cache un indicateur de chargement à la place du texte du bouton et le désactive
    func isLoading(_ loading: Bool) {
        let tag = 4242
        if loading {
            self.isEnabled = false
            self.setTitleColor(UIColor.clear, for: .disabled)
            let indic = UIActivityIndicatorView()
            let buttonYCenter = self.bounds.size.height / 2
            let buttonXCenter = self.bounds.size.width / 2
            indic.center = CGPoint(x: buttonXCenter, y: buttonYCenter)
            indic.tag = tag
            self.addSubview(indic)
            indic.startAnimating()
        } else {
            if let indic = self.viewWithTag(tag) as? UIActivityIndicatorView {
                self.isEnabled = true
                indic.stopAnimating()
                indic.removeFromSuperview()
            }
        }
    }
}
