import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lazy_listview_with_bloc/core/extension.dart';

class MyBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    if (kDebugMode) {
      ('>>EVENT>>>>>${bloc.runtimeType} $event').log();
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      ('>>ERROR>>>>>${bloc.runtimeType} $error $stackTrace').log;
    }
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (kDebugMode) {
      ('>>CHANGE>>>>>${bloc.runtimeType} $change').log;
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    if (kDebugMode) {
      ('>>TRANSITION>>>>>${bloc.runtimeType} $transition').log;
    }
  }
}
