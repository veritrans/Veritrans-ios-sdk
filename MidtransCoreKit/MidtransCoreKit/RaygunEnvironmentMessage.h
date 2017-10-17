//
//  RaygunEnvironmentMessage.h
//  Raygun4iOS
//
//  Created by Mitchell Duncan on 11/09/17.
//  Copyright © 2017 Mindscape. All rights reserved.
//

#ifndef RaygunEnvironmentMessage_h
#define RaygunEnvironmentMessage_h

@interface RaygunEnvironmentMessage : NSObject

@property (nonatomic, readwrite, copy) NSNumber *processorCount;
@property (nonatomic, readwrite, copy) NSString *oSVersion;
@property (nonatomic, readwrite, copy) NSString *model;
@property (nonatomic, readwrite, copy) NSNumber *windowsBoundWidth;
@property (nonatomic, readwrite, copy) NSNumber *windowsBoundHeight;
@property (nonatomic, readwrite, copy) NSNumber *resolutionScale;
@property (nonatomic, readwrite, copy) NSString *cpu;
@property (nonatomic, readwrite, copy) NSNumber *utcOffset;
@property (nonatomic, readwrite, copy) NSString *locale;

/**
 Creates and returns a dictionary with the classes properties and their values.
 Used when constructing the crash report that is sent to Raygun.
 
 @return a new Dictionary with the classes properties and their values.
 */
-(NSDictionary *)convertToDictionary;

@end

#endif /* RaygunEnvironmentMessage_h */
