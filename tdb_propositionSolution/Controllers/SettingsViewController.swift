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
    var walkSpeed: Double = 4.5 {
        didSet {
            txt_walkSpeed.text = String(walkSpeed)
            step_walkSpeed.value = walkSpeed * 2
        }
    }
    var home: Location? {
        didSet {
            txt_homeAdress.text = home!.name
        }
    }
    var electric: Bool = false {
        didSet {
            sw_electric.isOn = electric
            sw_electricChanged(sw_electric)
        }
    }
    var consumption: Double = 7.5 {
        didSet {
            txt_consumption.text = String(consumption)
        }
    }
    var weight: Int = 1510 {
        didSet {
            txt_weight.text = String(weight)
        }
    }
    
    //MARK: Controls
    @IBOutlet var txt_walkSpeed: UITextField!
    @IBOutlet var step_walkSpeed: UIStepper!
    @IBOutlet var txt_homeAdress: UITextField!
    @IBOutlet var sw_electric: UISwitch!
    @IBOutlet var txt_consumption: UITextField!
    @IBOutlet var txt_weight: UITextField!
    @IBOutlet var btn_save: UIBarButtonItem!
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()

        loadPreferences()
        txt_homeAdress.delegate = self
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK: Private methods
    private func loadPreferences() {
        if defaults.double(forKey: "walkSpeed") != 0 {
            walkSpeed = defaults.double(forKey: "walkSpeed")
        }
        if defaults.string(forKey: "homeAdress") != nil && defaults.double(forKey: "homeLongitude") != 0.0 && defaults.double(forKey: "homeLatitude") != 0.0 {
            let homeAdress = defaults.string(forKey: "homeAdress")!
            home = Location(name: homeAdress, coordinate: [defaults.double(forKey: "homeLongitude"), defaults.double(forKey: "homeLatitude")])
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
        weight = Int(txt_weight.text!)!
    }
    
    private func savePreferences() {
        defaults.set(walkSpeed, forKey: "walkSpeed")
        defaults.set(consumption, forKey: "consumption")
        defaults.set(electric, forKey: "electric")
        defaults.set(weight, forKey: "weight")
        if home != nil {
            defaults.set(home!.name, forKey: "homeAdress")
            defaults.set(home!.coordinate.longitude, forKey: "homeLongitude")
            defaults.set(home!.coordinate.latitude, forKey: "homeLatitude")
        } else {
            defaults.set(nil, forKey: "homeAdress")
            defaults.set(0.0, forKey: "homeLongitude")
            defaults.set(0.0, forKey: "homeLatitude")
        }
        updateCarInstance()
    }
    
    private func updateCarInstance() {
        let car = Car.getInstance()
        car.weight = weight
        car.consumption = consumption
        car.electric = electric
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
                self.home = location
            } else {
                self.txt_homeAdress.text = ""
                self.home = nil
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
    
    @IBAction func step_walkSpeedChanged(_ sender: Any) {
        walkSpeed = step_walkSpeed.value / 2
        updateSaveButton()
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
