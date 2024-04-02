//
//  MorseListVC.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 4/2/24.
//

import UIKit

import SnapKit

final class MorseListVC: UIViewController {
    var viewmodel: MorseListViewModel?

    let tableView: UITableView = {
        let t = UITableView(frame: .zero)
        t.backgroundColor = .systemPink
        return t
    }()

    override func viewDidLoad() {
        setupUI()
        print("#### \(viewmodel?.englishMorseList[0].alphabetName)")
    }

    override func viewWillDisappear(_ animated: Bool) {
        viewmodel = nil
    }
}

extension MorseListVC {
    func setupUI() {
        view.backgroundColor = .systemOrange
        addView()
        createTableView()
    }

    func addView() {
        view.addSubview(tableView)
    }

    func createTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension MorseListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension MorseListVC: UITableViewDelegate {}
