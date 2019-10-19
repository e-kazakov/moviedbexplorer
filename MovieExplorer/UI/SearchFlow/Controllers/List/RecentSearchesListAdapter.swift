//
//  RecentSearchesListAdapter.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 20.07.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

class RecentSearchesListAdapter {
  
  var onSelect: ((String) -> Void)?
  
  func list(from recentSearches: [String]) -> List {
    List(sections: [
      ListSection(recentSearches.map(queryItem))
    ])
  }
  
  private func queryItem(_ query: String) -> ListItem {
    let item = RecentSearchQueryListItem(query: query)
    item.onSelect = { [unowned self] in self.onSelect?(query) }
    return item
  }
}
