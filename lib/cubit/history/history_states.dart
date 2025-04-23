abstract class HistoryStates {}

class HistoryInitiateState extends HistoryStates {}

class HistoryLoadingState extends HistoryStates {}

class HistorySuccessState extends HistoryStates {}

class HistoryFailedState extends HistoryStates {}

class HistoryFilterLoadingState extends HistoryStates {}

class HistoryFilterSuccessState extends HistoryStates {}

class HistoryDeleteLoadingState extends HistoryStates {}

class HistoryDeleteSuccessState extends HistoryStates {}

class HistoryDeleteFailedState extends HistoryStates {}

class MembersLoadingState extends HistoryStates {}

class MembersSuccessState extends HistoryStates {}

class MembersFailedState extends HistoryStates {}

class HistoryCalculateTotalState extends HistoryStates {}
