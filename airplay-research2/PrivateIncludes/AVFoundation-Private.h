//
//  AVFoundation-Private.h
//  airplay-research2
//
//  Created by Chris Jones on 28/04/2021.
//

#import <AVFoundation/AVFoundation.h>

#ifndef AVFoundation_Private_h
#define AVFoundation_Private_h

@interface AVOutputDevice: NSObject

@property(readonly, nonatomic) NSString *currentBluetoothListeningMode;
@property(readonly, nonatomic) NSArray *availableBluetoothListeningModes;
- (BOOL)setCurrentBluetoothListeningMode:(NSString *)mode error:(NSError **)outError;

@property (readonly, nonatomic) NSString *deviceID;
@property (readonly, nonatomic) NSString *name;

@end

@interface AVOutputContext: NSObject
+ (instancetype)sharedSystemAudioContext;

-(void)setApplicationProcessID:(int)pid;

@property (nonatomic, readonly) NSArray <AVOutputDevice *> *outputDevices;

@end

@interface AVOutputDeviceDiscoverySessionAvailableOutputDevices : NSObject
@property (nonatomic,readonly) NSArray * otherDevices;
@end


@interface AVOutputDeviceDiscoverySession: NSObject

-(id)initWithDeviceFeatures:(unsigned long long)arg1;
-(void)setDiscoveryMode:(long long)arg1;
-(NSArray *)availableOutputDevices;
-(NSArray *)availableOutputDeviceGroups;
-(AVOutputDeviceDiscoverySessionAvailableOutputDevices *)availableOutputDevicesObject;
@end

#endif /* AVFoundation_Private_h */
