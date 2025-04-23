import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import '../../data/local/shared_preference.dart';

const String ARABIC = "ar";
const String ENGLISH = "en";
const String ASSET_PATH_LOCALISATIONS = "assets/translations";

const Locale ARABIC_LOCAL = Locale("ar", "SA");
const Locale ENGLISH_LOCAL = Locale("en", "US");
const String PREFS_KEY_LANG = "PREFS_KEY_LANG";

class LanguageManager {
  Future<String> getAppLanguage() async {
    String? language = await SharedPreference.getString(PREFS_KEY_LANG);
    if (language != null && language.isNotEmpty) {
      return language;
    } else {
      // return default lang
      return ENGLISH;
    }
  }

  Future<Locale> getLocal() async {
    String currentLang = await getAppLanguage();

    if (currentLang == ARABIC) {
      return ARABIC_LOCAL;
    } else {
      return ENGLISH_LOCAL;
    }
  }

  Future<void> changeAppLanguage(BuildContext context) async {
    String currentLang = await getAppLanguage();
    if (currentLang == ARABIC) {
      // set english
      await SharedPreference.setString(PREFS_KEY_LANG, ENGLISH)
          .then((value) async {
        await EasyLocalization.of(context)!
            .setLocale(ENGLISH_LOCAL)
            .then((value) => Phoenix.rebirth(context));
      });
    } else {
      // set arabic

      await SharedPreference.setString(PREFS_KEY_LANG, ARABIC)
          .then((value) async {
        await EasyLocalization.of(context)!
            .setLocale(ARABIC_LOCAL)
            .then((value) => Phoenix.rebirth(context));
      });
    }
  }
}
