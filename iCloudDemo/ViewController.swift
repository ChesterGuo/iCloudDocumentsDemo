//
//  ViewController.swift
//  iCloudDemo
//
//  Created by ChesterGuo on 2017/1/1.
//  Copyright © 2017年 Guo. All rights reserved.
//

import UIKit
import CloudKit
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CloudManagerDelegate{
    var dataArray = Array<Any>()
    var tableView : UITableView?
    let cloudManager = CloudDocumentsManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        let rightBarItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addHandle))
        self.navigationItem.rightBarButtonItem = rightBarItem
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 64), style: .plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.tableFooterView = UIView()
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        self.view.addSubview(tableView!)
        cloudManager.delegate = self
        if (cloudManager.loadDocuments()){
            print("iCloud Documents query start")
        }else{
            print("iCloud storage did not work")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func addHandle(){
        let inputCon = InputViewController()
        inputCon.diaryClosure = {(diary: Diary) -> Swift.Void in
            self.dataArray.append(diary)
            self.tableView?.reloadData()
            self.cloudManager.save(diaries: self.dataArray as! Array<Diary>)
        }
        self.present(inputCon, animated: true, completion: nil)
    }
    func queryDocumentsComplete(results:Array<Any>){
        dataArray = results
        tableView?.reloadData()
    }
    func documentDidEndEditting(){
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 44.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let inputCon = InputViewController()
        let item = dataArray[indexPath.row] as? Diary
        inputCon.currentDiary = item
        inputCon.diaryClosure = {(diary: Diary) -> Swift.Void in
            for (index,individual) in self.dataArray.enumerated() {
                let selectedDiary = individual as! Diary
                if selectedDiary.creatTimestamp == item?.creatTimestamp  {
                    self.dataArray[index] = diary
                    self.cloudManager.save(diaries: self.dataArray as! Array<Diary>)
                }
            }
            self.tableView?.reloadData()
        }
    self.present(inputCon, animated: true, completion: nil)
    }
func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle{
    return .delete
}

func numberOfSections(in tableView: UITableView) -> Int{
    return 1
}
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    return dataArray.count
}
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
    let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
    let item = dataArray[indexPath.row] as? Diary
    cell.textLabel?.text = item?.creatTimestamp
    return cell
}
func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
    return true
}
func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
    if editingStyle == .delete {
        dataArray.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        self.cloudManager.save(diaries: self.dataArray as! Array<Diary>)
    }
}
}
