//
//  TipOptionGroupViewModel.swift
//  modernStackView
//
//  Created by Langpeu on 1/12/25.
//

import Foundation
import RxSwift
import RxRelay
import Then
import SnapKit


class TipOptionGroupViewModel {
    struct Input {
        let selectionChanged: PublishRelay<(String, String, Bool)> // (optGroupName, optId, isSelected)
    }

    struct Output {
        let groupedOptions: Observable<[TipOptionModel]> // 그룹화된 옵션들
        let selections: Observable<[String: [String: Bool]]> // {optGroupName: {optId: isSelected}}
    }

    struct Transform {
        let input: Input
        let output: Output
    }

    private let disposeBag = DisposeBag()
    
    private let optionsRelay = BehaviorRelay<[TipOptionModel]>(value: [])
    private let selectionRelay = BehaviorRelay<[String: [String: Bool]]>(value: [:])

    func transform(_ input: Input) -> Transform {
        // 선택 상태 업데이트
        input.selectionChanged
            .subscribe(onNext: { [weak self] groupName, optId, isSelected in
                guard let self = self else { return }
                var currentSelections = self.selectionRelay.value
                var groupSelections = currentSelections[groupName] ?? [:]
                groupSelections[optId] = isSelected
                currentSelections[groupName] = groupSelections
                self.selectionRelay.accept(currentSelections)
            })
            .disposed(by: disposeBag)
        
        let output = Output(
            groupedOptions: optionsRelay.asObservable(),
            selections: selectionRelay.asObservable()
        )
        
        return Transform(input: input, output: output)
    }
    
    // Data 설정
    func setData(_ options: [TipOptionModel]) {
        optionsRelay.accept(options)
        // 초기 선택 상태 설정
        let initialSelections = options.reduce(into: [String: [String: Bool]]()) { result, group in
            result[group.optGroupName] = group.tips.reduce(into: [String: Bool]()) { $0[$1.optId] = false }
        }
        selectionRelay.accept(initialSelections)
    }
}
