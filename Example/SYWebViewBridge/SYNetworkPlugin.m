//
//  SYNetworkPlugin.m
//  SYWebViewBridge_Example
//
//  Created by Wang,Suyan on 2020/10/4.
//  Copyright © 2020 wsy. All rights reserved.
//

#import "SYNetworkPlugin.h"
#import <Foundation/Foundation.h>

@implementation SYNetworkPlugin

- (void)request:(SYBridgeMessage *)msg callback:(SYPluginMessageCallBack)callback {
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSString *url = msg.paramDict[@"url"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error && data) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                callback(@{
                    kSYCallbackType: kSYCallbackSuccess,
                    @"data": dict ?: @{}
                }, msg);
            }
            else {
                callback(@{
                    kSYCallbackType: kSYCallbackFail
                }, msg);
            }
        });
    }];
    [task resume];
}

@end
