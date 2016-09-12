//
//  ORAMessageViewCell.m
//  OraComm
//
//  Created by trent.harvey on 9/12/16.
//  Copyright © 2016 Ora Interactive. All rights reserved.
//

#import "ORAMessageViewCell.h"

#import "ORAMessage.h"
#import "ORAUser.h"

@interface ORAMessageViewCell ()
{
    
    IBOutlet UILabel *messageBody;
    IBOutlet UILabel *messageSenderLabel;
    IBOutlet UILabel *messageSentTimeLabel;
    
}

@end

@implementation ORAMessageViewCell

static NSDateFormatter *df;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setMessage:(ORAMessage *)message
{
    //Set Message
    _message = message;
    
    NSLog(@"Setting Message for Cell");
    
    //Set Message Body Text
    messageBody.text = message.message;
    
}

@end
