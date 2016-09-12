//
//  ORAMessageViewCell.h
//  OraComm
//
//  Created by trent.harvey on 9/12/16.
//  Copyright © 2016 Ora Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ORAMessage;

@interface ORAMessageViewCell : UITableViewCell

@property (nonatomic, retain) ORAMessage *message;

@end
