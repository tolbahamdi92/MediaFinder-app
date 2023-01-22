//
//  Constants.swift
//  MediaFinder
//
//  Created by Tolba on 23/06/1444 AH.
//

import Foundation

// MARK:- StoryBoard
struct StoryBoard {
    static let main = "Main"
}

// MARK:- ViewController
struct ViewController {
    static let signUpVC = "SignUpVC"
    static let signInVC = "SignInVC"
    static let profileVC = "ProfileVC"
    static let mapVC = "MapVC"
    static let mediaVC = "MediaVC"
    static let locationSearchTVC = "LocationSearchTVC"
}

// MARK:- ViewControllerTitle
struct ViewControllerTitle {
    static let signUp = "Sign Up"
    static let userDataEditing = "User Data"
    static let signIn = "Sign In"
    static let profile = "Profile"
    static let media = "Media"
}

// MARK:- Cells
struct  Cells {
    static let media = "MediaTVC"
    static let locationSearch = "cell"
}

// MARK:- ButtonsTitle
struct ButtonsTitle {
    static let signUp = "Sign Up"
    static let saveData = "Save Data"
    static let logOut = "Log out"
    static let profile = "Profile"
    static let ok = "OK"
}

// MARK:- UserDefaultsKeys
struct UserDefaultsKeys {
    static let isLoggedIn = "isLoggedIn"
    static let email = "email"
}

// MARK:- URLs
struct URLs {
    static let base = "https://itunes.apple.com/search?"
}

// MARK:- ParameterKey
struct ParameterKey {
    static let term = "term"
    static let media = "media"
}

// MARK:- ValidationRegex
struct ValidationRegex {
    static let formate = "SELF MATCHES %@"
    static let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9._]+\\.[A-Za-z]{2,}"
    static let password = "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}"
    static let phone = "^[0-9]{11}$"
}

// MARK:- SQL
struct SQL {
    static let userTable = "users"
    static let id = "id"
    static let email = "email"
    static let userData = "userData"
    static let userPathComponent = "users"
    static let pathExtension = "sqlite3"
    
    static let searchDataTable = "searchData"
    static let mediaType = "mediaType"
    static let results = "results"
    static let searchPathComponent = "searchData"
}

// MARK:- PlaceholderImage
struct PlaceholderImage {
    static let user = "user"
    static let search = "search"
}

// MARK:- PlaceholderText
struct PlaceholderText {
    static let searchMap = "Search for places"
}

// MARK:- Alerts
struct Alerts {
    static let sorryTitle = "Sorry"
    static let successTitle = "Success"
    static let validEmail = " Please enter valid email \n Example tolba@gmail.com"
    static let validPassword = "Please enter valid password \n contains at least one upper character \n contains at least one small character \n contain at least one number \n At least total 8 character"
    static let validPhone = "Please enter valid phone \n Example 01055555555"
    static let noImage = "Please choose your photo"
    static let noName = "Please enter your name"
    static let noEmail = "Please enter your email"
    static let noPassword = "Please enter your password"
    static let noPhone = "Please enter your phone"
    static let noAddress = "Please enter your address"
    static let noFoundData = "No Found Data"
    static let noSearchData = "please enter data in search"
    static let moreCharacterSearch = "please enter at least 3 characters"
    
    static let dataLoginWrong = "email or password is wrong"
    
    static let tryAgain = "Possibly something is wrong try again"
    
    static let disableLocation = "Your location is disable. \nPlease enable it"
    static let deniedLocationService = "I can not get location . \nI hope to accept access your location"
    
    static let saveSuccess = "Data saved successfully"
    static let updateSuccess = "Data updated successfully"
    static let userFound = "account already found"
}
