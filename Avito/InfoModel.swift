//
//  SiteData.swift
//  Avito
//
//  Created by Nikita Entin on 05.01.2021.
//

import Foundation

//MARK:- модель для декодинга JSON

struct InfoModel: Decodable {
    var status: String?
    var result: Result
}

struct Result: Decodable {
    var title: String?
    var actionTitle: String?
    var selectedActionTitle: String?
    var list: [List]
}

struct List: Decodable {
    var id: String?
    var title: String?
    var description: String?
    var icon: Icon
    var price: String?
    var isSelected: Bool
}
struct Icon: Decodable {
    var iconSize: URL
    
    enum CodingKeys: String, CodingKey {
        case iconSize = "52x52"
    }
    
}
