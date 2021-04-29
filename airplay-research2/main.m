//
//  main.m
//  airplay-research2
//
//  Created by Chris Jones on 28/04/2021.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "AVFoundation-Private.h"
#import "AVFEntitlementHack.h"

@interface FOOmanager: NSObject
-(void)devicesChanged:(id)object;
-(void)discoveryChanged:(id)object;
@end

@implementation FOOmanager

-(void)devicesChanged:(NSNotification *)object {
    AVOutputContext *context = (AVOutputContext *)object.object;
    NSLog(@"Context device count: %lu", (unsigned long)context.outputDevices.count);
}

-(void)discoveryChanged:(NSNotification *)object {
    AVOutputDeviceDiscoverySession *session = (AVOutputDeviceDiscoverySession *)object.object;
    NSLog(@"Session device count: %lu", (unsigned long)session.availableOutputDevices.count);

    AVOutputDeviceDiscoverySessionAvailableOutputDevices *devicesObject = [session availableOutputDevicesObject];
    NSArray *foo = devicesObject.otherDevices;

    NSLog(@"Other device count: %lu", (unsigned long)foo.count);
}
@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");

        hookAVFEntitlement();
        AVOutputContext *context = [AVOutputContext sharedSystemAudioContext];
        [context setApplicationProcessID:getpid()];

        NSLog(@"%@", context);

        NSLog(@"Device count: %lu", (unsigned long)context.outputDevices.count);
        for (AVOutputDevice *device in context.outputDevices) {
            NSLog(@"Device: %@", device.name);
        }

        AVOutputDeviceDiscoverySession *session = [[AVOutputDeviceDiscoverySession alloc] initWithDeviceFeatures:1];
        [session setDiscoveryMode:0x2];

        NSLog(@"%@", session);

        NSLog(@"Device count: %lu", (unsigned long)session.availableOutputDevices.count);
        for (AVOutputDevice *device in session.availableOutputDevices) {
            NSLog(@"Device: %@", device.name);
        }

        NSLog(@"Device group count: %lu", (unsigned long)session.availableOutputDeviceGroups.count);
        for (id wut in session.availableOutputDeviceGroups) {
            NSLog(@"Group: %@", wut);
        }

        FOOmanager *foo = [[FOOmanager alloc] init];

        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:foo selector:@selector(devicesChanged:) name:@"AVOutputContextOutputDeviceDidChangeNotification" object:context];
        [center addObserver:foo selector:@selector(discoveryChanged:) name:@"AVOutputDeviceDiscoverySessionAvailableOutputDevicesDidChangeNotification" object:session];

        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop run];
    }
    return 0;
}
