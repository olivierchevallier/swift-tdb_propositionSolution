//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// TransitNavigationCollectionViewCell :
//
// Créé par : Olivier Chevallier le 02.10.19
//--------------------------------------------------


import UIKit

class TransitNavigationCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    //MARK: Controls
    @IBOutlet var lbl_infos: UILabel!
    
    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
