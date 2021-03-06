#
#  rb_main.rb
#  CookieInspector
#
#  Created by Scott Gonyea on 11/25/11.
#  Copyright (c) 2011 sgonyea inc. All rights reserved.
#

# Loading the Cocoa framework. If you need to load more frameworks, you can
# do that here too.
framework 'Cocoa'

$:.unshift File.expand_path(File.dirname(__FILE__))

# Loading all the Ruby project files.
main      = File.basename(__FILE__, File.extname(__FILE__))
dir_path  = NSBundle.mainBundle.resourcePath.fileSystemRepresentation

Dir.glob(File.join(dir_path, '*.{rb,rbo}')).map { |x|
    File.basename(x, File.extname(x))
  }.uniq.each do |path|
    if path != main
      require(path)
    end
  end

# Starting the Cocoa main loop.
NSApplicationMain(0, nil)
