//
//  ViewController.swift
//  ReduxCounter
//
//  Created by Justin Shiiba on 4/15/17.
//  Copyright © 2017 Shiiba. All rights reserved.
//

import UIKit

struct Counter {
    let id: Int
    let count: Int
}

struct ViewModel {
    let counters: [Counter]

    func countLabelAt(_ index: Int) -> String {
        return String(counters[index].count)
    }
}

class ViewController: UITableViewController {

    private let ReuseId = "TableviewCell"
    private let ButtonReuse = "ButtonReuse"
    private var viewModel: ViewModel
    var store: Store?

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "AddCounterCell", bundle: nil), forCellReuseIdentifier: ButtonReuse)
        tableView.register(UINib(nibName: "CounterViewCell", bundle: nil), forCellReuseIdentifier: ReuseId)

        store?.subscribe(subscriber: self)
    }

    func update(viewModel: ViewModel) {
        self.viewModel = viewModel
        tableView.reloadData()
    }

    // MARK: - TableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return viewModel.counters.count
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ButtonReuse, for: indexPath) as! AddCounterCell
            cell.delegate = self
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseId, for: indexPath) as! CounterViewCell
        cell.delegate = self
        guard indexPath.row < viewModel.counters.count else {
            return cell
        }

        cell.countLabel?.text = viewModel.countLabelAt(indexPath.row)
        return cell
    }
}

extension ViewController: CounterCellDelegate {
    func increaseTapped(for cell: UITableViewCell) {
        guard let index = tableView.indexPath(for: cell)?.row,
              let counterId = store?.getState().counters[index].id else { return }

        store?.dispatch(action: .increaseCount(counterId))
    }

    func decreaseTapped(for cell: UITableViewCell) {
        guard let index = tableView.indexPath(for: cell)?.row,
             let counterId = store?.getState().counters[index].id else { return }

        store?.dispatch(action: .decreaseCount(counterId))
    }

    func removeTapped(for cell: UITableViewCell) {
        guard let index = tableView.indexPath(for: cell)?.row,
            let counterId = store?.getState().counters[index].id else { return }

        store?.dispatch(action: .removeCounter(counterId))
    }
}

extension ViewController: AddCounterCellDelegate {
    func addTapped(for cell: UITableViewCell) {
        store?.dispatch(action: .addCounter)
    }
}

extension ViewController: Subscriber {
    func update(_ state: AppState) {
        let newState = ViewModel(counters: state.counters)
        self.update(viewModel: newState)
    }
}
