//
//  CandidatesView.swift
//  Vote Presidente
//
//  Created by Arthur Augusto Sousa Marques on 3/15/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CandidateCell"

class CandidatesView: UITableViewController {
    let viewModel = CandidatesViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCandidates
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = super.tableView(tableView, heightForRowAt: indexPath)
        height += viewModel.candidateDescriptionHeight(at: indexPath)
        return height
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CandidatesViewCell
        cell.setupView(at: indexPath)
        return cell
    }
}

extension CandidatesView: CandidatesViewModelDelegate {
    func reloadData() {
        tableView.reloadData()
    }
}
