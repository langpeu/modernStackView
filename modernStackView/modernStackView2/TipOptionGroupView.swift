//
//  TipOptionGroupView.swift
//  modernStackView
//
//  Created by Langpeu on 1/12/25.
//

import UIKit
import RxSwift
import RxRelay
import Then
import SnapKit

class TipOptionGroupView: UIView {
    private let disposeBag = DisposeBag()
    
    private let groupNameLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 18)
        $0.textColor = .black
    }
    
    private let groupDescriptionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .red
    }
    
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
    }
    
    init(groupName: String, groupDescription:String, tips: [TipModel], selectionChanged: PublishRelay<(String, String, Bool)>) {
        super.init(frame: .zero)
        setupUI(groupName: groupName, groupDescription: groupDescription, tips: tips, selectionChanged: selectionChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(groupName: String, groupDescription: String, tips: [TipModel], selectionChanged: PublishRelay<(String, String, Bool)>) {
        addSubview(groupNameLabel)
        addSubview(groupDescriptionLabel)
        addSubview(stackView)
        
        groupDescriptionLabel.text = groupDescription
        groupNameLabel.text = groupName
        
        groupNameLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
        }
        
        groupDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(groupNameLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(groupDescriptionLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        // 각 옵션 추가
        for tip in tips {
            let optionView = TipOptionCell(tip: tip, groupName: groupName)
            
            stackView.addArrangedSubview(optionView)
            
            optionView.snp.makeConstraints { make in
               // make.top.trailing.bottom.equalToSuperview()
                make.leading.trailing.equalToSuperview().inset(20)
                make.height.equalTo(30)
            }
            
            // 체크박스 선택 이벤트 바인딩
            optionView.checkBoxTapped
                .map { (groupName, tip.optId, $0) }
                .bind(to: selectionChanged)
                .disposed(by: disposeBag)
        }
    }
}
