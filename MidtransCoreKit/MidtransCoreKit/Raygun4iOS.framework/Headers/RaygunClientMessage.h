//
//  RaygunClientMessage.h
//  Raygun4iOS
//
//  Created by Mitchell Duncan on 11/09/17.
//  Copyright © 2017 Mindscape. All rights reserved.
//

#ifndef RaygunClientMessage_h
#define RaygunClientMessage_h

@interface RaygunClientMessage : NSObject

@property (nonatomic, readwrite, copy) NSString *name;
@property (nonatomic, readwrite, copy) NSString *version;
@property (nonatomic, readwrite, copy) NSString *clientUrl;

- (id)init:(NSString *)name withVersion:(NSString *)version withUrl:(NSString *)url;

/**
 Creates and returns a dictionary with the classes properties and their values.
 Used when constructing the crash report that is sent to Raygun.
 
 @return a new Dictionary with the classes properties and their values.
 */
-(NSDictionary *)convertToDictionary;

@end

#endif /* RaygunClientMessage_h */
