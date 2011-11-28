#
#  cookie_inspector.rb
#  CookieInspector
#
#  Created by Scott Gonyea on 11/28/11.
#  Copyright 2011 sgonyea inc. All rights reserved.
#
module CookieInspector
  extend self

  def cookie_store
    NSHTTPCookieStorage.sharedHTTPCookieStorage
  end

  def cookies
    cookie_store.cookies
  end

  def cookie_table
    cookie_store.to_table
  end
end
