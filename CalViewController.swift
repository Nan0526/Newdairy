//
//  CalViewController.swift
//  newDairy
//
//  Created by 邵贵林 on 2019/9/11.
//  Copyright © 2019年 邵贵林. All rights reserved.
//

import UIKit

class CalViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
   
    @IBOutlet weak var CalCollectionView: UICollectionView!
    
    @IBOutlet weak var todayYear: UILabel!
    
    @IBOutlet weak var todayMonth: UILabel!
    //====================自定义
    let monthArray:[String]=["Jan.","Feb.","Mar.","Apr.","May.","Jun.","Jul.","Aug.","Sept.","Oct.","Nov.","Dec."]
    let weekArray:[String]=["S","M","T","W","T","F","S"]
    var today:Int=0
    var month:Int=0
    var year:Int=0
    
    var firstDayOfMonth:Int=0
    var numberOfTheMonth:Int=0
    
    var count:Int=1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //给collection绑定委托和数据源
        CalCollectionView.delegate=self
        CalCollectionView.dataSource=self

        //获取当前日期，并存储到变量
        let calendar: Calendar = Calendar(identifier: .gregorian)
        var comps: DateComponents = DateComponents()
        comps = calendar.dateComponents([.year, .month, .day], from: Date())
        today=comps.day!
        month=comps.month!
        year=comps.year!
        getCountOfDaysInMonth(year: year, month: month)
        
    }
    //
    func getCountOfDaysInMonth(year: Int, month: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        let date = dateFormatter.date(from: String(year)+"-"+String(month))
        let calendar: Calendar = Calendar(identifier: .gregorian)
        var sRange = calendar.range(of: .day, in: .month, for: date!)
        numberOfTheMonth=(sRange?.count)!;
        firstDayOfMonth = calendar.component(.weekday, from: date!)
        if(firstDayOfMonth==7){
            firstDayOfMonth=1
        }
        todayYear.text=String(year)
        todayMonth.text=monthArray[month-1]
        //print("\(numberOfTheMonth)===\(firstDayOfMonth)")
        
    }
    
    @IBAction func last(_ sender: UIButton) {
        count=1
        if(month==1){
            year=year-1
            month=12
        }else{
            month=month-1
        }
        getCountOfDaysInMonth(year: year, month: month)
        CalCollectionView.reloadData()
    }
    
    
    @IBAction func next(_ sender: UIButton) {
        count=1
        if(month==12){
            year+=1
            month=1
        }else{
            month+=1
        }
        getCountOfDaysInMonth(year: year, month: month)
        CalCollectionView.reloadData()
    }
    //有几个部分
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    //每个部分有多少个
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(section==0){
            return 7;
        }else{
            return 42;
        }
    }
    //创建每一个cell，每一个是什么样
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateItem", for: indexPath) as! dateCollectionViewCell
        
        if(indexPath.section==0){
            //星期
            cell.textLabel.text=weekArray[indexPath.row]
            cell.bgImg.isHidden=true
        }else{
            //日期
            let temp=firstDayOfMonth-1
             if(indexPath.row<numberOfTheMonth+temp&&indexPath.row>=temp){
             //这个月有多少天显示对应数字
                cell.textLabel.text="\(count)"
                if(count==today){cell.bgImg.isHidden=false}
                else {cell.bgImg.isHidden=true}
                count+=1
            }else{
                //多余的显示空格
                cell.bgImg.isHidden=true
                cell.textLabel.text=""
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let tCell:dateCollectionViewCell=collectionView.cellForItem(at: indexPath) as! dateCollectionViewCell
        //print(tCell.textLabel.text)
        if(tCell.textLabel.text != ""){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let homePageVC = storyboard.instantiateViewController(withIdentifier: "homePage") as? HomePageViewController else {  return }
            var vMonth:String = "\(month)"
            if(month<10){
                vMonth="0\(month)"
            }
            let xx=indexPath.row-firstDayOfMonth+2//点击的日
            var vDay:String="\(xx)"
            if(xx<10){
                vDay="0\(xx)"
            }
            let theDate:String="\(year)-\(vMonth)-\(vDay)"
            //print(theDate)
            homePageVC.setDates(vDate: theDate)
            self.navigationController?.pushViewController(homePageVC, animated: true)
        }
        //直接计算
//        let temp=firstDayOfMonth-1
//        if(indexPath.row<numberOfTheMonth+temp&&indexPath.row>=temp){
//
//             let xx=indexPath.row-firstDayOfMonth+2
//            print("\(xx)");
//        }
    }
    

}
