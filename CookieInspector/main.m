//
//  main.m
//  CookieInspector
//
//  Created by Scott Gonyea on 11/28/11.
//  Copyright (c) 2011 sgonyea inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <MacRuby/MacRuby.h>

int main(int argc, char *argv[])
{
  return macruby_main("rb_main.rb", argc, argv);
}
