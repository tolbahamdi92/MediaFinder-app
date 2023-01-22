//
//  SignUpVC.swift
//  MediaFinder
//
//  Created by Tolba on 09/05/1444 AH.
//

import SDWebImage

protocol AddressDelegate {
    func setAddress(address: String)
}

class SignUpVC: UIViewController {
    
    // MARK:- IBOutlet
    @IBOutlet weak var containerUserImageView: UIView!
    @IBOutlet weak var chooseImgBtn: UIButton!
    @IBOutlet weak var userImgImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var address1TextField: UITextField!
    @IBOutlet weak var address2TextField: UITextField!
    @IBOutlet weak var address3TextField: UITextField!
    @IBOutlet weak var genderSwitch: UISwitch!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var haveAccountLabel: UILabel!
    @IBOutlet weak var signInLabel: UILabel!
    
    // MARK:- Properities
    private let imagePicker = UIImagePickerController()
    private var addressTag: Int = 0
    var isEditData: Bool = false
    
    // MARK:- ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        isEditData ? setupEditingUI() : setupUI()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUserImageUI()
    }
    
    // MARK:- IBAction.
    @IBAction func chooseImgBtnTapped(_ sender: UIButton) {
        chooseImageBtnTapped()
    }
    
    @IBAction func signUpBtnTapped(_ sender: UIButton) {
        signUpBtnActionTapped()
    }
    
    @IBAction func signInLabelTapped(_ sender: UITapGestureRecognizer) {
        goToSignInView()
    }
    
    @IBAction func addressBtnTapped(_ sender: UIButton) {
        addressTag = sender.tag
        goToMapView()
    }
}

// MARK:- UIImagePickerControllerDelegate & UINavigationControllerDelegate.
extension SignUpVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagePicked = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            userImgImageView.image = imagePicked
        }
        dismiss(animated: true)
    }
}

// MARK:- AddressDelegate Protocol
extension SignUpVC: AddressDelegate {
    func setAddress(address: String) {
        switch addressTag {
        case 0:
            address1TextField.text = address
        case 1:
            address2TextField.text = address
        default:
            address3TextField.text = address
        }
    }
}

// MARK:- Private SetupUI Methods
extension SignUpVC {
    private func setupUserImageUI() {
        let cornerRadius = containerUserImageView.frame.size.width / 2
        userImgImageView.layer.cornerRadius = cornerRadius
        userImgImageView.layer.shouldRasterize = false
        chooseImgBtn.layer.cornerRadius = cornerRadius
        containerUserImageView.layer.cornerRadius = cornerRadius
        containerUserImageView.layer.shadowColor = UIColor.black.cgColor
        containerUserImageView.layer.shadowOffset = CGSize(width: 0, height: 5)
        containerUserImageView.layer.shadowOpacity = 0.9
        containerUserImageView.layer.shadowRadius = 5
    }
    
    private func setupUI() {
        self.title = ViewControllerTitle.signUp
        userImgImageView.image = UIImage(named: PlaceholderImage.user)
    }
    
    private func setupEditingUI() {
        self.title = ViewControllerTitle.userDataEditing
        signUpButton.setTitle(ButtonsTitle.saveData, for: .normal)
        haveAccountLabel.isHidden = true
        signInLabel.isHidden = true
        let oldEmail = UserDefaults.standard.string(forKey: UserDefaultsKeys.email)
        guard let user = UserDBSQLiteManager.shared.fetchUser(email: oldEmail ?? "") else { return }
        userImgImageView.image = UIImage(data: user.image)
        nameTextField.text = user.name
        emailTextField.text = user.email
        passwordTextField.text = user.password
        phoneTextField.text = user.phone
        address1TextField.text = user.address1
        address2TextField.text = user.address2
        address3TextField.text = user.address3
        genderSwitch.setOn(user.gender == .Male ? true : false, animated: true)
    }
    
}

// MARK:- Private Data Methods
extension SignUpVC {
    private func isValidData() -> Bool {
        guard ValidtionDataManager.shared.isValidEmail(email: emailTextField.text!) else {
            showAlert(title: Alerts.sorryTitle, message: Alerts.validEmail)
            return false
        }
        guard ValidtionDataManager.shared.isValidPassword(password: passwordTextField.text!) else {
            showAlert(title: Alerts.sorryTitle, message: Alerts.validPassword)
            return false
        }
        guard ValidtionDataManager.shared.isValidPhone(phone: phoneTextField.text!) else {
            showAlert(title: Alerts.sorryTitle, message: Alerts.validPhone)
            return false
        }
        return true
    }
    
    private func isEnteredData() -> Bool {
        guard userImgImageView.image != UIImage(named: PlaceholderImage.user) else {
            showAlert(title: Alerts.sorryTitle, message: Alerts.noImage)
            return false
        }
        guard nameTextField.text != "" else {
            showAlert(title: Alerts.sorryTitle, message: Alerts.noName)
            return false
        }
        guard emailTextField.text != "" else {
            showAlert(title: Alerts.sorryTitle, message: Alerts.noEmail)
            return false
        }
        guard passwordTextField.text != "" else {
            showAlert(title: Alerts.sorryTitle, message: Alerts.noPassword)
            return false
        }
        guard phoneTextField.text != "" else {
            showAlert(title: Alerts.sorryTitle, message: Alerts.noPhone)
            return false
        }
        guard address1TextField.text != "" || address2TextField.text != "" || address3TextField.text != "" else {
            showAlert(title: Alerts.sorryTitle, message: Alerts.noAddress)
            return false
        }
        return true
    }
    
    private func saveUserData() -> Status {
        let user = User(name: nameTextField.text!,
                        email: emailTextField.text!,
                        password: passwordTextField.text!,
                        phone: phoneTextField.text!,
                        address1: address1TextField.text ?? "",
                        address2: address2TextField.text ?? "",
                        address3: address3TextField.text ?? "",
                        image: userImgImageView.image!.jpegData(compressionQuality: 0.5) ?? Data(),
                        gender: genderSwitch.isOn ? .Male : .Female)
        return UserDBSQLiteManager.shared.saveUser(user)
    }
    
    private func updateUserData() -> Status {
        let oldEmail = UserDefaults.standard.string(forKey: UserDefaultsKeys.email)
        let user = User(name: nameTextField.text!,
                        email: emailTextField.text!,
                        password: passwordTextField.text!,
                        phone: phoneTextField.text!,
                        address1: address1TextField.text ?? "",
                        address2: address2TextField.text ?? "",
                        address3: address3TextField.text ?? "",
                        image: userImgImageView.image!.jpegData(compressionQuality: 0.5) ?? Data(),
                        gender: genderSwitch.isOn ? .Male : .Female)
        return UserDBSQLiteManager.shared.updateUser(oldEmail: oldEmail ?? "", user)
    }
}

// MARK:- Private Action Methods
extension SignUpVC {
    private func chooseImageBtnTapped() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    private func goToSignInView() {
        let signInVc = UIStoryboard(name: StoryBoard.main, bundle: nil).instantiateViewController(identifier: ViewController.signInVC)
        self.navigationController?.pushViewController(signInVc, animated: true)
    }
    
    private func goToMapView() {
        let mapVC = UIStoryboard(name: StoryBoard.main, bundle: nil).instantiateViewController(identifier: ViewController.mapVC) as! MapVC
        mapVC.delegate = self
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    private func signUpBtnActionTapped() {
        if isEnteredData() && isValidData() {
            if isEditData {
                let status = updateUserData()
                switch status {
                case .success:
                    self.showAlert(title: Alerts.successTitle, message: Alerts.updateSuccess) {_ in
                        self.navigationController?.popViewController(animated: true)
                    }
                default:
                    self.showAlert(title: Alerts.sorryTitle, message: Alerts.tryAgain)
                }
            } else {
                let status = saveUserData()
                switch status {
                case .success:
                    self.showAlert(title: Alerts.successTitle, message: Alerts.saveSuccess) {_ in
                        self.goToSignInView()
                    }
                    
                case .found:
                    self.showAlert(title: Alerts.sorryTitle, message: Alerts.userFound)
                case .error:
                    self.showAlert(title: Alerts.sorryTitle, message: Alerts.tryAgain)
                }
                
            }
        }
    }
}
