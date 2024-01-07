//
//  ConstantValues.h
//  pocketCalc
//
//  Created by Albert Tran on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

// Turn on debug mode
#define DEBUG_MODE_ENABLE FALSE //   TRUE/FALSE
#define RUN_ON_SIM_ONLY FALSE //FALSE    // this is used for storing data onto plist file

// This keys are used for TipInfo.plist
#define TIP_PERCENTAGE_KEY @"tip_percentage"
#define HEADS_COUNT_KEY @"heads_count"

// Title Label
#define TIP_TITLE @"Tip Calc"
#define TAX_TITLE @"Shop Calc"
#define IOU_TITLE @"IOU"
#define USER_PROFILE_TITLE @"Profile"
#define BASIC_CALC_TITLE @"Calculator"
#define UNIT_CONV_TITLE @"Unit Converter"
#define DEAL_FEEDBACK_TITLE @"Deal Feedback"
#define RESTAURANT_FEEDBACK_TITLE @"Restaurant Rating"
#define ABOUT_POCKET_CALC_TITLE @"About"

#define PLIST_FILENAME @"UserRecords"
#define RECEIPT_RECORD_PLIST_FILENAME @"ReceiptRecords"

// Deal Feedback Dictionary Key Label
#define NAME_KEY @"name"
#define PURCHASED_DATE_KEY @"date"
#define PURCHASED_ITEM_KEY @"purchasedItem"
#define ITEM_PRICE_KEY @"price"
#define ITEM_DISCOUNT_RATE_KEY @"discountRate"
#define RATING_KEY @"rating"
#define STORE_NAME_KEY @"storeName"
#define STORE_LOCATION_KEY @"storeLocation"
#define EMAIL_MSG_KEY @"EmailMsg"

// Shopping Item Dictionary Key Label
#define ITEM_SAVINGS_KEY @"savings"
#define ITEM_COUPONS_AMOUNT_KEY @"couponAmount"
#define ITEM_DISCOUNT_AMOUNT_KEY @"discountAmount"
#define ITEM_TOTAL_AFTER_TAX_KEY @"totalAfterTax"
#define ITEM_SALE_TAX_PERCENT_KEY @"taxPercent"
#define ITEM_SALE_TAX_AMOUNT_KEY @"taxAmount"

// Restaurant Feedback Dictionary Key Label
#define RESTAURANT_NAME_KEY @"restaurantName"
#define RESTAURANT_LOCATION_KEY @"restaurantLocation"
#define FOOD_RATE_KEY @"foodRate"
#define SERVICE_RATE_KEY @"serviceRate"
#define ENV_RATE_KEY @"atmosphereRate"
#define PRICE_RATE_KEY @"priceRate"
#define RECOMMENDATIONS_KEY @"recommendations"

#define RATING_STARS_LABEL @"☆_☆☆_☆☆☆_☆☆☆☆_☆☆☆☆☆"

// IOU Info Dictionary Key label
#define BORROWER_NAME_KEY @"borrowerName"
#define BORROWER_PHONE_KEY @"borrowPhone"
#define LENDER_NAME_KEY @"lenderName"
#define LENDER_AMOUNT_KEY @"lenderAmount"
#define DUE_DATE_KEY @"dueDate"

// Default SALE TAX
#define DEFAULT_SALE_TAX_KEY @"defaultSaleTax"

// ID for each Records
#define DEAL_TAG @"Deal Feedback"
#define RESTAURANT_TAG @"Restaurant Feedback"
#define IOU_TAG @"IOU"
#define DEFAULT_SALE_TAX_TAG @"Tax"
#define SHOPPING_RECEIPT_TAG @"Shopping Receipt"
#define STORE_INFO_TAG @"storeInfo"
#define PURCHASE_ITEM_DETAIL_TAG @"itemDetail"

#define TOTAL_NUM_TABLE_SECTIONS 4

// Unit Converter
#define SELECT_OPTION_TITLE @"Select"
#define FROM_OPTION_TITLE @"From"
#define TO_OPTION_TITLE @"To"
#define TOTAL_NUM_PICKERVIEW_COMPONENTS 3
#define LENGTH_CONVERSION_TITLE @"Length"
#define MASS_CONVERSION_TITLE @"Mass"
#define TEMPERATURE_CONVERSION_TITLE @"Temp"
#define PRESSURE_CONVERSION_TITLE @"Pressure"
#define AREA_CONVERSION_TITLE @"Area"
#define VOLUMN_CONVERSION_TITLE @"Volumn"
#define COOKING_CONVERSION_TITLE @"Cooking"

#define ARROW_SYMBOL_LABEL @"-->"

#define HISTORY_BACKGROUND_IMG @"newBG.png" //@"backgroundHistoryView.png"
#define ABOUT_BACKGROUND_IMG @"bgAboutView.png"
#define PROFILE_BACKGROUND_IMG @"backgroundTable.png"


#define DEVELOPER_EMAIL_ADDRESS @"ezfunapps@gmail.com"

#define ABOUT_EMAIL_SUBJECT @"Money Calculator + Feedback!"
#define IOU_EMAIL_SUBJECT @"IOU Information!"
#define RESTAURANT_EMAIL_SUBJECT @"Restaurant Rating!"
#define DEAL_EMAIL_SUBJECT @"Got A Deal!"
#define SHOPPING_RECEIPT_SUBJECT @"Shopping Receipt"

#define DISPLAY_DATE_FORMAT @"EEEE (MMMM dd, yyyy)"

#define DOCSFOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

#define DISPLAY_ITEM_DIVIDER_LINE @"---------------------------"
#define DISPLAY_RECEIPT_SUMMARY_LINE @"------ Summary -------"

enum MediaOptionsList {
    CHOOSE_PHOTO_OPTION = 1,
    TAKE_PHOTO_OPTION = 2,
    CHOOSE_VIDEO_OPTION = 2,
    TAKE_VIDEO_OPTION = 3,
    CHOOSE_AUDIO_OPTION = 4,
    TAKE_AUDIO_OPTION = 0,
    TOTAL_NUM_MEDIA_OPTION_CNT = 6
};

enum UserProfileRecord {
    IOU_RECORDS_PROFILE = 0,
    DEAL_RECORDS_PROFILE = 1,
    RESTAURANT_RECORDS_PROFILE = 2,
    SHOPPING_RECEIPT_RECORDS_PROFILE = 3,
    TOTAL_NUM_USER_PROFILE_RECORD_CNT = 4
};









