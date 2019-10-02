//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// TransitSubscibtionViewController :
//
// Créé par : Olivier Chevallier le 02.10.19
//--------------------------------------------------


import UIKit

class TransitSubscibtionViewController: UIViewController {
    //MARK: - Properties
    //MARK: Controls
    @IBOutlet var btn_yesUnireseau: ConfigButtonControl!
    @IBOutlet var btn_yesAG: ConfigButtonControl!
    @IBOutlet var btn_yesHalf: ConfigButtonControl!
    @IBOutlet var btn_no: ConfigButtonControl!
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - Actions
    @IBAction func btn_tapped(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        
        switch sender {
            case btn_no:
                defaults.set("none", forKey: "transitSubscription")
            case btn_yesAG:
                defaults.set("AG", forKey: "transitSubscription")
            case btn_yesHalf:
                defaults.set("half", forKey: "transitSubscription")
            case btn_yesUnireseau:
                defaults.set("unireseau", forKey: "transitSubscription")
            default:
                defaults.set("", forKey: "transitSubscription")
        }
        performSegue(withIdentifier: "WalkSpeedSegue", sender: self)
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
