//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// CarConfigViewController : Contrôleur de la vue de configuration de la voiture
//
// Créé par : Olivier Chevallier le 02.10.19
//--------------------------------------------------


import UIKit

class CarConfigViewController: UIViewController {
    //MARK: - Properties
    //MARK: - Immutable
    let defaults = UserDefaults.standard
    
    //MARK: Mutable
    var electric: Bool = false
    var consumption: Double = 7.5
    var weight: Int = 1510
    
    //MARK: Controls
    @IBOutlet var sw_electric: UISwitch!
    @IBOutlet var txt_consumption: UITextField!
    @IBOutlet var txt_weight: UITextField!
    @IBOutlet var btn_next: ConfigButtonControl!
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        showDefaultData()
        updateNextButton()
    }
    
    //MARK: - Private methods
    private func showDefaultData() {
        sw_electric.isOn = electric
        sw_electricChanged(sw_electric)
        txt_weight.text = String(weight)
    }
    
    /// Active ou désactive le bouton permettant de passer à l'ecran suivant en fonction de la validité des données
    private func updateNextButton() {
        let consumptionValid = Double(txt_consumption.text!) != nil || sw_electric.isOn
        let weightValid = Int(txt_weight.text!) != nil
        if  consumptionValid && weightValid {
            btn_next.isEnabled = true
        } else {
            btn_next.isEnabled = false
        }
    }
    
    /// Traite les données rensignées par l'utilisateur pour les préparer à l'enregistrement
    private func castData() {
        consumption = sw_electric.isOn ? 0 : Double(txt_consumption.text!)!
        electric = sw_electric.isOn
        weight = Int(txt_weight.text!)!
    }
    
    /// Enregistre les données 
    private func saveData() {
        defaults.set(consumption, forKey: "consumption")
        defaults.set(electric, forKey: "electric")
        defaults.set(weight, forKey: "weight")
    }
    
    //MARK: - Actions
    @IBAction func sw_electricChanged(_ sender: UISwitch) {
        if sender.isOn {
            txt_consumption.isEnabled = false
            txt_consumption.text = "-"
            txt_consumption.textColor = .secondaryLabel
        } else {
            txt_consumption.isEnabled = true
            txt_consumption.textColor = .label
            txt_consumption.text = String(consumption)
        }
        updateNextButton()
    }
    
    @IBAction func viewTapped(_ sender: Any) {
        for view in self.view.subviews {
            if let textField = view as? UITextField {
                if textField.isEditing {
                    textField.resignFirstResponder()
                }
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        castData()
        saveData()
    }
}
