//
//  AddDairyViewController.swift
//  newDairy
//
//  Created by 邵贵林 on 2019/9/13.
//  Copyright © 2019年 邵贵林. All rights reserved.
//

import UIKit
import CoreData
class AddDairyViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    @IBOutlet weak var sImg: UIImageView!
    
    @IBOutlet weak var locationText: UILabel!
    
    @IBOutlet weak var sTitle: UITextField!
    
    
    @IBOutlet weak var sContent: UITextView!
    //自定义变量
    var xTime:String=""
    var xTitle:String=""
    var xContent:String=""
    var xImg:String=""
    var xLocation:String=""
    var xType:String="add"//区别添加和修改
    var xDate:String=""//用于新建日记记录日期
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //数据初始化
        sTitle.text=xTitle
        sContent.text=xContent
        locationText.text=xLocation
        if(xType == "update"){
            sImg.image=getImg(imgName: xImg)
        }
        
        let saveButton=UIBarButtonItem(barButtonSystemItem:.save, target: self, action: #selector(saveDairy))
        self.navigationItem.rightBarButtonItem=saveButton
        
        //notice
        let notificationName = Notification.Name(rawValue: "locationNotification")
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(locationNotification(notification:)),
                                               name: notificationName, object: nil)
        
    }
    
   
    func setUseDate(theDate:String){
        xDate=theDate
    }
    
    
    @objc func locationNotification(notification: Notification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        let location = userInfo["location"] as! String
        self.locationText.text=location
       
    }
    
     @objc func saveDairy(){
        //1.去本地获取用户名
        let username = UserDefaults.standard.string(forKey: "username")!
        //根据用户名获取sqlite对应数据
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        if(xType=="add"){
            //存储到sqlite数据库
            let contact=Diary(context: context)
            contact.content=sContent.text
            contact.title=sTitle.text
            contact.location=locationText.text
            //获取当前时间
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "HH:mm:ss"// time format
            let time = dateformatter.string(from: Date())
            contact.times="\(xDate) \(time)"
            //取时间戳
            let now = NSDate()
            let timeInterval:TimeInterval = now.timeIntervalSince1970
            let timeStamp = Int(timeInterval)
            let tImgName="\(timeStamp).jpg"
            saveImage(imgName: tImgName)//本地保存
            contact.img=tImgName
            contact.username=username
            app.saveContext()
            //存储结束
            print("save success")
        }else{
            //update
            let fetchRequest = NSFetchRequest<Diary>(entityName:"Diary")
            fetchRequest.fetchLimit = 10
            fetchRequest.fetchOffset = 0
            
            let predicate = NSPredicate(format: "times= '\(xTime)'")
            fetchRequest.predicate = predicate
            
            //fetch
            do {
                let fetchedObjects = try context.fetch(fetchRequest)
                fetchedObjects[0].content=self.sContent.text
                fetchedObjects[0].title=self.sTitle.text
                fetchedObjects[0].location=self.locationText.text
                fetchedObjects[0].times=xTime
                    //取时间戳
                    let now = NSDate()
                    let timeInterval:TimeInterval = now.timeIntervalSince1970
                    let timeStamp = Int(timeInterval)
                    let tImgName="\(timeStamp).jpg"
                    saveImage(imgName: tImgName)//本地保存
                    fetchedObjects[0].img=tImgName
                try context.save()
            }
            catch {
                fatalError("error：\(error)")
            }
        }
        //back
        self.navigationController?.popViewController(animated: true)
        
    }
    //存储图片
    func saveImage(imgName: String) {
        if let image = sImg.image,let imageData = image.jpegData(compressionQuality: 1.0){
            let fileManager = FileManager()
            if let docsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first{
                let url = docsDir.appendingPathComponent(imgName)
                do{
                    try imageData.write(to: url)
                }catch{
                    print("save error")
                }
            }
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.sImg.image = selectedImage
        picker.dismiss(animated: true, completion: nil)
        
    }
    //选取相册图片
    @IBAction func chooseImg(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
//    deinit {
//        //remove notify
//        NotificationCenter.default.removeObserver(self)
//    }
    
    func setData(tTitle:String,tContent:String,imgName:String,tLocation:String,tTime:String){
        xTitle = tTitle
        xContent=tContent
        xLocation=tLocation
        xTime=tTime
        xImg=imgName
        xType="update"
        
    }
    //根据图片的名字，找到图片
    func getImg(imgName: String)->UIImage{
        var coverImg: UIImage?=nil
        let fileManager = FileManager()
        if let docsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first{
            let url = docsDir.appendingPathComponent(imgName)
            if let imageData = NSData(contentsOf: url){
                coverImg = UIImage(data: imageData as Data)
            }
        }
        return coverImg!
    }
}
