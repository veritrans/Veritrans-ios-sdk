//
//  RaygunMessage.h
//  Raygun4iOS
//
//  Created by Mitchell Duncan on 11/09/17.
//  Copyright © 2017 Mindscape. All rights reserved.
//

#ifndef RaygunMessage_h
#define RaygunMessage_h

#import "RaygunMessageDetails.h"

@interface RaygunMessage : NSObject

@property (nonatomic, readwrite, copy) NSString *occurredOn;
@property (nonatomic, readwrite, retain) RaygunMessageDetails *details;

- (id)init:(NSString *)occurredOn withDetails:(RaygunMessageDetails *)details;

/**
 Creates and returns the json payload to be sent to Raygun.
 
 @return a data object containing the RaygunMessage properties in a json format.
 */
- (NSData *)convertToJson;

@end

#endif /* RaygunMessage_h */
