//
//  UIViewController+ScrollToSection.h
//  Clipboard
//
//  Created by Tono MacMini on 7/28/14.
//  Copyright (c) 2014 Agavelab. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    WPTSectionPersonalInformation,
    WPTSectionEmergencyContact,
    WPTSectionPrimaryPhysician,
    WPTSectionHowDidYouHear,
    WPTSectionConditionResulted,
    WPTSectionAttorney,
    WPTSectionGuarantor,
    WPTSectionPrimaryInsurance,
    WPTSectionSecondaryInsurance,
    WPTSectionWorkerCompany,
    WPTSectionSelfPayment,
    WPTSectionMedicalHistory,
    WPTSectionRecentSymptoms,
    WPTSectionPreviousDiagnoses,
    WPTSectionMentalHealth,
    WPTSectionMedications,
    WPTSectionPreviousSurgeries,
    WPTSectionSymptomInformation,
    WPTSectionPriorTreatment,
    WPTSectionAreasAffected,
    WPTSectionNatureOfSymptoms,
    WPTSectionPainScale
} WPTFormSection;


@interface UITableViewController (ScrollToSection)

- (void)scrollToSection:(WPTFormSection)section;
- (BOOL)isComplete;

@end
