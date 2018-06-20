//
//  HGLoginController.swift
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/20.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

import UIKit

class HGLoginController: HGBASEViewController {

    @IBOutlet weak var tfAccount: HGTextField!
    @IBOutlet weak var tfPassword: HGTextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnRetrievePassword: UIButton!
    @IBOutlet weak var constraintCancelButtonTop: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        
//        self.constraintCancelButtonTop.constant = 44
        
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
    
    @IBAction func loginAction(_ sender: Any) {
        let account = self.tfAccount.text?.byTrim();
        let password = self.tfPassword.text?.byTrim();
        
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
            self.showTip("密码格式不正确(最少6位)")
            return;
        }
        
        self.view.endEditing(true)
        self.showProgressTip(nil, dealy: 20)
        HGHTTPClient.sharedInstance().login(account, password: password) { (success, errStr, res) in
            self.hideTip()
            self.backAction(self)//此处TODO，传什么Any？
        }
        
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Private
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
   
}
