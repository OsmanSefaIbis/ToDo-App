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
    
    // MARK: Data
    var data: [ToDoCellModel] =
    [
        .init(title: "Work", description: "Edit ", tags: [.work]),
        .init(title: "Study", description: "Edit.", tags: [.study]),
        .init(title: "WorkStudy", description: "Edit.", tags: [.work,.study]),
        .init(title: "WorkStudyEntertainment", description: "Edit.", tags: [.work, .study, .entertainment]),
        .init(title: "StudyEntertainment", description: "Edit.", tags: [ .study, .entertainment]),
        .init(title: "EntertainmentFamily", description: "Edit.", tags: [ .entertainment,.family]),
        .init(title: "Family", description: "Edit.", tags: [.family]),
        .init(title: "WorkFamily", description: "Edit.", tags: [.work,.family]),
        .init(title: "All", description: "All", tags: [.work, .study, .entertainment,.family]),
    ]
    var filteredData: [ToDoCellModel] = []
    private var tagSelection: Set<TagEnum> = []
    
    // Tag Flags
    private var workPressedFlag: Bool = false
    private var studyPressedFlag: Bool = false
    private var entertainmentPressedFlag: Bool = false
    private var familyPressedFlag: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        ToDoTableview.delegate = self
        ToDoTableview.dataSource = self
        self.ToDoTableview.register(.init(nibName: "ToDoCell", bundle: nil), forCellReuseIdentifier: "ToDoCell")
        self.ToDoTableview.separatorStyle = ToDoCell.SeparatorStyle.none
        checkTagSelection()
    }
    
    func TagButtonPressedHelper(flag pressedFlag: inout Bool, tag tagEnum: TagEnum){
        pressedFlag = !pressedFlag
        if pressedFlag{
            tagSelection.insert(tagEnum)
        }else{
            tagSelection.remove(tagEnum)
        }
        filteredData = data.filter { element in
            element.tags.contains(where: { Array(tagSelection).contains($0) })
        }
        checkTagSelection()
        ToDoTableview.reloadData()
    }
    func checkTagSelection(){
        if Array(tagSelection).isEmpty{
            filteredData = data
        }
    }
    
    // MARK: Button Actions
    
    @IBAction func TagWorkButtonPressed(_ sender: Any) {
        TagButtonPressedHelper(flag: &workPressedFlag, tag: .work)
    }
    @IBAction func TagStudyButtonPressed(_ sender: Any) {
        TagButtonPressedHelper(flag: &studyPressedFlag, tag: .study)
    }
    @IBAction func TagEntertainmentButtonPressed(_ sender: Any) {
        TagButtonPressedHelper(flag: &entertainmentPressedFlag, tag: .entertainment)
    }
    @IBAction func TagFamilyButtonPressed(_ sender: Any) {
        TagButtonPressedHelper(flag: &familyPressedFlag, tag: .family)
    }
    @IBAction func AddToDoButtonPressed(_ sender: Any) {
        let nextSB = UIStoryboard(name: "Main", bundle: nil)
        let vc = nextSB.instantiateViewController(withIdentifier: "AddToDoViewController") as! AddToDoViewController
        vc.modalPresentationStyle = .fullScreen
        // assign delegate
        vc.delegate = self
        self.present(vc, animated: false)
    }
}


// MARK: Extensions
extension ToDoViewController: ToDoAddedDelegate{
    func didChanged(_ title: String?, _ description: String?, _ tags: Set<TagEnum>?) {
        if let title, let description, let tags{
            data.append(.init(title: title, description: description, tags: tags))
            ToDoTableview.reloadData()
        }
    }
}
extension ToDoViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let cellSpacingHeight: CGFloat = 5
        return cellSpacingHeight
    }
}
extension ToDoViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.ToDoTableview.dequeueReusableCell(withIdentifier: "ToDoCell") as! ToDoCell
        cell.configure(with: filteredData[indexPath.row])
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }
}
extension ToDoViewController: CustomCellDelegate{
    func deleteActionPressed(at indexPath: IndexPath) {
        data.remove(at: indexPath.row)
        filteredData = data
        ToDoTableview.reloadData()
    }
    

}

