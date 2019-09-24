//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// TransitItineraryTableViewCell :
//
// Créé par : Olivier Chevallier le 20.09.19
//--------------------------------------------------


import UIKit

class TransitItineraryTableViewCell: UITableViewCell {

    //MARK: - Properties
    //MARK: Controls
    @IBOutlet var lbl_times: UILabel!
    @IBOutlet var lbl_travelTime: UILabel!
    @IBOutlet var stk_lines: UIStackView!
    
    
    //MARK: - 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
