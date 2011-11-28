#
#  nshttp_cookie_storage.rb
#  CookieInspector
#
#  Created by Scott Gonyea on 11/28/11.
#  Copyright 2011 sgonyea inc. All rights reserved.
#
class NSHTTPCookieStorage
  def to_table
    table = new_table

    cookies.each do |cookie|
      domain_cookies = table[cookie.domain]

      domain_cookies.merge! cookie.to_table
    end

    return table
  end

  private
  def new_table
    Hash.new { |k,v| k[v] = {} }
  end
end
