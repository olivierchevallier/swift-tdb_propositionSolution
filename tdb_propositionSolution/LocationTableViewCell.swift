//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// LocationTableViewCell : Cellule de la TableView affichant les résultats de recherche
//
// Créé par : Olivier Chevallier le 11.09.19
//--------------------------------------------------

import UIKit

class LocationTableViewCell: UITableViewCell {
    //MARK: Properties
    @IBOutlet var lbl_locationName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
