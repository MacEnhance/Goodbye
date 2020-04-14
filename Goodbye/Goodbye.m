//
//  Goodbye.m
//  Goodbye
//
//  Created by Wolfgang Baird on 4/14/20.
//  Copyright © 2020 Wolfgang Baird. All rights reserved.
//

#import "ZKSwizzle.h"
#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

@interface ME_Goodbye_t : NSObject <NSApplicationDelegate>
@end

@implementation ME_Goodbye_t
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    NSUserDefaults *blacklistArray = [[NSUserDefaults alloc] initWithSuiteName:[[NSBundle bundleForClass:[self class]] bundleIdentifier]];
    if (![[blacklistArray valueForKey:[[NSBundle mainBundle] bundleIdentifier]] boolValue])
        return true;
    else
        return ZKOrig(BOOL, sender);
}
@end

@interface Goodbye : NSObject
@end

@implementation Goodbye
+ (void)load { _ZKSwizzle(ME_Goodbye_t.class, NSApp.delegate.class); }
@end

