//
//  HomePageViewController.swift
//  newDairy
//
//  Created by 邵贵林 on 2019/9/13.
//  Copyright © 2019年 邵贵林. All rights reserved.
//

import UIKit
import CoreData
class HomePageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var dairyTableView: UITableView!
    //=========自定义
    var dairies:[Diary] = []
    var xDate:String=""//保存选中的日期(2010-09-01)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dairyTableView.delegate=self
        dairyTableView.dataSource=self

        let addButton=UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDairy))
        self.navigationItem.rightBarButtonItem=addButton
        
    }
   
    override func viewWillAppear(_ animated: Bool) {
         getDairie()
        dairyTableView.reloadData()
    }
    
    //跳转到添加界面
    @objc func addDairy(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let addDiaryVC = storyboard.instantiateViewController(withIdentifier: "addDiaryVC") as? AddDairyViewController else {  return }
        addDiaryVC.setUseDate(theDate: xDate)
        self.navigationController?.pushViewController(addDiaryVC, animated: true)
    }
    func getDairie(){
        //1.去本地获取用户名
        let username = UserDefaults.standard.string(forKey: "username")!
        //访问数据库
        //根据用户名获取sqlite对应数据
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let request = NSFetchRequest<Diary>(entityName: "Diary")
        let predicate = NSPredicate(format: "username='\(username)'")
        request.predicate = predicate
        do{
            dairies.removeAll()
            let tempArr = try context.fetch(request)
            for i in 0..<tempArr.count{
                //取出日期2019-09-09 12:12:12
                let item:String = tempArr[i].times!
                //按空格分割日期
                let arrs:[String]=item.components(separatedBy: " ")
                if(arrs[0] == xDate){
                    dairies.append(tempArr[i])
                }
            }
            
        }catch{
            print("Fetch error")
        }
        
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
    
    //选中该行（点击）
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let addDiaryVC = storyboard.instantiateViewController(withIdentifier: "addDiaryVC") as? AddDairyViewController else {  return }
        let temp:Diary=dairies[indexPath.row]
        addDiaryVC.setData(tTitle: temp.title!, tContent: temp.content!, imgName: temp.img!, tLocation: temp.location!, tTime: temp.times!)
        self.navigationController?.pushViewController(addDiaryVC, animated: true)
        
    }
    
    
    //set can editor
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?{
        return "Del"
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            let dd:Diary=self.dairies[indexPath.row]
            let app = UIApplication.shared.delegate as! AppDelegate
            let context = app.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Diary>(entityName:"Diary")
            fetchRequest.fetchLimit = 10
            fetchRequest.fetchOffset = 0
            //print(dd.times!)
            let predicate = NSPredicate(format: "times='\(dd.times!)'")
            fetchRequest.predicate = predicate

            //fetch
            do {

                let fetchedObjects = try context.fetch(fetchRequest)
                print(fetchedObjects.count)
                context.delete(fetchedObjects[0])
                try! context.save()
            }
            catch {
                fatalError("error：\(error)")
            }
            self.dairies.remove(at: indexPath.row)
            //Refresh Tableview
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    //每个部分有多少个元素
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dairies.count;
    }
    //每一行长啥样
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dairyID", for: indexPath) as! DairyTableViewCell
        //修改title，img
        //获取当前行日记类
        let temp:Diary=dairies[indexPath.row]
        cell.title.text=temp.title
        cell.location.text=temp.location
        cell.date.text=temp.times
        //图片
        cell.img.image=getImg(imgName: temp.img!)
        return cell
    }
    //设置行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func setDates(vDate:String){
        xDate=vDate
    }
    

}
