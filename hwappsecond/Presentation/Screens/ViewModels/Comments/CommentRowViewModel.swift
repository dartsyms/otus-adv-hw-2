//
//  CommentRowViewModel.swift
//  hwappsecond
//
//  Created by sanchez on 12.10.2020.
//

import Foundation
import DummyApiNetworkClient

final class CommentRowViewModel: ObservableObject {
    @Published private(set) var comment: Comment
    
    init(comment: Comment) {
        self.comment = comment
    }    
}
