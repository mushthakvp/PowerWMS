import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_nl.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('nl')
  ];

  /// No description provided for @internet_disconnected.
  ///
  /// In en, this message translates to:
  /// **'There is no Internet connection.'**
  String get internet_disconnected;

  /// No description provided for @load_picklist_error.
  ///
  /// In en, this message translates to:
  /// **'The pick list could not be loaded. Check your internet connection. If the error persists, please contact support.'**
  String get load_picklist_error;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @barcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get barcode;

  /// No description provided for @barcodeHelp.
  ///
  /// In en, this message translates to:
  /// **'Scan a barcode to search for a product.'**
  String get barcodeHelp;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @loginSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginSignIn;

  /// No description provided for @loginUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get loginUsernameLabel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @picklistsOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get picklistsOpen;

  /// No description provided for @picklistsRevise.
  ///
  /// In en, this message translates to:
  /// **'Revise'**
  String get picklistsRevise;

  /// No description provided for @picklistsSearch.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get picklistsSearch;

  /// No description provided for @productAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get productAdd;

  /// No description provided for @productAlreadyScanned.
  ///
  /// In en, this message translates to:
  /// **'Item is already scanned'**
  String get productAlreadyScanned;

  /// No description provided for @productAmountAsked.
  ///
  /// In en, this message translates to:
  /// **'Amount asked ({unit})'**
  String productAmountAsked(String unit);

  /// No description provided for @productAmountBoxes.
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{{count} box} other{{count} boxes}}'**
  String productAmountBoxes(num count);

  /// No description provided for @productAmountPicked.
  ///
  /// In en, this message translates to:
  /// **'Amount picked ({unit})'**
  String productAmountPicked(String unit);

  /// No description provided for @productAmountToPick.
  ///
  /// In en, this message translates to:
  /// **'Amount to pick ({unit})'**
  String productAmountToPick(String unit);

  /// No description provided for @productAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get productAvailable;

  /// No description provided for @productConfirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item?'**
  String get productConfirmDelete;

  /// No description provided for @productCancelRestAmount.
  ///
  /// In en, this message translates to:
  /// **'Cancel rest amount'**
  String get productCancelRestAmount;

  /// No description provided for @productConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get productConfirm;

  /// No description provided for @productDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get productDelete;

  /// No description provided for @productNotFound.
  ///
  /// In en, this message translates to:
  /// **'Product is not found'**
  String get productNotFound;

  /// No description provided for @productOrderline.
  ///
  /// In en, this message translates to:
  /// **'Order line'**
  String get productOrderline;

  /// No description provided for @productProcess.
  ///
  /// In en, this message translates to:
  /// **'Process'**
  String get productProcess;

  /// No description provided for @productProductNumber.
  ///
  /// In en, this message translates to:
  /// **'Product number'**
  String get productProductNumber;

  /// No description provided for @productScanBarcode.
  ///
  /// In en, this message translates to:
  /// **'Scan barcode'**
  String get productScanBarcode;

  /// No description provided for @productToPick.
  ///
  /// In en, this message translates to:
  /// **'To pick'**
  String get productToPick;

  /// No description provided for @productTradeUnitAmount.
  ///
  /// In en, this message translates to:
  /// **'Trade unit amount'**
  String get productTradeUnitAmount;

  /// No description provided for @productWantToProcess.
  ///
  /// In en, this message translates to:
  /// **'Do you want to process the scans?'**
  String get productWantToProcess;

  /// No description provided for @productWarehouseLocation.
  ///
  /// In en, this message translates to:
  /// **'Warehouse location'**
  String get productWarehouseLocation;

  /// No description provided for @productWarehouseStock.
  ///
  /// In en, this message translates to:
  /// **'Warehouse stock'**
  String get productWarehouseStock;

  /// No description provided for @productWrongProduct.
  ///
  /// In en, this message translates to:
  /// **'Wrong product scanned'**
  String get productWrongProduct;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @settingsDirectlyProcess.
  ///
  /// In en, this message translates to:
  /// **'Directly process'**
  String get settingsDirectlyProcess;

  /// No description provided for @warehouseReceipts.
  ///
  /// In en, this message translates to:
  /// **'Picklists'**
  String get warehouseReceipts;

  /// No description provided for @dateNotCorrect.
  ///
  /// In en, this message translates to:
  /// **'Date not correct'**
  String get dateNotCorrect;

  /// No description provided for @productWillBeCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get productWillBeCancel;

  /// No description provided for @productWillBeBackorder.
  ///
  /// In en, this message translates to:
  /// **'Backorder'**
  String get productWillBeBackorder;

  /// No description provided for @productCannotScan.
  ///
  /// In en, this message translates to:
  /// **'Scanning is no longer permitted with this product.'**
  String get productCannotScan;

  /// No description provided for @otherWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Change your warehouse to: {unit}'**
  String otherWarehouse(String unit);

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @productScreenSearch.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get productScreenSearch;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @defaultWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Default warehouse'**
  String get defaultWarehouse;

  /// No description provided for @sortPicklistlinesOn.
  ///
  /// In en, this message translates to:
  /// **'Sort picklistlines on:'**
  String get sortPicklistlinesOn;

  /// No description provided for @warehouseLocation.
  ///
  /// In en, this message translates to:
  /// **'Warehouse location'**
  String get warehouseLocation;

  /// No description provided for @productNumber.
  ///
  /// In en, this message translates to:
  /// **'Product number'**
  String get productNumber;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @oneScanPicksAll.
  ///
  /// In en, this message translates to:
  /// **'One scan picks all'**
  String get oneScanPicksAll;

  /// No description provided for @directMutation.
  ///
  /// In en, this message translates to:
  /// **'Direct mutation'**
  String get directMutation;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get processing;

  /// No description provided for @reference.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get reference;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @statusDescending.
  ///
  /// In en, this message translates to:
  /// **'statusDescending'**
  String get statusDescending;

  /// No description provided for @serial_numbers.
  ///
  /// In en, this message translates to:
  /// **'Serial Numbers'**
  String get serial_numbers;

  /// No description provided for @statusDiscontinued.
  ///
  /// In en, this message translates to:
  /// **'statusDiscontinued'**
  String get statusDiscontinued;

  /// No description provided for @add_serial_numbers.
  ///
  /// In en, this message translates to:
  /// **'Add serial numbers'**
  String get add_serial_numbers;

  /// No description provided for @receiptLineNumber.
  ///
  /// In en, this message translates to:
  /// **'Receipt line number'**
  String get receiptLineNumber;

  /// No description provided for @receiptCode.
  ///
  /// In en, this message translates to:
  /// **'Receipt code'**
  String get receiptCode;

  /// No description provided for @total_scanned_serial_numbers.
  ///
  /// In en, this message translates to:
  /// **'Total Scanned Serial Numbers'**
  String get total_scanned_serial_numbers;

  /// No description provided for @whole_sale_data.
  ///
  /// In en, this message translates to:
  /// **'Wholesale data'**
  String get whole_sale_data;

  /// No description provided for @count.
  ///
  /// In en, this message translates to:
  /// **'Count'**
  String get count;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @invalid_credentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials'**
  String get invalid_credentials;

  /// No description provided for @cannotProcessed.
  ///
  /// In en, this message translates to:
  /// **'Completing picklist not allowed. Still unprocessed mutations.'**
  String get cannotProcessed;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'nl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'nl': return AppLocalizationsNl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
