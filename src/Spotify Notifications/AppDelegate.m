//
//  AppDelegate.m
//  Spotify Notifications
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize statusBar;
@synthesize statusMenu;
@synthesize soundToggle;

- (void)applicationDidFinishLaunching:(NSNotification *)notification{
        
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(eventOccured:)
                                                            name:@"com.spotify.client.PlaybackStateChanged"
                                                          object:nil];
    
    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    self.statusBar.image = [NSImage imageNamed:@"status_bar.tiff"];
    self.statusBar.menu = self.statusMenu;
    self.statusBar.highlightMode = YES;
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center
     shouldPresentNotification:(NSUserNotification *)notification{
    return YES;
}

- (void)eventOccured:(NSNotification *)notification{
    
    NSDictionary *information = [notification userInfo];
    
    if ([[information objectForKey: @"Player State"]isEqualToString:@"Playing"]){
        
        NSUserNotification *notification = [[NSUserNotification alloc] init];
        notification.title = [information objectForKey: @"Name"];
        notification.subtitle = [information objectForKey: @"Album"];
        notification.informativeText = [information objectForKey: @"Artist"];
        
        if (soundToggle.state == 1){
            notification.soundName = NSUserNotificationDefaultSoundName;
        }
        
        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
        
    }
}

- (IBAction)toggleSound:(id)sender{
    if (soundToggle.state == 1){
        [soundToggle setState:0];
    }
    
    else{
        [soundToggle setState:1];
    }
}

- (IBAction)showAbout:(id)sender{
    [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:@"http://citruspi.github.io/Spotify-Notifications"]];
}

@end