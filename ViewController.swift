//
//  ViewController.swift
//  newDairy
//
//  Created by 邵贵林 on 2019/9/10.
//  Copyright © 2019年 邵贵林. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var psw: UITextField!
    
    @IBOutlet weak var errorText: UILabel!
    
    
    
    
    @IBAction func login(_ sender: UIButton) {
        if(username.text==""||psw.text==""){
            errorText.text="input username and psw"
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
                //没有记录，失败
                errorText.text="username error"
            }else{
                //有记录，匹配密码
                if(theUser[0].psw != psw.text!){
                    errorText.text="psw error"
                    return
                }
                errorText.text="success"
                //存储用户名，用于其他界面获取或存储数据
                UserDefaults.standard.set(username.text!, forKey: "username")
                let main = UIStoryboard(name: "Main", bundle:nil)
                //跳转到日历主界面
                let vc = main.instantiateViewController(withIdentifier: "navVC") as! UINavigationController
                self.present(vc, animated:true, completion:nil)
            }
            
        }catch{
            print("Fetch error")
        }
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


}

