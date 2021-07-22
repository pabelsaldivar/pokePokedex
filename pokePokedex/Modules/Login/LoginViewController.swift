//
//  LoginViewController.swift
//  pokePokedex
//
//  Created by Pabel Saldivar on 22/07/21.

import UIKit
import NVActivityIndicatorView

final class LoginViewController: UIViewController {

    // MARK: - Public properties -

    var presenter: LoginPresenterInterface!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    var activityIndicator: NVActivityIndicatorView!

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        registerKeyBoardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterKeyBoardNotifications()
    }
    
    func configureView() {
        continueButton.layer.cornerRadius = 8.0
        activityIndicator = NVActivityIndicatorView(frame: (self.view.frame), type: .ballRotateChase, color: .white, padding: 80.0)
        activityIndicator.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.view.addSubview(activityIndicator)
    }
	
    @IBAction func continueButtonTapped(_ sender: Any) {
        presenter.validate(email: userNameTextField.text,
                           password: passwordTextField.text)
    }
}

// MARK: - Extensions - LoginViewInterface

extension LoginViewController: LoginViewInterface {
    func show(_ error: Error) {
        let title = "Ooh oh! "
        let message = error.localizedDescription
        let settingsActionTitle = "Entendido"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let goToSettings = UIAlertAction(title: settingsActionTitle, style: .default) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(goToSettings)
        self.present(alert, animated: true)
    }
    
    func showLoader() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
    
    func login(didFinishToValidate userData: (email: String, password: String)) {
        presenter.login(user: userData.email, by: userData.password)
    }
    
    func login(didFinishToLogin userToken: String) {
        presenter.navigate(to: .Dashboard)
    }   
}

// MARK: - Extensions - Keyboard

extension LoginViewController {
    private func registerKeyBoardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unregisterKeyBoardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardFrame = keyboardSize.cgRectValue
        
        let realDistance = keyboardFrame.height
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: realDistance, right: 0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
    }
}

// MARK: - Extensions - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case userNameTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordTextField.endEditing(true)
        default:
            break
        }
        return true
    }
}
