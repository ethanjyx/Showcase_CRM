#import "PickerHelper.h"

@implementation PickerHelper

+ (NSString *)formatDate:(NSDate *)d
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"MM'/'dd'/'yyyy"];
    NSString *formattedDate = [dateFormatter stringFromDate:d];
    return formattedDate;
}

@end