//
//  ViewController.swift
//  TasksApp
//
//  Created by Aloc SP06447 on 06/12/2017.
//  Copyright © 2017 Aloc SP06447. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        login.text = "beleli@gmail.com"
        password.text = "Marmota51"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func touchOk(_ sender: UIButton) {
        //show loading
        PostService().getLogin(username: login.text!, password: password.text!,
                onSuccess: { response in
            let login = response?.body ?? Login()
            UserDefaults.standard.set(login.access_token, forKey: "token")
            self.performSegue(withIdentifier: "segueToTasks", sender: self)
        }, onError: { _ in
            self.showMessage("Houve algum problema")
        }, always: {
            //hide loading
        })
        
    }
    
    private func showMessage(_ message: String) {
        let myalert = UIAlertController(title: "Mensagem", message: message, preferredStyle: UIAlertControllerStyle.alert)
        myalert.addAction(UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction!) in
            myalert.dismiss(animated: true)
        })
        self.present(myalert, animated: true)
    }
    
    
    
}

