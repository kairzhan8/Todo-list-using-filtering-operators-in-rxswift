//
//  TaskListViewController.swift
//  Todo list using filtering operators in rxswift
//
//  Created by kairzhan on 2/24/21.
//

import UIKit
import RxSwift
import RxRelay

class TaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private var tasks = BehaviorRelay<[Task]>(value: [])
    private var filteredTasks = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController,
              let addTaskVC = navC.viewControllers.first as? AddTaskViewController else {
                fatalError("Controller not found")
            }
        addTaskVC.taskSubjectObservable
            .subscribe(onNext: { [unowned self] task in
                
                let priority = Priority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex - 1)
                
                var existingTasks = self.tasks.value
                existingTasks.append(task)
                self.tasks.accept(existingTasks)
                filterTasks(by: priority)
            }).disposed(by: disposeBag)
    }
    
    @IBAction func priorityValueChanged(segmentControl: UISegmentedControl) {
        let priority = Priority(rawValue: segmentControl.selectedSegmentIndex - 1)
        filterTasks(by: priority)
    }
    
    private func filterTasks(by priority: Priority?) {
        if priority == nil {
            self.filteredTasks = self.tasks.value
        } else {
            self.tasks.map { tasks in
                return tasks.filter { $0.priority == priority!}
            }.subscribe(onNext: { [weak self] tasks in
                self?.filteredTasks = tasks
                print(tasks)
            }).disposed(by: disposeBag)
        }
    }
}
