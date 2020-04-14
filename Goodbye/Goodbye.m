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

@interface Goodbye : NSObject
@end

@interface ME_Goodbye_NSApplicationDelegate : NSObject <NSApplicationDelegate>
@end

@implementation ME_Goodbye_NSApplicationDelegate
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    NSUserDefaults *blacklistArray = [[NSUserDefaults alloc] initWithSuiteName:[[NSBundle bundleForClass:[Goodbye class]] bundleIdentifier]];
    if ([[blacklistArray valueForKey:[[NSBundle mainBundle] bundleIdentifier]] boolValue])
        return ZKOrig(BOOL, sender);
    else
        return true;
}
@end

@implementation Goodbye
+ (void)load { _ZKSwizzle(ME_Goodbye_NSApplicationDelegate.class, NSApp.delegate.class); }
@end

