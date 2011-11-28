#
#  nshttp_cookie.rb
#  CookieInspector
#
#  Created by Scott Gonyea on 11/28/11.
#  Copyright 2011 sgonyea inc. All rights reserved.
#
class NSHTTPCookie
  def to_table
    table = {
      name => {
        :path         => path,
        :expiresDate  => expiresDate,
        :value        => value
      }
    }
  end
end
