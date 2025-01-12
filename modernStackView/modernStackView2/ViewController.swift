//
//  ViewController.swift
//  modernStackView
//
//  Created by Langpeu on 1/12/25.
//

import UIKit
import RxSwift
import RxRelay
import Then
import SnapKit

class ViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = TipOptionGroupViewModel()

    private let scrollView = UIScrollView().then{
        $0.backgroundColor = .white
    }
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.alignment = .fill
        $0.distribution = .fill
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupData()
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            
        }
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview() // 스크롤 방향 고정
        }
    }

    private func setupBindings() {
        let input = TipOptionGroupViewModel.Input(
            selectionChanged: PublishRelay<(String, String, Bool)>()
        )
        let transform = viewModel.transform(input)

        // 그룹 데이터 바인딩
        transform.output.groupedOptions
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] groups in
                self?.setupGroups(groups, selectionChanged: input.selectionChanged)
            })
            .disposed(by: disposeBag)

        // 선택 상태 출력 디버깅
        transform.output.selections
            .subscribe(onNext: { selections in
                print("옵션 선택: \(selections)")
            })
            .disposed(by: disposeBag)
    }

    private func setupGroups(_ groups: [TipOptionModel], selectionChanged: PublishRelay<(String, String, Bool)>) {
        // 기존 그룹 제거
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // 새로운 그룹 추가
        for group in groups {
            let groupView = TipOptionGroupView(
                groupName: group.optGroupName,
                groupDescription: group.optDescription,
                tips: group.tips,
                selectionChanged: selectionChanged
            )
            stackView.addArrangedSubview(groupView)
        }
    }

    private func setupData() {
        // Example data
        viewModel.setData(TipOptionModel.mockupTips())
    }
}

