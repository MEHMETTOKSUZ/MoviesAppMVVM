//
//  SignInViewController.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 15.02.2024.
//

import UIKit
import Firebase
import FirebaseDatabase

class SignInViewController: UIViewController {
    
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        

        passwordText.isSecureTextEntry = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    
    @IBAction func logInButtonClicked(_ sender: Any) {
        
        logIn()
        
    }
    
    @IBAction func signInButtonClicked(_ sender: Any) {
        
        signIn()
        
    }
    
    func signIn() {
        guard let email = emailText.text, !email.isEmpty,
              let password = passwordText.text, !password.isEmpty,
              let username = usernameText.text, !username.isEmpty else {
            makeAlert(title: "Bildirim", message: "Kullanıcı adı, e-posta veya şifre boş bırakılamaz")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authData, error in
            if let error = error {
                self.makeAlert(title: "Bildirim", message: error.localizedDescription)
            } else {
                self.saveUserDataToFirestore(email: email, username: username)
            }
        }
    }

    func saveUserDataToFirestore(email: String, username: String) {
        let fireBase = Firestore.firestore()
        let userInfo = ["email": email, "userName": username]
        
        fireBase.collection("UserInfo").addDocument(data: userInfo) { error in
            if let error = error {
                self.makeAlert(title: "Bildirim", message: error.localizedDescription)
            } else {
                self.performSegue(withIdentifier: "toHomeViewControllerFromSingIn", sender: nil)
            }
        }
    }
    
    func logIn() {
        guard let username = usernameText.text, !username.isEmpty,
              let password = passwordText.text, !password.isEmpty,
              let email = emailText.text, !email.isEmpty else {
            makeAlert(title: "Bildirim", message: "Kullanıcı adı, e-posta veya şifre boş bırakılamaz")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { authData, error in
            if let error = error {
                self.makeAlert(title: "Bildirim", message: error.localizedDescription)
            } else {
                self.performSegue(withIdentifier: "toHomeViewControllerFromSingIn", sender: nil)
            }
        }
    }

    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Tamam", style: .cancel)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
   
}


