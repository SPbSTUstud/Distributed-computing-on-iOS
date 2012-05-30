//
//  Communicator.h
//  DistributedComputing
//
//  Created by Tatiana Petrova on 28.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SolverDelegate.h"

@interface Communicator : NSObject <NSXMLParserDelegate, SolverDelegate>

// Constants (просто огонь!!!11адинад)
FOUNDATION_EXPORT NSString *const urlTemplate;

FOUNDATION_EXPORT NSString *const userIdKey;
FOUNDATION_EXPORT NSString *const actionRegister;
FOUNDATION_EXPORT NSString *const actionGetData;
FOUNDATION_EXPORT NSString *const actionPutData;

FOUNDATION_EXPORT NSString *const xmlRegisterRequest;
FOUNDATION_EXPORT NSString *const xmlGetDataRequest;
FOUNDATION_EXPORT NSString *const xmlPutDataRequest;

// Methods
- (void)goWithAddress:(NSString *)address andOutputIn:(UITextView *)textView;
- (void)stop;

@end
