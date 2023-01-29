//
//  UsersVC.swift
//  Chat-Bee
//
//  Created by mac on 06/01/2023.
//

import UIKit


class UsersVC: UIViewController {
    
    
    //Mark:- IBOutlets

    @IBOutlet weak var tableView: UITableView!
    
    
    
    //Mark:- Constants
    
    var users = [FUser]()
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        getUsersData()
    }
    //Mark:- IBAction
    
    
    
    
    
    
    //Mark:- helper Function
    func getUsersData(){
        
        DBref.child(reference(.User)).observe(.value) { (snapshot) in
            let snap = snapshot.value as! [String : Any]
            for (_,value) in snap{
                let Fuser = FUser(_dictionary: value as! NSDictionary)
                if Fuser.objectId != FUser.currentId(){
                    self.users.append(Fuser)
                }
                
            }
            self.tableView.reloadData()
        }
        
        
        
        
    }
    

}
extension UsersVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserTVCell
        cell.emailLBL.text = users[indexPath.row].email
        cell.nameLBL.text = users[indexPath.row].fullname
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let VC = UIStoryboard(name: "Messages", bundle: nil).instantiateViewController(withIdentifier: "MessageVC") as! MessageVC
        
        
        VC.users = [FUser.currentUser()!, users[indexPath.row]]
        VC.usersId = [FUser.currentId(), users[indexPath.row].objectId ]
        
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
    
    
    
}
