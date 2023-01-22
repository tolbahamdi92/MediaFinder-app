//
//  UserDBSQLiteManager.swift
//  MediaFinder
//
//  Created by Tolba Hamdi on 1/13/23.
//

import Foundation
import SQLite

enum Status {
    case success
    case found
    case error
}

class UserDBSQLiteManager {
    
    // MARK:- Properties
    private var db: Connection!
    static let shared = UserDBSQLiteManager()
    private let usersTable = Table(SQL.userTable)
    private let email = Expression<String>(SQL.email)
    private let userData = Expression<Data>(SQL.userData)
    private let mediaType = Expression<String>(SQL.mediaType)
    private let results = Expression<Data>(SQL.results)
    
    //MARK:- Initializer
    private init() {
        initDB()
    }
}

// MARK:- Methods
extension UserDBSQLiteManager {
    private func initDB() {
        do {
            let docDir = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = docDir.appendingPathComponent(SQL.userPathComponent).appendingPathExtension(SQL.pathExtension)
            let database = try Connection(fileURL.path)
            self.db = database
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func createUsersTable () {
        do {
            try self.db.run(usersTable.create(ifNotExists: true) { table in
                table.column(self.email, primaryKey: true)
                table.column(self.userData)
                table.column(self.mediaType)
                table.column(self.results)
            })
        }
        catch {
            print("erorr created")
            print(error.localizedDescription)
        }
    }
    
    func fetchUser(email: String) -> User? {
        do {
            let users = try self.db.prepare(self.usersTable)
            var userData: User?
            for user in users where user[self.email] == email {
                let userFromData = try JSONDecoder().decode(User.self, from: user[self.userData])
                userData = userFromData
            }
            return userData
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func saveUser(_ user: User) -> Status {
        do{
            createUsersTable()
            let count = try db.scalar(self.usersTable.filter(self.email == user.email).count)
            if count > 0 {
                return .found
            } else {
                let data = try JSONEncoder().encode(user)
                try self.db.run(usersTable.insert(self.email <- user.email, self.userData <- data, self.mediaType <- "", self.results <- Data()))
                return .success
            }
        }
        catch {
            print(error.localizedDescription)
            return .error
        }
    }
    
    func updateUser(oldEmail: String, _ user: User) -> Status {
        do{
            let userFilter = self.usersTable.filter(self.email == oldEmail)
            let data = try JSONEncoder().encode(user)
            let updateUser = userFilter.update(self.email <- user.email, self.userData <- data)
            try self.db.run(updateUser)
            UserDefaults.standard.set(user.email, forKey: UserDefaultsKeys.email)
            return .success
        }
        catch {
            print(error.localizedDescription)
            return .error
        }
    }
    
    public func isValidLogin(email: String, password: String) -> Bool {
        if let user = fetchUser(email: email) {
            if user.email == email && user.password == password {
                UserDefaults.standard.set(email, forKey: UserDefaultsKeys.email)
                return true
            }
            return false
        }
        return false
    }
    
    func saveSearchData(email: String, type: String, media: [Media]) {
        do{
            let userFilter = self.usersTable.filter(self.email == email)
            let data = try JSONEncoder().encode(media)
            let updateUser = userFilter.update(self.mediaType <- type, self.results <- data)
            try self.db.run(updateUser)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchSearchData(email: String) -> (String?, [Media]?) {
        do {
            let data = try self.db.prepare(self.usersTable)
            var mediaData: [Media]?
            var mediaType: String?
            for item in data where item[self.email] == email {
                let mediaFromData = try JSONDecoder().decode([Media].self, from: item[self.results])
                mediaType = item[self.mediaType]
                mediaData = mediaFromData
            }
            return (mediaType, mediaData)
        } catch {
            print(error.localizedDescription)
            return (nil,nil)
        }
    }
}
