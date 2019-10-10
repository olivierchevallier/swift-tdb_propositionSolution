//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// SettingsViewController :
//
// Créé par : Olivier Chevallier le 09.10.19
//--------------------------------------------------


import UIKit
import CoreLocation

class SettingsViewController: UIViewController, UITextFieldDelegate {
    //MARK: - Properties
    //MARK: Immutable
    let defaults = UserDefaults.standard
    let genevaCoordinates = CLLocationCoordinate2D(latitude: 42.206130, longitude: 6.147783)
    
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
    @IBOutlet var btn_save: UIBarButtonItem!
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()

        loadPreferences()
        showPreferences()
        txt_homeAdress.delegate = self
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK: Private methods
    private func loadPreferences() {
        if defaults.double(forKey: "walkSpeed") != 0 {
            walkSpeed = defaults.double(forKey: "walkSpeed")
        }
        if defaults.string(forKey: "homeAdress") != nil {
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
        sw_electricChanged(sw_electric)
        txt_weight.text = String(weight)
    }
    
    func updateSaveButton() {
        let walkSpeedValid = Double(txt_walkSpeed.text!) != nil
        let consumptionValid = Double(txt_consumption.text!) != nil || sw_electric.isOn
        let weightValid = Int(txt_weight.text!) != nil
        if  walkSpeedValid && consumptionValid && weightValid {
            btn_save.isEnabled = true
        } else {
            btn_save.isEnabled = false
        }
    }
    
    private func castPreferences() {
        walkSpeed = Double(txt_walkSpeed.text!)!
        consumption = sw_electric.isOn ? 0 : Double(txt_consumption.text!)!
        electric = sw_electric.isOn
        homeAdress = txt_homeAdress.text!
        weight = Int(txt_weight.text!)!
    }
    
    private func savePreferences() {
        defaults.set(walkSpeed, forKey: "walkSpeed")
        defaults.set(consumption, forKey: "consumption")
        defaults.set(electric, forKey: "electric")
        defaults.set(homeAdress, forKey: "homeAdress")
        defaults.set(weight, forKey: "weight")
    }
    
    //MARK: Actions
    @IBAction func textFieldChanged(_ sender: UITextField) {
        updateSaveButton()
    }
    
    @IBAction func txt_homeAdressEdited(_ sender: Any) {
        let locations = LocationsList(proximity: genevaCoordinates)
        locations.searchTxt = txt_homeAdress.text
        locations.locationsObtained {
            if let location = locations.locations.first {
                self.txt_homeAdress.text = location.name
            } else {
                self.txt_homeAdress.text = ""
            }
        }
        updateSaveButton()
    }
    
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
        updateSaveButton()
    }
    
    @IBAction func btn_savePressed(_ sender: Any) {
        castPreferences()
        savePreferences()
        btn_save.isEnabled = false
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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
