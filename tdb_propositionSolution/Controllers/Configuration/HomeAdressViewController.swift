//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// HomeAdressViewController :
//
// Créé par : Olivier Chevallier le 02.10.19
//--------------------------------------------------


import UIKit

class HomeAdressViewController: UIViewController {
    //MARK: - Properties
    //MARK: Controls
    @IBOutlet var txt_adress: UITextField!
    @IBOutlet var btn_finish: ConfigButtonControl!
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "configured")
        segue.destination.modalPresentationStyle = .fullScreen
        resignFirstResponder()
    }

}
