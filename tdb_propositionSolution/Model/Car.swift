//--------------------------------------------------
// Travail de bachelor - Proposition de solution
//
// Car : Classe modélisant la voiture de l'utilisateur, elle implémente le design pattern du singleton
//
// Créé par : Olivier Chevallier le 22.10.19
//--------------------------------------------------


import Foundation

class Car {
    //MARK: - Properties
    //MARK: Immutable
    static let defaults = UserDefaults.standard
    
    //MARK: Mutable
    private static var instance: Car {
        let electric = defaults.bool(forKey: "electric")
        var consumption = 0.0
        var weight = 0
        if !electric {
            if defaults.double(forKey: "consumption") != 0 {
                consumption = defaults.double(forKey: "consumption")
            }
        }
        if defaults.integer(forKey: "weight") != 0 {
            weight = defaults.integer(forKey: "weight")
        }
        let car = Car(weight: weight, electric: electric, consumption: consumption)
        return car
    }
    var weight: Int
    var electric: Bool
    var consumption: Double
    var emmissionPerKm: Double {
        get {
            if electric {
                return getElectricEmmisionPerKm()
            } else {
                return getThermicEmmisionPerKm()
            }
        }
    }
    
    //MARK: - Initializer
    init(weight: Int, electric: Bool, consumption: Double) {
        self.weight = weight
        self.electric = electric
        self.consumption = consumption
    }
    
    //MARK: - Private methods
    private func getElectricEmmisionPerKm() -> Double {
        let directUse = 6.52
        let indirectUse = 20.29
        let maintaining = 26.26 / 1000 * Double(weight)
        let recycling = (38.92 / 1000 * Double(weight)) + 38.63
        let delivery = 9.01 / 1000 * Double(weight)
        return directUse + indirectUse + maintaining + recycling + delivery
    }

    private func getThermicEmmisionPerKm() -> Double {
        let directUse = 25.65 * consumption
        let indirectUse = 6.12 * consumption
        let maintaining = 4.02 / 1000 * Double(weight)
        let recycling = 37.59 / 1000 * Double(weight)
        let delivery = 8.87 / 1000 * Double(weight)
        return directUse + indirectUse + maintaining + recycling + delivery
    }

    //MARK: - Public methods
    /// Permet de récupérer l'instance unique de la classe
    public static func getInstance() -> Car {
        return instance
    }
}
