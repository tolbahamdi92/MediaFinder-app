//
//  ProfileVC.swift
//  MediaFinder
//
//  Created by Tolba on 09/05/1444 AH.
//

import UIKit

class ProfileVC: UIViewController {
    
    // MARK:- IBOutlet
    @IBOutlet weak var containerUserImageView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var titleAddress1Label: UILabel!
    @IBOutlet weak var address1Label: UILabel!
    @IBOutlet weak var titleAddress2Label: UILabel!
    @IBOutlet weak var address2Label: UILabel!
    @IBOutlet weak var titleAddress3Label: UILabel!
    @IBOutlet weak var address3Label: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    // MARK:- ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()

        setupUserImageUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setData()
    }
    
    // MARK:- IBAction
    @IBAction func editDataBtnTapped(_ sender: UIButton) {
        gotoUserData()
    }
    
}

// MARK: - Private SetupUI Methods
extension ProfileVC {
    private func setupUserImageUI() {
        let cornerRadius = containerUserImageView.frame.size.width / 2
        userImageView.layer.cornerRadius = cornerRadius
        containerUserImageView.layer.cornerRadius = cornerRadius
        containerUserImageView.layer.shadowColor = UIColor.black.cgColor
        containerUserImageView.layer.shadowOffset = CGSize(width: 0, height: 5)
        containerUserImageView.layer.shadowOpacity = 0.5
        containerUserImageView.layer.shadowRadius = 5
    }
    
    private func setupNavigationBar() {
        self.title = ViewControllerTitle.profile
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: ButtonsTitle.logOut, style: .plain, target: self, action: #selector(self.logOut))
    }
}

// MARK: - Private Data Methods
extension ProfileVC {
    private func setData() {
        let email = UserDefaults.standard.string(forKey: UserDefaultsKeys.email)
        if let user = UserDBSQLiteManager.shared.fetchUser(email: email ?? "") {
            nameLabel.text = user.name
            emailLabel.text = user.email
            phoneLabel.text = user.phone
            if user.address1 == "" {
                titleAddress1Label.isHidden = true
                address1Label.isHidden = true
            } else {
                address1Label.text = user.address1
                titleAddress1Label.isHidden = false
                address1Label.isHidden = false
            }
            if user.address2 == "" {
                titleAddress2Label.isHidden = true
                address2Label.isHidden = true
            } else {
                address2Label.text = user.address2
                titleAddress2Label.isHidden = false
                address2Label.isHidden = false
            }
            if user.address3 == "" {
                titleAddress3Label.isHidden = true
                address3Label.isHidden = true
            } else {
                address3Label.text = user.address3
                titleAddress3Label.isHidden = false
                address3Label.isHidden = false
            }
            userImageView.image = UIImage(data: user.image)
            genderLabel.text = user.gender.rawValue
        } else {
            showAlert(title: Alerts.sorryTitle, message: Alerts.tryAgain)
        }
    }
}

// MARK: - Private Action Methods
extension ProfileVC {
    @objc func logOut() {
        if let destinationVC = navigationController?.viewControllers.filter({$0 is SignInVC}).first {
            navigationController?.popToViewController(destinationVC, animated: true)
        } else {
            let signInVc = UIStoryboard(name: StoryBoard.main, bundle: nil).instantiateViewController(identifier: ViewController.signInVC) as! SignInVC
            navigationController?.viewControllers.insert(signInVc, at: 1)
            navigationController?.popToViewController(signInVc, animated: true)
        }
    }
    
    private func gotoUserData() {
        let userDataVC = UIStoryboard(name: StoryBoard.main, bundle: nil).instantiateViewController(identifier: ViewController.signUpVC) as! SignUpVC
        userDataVC.isEditData = true
        self.navigationController?.pushViewController(userDataVC, animated: true)
    }
}
