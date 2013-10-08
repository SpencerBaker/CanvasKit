//
//  CKCourse.m
//  CanvasKit
//
//  Created by rroberts on 9/10/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import "CKCourse.h"
#import "NSValueTransformer+CKPredefinedTransformerAdditions.h"
#import "NSDictionary+DictionaryByAddingObjectsFromDictionary.h"

@implementation CKCourse

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyPaths = @{
        @"sisCourseId": @"sis_course_id",
        @"name": @"name",
        @"courseCode": @"course_code",
        @"workflowState": @"workflow_state",
        @"accountId": @"account_id",
        @"startAt": @"start_at",
        @"endAt": @"end_at",
        @"enrollments": @"enrollments",
        @"calendar": @"calendar.ics",
        @"defaultView": @"default_view",
        @"syllabusBody": @"syllabus_body",
        @"term": @"term",
        @"applyAssignmentGroupWeights": @"apply_assignment_group_weights",
        @"publicSyllabus" : @"public_syllabus"
    };
    NSDictionary *superPaths = [super JSONKeyPathsByPropertyKey];
    return [superPaths dictionaryByAddingObjectsFromDictionary:keyPaths];
}

+ (NSValueTransformer *)calendarJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)startAtJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:CKDateTransformerName];
}

+ (NSValueTransformer *)endAtJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:CKDateTransformerName];
}

- (NSString *)path
{
    return [[self.context.path stringByAppendingPathComponent:@"courses"] stringByAppendingPathComponent:self.id];
}

@end
