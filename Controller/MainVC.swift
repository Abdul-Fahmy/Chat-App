//
//  ViewController.swift
//  Chat-Bee
//
//  Created by mac on 03/01/2023.
//

import UIKit
import Firebase
import FirebaseAuth
import ProgressHUD
import FirebaseCore
import FirebaseDatabase

class MainVC: UIViewController {
    
    //Mark:- Outlet
    
    @IBOutlet weak var nameTF: UITextField!{
        didSet{
            nameTF.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent((0.5))])
        }
    }
    
    @IBOutlet weak var emailTF: UITextField!{
        didSet{
            emailTF.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent((0.5))])
        }
    }
    
    @IBOutlet weak var passwordTF: UITextField!{
        didSet{
            passwordTF.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent((0.5))])
        }
    }
    
    @IBOutlet weak var signOutLet: UIButton!{
        didSet{
            signOutLet.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet weak var logNotification: UILabel!
    
    //Mark:- Constants
    
    let leftSwipeGes = UISwipeGestureRecognizer()
    let rightSwipeGes = UISwipeGestureRecognizer()
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setSwipes()
    }
    
    
    //Mark:- IBAction
    @objc func Swipped(){
        if signOutLet.titleLabel?.text == "Sign up"{
            signOutLet.setTitle("Sign in", for: .normal)
            nameTF.isHidden = true
            logNotification.text = "Swip to Sign up"
        }else{
            signOutLet.setTitle("Sign up", for: .normal)
            nameTF.isHidden = false
            logNotification.text = "Swip to Sign in"

            
        }
        
    }
    
    @IBAction func signBtnPressed(_ sender: UIButton) {
        if sender.titleLabel?.text == "Sign up"{
            registerBtnPressed()
            
        }else{
            logInBtnPressed()
        }
    }
    
    
    //Mark:- Helper Function
    func setSwipes(){
        leftSwipeGes.direction = .left
        rightSwipeGes.direction = .right
        
        self.view.addGestureRecognizer(leftSwipeGes)
        self.view.addGestureRecognizer(rightSwipeGes)
        
        leftSwipeGes.addTarget(self, action: #selector(Swipped))
        rightSwipeGes.addTarget(self, action: #selector(Swipped))
    }
    func logInBtnPressed(){
        
        guard !emailTF.text!.isEmpty, !passwordTF.text!.isEmpty else{return}
        
        Auth.auth().signIn(withEmail: emailTF.text!, password: passwordTF.text!) { result, error in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            print(result!.user.uid)
            SaveCurrentUser(uId: result!.user.uid) { (isSaved) in
                if isSaved {
                    // ToDo:- go to home
                    self.goToHome()
                    
                }else{
                    ProgressHUD.showError("User Not Saved")
                }
            }
        }
        
    }
    func registerBtnPressed(){
        guard !emailTF.text!.isEmpty, !passwordTF.text!.isEmpty, !nameTF.text!.isEmpty else{ProgressHUD.showError("Fill Empty Fields");return}
        Auth.auth().createUser(withEmail: emailTF.text! , password: passwordTF.text!) { result, error in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            print(result!.user.uid)
            self.saveUserToDatabase(uID: result!.user.uid)
        }
    }
    func saveUserToDatabase(uID: String){
        
        let userFuser = FUser(_objectId: uID, _createdAt: Date(), _updatedAt: Date(), _email: emailTF.text!, _fullname: nameTF.text!)
        
        let userDic = userDictionaryFrom(user:userFuser)
        
        DBref.child(reference(.User)).child(uID).setValue(userDic) { error, ref in
            if error != nil{
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            print("User Data Saved succ")
            saveUserLocally(fUser: userFuser)
            // go to Home Screen
            self.goToHome()
            
            
        }
        
    }
    
    func goToHome(){
        let vc = UIStoryboard(name: "Users", bundle: nil).instantiateViewController(withIdentifier: "MyUserNav")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    

}

