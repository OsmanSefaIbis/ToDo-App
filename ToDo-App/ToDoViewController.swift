//
//  ViewController.swift
//  ToDo-App
//
//  Created by Sefa İbiş on 23.03.2023.
//

import UIKit

class ToDoViewController: UIViewController {
    
    // MARK: UI Components
    @IBOutlet weak var AppTitleLabel: UILabel!
    @IBOutlet weak var TagButtonWork: UIButton!
    @IBOutlet weak var TagButtonStudy: UIButton!
    @IBOutlet weak var TagButtonEntertainment: UIButton!
    @IBOutlet weak var TagButtonFamily: UIButton!
    @IBOutlet weak var ToDoTableview: UITableView!
    @IBOutlet weak var AddToDoButton: UIButton!
    
    // MARK: DATA
    var data: [ToDoCellModel] =
        [
            .init(title: "Apply for IOS jobs", description: "Edit your CV, linkedin. Scout for network. Do learning projects. Do case study examples from web or suggestions. Revisit your learnings."),
            .init(title: "Holiday Plan", description: "Select a non-visa country, find cheap accommodation, buy tickets, ask friends to join, plan travel route and locations."),
            .init(title: "Organize a family party", description: "Reserve the occasion place. Buy groceries and other stuff related with the party. Invite family members and additional relatives. Arrange a party mix. Buy Drinks !!!")
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI(){
        self.ToDoTableview.register(.init(nibName: "ToDoCell", bundle: nil), forCellReuseIdentifier: "ToDoCell")
        self.ToDoTableview.separatorStyle = ToDoCell.SeparatorStyle.none
        ToDoTableview.delegate = self
        ToDoTableview.dataSource = self
    }
    @IBAction func AddToDoButtonPressed(_ sender: Any) {
        let nextSB = UIStoryboard(name: "Main", bundle: nil)
        let vc = nextSB.instantiateViewController(withIdentifier: "AddToDoViewController") as! AddToDoViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
}
extension ToDoViewController: UITableViewDelegate{

        // Set the spacing between sections
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            let cellSpacingHeight: CGFloat = 5
            return cellSpacingHeight
        }
    
}
extension ToDoViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.ToDoTableview.dequeueReusableCell(withIdentifier: "ToDoCell") as! ToDoCell
        cell.configure(with: data[indexPath.row])
        return cell
    }
}

