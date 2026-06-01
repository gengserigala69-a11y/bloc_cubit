import 'package:bloc/bloc.dart';

class CounterObserver extends BlocObserver {
  const CounterObserver();
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
  }

@override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,){
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace){
    print(error);
    super.onError(bloc, error, stackTrace);
  }



}
