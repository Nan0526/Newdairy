//
//  SignUpViewController.swift
//  newDairy
//
//  Created by 邵贵林 on 2019/9/10.
//  Copyright © 2019年 邵贵林. All rights reserved.
//

import UIKit
import CoreData
class SignUpViewController: UIViewController {

    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var psw: UITextField!
    
    
    @IBOutlet weak var repsw: UITextField!
    
    @IBOutlet weak var errorText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func SignUp(_ sender: UIButton) {
        if(username.text==""||psw.text==""||repsw.text==""){
            errorText.text="input infomation"
            return
        }
        if(psw.text != repsw.text){
            errorText.text="two password inconsistencies"
            return
        }
        //根据用户名获取sqlite对应数据
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let request = NSFetchRequest<User>(entityName: "User")
        let predicate = NSPredicate(format: "username='\(username.text!)'")
        request.predicate = predicate
        do{
            let theUser = try context.fetch(request)
            
            if(theUser.count==0){
                //用户不存在，可以注册
                //注册
                //存储到sqlite数据库
                let contact=User(context: context)
                contact.username=username.text
                contact.psw=psw.text
                app.saveContext()
                errorText.text = "sign up success"
                
            }else{
                //用户已存在，不能注册
                errorText.text="the user exist!"
                return
            }
            
        }catch{
            print("Fetch error")
        }
  
    }
    
}
