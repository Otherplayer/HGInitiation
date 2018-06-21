//
//  HGRegisterController.swift
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/20.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

import UIKit

class HGRegisterController: HGBASEViewController {

    @IBOutlet weak var tfAccount: HGTextField!
    @IBOutlet weak var tfPassword: HGTextField!
    @IBOutlet weak var tfCaptcha: HGTextField!
    @IBOutlet weak var btnSendCaptcha: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Action
    
    @IBAction func registerAction(_ sender: Any) {
        let account = self.tfAccount.text?.byTrim();
        let password = self.tfPassword.text?.byTrim();
        let captcha = self.tfCaptcha.text?.byTrim();
        
        guard account!.count > 0 else {
            self.showTip("手机号不能为空")
            return;
        }
        guard account!.count == 11 else {
            self.showTip("手机号格式不正确")
            return;
        }
        guard password!.count > 0 else {
            self.showTip("密码不能为空")
            return;
        }
        guard password!.count >= 6 else {
            self.showTip("密码最少6位")
            return;
        }
        guard captcha!.count > 0 else {
            self.showTip("验证码不能为空")
            return;
        }
        guard captcha!.count >= 4 else {
            self.showTip("验证码格式不正确")
            return;
        }
        
        self.view.endEditing(true)
        self.showProgressTip(nil, dealy: 20)
        HGHTTPClient.sharedInstance().regist(account, password: password,captcha: captcha) { (success, errStr, res) in
            self.hideTip()
            self.backAction(self)//此处TODO，传什么Any？
        }
        
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func sendCaptchaAction(_ sender: Any) {
        let account = self.tfAccount.text?.byTrim();
        
        guard account!.count > 0 else {
            self.showTip("手机号不能为空")
            return;
        }
        guard account!.count == 11 else {
            self.showTip("手机号格式不正确")
            return;
        }
        
        self.view.endEditing(true)
        self.showProgressTip(nil, dealy: 20)
        HGHTTPClient.sharedInstance().fetchCaptcha(account) { (success, errStr, res) in
            self.hideTip()
            self.btnSendCaptcha.startTime(10, title: "发送验证码", waitTittle: "秒后重试")
        }
        
    }
    
    
    // MARK: - Private
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}
