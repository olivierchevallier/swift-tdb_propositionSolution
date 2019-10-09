//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// SettingsViewController :
//
// Créé par : Olivier Chevallier le 09.10.19
//--------------------------------------------------


import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    //MARK: - Properties
    //MARK: Immutable
    let defaults = UserDefaults.standard
    
    //MARK: Mutable
    var walkSpeed: Double = 4.5
    var homeAdress: String = ""
    var electric: Bool = false
    var consumption: Double = 7.5
    var weight: Int = 1510
    
    //MARK: Controls
    @IBOutlet var txt_walkSpeed: UITextField!
    @IBOutlet var txt_homeAdress: UITextField!
    @IBOutlet var sw_electric: UISwitch!
    @IBOutlet var txt_consumption: UITextField!
    @IBOutlet var txt_weight: UITextField!
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()

        loadPreferences()
        showPreferences()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK: Private methods
    private func loadPreferences() {
        if defaults.bool(forKey: "configured") {
            walkSpeed = defaults.double(forKey: "walkSpeed")
            homeAdress = defaults.string(forKey: "homeAdress")!
        }
        electric = defaults.bool(forKey: "electric")
        if !electric {
            if defaults.double(forKey: "consumption") != 0 {
                consumption = defaults.double(forKey: "consumption")
            }
        }
        if defaults.integer(forKey: "weight") != 0 {
            weight = defaults.integer(forKey: "weight")
        }
    }
    
    private func showPreferences() {
        txt_walkSpeed.text = String(walkSpeed)
        txt_homeAdress.text = homeAdress
        sw_electric.isOn = electric
        txt_consumption.text = String(consumption)
        txt_weight.text = String(weight)
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        print("rupestre")
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
