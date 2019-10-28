//
//  MovieDetailsMemberListAdapter.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 10/19/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieDetailsMembersListAdapter {
  
  func list(_ members: [MoviePersonellMemberViewModel]) -> List {
    var section = ListSection(members.map(membersListItem))
    section.minimumInteritemSpacing = 8
    section.minimumLineSpacing = 8
    section.inset = UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16)

    return List(sections: [section])
  }
  
  private func membersListItem(_ member: MoviePersonellMemberViewModel) -> ListItem {
    MovieDetailsMemberListItem(member: member)
  }
}
