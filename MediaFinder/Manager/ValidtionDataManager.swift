//
//  ValidtionDataManager.swift
//  MediaFinder
//
//  Created by Tolba Hamdi on 12/16/22.
//

import Foundation

struct ValidtionDataManager {
    
    // MARK:- Properties
    static let shared: ValidtionDataManager = ValidtionDataManager()
    private let formate = ValidationRegex.formate
    
    // MARK:- Initializer
    private init (){}
}

// MARK:- Methods
extension ValidtionDataManager {
    func isValidEmail(email: String) -> Bool {
        let regex = ValidationRegex.email
        let predicate = NSPredicate(format: formate, regex)
        return predicate.evaluate(with: email)
    }
    
    func isValidPassword(password: String) -> Bool {
        let regex = ValidationRegex.password
        let predicate = NSPredicate(format: formate, regex)
        return predicate.evaluate(with: password)
    }
    
    func isValidPhone(phone: String) -> Bool {
        let regex = ValidationRegex.phone
        let predicate = NSPredicate(format: formate, regex)
        return predicate.evaluate(with: phone)
    }
}
