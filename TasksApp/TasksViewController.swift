//
//  TasksViewController.swift
//  TasksApp
//
//  Created by Aloc SP06447 on 07/12/2017.
//  Copyright © 2017 Aloc SP06447. All rights reserved.
//

import UIKit

class TasksViewController: UITableViewController, UISearchBarDelegate, UISearchControllerDelegate {
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var btnSearch: UIBarButtonItem!
    
    var originalTasks = [TaskItemDb]()
    var filteredTasks = [TaskItemDb]()
    var selectedItem: TaskItemDb?
    let offlineDb = OffLineDb()
    var synchronizeDb = true
    var searchController: UISearchController!
    
    @IBAction func btnSearch(_ sender: UIBarButtonItem) {
        self.searchController = searchControllerWith(searchResultsController: nil)
        self.navItem.titleView = self.searchController.searchBar
        self.definesPresentationContext = true
        self.btnSearch.isEnabled = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.resignFirstResponder()
        self.btnSearch.isEnabled = true
        self.navItem.titleView = nil
        
        filteredTasks = originalTasks
        self.tableView.reloadData()
    }
    
    func cancelBarButtonItemClicked() {
        self.searchBarCancelButtonClicked(self.searchController.searchBar)
        
        filteredTasks = originalTasks
        self.tableView.reloadData()
    }
    
    func searchControllerWith(searchResultsController: UIViewController?) -> UISearchController {
        let searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.showsCancelButton = true
        
        return searchController
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            filteredTasks = originalTasks
        } else {
            let filtered = originalTasks.filter {
                let textToSearch = "\(String(describing: $0.title)) \(String(describing: $0.descricao))"
                return textToSearch.range(of: searchText) != nil
            }
            filteredTasks = filtered
        }
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //getTasks()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.selectedItem = nil
        self.getTasks()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCellTableViewCell
        let item = filteredTasks[indexPath.row]
        
        cell.nome.text = item.title
        cell.descricao.text = item.descricao
        cell.horario.text = item.expiration_date
        cell.enable.isHidden = !item.is_complete.boolValue
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //remover remainder
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteTask(task: originalTasks[indexPath.row])
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = originalTasks[indexPath.row]
        performSegue(withIdentifier: "segueToDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC: DetailViewController = segue.destination as! DetailViewController
        destVC.task = selectedItem
    }
    
    private func deleteTask(task: TaskItemDb) {
        //show loading
        if task.id == nil {
            offlineDb.deleteTaksOffline(task)
            self.getTasks()
        } else {
            PostService().deleteTask(id: task.id!,
                onSuccess: { _ in },
                onError: { _ in
                    self.offlineDb.deleteTaksOffline(task)
            },
                always: {
                    self.getTasks()
            })
        }
    }
    
    
    private func getTasks() {
        //show loading
        PostService().getTasks(
            onSuccess: { response in
                self.originalTasks = self.offlineDb.getItemDb((response?.body?.results)!)
                if self.synchronizeDb {
                    self.offlineDb.synchronizeDb()
                    self.offlineDb.clearAndSaveAllTaks(self.originalTasks)
                    self.synchronizeDb = false
                } else {
                    self.offlineDb.clearAndSaveAllTaks(self.originalTasks)
                }
        },
            onError: { _ in
                self.originalTasks = self.offlineDb.getAllDbTasks()
                self.showMessage("Erro ao buscar as tarefas, utilizando base local")
        },
            always: {
                self.filteredTasks = self.originalTasks
                self.tableView.reloadData()
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
