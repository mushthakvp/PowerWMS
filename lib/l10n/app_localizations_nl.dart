import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get internet_disconnected => 'Er is geen internetverbinding.';

  @override
  String get load_picklist_error => 'De picklist kon niet worden geladen. Controleer uw internetverbinding. Als de error zich blijft voordoen neem contact op met support.';

  @override
  String get back => 'Terug';

  @override
  String get close => 'Sluiten';

  @override
  String get save => 'Opslaan';

  @override
  String get barcode => 'Barcode';

  @override
  String get barcodeHelp => 'Scan a barcode to search for a product.';

  @override
  String get cancel => 'Cancel';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get error => 'Fout';

  @override
  String get loginPasswordLabel => 'Wachtwoord';

  @override
  String get loginSignIn => 'Inloggen';

  @override
  String get loginUsernameLabel => 'Gebruikersnaam';

  @override
  String get ok => 'OK';

  @override
  String get picklistsOpen => 'Onderhanden';

  @override
  String get picklistsRevise => 'Controleren';

  @override
  String get picklistsSearch => 'Zoeken...';

  @override
  String get productAdd => 'Toevoegen';

  @override
  String get productAlreadyScanned => 'Dit item is reeds gescand';

  @override
  String productAmountAsked(String unit) {
    return 'Gevraagd ($unit)';
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
    return 'Gepickt ($unit)';
  }

  @override
  String productAmountToPick(String unit) {
    return 'Te picken ($unit)';
  }

  @override
  String get productAvailable => 'Beschikbaar';

  @override
  String get productConfirmDelete => 'Weet je zeker dat je dit item wilt verwijderen?';

  @override
  String get productCancelRestAmount => 'Restbedrag annuleren';

  @override
  String get productConfirm => 'Bevestigen';

  @override
  String get productDelete => 'Verwijderen';

  @override
  String get productNotFound => 'Product niet gevonden';

  @override
  String get productOrderline => 'Orderregel';

  @override
  String get productProcess => 'Verwerken';

  @override
  String get productProductNumber => 'Productnummer';

  @override
  String get productScanBarcode => 'Scan barcode';

  @override
  String get productToPick => 'Te picken';

  @override
  String get productTradeUnitAmount => 'Logistieke eenheid';

  @override
  String get productWantToProcess => 'Wilt u de mutaties verwerken?';

  @override
  String get productWarehouseLocation => 'Magazijn locatie';

  @override
  String get productWarehouseStock => 'Magazijn voorraad';

  @override
  String get productWrongProduct => 'Verkeerd product gescand';

  @override
  String get products => 'Producten';

  @override
  String get settingsDirectlyProcess => 'Direct verwerken';

  @override
  String get warehouseReceipts => 'Magazijnbonnen';

  @override
  String get dateNotCorrect => 'Datum niet correct';

  @override
  String get productWillBeCancel => 'Geannuleerd';

  @override
  String get productWillBeBackorder => 'Naleveren';

  @override
  String get productCannotScan => 'Scannen is met dit product niet meer toegestaan.';

  @override
  String otherWarehouse(String unit) {
    return 'Verander uw magazijn naar: $unit';
  }

  @override
  String get complete => 'Afronden';

  @override
  String get productScreenSearch => 'Zoeken...';

  @override
  String get settings => 'Instellingen';

  @override
  String get defaultWarehouse => 'Standaard magazijn';

  @override
  String get sortPicklistlinesOn => 'Sorteren magazijnbonregels op:';

  @override
  String get warehouseLocation => 'Magazijnlocatie';

  @override
  String get productNumber => 'Product nummer';

  @override
  String get description => 'Product omschrijving';

  @override
  String get oneScanPicksAll => 'Eén scan pakt alles';

  @override
  String get directMutation => 'Directe mutatie';

  @override
  String get processing => 'Verwerken';

  @override
  String get reference => 'Reference';

  @override
  String get note => 'Notitie';

  @override
  String get unavailable => 'Niet beschikbaar';

  @override
  String get statusDescending => 'Aflopend';

  @override
  String get serial_numbers => 'Serienummers';

  @override
  String get statusDiscontinued => 'Niet meer leverbaar';

  @override
  String get add_serial_numbers => 'Serienummers toevoegen';

  @override
  String get receiptLineNumber => 'Regelnummer';

  @override
  String get receiptCode => 'Ontvangtsnummer';

  @override
  String get total_scanned_serial_numbers => 'Totaal gescande serienummers';

  @override
  String get whole_sale_data => 'Wholesale gegevens';

  @override
  String get count => 'Tellen';

  @override
  String get status => 'Staat';

  @override
  String get invalid_credentials => 'Gebruikersnaam of wachtwoord onjuist';

  @override
  String get cannotProcessed => 'Afronden niet toegestaan. Nog onverwerkte mutaties.';
}
