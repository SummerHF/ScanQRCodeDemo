//
//  SoundManager.m
//  loveOil
//
//  Created by macbookair on 9/3/16.
//  Copyright © 2016 macbookair. All rights reserved.
//

#import "SoundManager.h"

@implementation SoundManager

+(void)playSystemSound
{
    SystemSoundID soundID = 1007;
    
    AudioServicesPlaySystemSound(soundID);
}

@end
