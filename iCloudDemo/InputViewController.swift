//
//  InputViewController.swift
//  iCloudDemo
//
//  Created by ChesterGuo on 2017/1/2.
//  Copyright © 2017年 Guo. All rights reserved.
//

import UIKit
typealias sendDiaryClosure=(_ diary:Diary)->Void

class InputViewController: UIViewController,UITextViewDelegate,CloudManagerDelegate {
    var currentDiary : Diary!
    var diaryClosure:sendDiaryClosure?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let textView = UITextView(frame: CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height/2))
        textView.delegate = self
        if currentDiary != nil {
            textView.text = currentDiary.content
        }
        self.view.addSubview(textView)
        textView.becomeFirstResponder()
        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action: #selector(doneHandle), for: .touchUpInside)
        doneButton.frame = CGRect(x: self.view.frame.size.width - 60, y: 30, width: 44, height: 20)
        self.view.addSubview(doneButton)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func doneHandle(){
        self.view.endEditing(true)
    }
    func textViewDidEndEditing(_ textView: UITextView){
        if textView.text.lengthOfBytes(using: .utf8) > 0{
            let diary = Diary(content: textView.text)
            if currentDiary != nil{
                let date = Date()
                let dateF = DateFormatter()
                dateF.dateFormat = "yyyy-MM-dd HH:MM"
                diary.name = dateF.string(from: date)
                currentDiary = diary
                if diaryClosure != nil{
                    diaryClosure!(currentDiary)
                }
            }else{
                if diaryClosure != nil{
                    diaryClosure!(diary)
                }
            }
        }
        self.dismiss(animated: true, completion: nil)

    }
    func queryDocumentsComplete(results:Array<Any>){
    }
    func documentDidEndEditting(){
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
