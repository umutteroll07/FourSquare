//
//  ViewController.swift
//  FourSquare
//
//  Created by Umut Erol on 16.12.2023.
//

import UIKit
import Parse

class SignUpVC: UIViewController {

    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var txt_username: UITextField!
    @IBOutlet weak var txt_psw: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func clicked_signIn(_ sender: Any) {
        if txt_username.text != "" && txt_psw.text != "" {
            
            PFUser.logInWithUsername(inBackground: txt_username.text!, password: txt_psw.text!) { user, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: "Ups")

                }
                else {
                    print("welcome")
                    print(user?.username)
                    let user = PFUser.current()
                    
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
            
        }
        else {
            self.makeAlert(title: "Error", message: "Username and password shouldn't be empty!")
        }
    }
    
    
    
    @IBAction func clicked_signUp(_ sender: Any) {
        if txt_username.text != "" && txt_psw.text != "" {
            
            let user = PFUser()
            user.username  = txt_username.text
            user.password  = txt_psw.text
            user.signUpInBackground { user, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: "Sorry we have a problem")
                }
                else {
                    // Seque
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                    print("OK")
                }
            }
            
        }
        else {
            self.makeAlert(title: "Error!", message: "Username and password shouldn't be empty!")
        }
    }
    
    func makeAlert(title : String , message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let alertButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(alertButton)
        self.present(alert, animated: true,completion: nil)
    }
    
}

