//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// UIColor+HexInit : Code source https://www.hackingwithswift.com/example-code/uicolor/how-to-convert-a-hex-color-to-a-uicolor
//
// Créé par : Olivier Chevallier le 24.09.19
//--------------------------------------------------

import UIKit

extension UIColor {
    /// Initialiseur permettant d'instancier une UIColor à partir du code hexadécimal passé sous forme de chaine de caractères avec ou sans #.
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        let start: String.Index
        
        if hex.hasPrefix("#") {
            start = hex.index(hex.startIndex, offsetBy: 1)
        } else {
            start = hex.startIndex
        }
        
        let hexColor = String(hex[start...])
        
        if hexColor.count == 6 {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                b = CGFloat((hexNumber & 0x0000ff)) / 255
                a = CGFloat(255)
                
                self.init(red: r, green: g, blue: b, alpha: a)
                return
            }
        }
        
        return nil
    }
}
