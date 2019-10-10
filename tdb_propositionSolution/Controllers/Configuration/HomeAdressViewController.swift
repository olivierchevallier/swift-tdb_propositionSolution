//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// HomeAdressViewController :
//
// Créé par : Olivier Chevallier le 02.10.19
//--------------------------------------------------


import UIKit
import CoreLocation

class HomeAdressViewController: UIViewController, UITextFieldDelegate {
    //MARK: - Properties
    //MARK: Immutable
    let genevaCoordinates = CLLocationCoordinate2D(latitude: 42.206130, longitude: 6.147783)
    
    //MARK: Controls
    @IBOutlet var txt_adress: UITextField!
    @IBOutlet var btn_finish: ConfigButtonControl!
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        txt_adress.delegate = self
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Actions
    @IBAction func txt_homeAdressEdited(_ sender: Any) {
        let locations = LocationsList(proximity: genevaCoordinates)
        locations.searchTxt = txt_adress.text
        locations.locationsObtained {
            if let location = locations.locations.first {
                self.txt_adress.text = location.name
            } else {
                self.txt_adress.text = ""
            }
        }
    }
    
    //MARK: - UITextFieldDelegate    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "configured")
        defaults.set(txt_adress.text!, forKey: "homeAdress")
        resignFirstResponder()
    }

}
