//
//  SettingsViewController.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 17.02.2024.
//

import UIKit
import Firebase
import FirebaseStorage

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var darkModSwitch: UISwitch!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var uploadProfile: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    private let firestore = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchUserInfo()
        fetchUserProfileImage()
    }
    
    @IBAction func darkModButtonClicked(_ sender: UISwitch) {
        
        if sender.isOn {
            ThemeHelper.switchToDarkMode()
        } else {
            ThemeHelper.switchToLightMode()
        }
    }
    
    @IBAction func uploadProfileImage(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
        
    }
    
    @IBAction func logOutButtonClicked(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toLogInScreenFromSettings", sender: nil)
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    private func configureUI() {
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2
        uploadProfile.layer.cornerRadius = uploadProfile.bounds.height / 2
        logOutButton.setTitleColor(.white, for: .normal)
        aboutButton.setTitleColor(.white, for: .normal)
        usernameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        emailLabel.font = UIFont.boldSystemFont(ofSize: 15)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            showAlert(title: "Error", message: "Failed to select image")
            return
        }
        
        uploadProfileImageToFirebase(image: selectedImage)
    }
    
    private func fetchUserInfo() {
        guard let currentUserEmail = Auth.auth().currentUser?.email else { return }
        
        firestore.collection("UserInfo").whereField("email", isEqualTo: currentUserEmail).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                print("Error fetching user info: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let userInfo = documents.first?.data() {
                DispatchQueue.main.async {
                    self.emailLabel.text = currentUserEmail
                    self.usernameLabel.text = userInfo["userName"] as? String
                }
            }
        }
    }
    
    private func fetchUserProfileImage() {
        guard let currentUserEmail = Auth.auth().currentUser?.email else { return }
        
        firestore.collection("Images").whereField("imageOwner", isEqualTo: currentUserEmail).order(by: "timestamp").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                print("Error fetching user profile image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let imageUrl = documents.last?.data()["image"] as? String {
                DispatchQueue.main.async {
                    self.profileImage.downloaded(from: imageUrl)
                }
            }
        }
    }
    
    private func uploadProfileImageToFirebase(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.5),
              let currentUserEmail = Auth.auth().currentUser?.email else {
            showAlert(title: "Error", message: "Failed to upload profile image")
            return
        }
        
        let imageId = UUID().uuidString
        let imageRef = Storage.storage().reference().child("images/\(imageId).jpg")
        
        imageRef.putData(imageData, metadata: nil) { metadata, error in
            guard error == nil else {
                self.showAlert(title: "Error", message: error?.localizedDescription ?? "Unknown error")
                return
            }
            
            imageRef.downloadURL { url, error in
                guard let imageUrl = url?.absoluteString else {
                    self.showAlert(title: "Error", message: "Failed to get image URL")
                    return
                }
                
                let imageInfo: [String: Any] = ["image": imageUrl,
                                                "imageOwner": currentUserEmail,
                                                "timestamp": FieldValue.serverTimestamp()]
                
                self.firestore.collection("Images").addDocument(data: imageInfo) { error in
                    if let error = error {
                        self.showAlert(title: "Error", message: error.localizedDescription)
                    } else {
                        DispatchQueue.main.async {
                            self.profileImage.image = image
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func purchasedButtonClicked(_ sender: Any) {
        
        performSegue(withIdentifier: "toPurchasedFromSettings", sender: nil)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .cancel))
        present(alert, animated: true)
        
    }
}
