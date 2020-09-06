//
//  ViewController.swift
//  Todoey
//
//  Created by DX推進 on 2020/07/29.
//  Copyright © 2020 DX推進. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    //var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon", "a", "b", "c", "d", "e",
    //                 "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", ]
    //ItemClassを使用する
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        .first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
                
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy Eggos"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Destroy Demogorgon"
        itemArray.append(newItem3)
        
        //過去に追加した要素が保管されている場所にアクセスし、データを引っ張ってくる
        //if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
        //    itemArray = items
        //}
        loadItems()
    }
    
    
    //MARK - Tableview Datasource Methoda ~~~~~~~~~~~~~~~~~~~~
    
    //初めから起動
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //要素数分リストを表示する
        return itemArray.count
    }
    
    //初めから起動
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        //表示するテキストを決定する
        //ItemClassの場合、タイトルを使用する
        cell.textLabel?.text = item.title
        
        //チェックマークの操作
        //Ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        //↓　以下、上記の意味
        //if item.done == true {
        //    cell.accessoryType = .checkmark
        //}else {
        //    cell.accessoryType = .none
        //}
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    
    
    //MARK - TableView Delegate Methods ~~~~~~~~~~~~~~~~~~~~
    
    //選択すると起動する
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //選択するとチェックマークが切り替わる
        //現在の選択と逆のものが適応される（trueならfalse）
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK - Add New Items ~~~~~~~~~~~~~~~~~~~~
    
    //押すと反応する
    @IBAction func addButtonPrePressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
                
        //ボタンを押した後のアクション
        let action = UIAlertAction(title: "Add Item", style: .default){
            //what will happen once the user clicks the Add Item button on our UIAlert
            (action) in
            
            //ItemClassの場合、タイトルを使用する
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            //データ保管先の内容をアップデート
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.saveItems()
        }
        
        //テキスト記入欄作成
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
            //print(alertTextField.text)
        }
        
        alert.addAction(action)
        
        //アラート表示
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK - Model manupulation Methods
    
    func saveItems() {
        //エンコード
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("Error encoding item array, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            }catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
    
    
    


}

