//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// String+SplitAtFirst :
//
// Créé par : Olivier Chevallier le 07.10.19
//--------------------------------------------------


import Foundation

extension String {
    /// Fonction permettant de récupérer la sous-chaine de caractère se trouvant avant le caractère indiqué et celle se trouvant après.
    /// Le code vient de : https://stackoverflow.com/questions/27226128/what-is-the-more-elegant-way-to-remove-all-characters-after-specific-character-i
    public func splitAtFirst(delimiter: String) -> (first: String, last: String)? {
        guard let upperIndex = (range(of: delimiter)?.upperBound), let lowerIndex = (range(of: delimiter)?.lowerBound) else {
            return (self, self)
        }
        let firstPart: String = .init(prefix(upTo: lowerIndex))
        let lastPart: String = .init(suffix(from: upperIndex))
        return (firstPart, lastPart)
    }
}
