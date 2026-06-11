import 'package:get/get.dart';
import 'Languages/english.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': English.language,
  };
}
