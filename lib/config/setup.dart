import 'package:cat_tapper_telegram_web_app/exceptions/exceptions.dart';
import 'package:cat_tapper_telegram_web_app/modules/vms/account_controller.dart';
import 'package:cat_tapper_telegram_web_app/services/storage.dart';
import 'package:cat_tapper_telegram_web_app/services/telegram_service.dart';
import 'package:get_it/get_it.dart';

Future<void> setupServices() async {
  GetIt.I.registerSingleton(ErrorCatcher());
  GetIt.I.registerCachedFactory<Storage>( () => LocalStorage());
  GetIt.I.registerSingleton(AccountController(storage: GetIt.I.get<Storage>()));
  GetIt.I.registerSingleton(TelegramService());
}