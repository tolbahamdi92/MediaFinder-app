//
//  AppDelegate.swift
//  MediaFinder(
//
//  Created by Tolba on 05/05/1444 AH.
//

import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Propreties.
    var window: UIWindow?
    
    // MARK: - Application Methods.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        screenRootApp()
        return true
    }
}

// MARK: - Privat Methods
extension AppDelegate {
    private func goToMoviesView() {
        let navController = UINavigationController()
        let moviesVC = UIStoryboard(name: StoryBoard.main, bundle: nil).instantiateViewController(identifier: ViewController.mediaVC)
        window?.rootViewController = navController
        navController.pushViewController(moviesVC, animated: true)
    }
    private func goToSignInView() {
        let rootViewController = window!.rootViewController as! UINavigationController
        let signInVc = UIStoryboard(name: StoryBoard.main, bundle: nil).instantiateViewController(identifier: ViewController.signInVC)
        rootViewController.pushViewController(signInVc, animated: true)
    }
    private func screenRootApp() {
        let email = UserDefaults.standard.string(forKey: UserDefaultsKeys.email)
        if UserDBSQLiteManager.shared.fetchUser(email: email ?? "") != nil {
            if UserDefaults.standard.bool(forKey: UserDefaultsKeys.isLoggedIn) {
                goToMoviesView()
            } else {
                goToSignInView()
            }
        }
    }
}
