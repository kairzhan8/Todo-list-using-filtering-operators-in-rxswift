//
//  AddTaskViewController.swift
//  Todo list using filtering operators in rxswift
//
//  Created by kairzhan on 2/25/21.
//

import UIKit
import RxSwift

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var titleTaskTextField: UITextField!
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    
    private let taskSubject = PublishSubject<Task>()
    var taskSubjectObservable: Observable<Task> {
        return taskSubject.asObservable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func saveTask() {
        
        guard let priority = Priority(rawValue: prioritySegmentedControl.selectedSegmentIndex),
              let title = titleTaskTextField.text else { return }
        
        let task = Task(title: title, priority: priority)
        taskSubject.onNext(task)
        dismiss(animated: true, completion: nil)
    }
}
