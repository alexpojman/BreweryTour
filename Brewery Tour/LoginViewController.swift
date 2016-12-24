//
//  LoginViewController.swift
//  Brewery Tour
//
//  Created by Alexander Pojman on 12/23/16.
//  Copyright © 2016 Alexander Pojman. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    // MARK: - Properties and Outlets
    
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var passwordLabel: UILabel!
    @IBOutlet var confirmPasswordLabel: UILabel!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var warningLabel: UILabel!
    
    enum ErrorText: String {
        case invalidEmailAddress = "Invalid Email Address"
        case emailInUse = "Email Address Already in Use"
        case incorrectPassword = "Incorrect Password"
        case passwordsMismatch = "Passwords Do Not Match"
        case hasEmptyInputs = "Please Complete All Fields"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add Border to UIButton
        signUpButton.layer.borderWidth = 2
        signUpButton.layer.borderColor = UIColor.lightGray.cgColor
        
        // Set Kerning for Sign Up Button
        signUpButton .setAttributedTitle(kerningForText(text: signUpButton.title(for: .normal)!, amount: 5.0), for: .normal)
        
        // Add Border to UIButton
        loginButton.layer.borderWidth = 2
        loginButton.layer.borderColor = UIColor.lightGray.cgColor
        
        // Set Kerning for Login Button
        loginButton .setAttributedTitle(kerningForText(text: loginButton.title(for: .normal)!, amount: 5.0), for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTouchSignUpButton(_ sender: UIButton) {
        
        let emptyInputs = self.emptyInputsList()
        
        // Check for empty inputs
        if (emptyInputs.count == 0) {
            // Check if passwords match
            if (self.passwordsDoMatch()) {
                // Create New User
                FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                    // Handles Errors
                    if (error != nil) {
                        if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                            switch errCode {
                            case .errorCodeInvalidEmail:
                                self.showWarningLabel(errorText: .invalidEmailAddress)
                            case .errorCodeEmailAlreadyInUse:
                                self.showWarningLabel(errorText: .emailInUse)
                            case .errorCodeWrongPassword:
                                self.showWarningLabel(errorText: .incorrectPassword)
                            default:
                                print("Create User Error: \(error)")
                            }
                        }
                    } else {
                        // Sign Up/Login Successful, go to Main Screen
                        self.performSegue(withIdentifier: "loginToMainScreen", sender: self)
                    }
                }
            } else {
                self.showWarningLabel(errorText: .passwordsMismatch)
            }
        } else {
            emailTextField.shake()
            // Empty Inputs are present
            self.showWarningLabel(errorText: .hasEmptyInputs)
            
            // Show Shaking Animation
            for input in emptyInputs {
                input.shake()
            }
        }
    }
    
    func passwordsDoMatch() -> Bool {
        if (passwordTextField.text == confirmPasswordTextField.text && passwordTextField.text != "") {
            return true
        } else {
            return false
        }
    }
    
    func emptyInputsList() -> [UITextField] {
        var emptyInputsList = [UITextField].init()
        
        if (emailTextField.text == "") {
            emptyInputsList.append(emailTextField)
        }
        if (passwordTextField.text == "") {
            emptyInputsList.append(passwordTextField)
        }
        if (confirmPasswordTextField.text == "") {
            emptyInputsList.append(confirmPasswordTextField)
        }
        
        return emptyInputsList
    }
    
    // MARK: - Helper Methods
    
    func kerningForText(text: String, amount: CGFloat) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSKernAttributeName, value: CGFloat(amount), range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }
    
    func showWarningLabel(errorText: ErrorText) {
        
        self.warningLabel.text = errorText.rawValue
        
        UIView.animate(withDuration: 0.4, animations: {
                self.warningLabel.alpha = 1.0
            }, completion: { _ in
                UIView.animate(withDuration: 0.4, delay: 2.0, options: UIViewAnimationOptions.curveLinear, animations: {
                        self.warningLabel.alpha = 0.0
                    }, completion: { _ in
                        // Do Something
                    }
                )
            }
        )
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}

public extension UIView {
    
    func shake(count : Float? = nil,for duration : TimeInterval? = nil,withTranslation translation : Float? = nil) {
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        animation.repeatCount = count ?? 2
        animation.duration = (duration ?? 0.5)/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.byValue = translation ?? -5
        layer.add(animation, forKey: "shake")
    }    
}