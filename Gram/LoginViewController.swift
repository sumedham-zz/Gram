//
//  LoginViewController.swift
//  Gram
//
//  Created by Sumedha Mehta on 6/20/16.
//  Copyright © 2016 Sumedha Mehta. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapSignIn(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(loginText.text!, password: passwordText.text!) { (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                print("loggedin")
                self.performSegueWithIdentifier("goToMain", sender: nil)
            }
            else {
                print("fail")
            }
        }
    }

    @IBAction func onTapSignUp(sender: AnyObject) {
        let newUser = PFUser()
        newUser.username = loginText.text
        newUser.password = passwordText.text
        newUser.signUpInBackgroundWithBlock { (success:Bool, error: NSError?) in
            if success {
                print("Created a new User!")
                self.performSegueWithIdentifier("goToMain", sender: nil)
                
            }
            else {
                print(error?.localizedDescription)
                if(error?.code == 202) {
                    print("Username Already Exists")
                }
            }
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
