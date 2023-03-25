//
//  AddToDoViewController.swift
//  ToDo-App
//
//  Created by Sefa İbiş on 25.03.2023.
//

import UIKit

class AddToDoViewController: UIViewController {
    
    // MARK: UI Components
    @IBOutlet weak var AppTitleLabel: UILabel!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var AddTitleTextField: UITextField!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var AddDescriptionTextField: UITextField!
    @IBOutlet weak var TagsLabel: UILabel!
    @IBOutlet weak var TagButtonWork: UIButton!
    @IBOutlet weak var TagButtonStudy: UIButton!
    @IBOutlet weak var TagButtonEntertainment: UIButton!
    @IBOutlet weak var TagButtonFamily: UIButton!
    @IBOutlet weak var CancelToDoButton: UIButton!
    @IBOutlet weak var AddToDoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func CancelToDoButtonPressed(_ sender: Any) {
        let landingSB = UIStoryboard(name: "Main", bundle: nil)
        let vc = landingSB.instantiateViewController(withIdentifier: "ToDoViewController") as! ToDoViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    @IBAction func AddToDoButtonPressed(_ sender: Any) {
    }
}
