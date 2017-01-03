//
//  Diary.swift
//  iCloudDemo
//
//  Created by ChesterGuo on 2017/1/3.
//  Copyright © 2017年 Guo. All rights reserved.
//

import UIKit

class Diary: NSObject {
    var name : String?
    var creatTimestamp : String?
    var content : String?
    init(name :String,content:String,creatTimestamp:String){
        self.name = name
        self.content = content
        self.creatTimestamp = creatTimestamp
    }
    init(content:String){
        let date = Date()
        let timestamp = date.timeIntervalSince1970
        self.content = content
        self.creatTimestamp = String(timestamp)
        let dateF = DateFormatter()
        dateF.dateFormat = "yyyy-MM-dd HH:MM"
        self.name = dateF.string(from: date)
    }
    init(dic:Dictionary<String, Any>){
        self.name = dic["name"] as! String?
        self.content = dic["content"] as! String?
        self.creatTimestamp = dic["creatTimestamp"] as! String?
    }
    func convertToDictionary()->Dictionary<String, Any>{
        var dictionary = Dictionary<String, Any>()
        dictionary.updateValue(self.name ?? "", forKey: "name")
        dictionary.updateValue(self.creatTimestamp ?? "", forKey: "creatTimestamp")
        dictionary.updateValue(self.content ?? "", forKey: "content")
        return dictionary
    }
}
