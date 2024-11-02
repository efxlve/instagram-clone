//
//  FeedController.swift
//  InstagramClone
//
//  Created by Muharrem Efe Çayırbahçe on 17.10.2024.
//

import UIKit
import FirebaseAuth

private let reuseIdentifier = "Cell"

class FeedController: UICollectionViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Actions
    
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
    
    // MARK: - Helpers
    
    func configureUI() {
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Instagram logo
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        navigationItem.titleView?.contentMode = .scaleAspectFit
        
       
        // Logout button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }
}

// MARK: - UICollectionViewDataSource

extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        var height = width + 8 + 40 + 8
        height += 50
        height += 60
        
        return CGSize(width: width, height: height)
    }
}
