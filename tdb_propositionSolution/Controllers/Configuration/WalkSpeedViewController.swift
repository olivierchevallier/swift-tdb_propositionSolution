//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// WalkSpeedViewController : Contrôleur de la vue de configuration de la vitesse de marche
//
// Créé par : Olivier Chevallier le 02.10.19
//--------------------------------------------------


import UIKit

class WalkSpeedViewController: UIViewController {
    //MARK: - Properties
    //MARK: Controls
    @IBOutlet var btn_fast: ConfigButtonControl!
    @IBOutlet var btn_average: ConfigButtonControl!
    @IBOutlet var btn_slow: ConfigButtonControl!
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Actions
    @IBAction func btn_tapped(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        
        switch sender {
        case btn_fast:
            defaults.set(5.5, forKey: "walkSpeed")
        case btn_average:
            defaults.set(4.5, forKey: "walkSpeed")
        case btn_slow:
            defaults.set(3.5, forKey: "walkSpeed")
        default:
            defaults.set(0.0, forKey: "walkSpeed")
        }
        performSegue(withIdentifier: "HomeAdressSegue", sender: self)
    }
}
