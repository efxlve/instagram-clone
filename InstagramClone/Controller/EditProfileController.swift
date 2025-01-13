//
//  EditProfileController.swift
//  InstagramClone
//
//  Created by Muharrem Efe Çayırbahçe on 3.12.2024.
//

import UIKit
import FirebaseAuth

class EditProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    var user: User?
    private var selectedImage: UIImage?
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private lazy var changeProfilePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Profile Photo", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(handleChangeProfilePhoto), for: .touchUpInside)
        return button
    }()
    
    private let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.borderStyle = .none
        return tf
    }()
    
    private let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.borderStyle = .none
        return tf
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameTextField, usernameTextField])
        stack.axis = .vertical
        stack.spacing = 12
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var LogoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log Out", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUserData()
    }
    
    // MARK: - API
    
    func fetchUserData() {
        guard let uid = user?.uid else {
            print("DEBUG: User UID not found.")
            return
        }
        
        UserService.fetchUser(withUid: uid) { user in
            self.user = user
            
            DispatchQueue.main.async {
                self.nameTextField.text = user.fullname
                self.usernameTextField.text = user.username
                
                if let profileImageUrl = URL(string: user.profileImageUrl) {
                    URLSession.shared.dataTask(with: profileImageUrl) { data, _, error in
                        if let error = error {
                            print("DEBUG: Profile photo could not be loaded: \(error.localizedDescription)")
                            return
                        }
                        guard let data = data else { return }
                        DispatchQueue.main.async {
                            self.profileImageView.image = UIImage(data: data)
                        }
                    }.resume()
                }
            }
        }
    }
    
    func updateUserData() {
        guard let updatedName = nameTextField.text, !updatedName.isEmpty else { return }
        guard let updatedUsername = usernameTextField.text, !updatedUsername.isEmpty else { return }

        var values: [String: Any] = [
            "fullname": updatedName,
            "username": updatedUsername
        ]
        
        if let selectedImage = selectedImage {
            UserService.updateProfileImage(image: selectedImage) { profileImageUrl in
                values["profileImageUrl"] = profileImageUrl
                
                UserService.updateUserData(values: values) { error, ref in
                    if let error = error {
                        print("DEBUG: Failed to update user data with error \(error.localizedDescription)")
                        return
                    }
                    
                    self.dismiss(animated: true, completion: nil)
                }
            }
        } else {
            UserService.updateUserData(values: values) { error, ref in
                if let error = error {
                    print("DEBUG: Failed to update user data with error \(error.localizedDescription)")
                    return
                }
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Edit Profile"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismissal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleSave))
        
        view.addSubview(profileImageView)
        profileImageView.setDimensions(height: 80, width: 80)
        profileImageView.layer.cornerRadius = 40
        profileImageView.centerX(inView: view)
        profileImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 16)
        
        view.addSubview(changeProfilePhotoButton)
        changeProfilePhotoButton.centerX(inView: view)
        changeProfilePhotoButton.anchor(top: profileImageView.bottomAnchor, paddingTop: 8)
        
        view.addSubview(stack)
        stack.anchor(top: changeProfilePhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(LogoutButton)
        LogoutButton.centerX(inView: view)
        LogoutButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 16)
    }
    
    // MARK: - Actions
    
    @objc func handleChangeProfilePhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                let controller = LoginController()
                controller.delegate = self.tabBarController as? MainTabController
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        } catch {
            print("DEBUG: Error signing out")
        }
    }
    
    @objc func handleSave() {
        updateUserData()
    }
    
    @objc func handleDismissal() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        self.selectedImage = selectedImage
        self.profileImageView.image = selectedImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
