import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get internet_disconnected => 'There is no Internet connection.';

  @override
  String get load_picklist_error => 'The pick list could not be loaded. Check your internet connection. If the error persists, please contact support.';

  @override
  String get back => 'Back';

  @override
  String get close => 'Close';

  @override
  String get save => 'Save';

  @override
  String get barcode => 'Barcode';

  @override
  String get barcodeHelp => 'Scan a barcode to search for a product.';

  @override
  String get cancel => 'Cancel';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get error => 'Error';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginSignIn => 'Sign In';

  @override
  String get loginUsernameLabel => 'Username';

  @override
  String get ok => 'OK';

  @override
  String get picklistsOpen => 'Open';

  @override
  String get picklistsRevise => 'Revise';

  @override
  String get picklistsSearch => 'Search...';

  @override
  String get productAdd => 'Add';

  @override
  String get productAlreadyScanned => 'Item is already scanned';

  @override
  String productAmountAsked(String unit) {
    return 'Amount asked ($unit)';
  }

  @override
  String productAmountBoxes(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString boxes',
      one: '$countString box',
    );
    return '$_temp0';
  }

  @override
  String productAmountPicked(String unit) {
    return 'Amount picked ($unit)';
  }

  @override
  String productAmountToPick(String unit) {
    return 'Amount to pick ($unit)';
  }

  @override
  String get productAvailable => 'Available';

  @override
  String get productConfirmDelete => 'Are you sure you want to delete this item?';

  @override
  String get productCancelRestAmount => 'Cancel rest amount';

  @override
  String get productConfirm => 'Confirm';

  @override
  String get productDelete => 'Delete';

  @override
  String get productNotFound => 'Product is not found';

  @override
  String get productOrderline => 'Order line';

  @override
  String get productProcess => 'Process';

  @override
  String get productProductNumber => 'Product number';

  @override
  String get productScanBarcode => 'Scan barcode';

  @override
  String get productToPick => 'To pick';

  @override
  String get productTradeUnitAmount => 'Trade unit amount';

  @override
  String get productWantToProcess => 'Do you want to process the scans?';

  @override
  String get productWarehouseLocation => 'Warehouse location';

  @override
  String get productWarehouseStock => 'Warehouse stock';

  @override
  String get productWrongProduct => 'Wrong product scanned';

  @override
  String get products => 'Products';

  @override
  String get settingsDirectlyProcess => 'Directly process';

  @override
  String get warehouseReceipts => 'Picklists';

  @override
  String get dateNotCorrect => 'Date not correct';

  @override
  String get productWillBeCancel => 'Cancelled';

  @override
  String get productWillBeBackorder => 'Backorder';

  @override
  String get productCannotScan => 'Scanning is no longer permitted with this product.';

  @override
  String otherWarehouse(String unit) {
    return 'Change your warehouse to: $unit';
  }

  @override
  String get complete => 'Complete';

  @override
  String get productScreenSearch => 'Search...';

  @override
  String get settings => 'Settings';

  @override
  String get defaultWarehouse => 'Default warehouse';

  @override
  String get sortPicklistlinesOn => 'Sort picklistlines on:';

  @override
  String get warehouseLocation => 'Warehouse location';

  @override
  String get productNumber => 'Product number';

  @override
  String get description => 'Description';

  @override
  String get oneScanPicksAll => 'One scan picks all';

  @override
  String get directMutation => 'Direct mutation';

  @override
  String get processing => 'Processing';

  @override
  String get reference => 'Reference';

  @override
  String get note => 'Note';

  @override
  String get unavailable => 'Unavailable';

  @override
  String get statusDescending => 'statusDescending';

  @override
  String get statusDiscontinued => 'statusDiscontinued';

  @override
  String get count => 'Count';

  @override
  String get status => 'Status';

  @override
  String get cannotProcessed => 'Completing picklist not allowed. Still unprocessed mutations.';
}
