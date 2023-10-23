import 'package:flutter/foundation.dart' show ValueNotifier;
import 'package:flutter_application_1/data/storage_repository.dart';
import 'package:flutter_application_1/domain/notifiers/abstract/records_notifier.dart';
import 'package:flutter_application_1/domain/notifiers/hypertension_notifier/hypertension_model.dart';
import 'package:flutter_application_1/domain/notifiers/hypertension_notifier/hypertension_notifier.dart';
import 'package:flutter_application_1/domain/notifiers/weather_notifier/weather.dart';

sealed class HomeState {
  const HomeState();
}

class HomeStateData extends HomeState {
  const HomeStateData(this.data);

  final List<HypertensionModel> data;
}

class HomeStateLoading extends HomeState {
  const HomeStateLoading();
}

class HomeStateError extends HomeState {
  const HomeStateError(this.message);

  final String message;
}

class HomeStateDataEmpty extends HomeState {
  const HomeStateDataEmpty();
}

class StepperHomeState extends HomeState {
  const StepperHomeState();
}

class HomeStatePresenter extends ValueNotifier<HomeState> {
  HomeStatePresenter({
    required this.userRecordsNotifier,
    required this.storage,
  }) : super(const HomeStateLoading()) {
    load();
  }

  final HypertensionNotifier userRecordsNotifier;
  final StorageRepository storage;

  Future<void> addRecord({
    int sys = 120,
    int dia = 80,
    int pulse = 75,
    required Weather weather,
  }) async {
    value = const HomeStateLoading();
    await userRecordsNotifier.saveRecord(
      sys: sys,
      dia: dia,
      pulse: pulse,
      weather: weather,
    );
  }

  Future<void> removeRecord(HypertensionModel record) async {
    await userRecordsNotifier.removeRecord(record);
  }

  Future<void> load() async {
    final isTimeToStepper = storage.getBool(StorageStore.isTimeToStepperKey) ??
        StorageStore.isTimeToStepperDefaultValue;

    if (isTimeToStepper) {
      value = const StepperHomeState();
      return;
    }

    value = switch (userRecordsNotifier.value) {
      RecordsNotifierData(data: final records) => HomeStateData(records),
      RecordsNotifierLoading() => const HomeStateLoading(),
      RecordsNotifierEmpty() => const HomeStateDataEmpty(),
    };
  }
}
