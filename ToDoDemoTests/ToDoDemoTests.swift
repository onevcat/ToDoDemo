//
//  ToDoDemoTests.swift
//  ToDoDemoTests
//
//  Created by 王 巍 on 2017/7/6.
//  Copyright © 2017年 OneV's Den. All rights reserved.
//

import XCTest
@testable import ToDoDemo

class ToDoDemoTests: XCTestCase {
    
    var controller: TableViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        controller = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TableViewController") as! TableViewController
        _ = controller.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        controller = nil
        super.tearDown()
    }
    
    func testReducerUpdateTextFromEmpty() {
        let initState = TableViewController.State()
        let state = controller.reducer(action: .updateText(text: "123"), state: initState).state
        XCTAssertEqual(state.text, "123")
    }
    
    func testReducerUpdateTextFromExisting() {
        var initState = TableViewController.State()
        initState.text = "123"
        let state = controller.reducer(action: .updateText(text: "321"), state: initState).state
        XCTAssertEqual(state.text, "321")
    }
    
    func testReducerUpdateTextToEmpty() {
        var initState = TableViewController.State()
        initState.text = "123"
        let state = controller.reducer(action: .updateText(text: ""), state: initState).state
        XCTAssertEqual(state.text, "")
    }
    
    func testReducerAddToDos() {
        var initState = TableViewController.State()
        initState.dataSource = TableViewControllerDataSource(todos: ["1"], owner: nil)
        let state = controller.reducer(action: .addToDos(items: ["3", "2"]), state: initState).state
        XCTAssertEqual(state.dataSource.todos, ["3", "2", "1"])
    }
    
    func testUpdateView() {
        
        let state1 = TableViewController.State(
            dataSource:TableViewControllerDataSource(todos: [], owner: nil),
            text: ""
        )
        let state2 = TableViewController.State(
            dataSource:TableViewControllerDataSource(todos: ["1", "3"], owner: nil),
            text: "Hello"
        )
        let state3 = TableViewController.State(
            dataSource:TableViewControllerDataSource(todos: ["Hello", "2", "3"], owner: nil),
            text: "2"
        )
        
        let state4 = TableViewController.State(
            dataSource:TableViewControllerDataSource(todos: [], owner: nil),
            text: "onevcat"
        )
        
        controller.updateView(state: state2, previousState: state1, command: nil)
        XCTAssertEqual(controller.title, "TODO - (2)")
        XCTAssertEqual(controller.tableView.numberOfRows(inSection: TableViewControllerDataSource.Section.todos.rawValue), 2)
        XCTAssertEqual(controller.tableView.cellForRow(at: todoItemIndexPath(row: 1))?.textLabel?.text, "3")
        XCTAssertTrue(controller.navigationItem.rightBarButtonItem!.isEnabled)
        
        controller.updateView(state: state3, previousState: state2, command: nil)
        XCTAssertEqual(controller.title, "TODO - (3)")
        XCTAssertEqual(controller.tableView.numberOfRows(inSection: TableViewControllerDataSource.Section.todos.rawValue), 3)
        XCTAssertEqual(controller.tableView.cellForRow(at: todoItemIndexPath(row: 0))?.textLabel?.text, "Hello")
        XCTAssertFalse(controller.navigationItem.rightBarButtonItem!.isEnabled)
        
        controller.updateView(state: state4, previousState: state3, command: nil)
        XCTAssertEqual(controller.title, "TODO - (0)")
        XCTAssertEqual(controller.tableView.numberOfRows(inSection: TableViewControllerDataSource.Section.todos.rawValue), 0)
        XCTAssertNil(controller.tableView.cellForRow(at: todoItemIndexPath(row: 0)))
        XCTAssertTrue(controller.navigationItem.rightBarButtonItem!.isEnabled)
    }
    
    func testAdding() {
        let testItem = "Test Item"
        
        let originalTodos = controller.store.state.dataSource.todos
        controller.store.dispatch(.updateText(text: testItem))
        controller.addButtonPressed(self)
        
        let newState = controller.store.state
        XCTAssertEqual(newState.dataSource.todos, [testItem] + originalTodos)
        XCTAssertEqual(newState.text, "")
    }
    
    func testRemoving() {
        controller.store.dispatch(.addToDos(items: ["1", "2", "3"]))
        controller.tableView(controller.tableView, didSelectRowAt: todoItemIndexPath(row: 1))
        XCTAssertEqual(controller.store.state.dataSource.todos, ["1", "3"])
    }
    
    func testInputChanged() {
        controller.inputChanged(cell: TableViewInputCell(), text: "Hello")
        XCTAssertEqual(controller.store.state.text, "Hello")
    }
    
    func testLoadToDos() {
        var initState = TableViewController.State()
        initState.dataSource = TableViewControllerDataSource(todos: ["1"], owner: nil)
        let (state, command) = controller.reducer(action: .loadToDos, state: initState)
        XCTAssertEqual(state.dataSource.todos, ["1"])
        XCTAssertNotNil(command)
        switch command! {
        case .loadToDos(let handler):
            let action = handler(["2", "3"])
            let (newState, newCommand) = controller.reducer(action: action, state: state)
            controller.updateView(state: newState, previousState: state, command: newCommand)
            XCTAssertEqual(controller.tableView.numberOfRows(inSection: TableViewControllerDataSource.Section.todos.rawValue), 3)
        default:
            XCTFail("The command should be .loadToDos")
        }
    }
}

func todoItemIndexPath(row: Int) -> IndexPath {
    return IndexPath(row: row, section: TableViewControllerDataSource.Section.todos.rawValue)
}

