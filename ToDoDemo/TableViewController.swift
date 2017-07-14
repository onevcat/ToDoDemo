//
//  TableViewController.swift
//  ToDoDemo
//
//  Created by WANG WEI on 2017/7/6.
//  Copyright © 2017年 OneV's Den. All rights reserved.
//

import UIKit

let inputCellReuseId = "inputCell"
let todoCellResueId = "todoCell"

class TableViewController: UITableViewController {
    
    enum Section: Int {
        case input = 0, todos, max
    }
    
    var todos: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TODO - (0)"
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        ToDoStore.shared.getToDoItems { (data) in
            self.todos += data
            self.title = "TODO - (\(self.todos.count))"
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.max.rawValue
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            fatalError()
        }
        switch section {
        case .input: return 1
        case .todos: return todos.count
        case .max: fatalError()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError()
        }
        
        switch section {
        case .input:
            let cell = tableView.dequeueReusableCell(withIdentifier: inputCellReuseId, for: indexPath) as! TableViewInputCell
            cell.delegate = self
            return cell
        case .todos:
            let cell = tableView.dequeueReusableCell(withIdentifier: todoCellResueId, for: indexPath)
            cell.textLabel?.text = todos[indexPath.row]
            return cell
        default:
            fatalError()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == Section.todos.rawValue else {
            return
        }
        
        todos.remove(at: indexPath.row)
        title = "TODO - (\(todos.count))"
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let inputIndexPath = IndexPath(row: 0, section: Section.input.rawValue)
        guard let inputCell = tableView.cellForRow(at: inputIndexPath) as? TableViewInputCell,
              let text = inputCell.textField.text else
        {
            return
        }
        todos.insert(text, at: 0)
        title = "TODO - (\(todos.count))"
        tableView.reloadData()
        inputCell.textField.text = ""
    }
}

extension TableViewController: TableViewInputCellDelegate {
    func inputChanged(cell: TableViewInputCell, text: String) {
        let isItemLengthEnough = text.count >= 3
        navigationItem.rightBarButtonItem?.isEnabled = isItemLengthEnough
    }
}

