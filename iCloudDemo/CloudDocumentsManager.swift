//
//  CloudDocumentsManager.swift
//  iCloudDemo
//
//  Created by ChesterGuo on 2017/1/2.
//  Copyright © 2017年 Guo. All rights reserved.
//

import UIKit
protocol CloudManagerDelegate : NSObjectProtocol {
    func queryDocumentsComplete(results:Array<Any>)
    func documentDidEndEditting()
}
class CloudDocumentsManager: NSObject {
    var delegate : CloudManagerDelegate?
    /// get icloud Documents url
    ///
    /// - Returns: url or nil
    func iCloudDocumentURL() -> URL? {
        let fileManager = FileManager.default
        if let url = fileManager.url(forUbiquityContainerIdentifier: nil) {
            return url.appendingPathComponent("Documents")
        }
        return nil
    }

    func save(diaries:Array<Diary>){
        let baseURL = self.iCloudDocumentURL()
        if baseURL != nil{
            var dataList = Array<Dictionary<String, Any>>()
            for diary in diaries {
                let dic = diary.convertToDictionary()
                dataList.append(dic)
            }
            var url = self.iCloudDocumentURL()
            url = url?.appendingPathComponent("saveData")
            let document = XDocument(fileURL: url!)
            document.open { (success) in
                if(success){
                    document.diaries = dataList
                    document.save(to: url!, for: .forOverwriting) { (success) in
                        if success{
                            print("Overwrit success")
                            document.close(completionHandler: nil)
                        }
                    }
                }else{
                    document.diaries = dataList
                    document.save(to: url!, for: .forCreating) { (success) in
                        if success{
                            print("Creat success")
                            document.close(completionHandler: nil)
                        }
                    }
                }
            }
        }
    }
    /// query Documents subdirectory
    ///
    /// - Returns: iCloud storage usable/disabled
    private var query : NSMetadataQuery = NSMetadataQuery()
    func loadDocuments()->Bool{
        let baseURL = self.iCloudDocumentURL()
        guard baseURL != nil else {
            return false
        }
        let center = NotificationCenter.default
        query.searchScopes = [NSMetadataQueryUbiquitousDocumentsScope]
        query.predicate = NSPredicate(value: true)
//        center.addObserver(self, selector: #selector(metadataQueryDidFinishGathering), name: NSNotification.Name.NSMetadataQueryDidUpdate, object: nil)
        center.addObserver(self, selector: #selector(metadataQueryDidFinishGathering), name: NSNotification.Name.NSMetadataQueryDidFinishGathering, object: nil)
        self.query.enableUpdates()
        query.start()
        return true
    }

    func metadataQueryDidFinishGathering() {
        query.disableUpdates()
        query.stop()
        let center = NotificationCenter.default
        center.removeObserver(self)
        var diaryList = Array<Any>()
        if (query.resultCount == 1) {
            let item = query.results.first as! NSMetadataItem
            let fileURL = item.value(forAttribute: NSMetadataItemURLKey) as! URL
            let document = XDocument(fileURL: fileURL )
            document.open(completionHandler: { (success) in
                for dic in document.diaries{
                    let diary = Diary(dic: dic)
                    diaryList.append(diary)
                }
                self.delegate?.queryDocumentsComplete(results: diaryList)
                document.close(completionHandler: nil)
            })

        }else{
            self.delegate?.queryDocumentsComplete(results: diaryList)
        }
    }
}
