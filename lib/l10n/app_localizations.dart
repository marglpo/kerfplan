import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('pl'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('ru'),
    Locale('tr'),
    Locale('uk'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'KerfPlan'**
  String get appName;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'KerfPlan'**
  String get homeTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @newCutList.
  ///
  /// In en, this message translates to:
  /// **'New Cut List'**
  String get newCutList;

  /// No description provided for @noProjectsTitle.
  ///
  /// In en, this message translates to:
  /// **'No cut lists yet'**
  String get noProjectsTitle;

  /// No description provided for @noProjectsMessage.
  ///
  /// In en, this message translates to:
  /// **'Plan your first job in under a minute.'**
  String get noProjectsMessage;

  /// No description provided for @appVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'App version'**
  String get appVersionLabel;

  /// No description provided for @defaultUnits.
  ///
  /// In en, this message translates to:
  /// **'Default units'**
  String get defaultUnits;

  /// No description provided for @defaultKerf.
  ///
  /// In en, this message translates to:
  /// **'Default kerf'**
  String get defaultKerf;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @newProjectTitle.
  ///
  /// In en, this message translates to:
  /// **'New cut list'**
  String get newProjectTitle;

  /// No description provided for @projectNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Project name'**
  String get projectNameLabel;

  /// No description provided for @projectNameHint.
  ///
  /// In en, this message translates to:
  /// **'Garage frame'**
  String get projectNameHint;

  /// No description provided for @materialLabel.
  ///
  /// In en, this message translates to:
  /// **'Material'**
  String get materialLabel;

  /// No description provided for @materialHint.
  ///
  /// In en, this message translates to:
  /// **'40x20 steel'**
  String get materialHint;

  /// No description provided for @noteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get noteLabel;

  /// No description provided for @noteHint.
  ///
  /// In en, this message translates to:
  /// **'South wall'**
  String get noteHint;

  /// No description provided for @createCutList.
  ///
  /// In en, this message translates to:
  /// **'Create Cut List'**
  String get createCutList;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @editDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit details'**
  String get editDetails;

  /// No description provided for @duplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get duplicate;

  /// Suffix for automatically generated duplicate project names.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copyLabel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteProjectTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete cut list?'**
  String get deleteProjectTitle;

  /// No description provided for @deleteProjectMessage.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes \"{projectName}\" from this device.'**
  String deleteProjectMessage(String projectName);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @projectDeleted.
  ///
  /// In en, this message translates to:
  /// **'Cut list deleted'**
  String get projectDeleted;

  /// No description provided for @projectActions.
  ///
  /// In en, this message translates to:
  /// **'Actions for {projectName}'**
  String projectActions(String projectName);

  /// No description provided for @updatedLabel.
  ///
  /// In en, this message translates to:
  /// **'Updated {date}'**
  String updatedLabel(String date);

  /// No description provided for @stockSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stockSectionTitle;

  /// No description provided for @noStockYet.
  ///
  /// In en, this message translates to:
  /// **'No stock lengths added yet.'**
  String get noStockYet;

  /// No description provided for @partsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Parts'**
  String get partsSectionTitle;

  /// No description provided for @noPartsYet.
  ///
  /// In en, this message translates to:
  /// **'No parts added yet.'**
  String get noPartsYet;

  /// No description provided for @cutSettingsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Cut settings'**
  String get cutSettingsSectionTitle;

  /// No description provided for @calculate.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get calculate;

  /// No description provided for @calculateDisabledHint.
  ///
  /// In en, this message translates to:
  /// **'Add parts to calculate a cut plan.'**
  String get calculateDisabledHint;

  /// No description provided for @projectNotFound.
  ///
  /// In en, this message translates to:
  /// **'Cut list not found'**
  String get projectNotFound;

  /// No description provided for @backToProjects.
  ///
  /// In en, this message translates to:
  /// **'Back to projects'**
  String get backToProjects;

  /// No description provided for @projectNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a project name.'**
  String get projectNameRequired;

  /// No description provided for @projectNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Project name must be 80 characters or fewer.'**
  String get projectNameTooLong;

  /// No description provided for @materialTooLong.
  ///
  /// In en, this message translates to:
  /// **'Material must be 120 characters or fewer.'**
  String get materialTooLong;

  /// No description provided for @noteTooLong.
  ///
  /// In en, this message translates to:
  /// **'Note must be 500 characters or fewer.'**
  String get noteTooLong;

  /// No description provided for @projectSaveError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t save the cut list. Try again.'**
  String get projectSaveError;

  /// No description provided for @projectDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t delete the cut list. Try again.'**
  String get projectDeleteError;

  /// No description provided for @projectDuplicateError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t duplicate the cut list. Try again.'**
  String get projectDuplicateError;

  /// No description provided for @projectsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t load your cut lists.'**
  String get projectsLoadError;

  /// No description provided for @projectLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t load this cut list.'**
  String get projectLoadError;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @fixedInventory.
  ///
  /// In en, this message translates to:
  /// **'Fixed inventory'**
  String get fixedInventory;

  /// No description provided for @buyStock.
  ///
  /// In en, this message translates to:
  /// **'Buy stock'**
  String get buyStock;

  /// No description provided for @addStockLength.
  ///
  /// In en, this message translates to:
  /// **'Add stock length'**
  String get addStockLength;

  /// No description provided for @editStockLength.
  ///
  /// In en, this message translates to:
  /// **'Edit stock length'**
  String get editStockLength;

  /// No description provided for @stockLength.
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get stockLength;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @labelOptional.
  ///
  /// In en, this message translates to:
  /// **'Label (optional)'**
  String get labelOptional;

  /// No description provided for @stockLengthHint.
  ///
  /// In en, this message translates to:
  /// **'6000'**
  String get stockLengthHint;

  /// No description provided for @stockLengthCmHint.
  ///
  /// In en, this message translates to:
  /// **'244'**
  String get stockLengthCmHint;

  /// No description provided for @stockLengthMHint.
  ///
  /// In en, this message translates to:
  /// **'2.4'**
  String get stockLengthMHint;

  /// No description provided for @stockLabelHint.
  ///
  /// In en, this message translates to:
  /// **'Warehouse'**
  String get stockLabelHint;

  /// No description provided for @quantityHint.
  ///
  /// In en, this message translates to:
  /// **'10'**
  String get quantityHint;

  /// No description provided for @stockLengthRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a length.'**
  String get stockLengthRequired;

  /// No description provided for @stockLengthInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a number greater than zero.'**
  String get stockLengthInvalid;

  /// No description provided for @stockLengthPrecision.
  ///
  /// In en, this message translates to:
  /// **'This value cannot be stored exactly. Use a length that is a multiple of 0.0001 mm.'**
  String get stockLengthPrecision;

  /// No description provided for @stockLengthTooLarge.
  ///
  /// In en, this message translates to:
  /// **'This length is too large.'**
  String get stockLengthTooLarge;

  /// No description provided for @quantityRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a quantity.'**
  String get quantityRequired;

  /// No description provided for @quantityInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a whole number from 1 to 9999.'**
  String get quantityInvalid;

  /// No description provided for @quantityTooLarge.
  ///
  /// In en, this message translates to:
  /// **'Quantity must be 9999 or fewer.'**
  String get quantityTooLarge;

  /// No description provided for @stockLabelTooLong.
  ///
  /// In en, this message translates to:
  /// **'Label must be 80 characters or fewer.'**
  String get stockLabelTooLong;

  /// No description provided for @saveStock.
  ///
  /// In en, this message translates to:
  /// **'Save stock length'**
  String get saveStock;

  /// No description provided for @stockSaveError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t save this stock length. Try again.'**
  String get stockSaveError;

  /// No description provided for @stockDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t delete this stock length. Try again.'**
  String get stockDeleteError;

  /// No description provided for @stockDuplicateError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t duplicate this stock length. Try again.'**
  String get stockDuplicateError;

  /// No description provided for @stockLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t load stock.'**
  String get stockLoadError;

  /// No description provided for @stockNotFound.
  ///
  /// In en, this message translates to:
  /// **'Stock length not found'**
  String get stockNotFound;

  /// No description provided for @deleteStockTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete stock length?'**
  String get deleteStockTitle;

  /// No description provided for @deleteStockMessage.
  ///
  /// In en, this message translates to:
  /// **'{length} × {quantity} will be removed from this cut list.'**
  String deleteStockMessage(String length, int quantity);

  /// No description provided for @stockDeleted.
  ///
  /// In en, this message translates to:
  /// **'Stock length deleted'**
  String get stockDeleted;

  /// No description provided for @duplicateStock.
  ///
  /// In en, this message translates to:
  /// **'Duplicate stock length'**
  String get duplicateStock;

  /// No description provided for @stockSummary.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 stock length} other{{count} stock lengths}}'**
  String stockSummary(int count);

  /// No description provided for @totalPieces.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 total piece} other{{count} total pieces}}'**
  String totalPieces(int count);

  /// No description provided for @setBuyStockLength.
  ///
  /// In en, this message translates to:
  /// **'Set stock length'**
  String get setBuyStockLength;

  /// No description provided for @buyStockHelper.
  ///
  /// In en, this message translates to:
  /// **'We’ll calculate how many pieces you need.'**
  String get buyStockHelper;

  /// No description provided for @buyStockLengthMissing.
  ///
  /// In en, this message translates to:
  /// **'Set the stock length you plan to buy.'**
  String get buyStockLengthMissing;

  /// No description provided for @stockModeSaveError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t change stock mode. Try again.'**
  String get stockModeSaveError;

  /// No description provided for @backToProject.
  ///
  /// In en, this message translates to:
  /// **'Back to cut list'**
  String get backToProject;

  /// No description provided for @decreaseQuantity.
  ///
  /// In en, this message translates to:
  /// **'Decrease quantity'**
  String get decreaseQuantity;

  /// No description provided for @increaseQuantity.
  ///
  /// In en, this message translates to:
  /// **'Increase quantity'**
  String get increaseQuantity;

  /// No description provided for @unitMm.
  ///
  /// In en, this message translates to:
  /// **'mm'**
  String get unitMm;

  /// No description provided for @unitCm.
  ///
  /// In en, this message translates to:
  /// **'cm'**
  String get unitCm;

  /// No description provided for @unitM.
  ///
  /// In en, this message translates to:
  /// **'m'**
  String get unitM;

  /// No description provided for @unitInch.
  ///
  /// In en, this message translates to:
  /// **'in'**
  String get unitInch;

  /// No description provided for @lengthWithUnit.
  ///
  /// In en, this message translates to:
  /// **'{value} {unit}'**
  String lengthWithUnit(String value, String unit);

  /// No description provided for @approximateLength.
  ///
  /// In en, this message translates to:
  /// **'≈ {value}'**
  String approximateLength(String value);

  /// No description provided for @stockQuantity.
  ///
  /// In en, this message translates to:
  /// **'× {quantity}'**
  String stockQuantity(int quantity);

  /// No description provided for @stockActions.
  ///
  /// In en, this message translates to:
  /// **'Actions for {length}'**
  String stockActions(String length);

  /// No description provided for @decimalInchesHelper.
  ///
  /// In en, this message translates to:
  /// **'Enter decimal inches.'**
  String get decimalInchesHelper;

  /// No description provided for @exactStoredLengthHelper.
  ///
  /// In en, this message translates to:
  /// **'Stored exactly: {value} mm. The inch display is approximate. The saved length stays exact unless you edit it.'**
  String exactStoredLengthHelper(String value);

  /// No description provided for @addPart.
  ///
  /// In en, this message translates to:
  /// **'Add part'**
  String get addPart;

  /// No description provided for @editPart.
  ///
  /// In en, this message translates to:
  /// **'Edit part'**
  String get editPart;

  /// No description provided for @partNameOptional.
  ///
  /// In en, this message translates to:
  /// **'Part name (optional)'**
  String get partNameOptional;

  /// No description provided for @partNameHint.
  ///
  /// In en, this message translates to:
  /// **'Upright'**
  String get partNameHint;

  /// No description provided for @partNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Part name must be 100 characters or fewer.'**
  String get partNameTooLong;

  /// No description provided for @partSaveError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t save this part. Try again.'**
  String get partSaveError;

  /// No description provided for @partDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t delete this part. Try again.'**
  String get partDeleteError;

  /// No description provided for @partDuplicateError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t duplicate this part. Try again.'**
  String get partDuplicateError;

  /// No description provided for @partLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t load parts.'**
  String get partLoadError;

  /// No description provided for @partNotFound.
  ///
  /// In en, this message translates to:
  /// **'Part not found'**
  String get partNotFound;

  /// No description provided for @deletePartTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete part?'**
  String get deletePartTitle;

  /// No description provided for @deletePartMessage.
  ///
  /// In en, this message translates to:
  /// **'{description} × {quantity} will be removed from this cut list.'**
  String deletePartMessage(String description, int quantity);

  /// No description provided for @partDeleted.
  ///
  /// In en, this message translates to:
  /// **'Part deleted'**
  String get partDeleted;

  /// No description provided for @duplicatePart.
  ///
  /// In en, this message translates to:
  /// **'Duplicate part'**
  String get duplicatePart;

  /// No description provided for @partSummary.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 part line} other{{count} part lines}}'**
  String partSummary(int count);

  /// No description provided for @feet.
  ///
  /// In en, this message translates to:
  /// **'Feet'**
  String get feet;

  /// No description provided for @inches.
  ///
  /// In en, this message translates to:
  /// **'Inches'**
  String get inches;

  /// No description provided for @wholeInches.
  ///
  /// In en, this message translates to:
  /// **'Whole inches'**
  String get wholeInches;

  /// No description provided for @fraction.
  ///
  /// In en, this message translates to:
  /// **'Fraction'**
  String get fraction;

  /// No description provided for @inchesRange.
  ///
  /// In en, this message translates to:
  /// **'Use 0 to 11 inches. Enter additional feet in the Feet field.'**
  String get inchesRange;

  /// No description provided for @imperialLengthInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter whole numbers of zero or more and a fraction, totaling more than zero.'**
  String get imperialLengthInvalid;

  /// No description provided for @partTooLongWarning.
  ///
  /// In en, this message translates to:
  /// **'This part is longer than your largest usable stock length ({length}).'**
  String partTooLongWarning(String length);

  /// No description provided for @addStockToContinue.
  ///
  /// In en, this message translates to:
  /// **'Add stock to continue.'**
  String get addStockToContinue;

  /// No description provided for @cutPlanUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Cut plan isn’t available yet.'**
  String get cutPlanUnavailable;

  /// No description provided for @namedPartLength.
  ///
  /// In en, this message translates to:
  /// **'{name} — {length}'**
  String namedPartLength(String name, String length);

  /// No description provided for @cutPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Cut plan'**
  String get cutPlanTitle;

  /// No description provided for @calculating.
  ///
  /// In en, this message translates to:
  /// **'Calculating…'**
  String get calculating;

  /// No description provided for @recalculate.
  ///
  /// In en, this message translates to:
  /// **'Recalculate'**
  String get recalculate;

  /// No description provided for @editCutList.
  ///
  /// In en, this message translates to:
  /// **'Edit cut list'**
  String get editCutList;

  /// No description provided for @stockPiecesUsed.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 stock piece used} other{{count} stock pieces used}}'**
  String stockPiecesUsed(int count);

  /// No description provided for @stockPiecesToBuy.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 stock piece to buy} other{{count} stock pieces to buy}}'**
  String stockPiecesToBuy(int count);

  /// No description provided for @buySummary.
  ///
  /// In en, this message translates to:
  /// **'Buy {length} × {count}'**
  String buySummary(String length, int count);

  /// No description provided for @requestedParts.
  ///
  /// In en, this message translates to:
  /// **'Requested parts'**
  String get requestedParts;

  /// No description provided for @placedParts.
  ///
  /// In en, this message translates to:
  /// **'Placed parts'**
  String get placedParts;

  /// No description provided for @unplacedParts.
  ///
  /// In en, this message translates to:
  /// **'Unplaced parts'**
  String get unplacedParts;

  /// No description provided for @placedOfRequested.
  ///
  /// In en, this message translates to:
  /// **'Placed {placed} of {requested, plural, =1{1 part} other{{requested} parts}}'**
  String placedOfRequested(int placed, int requested);

  /// No description provided for @totalFinishedLength.
  ///
  /// In en, this message translates to:
  /// **'Total finished length'**
  String get totalFinishedLength;

  /// No description provided for @totalStockUsed.
  ///
  /// In en, this message translates to:
  /// **'Total stock used'**
  String get totalStockUsed;

  /// No description provided for @totalWaste.
  ///
  /// In en, this message translates to:
  /// **'Total waste'**
  String get totalWaste;

  /// No description provided for @wastePercentage.
  ///
  /// In en, this message translates to:
  /// **'Waste: {value}%'**
  String wastePercentage(String value);

  /// No description provided for @reusableLeftovers.
  ///
  /// In en, this message translates to:
  /// **'Reusable leftovers'**
  String get reusableLeftovers;

  /// No description provided for @scrap.
  ///
  /// In en, this message translates to:
  /// **'Scrap'**
  String get scrap;

  /// No description provided for @kerfLoss.
  ///
  /// In en, this message translates to:
  /// **'Kerf loss'**
  String get kerfLoss;

  /// No description provided for @trimLoss.
  ///
  /// In en, this message translates to:
  /// **'Trim loss'**
  String get trimLoss;

  /// No description provided for @reusable.
  ///
  /// In en, this message translates to:
  /// **'Reusable'**
  String get reusable;

  /// No description provided for @leftover.
  ///
  /// In en, this message translates to:
  /// **'Leftover'**
  String get leftover;

  /// No description provided for @reusableExplanation.
  ///
  /// In en, this message translates to:
  /// **'Reusable: tail leftovers at least {threshold}. Scrap includes kerf, trim, and shorter leftovers.'**
  String reusableExplanation(String threshold);

  /// No description provided for @resultMetric.
  ///
  /// In en, this message translates to:
  /// **'{label}: {value}'**
  String resultMetric(String label, String value);

  /// No description provided for @barTitle.
  ///
  /// In en, this message translates to:
  /// **'Bar {number} · {length}'**
  String barTitle(int number, String length);

  /// No description provided for @partsOnBar.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 part} other{{count} parts}}'**
  String partsOnBar(int count);

  /// No description provided for @classifiedLeftover.
  ///
  /// In en, this message translates to:
  /// **'{length} · {classification}'**
  String classifiedLeftover(String length, String classification);

  /// No description provided for @cutOrderPart.
  ///
  /// In en, this message translates to:
  /// **'{number}. {description}'**
  String cutOrderPart(int number, String description);

  /// No description provided for @endTrimPerEnd.
  ///
  /// In en, this message translates to:
  /// **'End trim: {length} each end'**
  String endTrimPerEnd(String length);

  /// No description provided for @barDiagramDescription.
  ///
  /// In en, this message translates to:
  /// **'Stock bar {number}, {length}, {parts}, leftover {tail}.'**
  String barDiagramDescription(
    int number,
    String length,
    String parts,
    String tail,
  );

  /// No description provided for @unplacedCount.
  ///
  /// In en, this message translates to:
  /// **'Unplaced parts ({count})'**
  String unplacedCount(int count);

  /// No description provided for @lengthQuantity.
  ///
  /// In en, this message translates to:
  /// **'{length} × {quantity}'**
  String lengthQuantity(String length, int quantity);

  /// No description provided for @inventoryExhaustedResultReason.
  ///
  /// In en, this message translates to:
  /// **'Not enough stock remains to place this part.'**
  String get inventoryExhaustedResultReason;

  /// No description provided for @resultLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t calculate this cut list.'**
  String get resultLoadError;

  /// No description provided for @resultValidationError.
  ///
  /// In en, this message translates to:
  /// **'Check stock, parts, and cut settings before calculating.'**
  String get resultValidationError;

  /// No description provided for @stockTooShortAfterTrim.
  ///
  /// In en, this message translates to:
  /// **'Stock is too short after end trim.'**
  String get stockTooShortAfterTrim;

  /// No description provided for @validBuyStockRequired.
  ///
  /// In en, this message translates to:
  /// **'Set a valid stock length before calculating.'**
  String get validBuyStockRequired;

  /// No description provided for @tooLongResultReason.
  ///
  /// In en, this message translates to:
  /// **'This part is longer than the largest usable stock length.'**
  String get tooLongResultReason;

  /// No description provided for @editCutSettings.
  ///
  /// In en, this message translates to:
  /// **'Edit cut settings'**
  String get editCutSettings;

  /// No description provided for @units.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get units;

  /// No description provided for @unitFtIn.
  ///
  /// In en, this message translates to:
  /// **'ft + in'**
  String get unitFtIn;

  /// No description provided for @millimeters.
  ///
  /// In en, this message translates to:
  /// **'Millimeters'**
  String get millimeters;

  /// No description provided for @centimeters.
  ///
  /// In en, this message translates to:
  /// **'Centimeters'**
  String get centimeters;

  /// No description provided for @meters.
  ///
  /// In en, this message translates to:
  /// **'Meters'**
  String get meters;

  /// No description provided for @feetAndInches.
  ///
  /// In en, this message translates to:
  /// **'Feet and inches'**
  String get feetAndInches;

  /// No description provided for @kerf.
  ///
  /// In en, this message translates to:
  /// **'Kerf'**
  String get kerf;

  /// No description provided for @kerfHelper.
  ///
  /// In en, this message translates to:
  /// **'Material removed between consecutive parts.'**
  String get kerfHelper;

  /// No description provided for @kerfFinalPartHelper.
  ///
  /// In en, this message translates to:
  /// **'No kerf is added after the final part on a stock piece.'**
  String get kerfFinalPartHelper;

  /// No description provided for @endTrimEachEnd.
  ///
  /// In en, this message translates to:
  /// **'End trim (each end)'**
  String get endTrimEachEnd;

  /// No description provided for @endTrimHelper.
  ///
  /// In en, this message translates to:
  /// **'Trim this length from each end of every stock piece.'**
  String get endTrimHelper;

  /// No description provided for @reusableLeftover.
  ///
  /// In en, this message translates to:
  /// **'Reusable leftover'**
  String get reusableLeftover;

  /// No description provided for @reusableLeftoverHelper.
  ///
  /// In en, this message translates to:
  /// **'Leftovers at or above this length are counted as reusable.'**
  String get reusableLeftoverHelper;

  /// No description provided for @cutSettingsSaveError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t save cut settings. Try again.'**
  String get cutSettingsSaveError;

  /// No description provided for @noUsableStockAfterTrim.
  ///
  /// In en, this message translates to:
  /// **'No usable stock length remains after end trim.'**
  String get noUsableStockAfterTrim;

  /// No description provided for @someStockUnusableAfterTrim.
  ///
  /// In en, this message translates to:
  /// **'Some stock pieces are too short after end trim.'**
  String get someStockUnusableAfterTrim;

  /// No description provided for @nonnegativeLengthInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a number greater than or equal to zero.'**
  String get nonnegativeLengthInvalid;

  /// No description provided for @nonnegativeImperialInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter whole numbers of zero or more and a fraction.'**
  String get nonnegativeImperialInvalid;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @shareCutPlan.
  ///
  /// In en, this message translates to:
  /// **'Share cut plan'**
  String get shareCutPlan;

  /// No description provided for @shareText.
  ///
  /// In en, this message translates to:
  /// **'Share text'**
  String get shareText;

  /// No description provided for @sharePdf.
  ///
  /// In en, this message translates to:
  /// **'Share PDF'**
  String get sharePdf;

  /// No description provided for @copyBuyList.
  ///
  /// In en, this message translates to:
  /// **'Copy buy list'**
  String get copyBuyList;

  /// No description provided for @buyListCopied.
  ///
  /// In en, this message translates to:
  /// **'Buy list copied'**
  String get buyListCopied;

  /// No description provided for @creatingPdf.
  ///
  /// In en, this message translates to:
  /// **'Creating PDF…'**
  String get creatingPdf;

  /// No description provided for @pdfCreateError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t create the PDF. Try again.'**
  String get pdfCreateError;

  /// No description provided for @shareError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t share the cut plan. Try again.'**
  String get shareError;

  /// No description provided for @buyListCopyError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t copy the buy list. Try again.'**
  String get buyListCopyError;

  /// No description provided for @reportSummary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get reportSummary;

  /// No description provided for @reportPurchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get reportPurchase;

  /// No description provided for @generatedLabel.
  ///
  /// In en, this message translates to:
  /// **'Generated'**
  String get generatedLabel;

  /// No description provided for @generatedBy.
  ///
  /// In en, this message translates to:
  /// **'Generated by {appName}'**
  String generatedBy(String appName);

  /// No description provided for @verifyBeforeCutting.
  ///
  /// In en, this message translates to:
  /// **'Cut plans are planning aids. Verify each measurement on the stock before cutting and follow tool safety procedures.'**
  String get verifyBeforeCutting;

  /// No description provided for @reportFileFallback.
  ///
  /// In en, this message translates to:
  /// **'Cut Plan'**
  String get reportFileFallback;

  /// No description provided for @addLeftoversToStock.
  ///
  /// In en, this message translates to:
  /// **'Add leftovers to stock'**
  String get addLeftoversToStock;

  /// No description provided for @addLeftoversTitle.
  ///
  /// In en, this message translates to:
  /// **'Add leftovers to stock?'**
  String get addLeftoversTitle;

  /// No description provided for @addLeftoversMessage.
  ///
  /// In en, this message translates to:
  /// **'These reusable leftovers will be added to this project\'s Fixed Inventory for future cut plans.'**
  String get addLeftoversMessage;

  /// No description provided for @addLeftoversFutureHint.
  ///
  /// In en, this message translates to:
  /// **'Add them after the cuts are complete.'**
  String get addLeftoversFutureHint;

  /// No description provided for @addToStock.
  ///
  /// In en, this message translates to:
  /// **'Add to stock'**
  String get addToStock;

  /// No description provided for @leftoversAddedToStock.
  ///
  /// In en, this message translates to:
  /// **'Reusable leftovers added to stock for future cut plans.'**
  String get leftoversAddedToStock;

  /// No description provided for @leftoversAddError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t add leftovers to stock. Try again.'**
  String get leftoversAddError;

  /// No description provided for @reusablePieces.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 reusable piece} other{{count} reusable pieces}}'**
  String reusablePieces(int count);

  /// No description provided for @saveAndAddAnother.
  ///
  /// In en, this message translates to:
  /// **'Save & add another'**
  String get saveAndAddAnother;

  /// No description provided for @defaultsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Defaults'**
  String get defaultsSectionTitle;

  /// No description provided for @appearanceSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceSectionTitle;

  /// No description provided for @defaultReusableLeftover.
  ///
  /// In en, this message translates to:
  /// **'Default reusable leftover'**
  String get defaultReusableLeftover;

  /// No description provided for @newProjectsDefaultsHelper.
  ///
  /// In en, this message translates to:
  /// **'These values are used when you create a new cut list. Existing cut lists are not changed.'**
  String get newProjectsDefaultsHelper;

  /// No description provided for @defaultReusableHelper.
  ///
  /// In en, this message translates to:
  /// **'Leftovers at or above this length are counted as reusable in new projects.'**
  String get defaultReusableHelper;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @settingsSaveError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t save settings. Try again.'**
  String get settingsSaveError;

  /// No description provided for @settingsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t load settings.'**
  String get settingsLoadError;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved'**
  String get settingsSaved;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// No description provided for @languageGerman.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get languageGerman;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// No description provided for @languagePortugueseBrazil.
  ///
  /// In en, this message translates to:
  /// **'Português (Brasil)'**
  String get languagePortugueseBrazil;

  /// No description provided for @languageItalian.
  ///
  /// In en, this message translates to:
  /// **'Italiano'**
  String get languageItalian;

  /// No description provided for @languagePolish.
  ///
  /// In en, this message translates to:
  /// **'Polski'**
  String get languagePolish;

  /// No description provided for @languageRussian.
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get languageRussian;

  /// No description provided for @languageTurkish.
  ///
  /// In en, this message translates to:
  /// **'Türkçe'**
  String get languageTurkish;

  /// No description provided for @languageUkrainian.
  ///
  /// In en, this message translates to:
  /// **'Українська'**
  String get languageUkrainian;

  /// No description provided for @proTitle.
  ///
  /// In en, this message translates to:
  /// **'KerfPlan Pro'**
  String get proTitle;

  /// No description provided for @upgradeOnce.
  ///
  /// In en, this message translates to:
  /// **'Upgrade once. Keep it for good.'**
  String get upgradeOnce;

  /// No description provided for @noSubscription.
  ///
  /// In en, this message translates to:
  /// **'No subscription.'**
  String get noSubscription;

  /// No description provided for @lifetimePro.
  ///
  /// In en, this message translates to:
  /// **'Lifetime Pro'**
  String get lifetimePro;

  /// No description provided for @removeAds.
  ///
  /// In en, this message translates to:
  /// **'Remove Ads'**
  String get removeAds;

  /// No description provided for @unlockLifetimePro.
  ///
  /// In en, this message translates to:
  /// **'Unlock Lifetime Pro — {price}'**
  String unlockLifetimePro(String price);

  /// No description provided for @removeAdsCta.
  ///
  /// In en, this message translates to:
  /// **'Remove Ads — {price}'**
  String removeAdsCta(String price);

  /// No description provided for @proActive.
  ///
  /// In en, this message translates to:
  /// **'Lifetime Pro active'**
  String get proActive;

  /// No description provided for @adFreeActive.
  ///
  /// In en, this message translates to:
  /// **'Ad-free'**
  String get adFreeActive;

  /// No description provided for @includedWithPro.
  ///
  /// In en, this message translates to:
  /// **'Included with Lifetime Pro'**
  String get includedWithPro;

  /// No description provided for @removeAdsDescription.
  ///
  /// In en, this message translates to:
  /// **'Keep the free features and remove advertising.'**
  String get removeAdsDescription;

  /// No description provided for @restorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get restorePurchases;

  /// No description provided for @restoringPurchases.
  ///
  /// In en, this message translates to:
  /// **'Restoring purchases…'**
  String get restoringPurchases;

  /// No description provided for @purchasesRestored.
  ///
  /// In en, this message translates to:
  /// **'Purchases restored'**
  String get purchasesRestored;

  /// No description provided for @lifetimeProRestored.
  ///
  /// In en, this message translates to:
  /// **'Lifetime Pro restored'**
  String get lifetimeProRestored;

  /// No description provided for @adFreeRestored.
  ///
  /// In en, this message translates to:
  /// **'Ad-free restored'**
  String get adFreeRestored;

  /// No description provided for @nothingToRestore.
  ///
  /// In en, this message translates to:
  /// **'Nothing to restore'**
  String get nothingToRestore;

  /// No description provided for @purchasePending.
  ///
  /// In en, this message translates to:
  /// **'Purchase pending'**
  String get purchasePending;

  /// No description provided for @purchasePendingMessage.
  ///
  /// In en, this message translates to:
  /// **'Your purchase is waiting for Google Play to complete payment.'**
  String get purchasePendingMessage;

  /// No description provided for @purchaseError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t complete the purchase. Try again.'**
  String get purchaseError;

  /// No description provided for @restoreError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t restore purchases. Try again.'**
  String get restoreError;

  /// No description provided for @billingUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Purchases are unavailable right now.'**
  String get billingUnavailable;

  /// No description provided for @productUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Temporarily unavailable.'**
  String get productUnavailable;

  /// No description provided for @processingPurchase.
  ///
  /// In en, this message translates to:
  /// **'Verifying purchase…'**
  String get processingPurchase;

  /// No description provided for @purchaseVerified.
  ///
  /// In en, this message translates to:
  /// **'Purchase verified'**
  String get purchaseVerified;

  /// No description provided for @kerfPlanFree.
  ///
  /// In en, this message translates to:
  /// **'KerfPlan Free'**
  String get kerfPlanFree;

  /// No description provided for @viewPro.
  ///
  /// In en, this message translates to:
  /// **'View Pro'**
  String get viewPro;

  /// No description provided for @upgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get upgrade;

  /// No description provided for @benefitUnlimitedProjects.
  ///
  /// In en, this message translates to:
  /// **'Unlimited cut lists'**
  String get benefitUnlimitedProjects;

  /// No description provided for @benefitMultipleStocks.
  ///
  /// In en, this message translates to:
  /// **'Multiple stock lengths'**
  String get benefitMultipleStocks;

  /// No description provided for @benefitPdf.
  ///
  /// In en, this message translates to:
  /// **'Workshop PDF export'**
  String get benefitPdf;

  /// No description provided for @benefitReuseLeftovers.
  ///
  /// In en, this message translates to:
  /// **'Reuse leftovers'**
  String get benefitReuseLeftovers;

  /// No description provided for @benefitNoAds.
  ///
  /// In en, this message translates to:
  /// **'No ads'**
  String get benefitNoAds;

  /// No description provided for @onboardingIntro.
  ///
  /// In en, this message translates to:
  /// **'Plan linear cuts with less waste.'**
  String get onboardingIntro;

  /// No description provided for @howDoYouMeasure.
  ///
  /// In en, this message translates to:
  /// **'How do you measure?'**
  String get howDoYouMeasure;

  /// No description provided for @metric.
  ///
  /// In en, this message translates to:
  /// **'Metric'**
  String get metric;

  /// No description provided for @imperial.
  ///
  /// In en, this message translates to:
  /// **'Imperial'**
  String get imperial;

  /// No description provided for @metricDescription.
  ///
  /// In en, this message translates to:
  /// **'Millimeters, centimeters and meters'**
  String get metricDescription;

  /// No description provided for @imperialDescription.
  ///
  /// In en, this message translates to:
  /// **'Inches and feet'**
  String get imperialDescription;

  /// No description provided for @recommendedForRegion.
  ///
  /// In en, this message translates to:
  /// **'Recommended for your region'**
  String get recommendedForRegion;

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @measurementCanChangeLater.
  ///
  /// In en, this message translates to:
  /// **'You can change this later in Settings.'**
  String get measurementCanChangeLater;

  /// No description provided for @measurements.
  ///
  /// In en, this message translates to:
  /// **'Measurements'**
  String get measurements;

  /// No description provided for @measurementSystem.
  ///
  /// In en, this message translates to:
  /// **'Measurement system'**
  String get measurementSystem;

  /// No description provided for @commonLengths.
  ///
  /// In en, this message translates to:
  /// **'Common lengths'**
  String get commonLengths;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'it',
    'pl',
    'pt',
    'ru',
    'tr',
    'uk',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
