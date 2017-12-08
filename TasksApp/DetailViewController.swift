//
//  DetailViewController.swift
//  TasksApp
//
//  Created by Aloc SP06447 on 07/12/2017.
//  Copyright © 2017 Aloc SP06447. All rights reserved.
//

import UIKit
import DatePickerDialog

class DetailViewController: UIViewController {
    
    var task: TaskItem?
    
    @IBOutlet weak var titulo: UITextField!
    @IBOutlet weak var descricao: UITextView!
    @IBOutlet weak var completo: UISwitch!
    //@IBOutlet weak var dataExpiracao: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let aux = task {
            descricao.text = aux.descricao
            titulo.text = aux.title
            completo.isOn = aux.is_complete!
            //dataExpiracao.date = Date(fromString: aux.expiration_date!, format: .isoDate)!
        } else {
            task = TaskItem()
            task?.owner = "c8abc5a6-802c-485d-b7a8-aae79346e5f5"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func touchExpirationDate(_ sender: UIButton) {
        let current = Date(fromString: task!.expiration_date ?? Date().toString(format: .isoDate), format: .isoDate)
        DatePickerDialog(showCancelButton: false).show("Data de Expiração", doneButtonTitle: "Ok", defaultDate: current!, datePickerMode: .date) {
            (date) -> Void in
            self.task?.expiration_date = date?.toString(format: .isoDate)
        }
    }
    
    @IBAction func touchSalvar(_ sender: UIButton) {
        task?.descricao = descricao.text
        task?.title = titulo.text
        task?.is_complete = completo.isOn
        //task?.expiration_date = date?.toString(format: .isoDate)
        if task?.id == nil {
            saveTask()
        } else {
            editTask()
        }
    }
    
    func editTask() {
        PostService().editTask(id: task!.id!, task: task!,
            onSuccess: { response in
                self.task = response!.body
                self.navigationController?.popViewController(animated: true)
        },
            onError: { _ in
                self.showMessage("Houve erro ao alterar a tarefa")
        },
            always: {
                
        })
    }
    
    func saveTask() {
        PostService().saveTask(task: task!,
            onSuccess: { response in
                self.task = response!.body
                self.navigationController?.popViewController(animated: true)
        },
            onError: { _ in
                self.showMessage("Houve erro ao criar a tarefa")
        },
            always: {
                                
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
