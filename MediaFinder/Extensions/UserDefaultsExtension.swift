//
//  UserDefaultsExtension.swift
//  MediaFinder
//
//  Created by Tolba on 14/05/1444 AH.
//

import Foundation

extension UserDefaults {
    func setObject<T: Codable>(_ data: T, for key: String) {
        do {
            let data = try JSONEncoder().encode(data)
            set(data, forKey: key)
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    func getObject<T: Codable>(dataType: T.Type, key: String) -> T? {
        guard let userDefaultData = data(forKey: key) else {
            return nil
        }
        do {
            let data = try JSONDecoder().decode(T.self, from: userDefaultData)
            return data
        } catch  {
            print(error.localizedDescription)
            return nil
        }
    }
}
