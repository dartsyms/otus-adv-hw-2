//
//  CommentRowViewModel.swift
//  hwappsecond
//

import Foundation
import DummyApiNetworkClient

final class CommentRowViewModel: ObservableObject {
    @Published private(set) var comment: Comment
    
    init(comment: Comment) {
        self.comment = comment
    }    
}
