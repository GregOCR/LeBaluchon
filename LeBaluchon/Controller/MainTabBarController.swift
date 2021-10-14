//
//  MainTabBarController.swift
//  LeBaluchon
//
//  Created by Greg on 01/09/2021.
//

import UIKit


class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        guard let firstItem = tabBar.items?.first else {
//            return print("problem")
//        }
//        firstItem.image = UIImage(systemName: "sun.max")
//        firstItem.selectedImage = UIImage(systemName: "sun.max")
        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
