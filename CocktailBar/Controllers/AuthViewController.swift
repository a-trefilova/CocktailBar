//
//  AuthViewController.swift
//  CocktailBar
//
//  Created by Константин Сабицкий on 26.08.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func loginBtnTapped(_ sender: UIButton) {
    }
    
    @IBAction func registerBtnTapped(_ sender: UIButton) {
    }
    
    
}
