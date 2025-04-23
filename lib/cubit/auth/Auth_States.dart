abstract class AuthStates {}

class AuthIntialState extends AuthStates {}

class AuthConnectingState extends AuthStates {}

class AuthConnectedState extends AuthStates {}

class AuthDisConnectedState extends AuthStates {}

class AuthCodeSendingState extends AuthStates {}

class AuthCodeSentState extends AuthStates {}

class AuthUserReloadedState extends AuthStates {}

class AuthTimerChangeState extends AuthStates {}

class AuthErrorLoggedInState extends AuthStates {}

class AuthErrorVerifyState extends AuthStates {}

class AuthErrorVerifySendCodeState extends AuthStates {}

class AuthSignUpState extends AuthStates {}

class AuthSignUpSuccessState extends AuthStates {}

class AuthSignUpFailedState extends AuthStates {}

class AuthChangePasswordState extends AuthStates {}

class AuthChangePasswordSuccessState extends AuthStates {}

class AuthChangePasswordFailedState extends AuthStates {}
