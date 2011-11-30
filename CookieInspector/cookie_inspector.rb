#
#  cookie_inspector.rb
#  CookieInspector
#
#  Created by Scott Gonyea on 11/28/11.
#  Copyright 2011 sgonyea inc. All rights reserved.
#
require 'nshttp_cookie'

module CookieInspector
  def cookie_store
    NSHTTPCookieStorage.sharedHTTPCookieStorage
  end

  def cookies
    cookie_store.cookies
  end

  def delete_cookie(cookie)
    cookie_store.deleteCookie(cookie)
  end

  def cookie_table
    cookies.map(&:to_hash)
  end
end
