import 'package:get_it/get_it.dart';
import 'package:audio_service/audio_service.dart';

import '../handlers/audio_handlers.dart';
import '../page_manager.dart';

GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerSingletonAsync<AudioHandler>(() => initAudioService());
  getIt.registerLazySingleton<PageManager>(() => PageManager());
}
