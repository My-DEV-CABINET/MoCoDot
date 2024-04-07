//
//  MorseListVC.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 4/2/24.
//

import UIKit

import SnapKit

enum Section {
    case english
    case chosung
    case jungsung
    case jongsung
}

final class MorseListVC: UIViewController {
    var viewModel: MorseListViewModel!

    var tableView = UITableView(frame: .zero, style: .insetGrouped)
    var dataSource: UITableViewDiffableDataSource<Section, AnyHashable>!
}

extension MorseListVC {
    override func viewDidLoad() {
        if ModeManager.shared.currentMode == true {
            overrideUserInterfaceStyle = .light
        } else {
            overrideUserInterfaceStyle = .dark
        }

        setupUI()
    }

    override func viewWillDisappear(_ animated: Bool) {
        viewModel = nil
    }
}

extension MorseListVC {
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, AnyHashable>(tableView: tableView) { (tableView, indexPath, item) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MorseCell.identifier, for: indexPath) as? MorseCell else { return UITableViewCell() }
            cell.configure(item as! MorseProtocol)
            cell.eventHandler = { [weak self] str in
                self?.viewModel.generatingMorseCodeSounds(str)
            }
            cell.backgroundColor = UIColor(named: UIType.unSelectButton.type)
            return cell
        }
    }

    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        let englishMorseList = viewModel.englishMorseList.filter { $0.alphabetName != " " && $0.alphabetName != "\n" }
        let chosungList = viewModel.koreanMorseList[0].filter { $0.alphabetName != " " }
        let jungsungList = viewModel.koreanMorseList[1].filter { $0.alphabetName != " " }
        let jongsungLIst = viewModel.koreanMorseList[2].filter { $0.alphabetName != " " }

        snapshot.appendSections([.english])
        snapshot.appendItems(englishMorseList, toSection: .english)

        snapshot.appendSections([.chosung])
        snapshot.appendItems(chosungList, toSection: .chosung)

        snapshot.appendSections([.jungsung])
        snapshot.appendItems(jungsungList, toSection: .jungsung)

        snapshot.appendSections([.jongsung])
        snapshot.appendItems(jongsungLIst, toSection: .jongsung)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension MorseListVC {
    func setupUI() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor(named: UIType.background.type)
        addView()
        createTableView()

        configureDataSource()
        applySnapshot()
    }

    func addView() {
        view.addSubview(tableView)
    }

    func createTableView() {
        tableView.backgroundColor = UIColor(named: UIType.background.type)
        tableView.delegate = self
        tableView.register(MorseCell.self, forCellReuseIdentifier: MorseCell.identifier)
        tableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderView.reuseId)

        tableView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(view)
        }
    }
}

extension MorseListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 선택된 셀을 해제합니다. 선택 효과가 사라지도록 합니다.
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderView.reuseId) as? SectionHeaderView else { return UIView() }
        let sectionType = dataSource.snapshot().sectionIdentifiers[section]
        switch sectionType {
        case .english:
            cell.titleLabel.text = "영어 모스부호"
        case .chosung:
            cell.titleLabel.text = "한글 모스부호 - 초성(초성 + 종성 = 자음)"
        case .jungsung:
            cell.titleLabel.text = "한글 모스부호 - 중성(모음)"
        case .jongsung:
            cell.titleLabel.text = "한글 모스부호 - 종성(초성 + 종성 = 자음)"
        }

        return cell
    }
}
