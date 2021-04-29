//
//  AVFEntitlementHack.m
//  airplay-research2
//
//  Created by Chris Jones on 28/04/2021.
//

#import "AVFEntitlementHack.h"
#import "fishhook.h"

// HACK!
// AVFoundation does the entitlement checking for the system output context in-process,
// which means we can just hook the entitlement-checking method at runtime and override it
// to always return true.

static CFTypeRef (*orig_stcvfe)(SecTaskRef  _Nonnull task, CFStringRef  _Nonnull entitlement, CFErrorRef  _Nullable * _Nullable error);

CFTypeRef my_SecTaskCopyValueForEntitlement(SecTaskRef  _Nonnull task, CFStringRef  _Nonnull entitlement, CFErrorRef  _Nullable * _Nullable error) {
    if (kCFCompareEqualTo == CFStringCompare(entitlement, CFSTR("com.apple.avfoundation.allow-system-wide-context"), 0)) {
        return kCFBooleanTrue;
    } else {
        return orig_stcvfe(task, entitlement, error);
    }
}

void hookAVFEntitlement(void) {
    rebind_symbols((struct rebinding[1]){"SecTaskCopyValueForEntitlement", my_SecTaskCopyValueForEntitlement, (void *)&orig_stcvfe}, 1);
}
