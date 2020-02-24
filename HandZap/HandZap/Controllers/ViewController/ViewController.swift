//
//  ViewController.swift
//  HandZap
//
//  Created by Chandra Rao on 24/02/20.
//  Copyright © 2020 Chandra Rao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var btnAdd: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var arrTableData: [FormsData]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            
            let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            self.navigationController?.navigationBar.titleTextAttributes = textAttributes
            
            self.tableView.rowHeight = UITableView.automaticDimension
            self.tableView.estimatedRowHeight = 142.0            
        }
    }
    
    @IBAction func btnAddClicked(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let formsVC = storyBoard.instantiateViewController(withIdentifier: "FormsViewController") as! FormsViewController
        formsVC.delegate = self
        self.navigationController?.pushViewController(formsVC, animated: true)
    }
    
    @objc func deleteItem(_ sender: Any) {
        if let button = sender as? UIButton {
            let alertController = UIAlertController(title:"HandZap", message: "", preferredStyle: .actionSheet)
            let deleteAction = UIAlertAction(title: "Delete Form", style: .destructive, handler: { (action) in
                if let arrData = self.arrTableData, arrData.count > 0 {
                    DispatchQueue.main.async {
                        self.arrTableData?.remove(at: button.tag)
                        self.tableView.reloadData()
                    }
                }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                
            })
            alertController.addAction(deleteAction)
            alertController.addAction(cancelAction)
            self.navigationController?.present(alertController, animated: true, completion: {
                
            })
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let arrData = self.arrTableData {
            return arrData.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell {
            if let arrData = self.arrTableData {
                cell.configureUI(withData: arrData[indexPath.row])
                cell.btnMore.tag = indexPath.row
                cell.btnMore.addTarget(self, action: #selector(deleteItem(_:)), for: .touchUpInside)
            }
            return cell
        }
        return UITableViewCell()
    }
}

extension ViewController: FormsListingProtocol {
    func appendFormsData(withData data: FormsData?) {
        DispatchQueue.main.async {
            if let formsData = data {
                if let _ = self.arrTableData {
                    self.arrTableData?.append(formsData)
                } else {
                    self.arrTableData = []
                    self.arrTableData?.append(formsData)
                }
            }
            self.tableView.reloadData()
        }
    }
}
