#
#  nshttp_cookie.rb
#  CookieInspector
#
#  Created by Scott Gonyea on 11/28/11.
#  Copyright 2011 sgonyea inc. All rights reserved.
#
require 'nshttp_cookie_storage'

class NSHTTPCookie
  def to_hash
    hash = {
      'cookie'      => self,
      'domain'      => domain,
      'name'        => name,
      'path'        => path,
      'expires_at'  => expires_at,
      'value'       => value
    }
  end

  def to_table
    table = {
      name => {
        'path'        => path,
        'expires_at'  => expires_at,
        'value'       => value
      }
    }
  end

  def expires_at
    expiresDate.to_s
  end
end
