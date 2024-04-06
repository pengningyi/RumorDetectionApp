import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../l10n/l10n.dart';
import '../../general/locale_provider.dart';
import 'package:provider/provider.dart';

class LanguageSettingsPage extends StatefulWidget {
  const LanguageSettingsPage({super.key});

  @override
  _LanguageSettingsPageState createState() => _LanguageSettingsPageState();
}

class _LanguageSettingsPageState extends State<LanguageSettingsPage> {

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final provider = Provider.of<LocaleProvider>(context, listen:false);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.languageSetting),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                provider.setLocale(const Locale('zh'));
              },
              child: Text('ZH'),
            ),
            ElevatedButton(
              onPressed: () {
                provider.setLocale(const Locale('en'));
              },
              child: Text('EN'),
            ),
            ElevatedButton(
              onPressed: () {
                provider.setLocale(const Locale('fr'));
              },
              child: Text('FR'),
            ),
            ElevatedButton(
              onPressed: () {
                provider.setLocale(const Locale('en'));
              },
              child: Text('Follow the system'),
            ),
          ],
        ),
      ),
    );
  }
}
