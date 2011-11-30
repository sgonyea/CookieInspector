#
#  CIController.rb
#  CookieInspector
#
#  Created by Scott Gonyea on 11/28/11.
#  Copyright 2011 sgonyea inc. All rights reserved.
#
require 'cookie_inspector'

class CIController
  include CookieInspector

  attr_accessor :cookiesTableView, :cookieSearchField

  def awakeFromNib
    cookiesTableView.dataSource = self

    cookiesTableView.allowsColumnSelection = false
  end

  def cookies_table
    @cookies_table || update_cookies_table!
  end

  # numberOfRowsInTableView:
  def numberOfRowsInTableView(view)
    cookies_table.length
  end

  def reloadCookies(sender)
    update_and_reload!
  end

  def deleteCookie(sender)
    index = cookiesTableView.selectedRow

    return if index < 0

    row     = cookies_table[index]
    cookie  = row['cookie']

    delete_cookie(cookie)
    update_and_reload!
  end

  # tableView:objectValueForTableColumn:row
  def tableView(view, objectValueForTableColumn:column, row:index)
    cookie = cookies_table[index]

    cookie[column.identifier]
  end

  def tableView(view, sortDescriptorsDidChange:oldDescriptors)
    sort_descriptor = view.sortDescriptors.first

    key = sort_descriptor.key
    asc = sort_descriptor.ascending

    preserving_selected_rows {
      sort_table_at_key(key, asc)
    }

    reload_data!
  end

  def searchCookies(sender)
    apply_search_filter
    reload_data!
  end

  def apply_search_filter
    text = cookieSearchField.stringValue

    if text.empty?
      @cookies_table = _cookies_table
    else
      @cookies_table = filter_cookies(text)
    end
  end

  def filter_cookies(text)
    text = Regexp.escape(text)
    regx = /#{text}/i

    _cookies_table.select do |row|
      row.values.grep(regx).any?
    end
  end

  def preserving_selected_rows
    if block_given?
      rows = get_selected_rows

      yield

      indexes = created_index_set_for_rows(rows)
      cookiesTableView.selectRowIndexes indexes, byExtendingSelection:false
    end
  end

  def sort_table_at_key(key, asc)
    cookies_table.sort! do |a,b|
      if asc
        a[key] <=> b[key]
      else
        b[key] <=> a[key]
      end
    end
  end

  def get_selected_rows
    indexes = cookiesTableView.selectedRowIndexes
    rows    = []
    block   = proc { |idx, stop| rows << cookies_table[idx] }

    indexes.enumerateIndexesUsingBlock(block)

    rows
  end

  def created_index_set_for_rows(rows)
    new_indexes = NSMutableIndexSet.new
    rows.each do |row|
      index = cookies_table.index(row)

      new_indexes.addIndex index
    end

    new_indexes
  end

  private
  def update_cookies_table!
    self.cookies_table  = cookie_table
    self._cookies_table = cookies_table.clone

    cookies_table
  end

  def cookies_table=(table)
    @cookies_table = table
  end

  def _cookies_table
    @_cookies_table ||= update_cookies_table!
  end

  def _cookies_table=(table)
    @_cookies_table = table
  end

  def reload_data!
    cookiesTableView.reloadData
  end

  def update_and_reload!
    update_cookies_table!
    apply_search_filter
    reload_data!
  end
end
