import 'package:flutter_bloc/flutter_bloc.dart';

import 'notification_states.dart';

class NotificationCubit extends Cubit<NotificationStates> {
  NotificationCubit() : super(NotificationInitialState());
}
