//
//  SignInVC.swift
//  MediaFinder
//
//  Created by Tolba on 09/05/1444 AH.
//

import UIKit

class SignInVC: UIViewController {
    
    // MARK:- IBOutlet
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK:- ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.isLoggedIn)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.isLoggedIn)
    }
    
    // MARK:- IBAction
    @IBAction func signInBtnTapped(_ sender: UIButton) {
        signInBtnActionTapped()
    }
    
    @IBAction func signUpLabelTapped(_ sender: UITapGestureRecognizer) {
        signUpLabelActionTapped()
    }
}

// MARK:- Private SetupUI Methods
extension SignInVC {
    private func setupNavigationBar() {
        self.title = ViewControllerTitle.signIn
        self.navigationItem.hidesBackButton = true
    }
}

// MARK:- Private Data Methods
extension SignInVC {
    private func isValidData() -> Bool {
        guard ValidtionDataManager.shared.isValidEmail(email: emailTextField.text!) else {
            showAlert(title: Alerts.sorryTitle, message: Alerts.validEmail)
            return false
        }
        guard ValidtionDataManager.shared.isValidPassword(password: passwordTextField.text!) else {
            showAlert(title: Alerts.sorryTitle, message: Alerts.validPassword)
            return false
        }
        return true
    }
    
    private func isEnteredData() -> Bool {
        guard emailTextField.text != "" else {
            showAlert(title: Alerts.sorryTitle, message: Alerts.noEmail)
            return false
        }
        guard passwordTextField.text != "" else {
            showAlert(title: Alerts.sorryTitle, message: Alerts.noPassword)
            return false
        }
        return true
    }
}

// MARK:- Private Button Methods
extension SignInVC {
    private func gotoMoviesView() {
        let mediaVC = UIStoryboard(name: StoryBoard.main, bundle: nil).instantiateViewController(identifier: ViewController.mediaVC)
        self.navigationController?.pushViewController(mediaVC, animated: true)
    }
    
    private func signInBtnActionTapped() {
        if isEnteredData() && isValidData() {
            if UserDBSQLiteManager.shared.isValidLogin(email: emailTextField.text!, password: passwordTextField.text!) {
                gotoMoviesView()
            } else {
                showAlert(title: Alerts.sorryTitle, message: Alerts.dataLoginWrong)
            }
        }
    }
    
    private func signUpLabelActionTapped () {
        if let _ =  navigationController?.viewControllers.filter({$0 is SignUpVC}).first {
            navigationController?.popViewController(animated: true)
        } else {
            let signUpVC = UIStoryboard(name: StoryBoard.main, bundle: nil).instantiateViewController(identifier: ViewController.signUpVC) as! SignUpVC
            navigationController?.viewControllers.insert(signUpVC, at: 0)
            navigationController?.popToViewController(signUpVC, animated: true)
        }
    }
}
