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
  attr_accessor :cookies_table, :_cookies_table

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

  def deleteCookies(sender)
    rows = get_selected_rows

    rows.each do |row|
      cookie = row['cookie']
      delete_cookie(cookie)
    end

    update_and_reload!
  end

  # tableView:objectValueForTableColumn:row
  def tableView(view, objectValueForTableColumn:column, row:index)
    cookie = cookies_table[index]

    cookie[column.identifier]
  end

  def tableView(view, sortDescriptorsDidChange:oldDescriptors)
    apply_sort_to_table_view
  end

  def get_sort_descriptor
    cookiesTableView.sortDescriptors.first
  end

  def apply_sort_to_table_view
    sort_descriptor = get_sort_descriptor

    return unless sort_descriptor

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
    preserving_selected_rows {
      text = cookieSearchField.stringValue

      if text.empty?
        @cookies_table = _cookies_table
      else
        @cookies_table = filter_cookies(text)
      end
    }
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
      a, b = b, a if not asc

      a[key] <=> b[key]
    end
  end

  def get_selected_rows
    rows  = []
    block = proc { |idx, stop| rows << cookies_table[idx] }

    enumerate_selection_with_block(block)

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

    apply_sort_to_table_view

    self._cookies_table = cookies_table.clone

    cookies_table
  end

  def _cookies_table
    @_cookies_table || update_cookies_table!
  end

  def selected_row_indexes
    cookiesTableView.selectedRowIndexes
  end

  def enumerate_selection_with_block(block)
    selected_row_indexes.enumerateIndexesUsingBlock(block)
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
