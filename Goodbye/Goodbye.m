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
    
    //Was the application originally set to Terminate?
    BOOL shouldTerminate = false;
    @try {
        shouldTerminate = ZKOrig(BOOL);
    } @catch (NSException *e ) {}
    if (shouldTerminate == true) {
        return true;
    }
    else {
        [self performSelector:@selector(closeIfRightConditions:) withObject:sender afterDelay:0.5];
        return false;
    }
}

- (void)closeIfRightConditions:(NSApplication*)sender {
    if ([sender occlusionState] & NSApplicationOcclusionStateVisible) {
        return;
    }
    else {
        // Application is not visible. Check for minaturized windows.
        NSArray *windows = [sender windows];
        for (NSWindow *aWindow in windows) {
            if ([aWindow isMiniaturized]) {
                return;
            }
        }
        // No miniaturized windows either. Safe to close app.
        [NSApp terminate:self];
    }
}

@end

@implementation Goodbye
+ (void)load {
    NSArray *globalBlacklist = [NSArray arrayWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"globalBlacklist" ofType:@"plist"]];
    
    if (![globalBlacklist containsObject: [[NSBundle mainBundle] bundleIdentifier]] && ![NSUserDefaults.standardUserDefaults boolForKey:@"GoodbyeBlacklist"] && ![[NSBundle mainBundle] objectForInfoDictionaryKey:@"LSUIElement"]) {
        _ZKSwizzle(ME_Goodbye_NSApplicationDelegate.class, NSApp.delegate.class);
    }
}
@end
