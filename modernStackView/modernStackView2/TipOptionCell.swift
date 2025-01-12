//
//  TipOptionCell.swift
//  modernStackView
//
//  Created by Langpeu on 1/12/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import Then
import SnapKit

class TipOptionCell: UIView {
    private let disposeBag = DisposeBag()
    private let checkBoxButton = UIButton().then {
        $0.setImage(UIImage(systemName: "square"), for: .normal)
        $0.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
    }
    private let tipLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .black
        $0.isUserInteractionEnabled = true
    }
    
    let checkBoxTapped = PublishRelay<Bool>()
    
    init(tip: TipModel, groupName: String) {
        super.init(frame: .zero)
        setupUI(tip: tip)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(tip: TipModel) {
        addSubview(checkBoxButton)
        addSubview(tipLabel)
        
        tipLabel.text = "\(tip.optName) - \(tip.price)"
        checkBoxButton.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
        tipLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkBoxButton.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(16)
            make.trailing.centerY.equalToSuperview()
        }
        
        checkBoxButton.rx.tap
            .map { [unowned self] in !self.checkBoxButton.isSelected }
            .bind(to: checkBoxTapped)
            .disposed(by: disposeBag)
        
        checkBoxTapped
            .bind(to: checkBoxButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        
        //UILabel 에 탭 제스처 추가
        let labelTapGesture = UITapGestureRecognizer()
        tipLabel.addGestureRecognizer(labelTapGesture)
        labelTapGesture.rx.event
            .map {[unowned self] _ in !self.checkBoxButton.isSelected }
            .bind(to: checkBoxTapped)
            .disposed(by: disposeBag)
    }
}
