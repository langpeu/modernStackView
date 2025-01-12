//
//  TipModel.swift
//  modernStackView
//
//  Created by Langpeu on 1/12/25.
//

import Foundation

struct TipOptionModel: Codable {
    let optGroupName: String // 그룹 이름
    let optDescription: String // 설명
    let tips: [TipModel]     // 그룹에 포함된 옵션들
    
    
    static func mockupTips() -> [TipOptionModel] {
        return [TipOptionModel(
            optGroupName: "아메리카노 꿀팁 🫐",
            optDescription: "1000원에 꿀팁 시럽 사용",
            tips: [
                .init(optName: "헤즐럿 시럽", optId: "1000", price: "1000"),
                .init(optName: "바닐라 시럽", optId: "1001", price: "2000"),
            ]),TipOptionModel(
                optGroupName: "카라멜마끼아또 꿀팁 시럽 🍌",
                optDescription: "무료로 팁을 사용해 보자",
                tips: [
                    .init(optName: "마키아또 시럽", optId: "2000", price: ""),
                    .init(optName: "바닐라 아이스크림", optId: "2001", price: ""),
                    .init(optName: "생크림 휘핑", optId: "2002", price: ""),
                    .init(optName: "생크림 휘핑 더블", optId: "2003", price: "")
                ]),TipOptionModel(
                    optGroupName: "이제 멘트도 안나온다. 🍆",
                    optDescription: "Tip Group Description",
                    tips: [
                        .init(optName: "Tip 1", optId: "3000", price: "1"),
                        .init(optName: "Tip 2", optId: "3001", price: "2"),
                    ]),TipOptionModel(
                        optGroupName: "정말로 이걸 넣으면 맛있을까 ? 🍑",
                        optDescription: "Tip Group Description",
                        tips: [
                            .init(optName: "Tip 1", optId: "1", price: "1"),
                            .init(optName: "Tip 2", optId: "2", price: "2"),
                        ]),TipOptionModel(
                            optGroupName: "Tip Group5",
                            optDescription: "Tip Group Description",
                            tips: [
                                .init(optName: "Tip 1", optId: "1", price: "1"),
                                .init(optName: "Tip 2", optId: "2", price: "2"),
                            ]),TipOptionModel(
                                optGroupName: "Tip Group6",
                                optDescription: "Tip Group Description",
                                tips: [
                                    .init(optName: "Tip 1", optId: "1", price: "1"),
                                    .init(optName: "Tip 2", optId: "2", price: "2"),
                                ])]
    }
}

struct TipModel: Codable {
    let optName: String // 옵션 이름
    let optId: String   // 옵션 ID
    let price: String   // 가격 정보
}
