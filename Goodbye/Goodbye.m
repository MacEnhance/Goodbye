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

@interface ME_Goodbye_Whitelisted_NSApplicationDelegate : NSObject <NSApplicationDelegate>
@end

@interface ME_Goodbye_NSApplicationDelegate : NSObject <NSApplicationDelegate>
@end

@implementation ME_Goodbye_Whitelisted_NSApplicationDelegate
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    NSLog(@"Goodbye closed app: globalWhitelist");
    return true;
}
@end

@implementation ME_Goodbye_NSApplicationDelegate
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    
    NSArray *windows = [NSApp windows];
    if ([windows count] == 0) {
        NSLog(@"Goodbye closed app: Found no NSWindows");
        return true;
    }
    else {
        for (NSWindow *aWindow in windows) {
            if (! [aWindow isKindOfClass:[NSPanel class]]) {
                NSLog(@"Goodbye closed app: saw a non-panel NSWindow");
                return true;
            }
        }
        NSLog(@"Goodbye left app open: saw only NSPanels");
        return false;
    }
}

@end

@implementation Goodbye
+ (void)load {
    
    NSArray *globalBlacklist = [NSArray arrayWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"globalBlacklist" ofType:@"plist"]];
    
    NSArray *globalWhitelist = [NSArray arrayWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"globalWhitelist" ofType:@"plist"]];
    
    if (![globalBlacklist containsObject: [[NSBundle mainBundle] bundleIdentifier]] && ![NSUserDefaults.standardUserDefaults boolForKey:@"GoodbyeBlacklist"] && ![[NSBundle mainBundle] objectForInfoDictionaryKey:@"LSUIElement"]) {
        if ([globalWhitelist containsObject: [[NSBundle mainBundle] bundleIdentifier]]) {
            _ZKSwizzle(ME_Goodbye_Whitelisted_NSApplicationDelegate.class, NSApp.delegate.class);
        }
        else {
            _ZKSwizzle(ME_Goodbye_NSApplicationDelegate.class, NSApp.delegate.class);
        }
    }
}
@end

