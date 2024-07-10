//
//  AlertError.swift
//  CountOnMe
//
//  Created by Aristide LAUGA on 19/06/2024.
//  Copyright © 2024 Vincent Saluzzo. All rights reserved.
//

import Foundation

enum AlertError: Error {
    case dividedByZero
    case operatorAlreadyPresent
    case startNewComputation
    case enterCorrectExpression
    
    var title: String {
        switch self {
        case .dividedByZero, .operatorAlreadyPresent, .enterCorrectExpression:
            "Zéro"
        case .startNewComputation:
            "Erreur"
        }
    }
    
    var message: String {
        switch self {
        case .dividedByZero:
            "Vous ne pouvez pas diviser par zéro !"
        case .operatorAlreadyPresent:
            "Un opérateur est déjà mis !"
        case .startNewComputation:
            "Démarrez un nouveau calcul !"
        case .enterCorrectExpression:
            "Entrez une expression correcte !"
        }
    }
    
    enum ErrorActionTitle: String {
        case OK
    }
}
