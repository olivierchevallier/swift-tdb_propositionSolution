//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// WalkSpeedViewController :
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

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btn_tapped(_ sender: Any) {
        performSegue(withIdentifier: "HomeAdressSegue", sender: self)
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
