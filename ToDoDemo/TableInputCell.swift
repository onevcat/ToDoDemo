//
//  TableInputCell.swift
//  ToDoDemo
//
//  Created by WANG WEI on 2017/7/6.
//  Copyright © 2017年 OneV's Den. All rights reserved.
//

import UIKit

protocol TableViewInputCellDelegate: class {
    func inputChanged(cell: TableViewInputCell, text: String)
}

class TableViewInputCell: UITableViewCell {
    weak var delegate: TableViewInputCellDelegate?
    @IBOutlet weak var textField: UITextField!
    @objc @IBAction func textFieldValueChanged(_ sender: UITextField) {
        delegate?.inputChanged(cell: self, text: sender.text ?? "")
    }
}
