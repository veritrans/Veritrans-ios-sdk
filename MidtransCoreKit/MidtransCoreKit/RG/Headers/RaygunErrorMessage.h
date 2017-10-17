//
//  RaygunErrorMessage.h
//  Raygun4iOS
//
//  Created by Mitchell Duncan on 11/09/17.
//  Copyright © 2017 Mindscape. All rights reserved.
//

#ifndef RaygunErrorMessage_h
#define RaygunErrorMessage_h

@interface RaygunErrorMessage : NSObject

@property (nonatomic, readwrite, copy) NSString *className;
@property (nonatomic, readwrite, copy) NSString *message;
@property (nonatomic, readwrite, copy) NSString *signalName;
@property (nonatomic, readwrite, copy) NSString *signalCode;
@property (nonatomic, readwrite, retain) NSArray *stackTrace;

-(id) init:(NSString *)className withMessage:(NSString *)message
                              withSignalName:(NSString *)signalName
                              withSignalCode:(NSString *)signalCode
                              withStackTrace:(NSArray *)stacktrace;

/**
 Creates and returns a dictionary with the classes properties and their values.
 Used when constructing the crash report that is sent to Raygun.
 
 @return a new Dictionary with the classes properties and their values.
 */
-(NSDictionary *)convertToDictionary;

@end

#endif /* RaygunErrorMessage_h */
