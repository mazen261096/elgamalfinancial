abstract class WalletStates {}

class WalletInitialState extends WalletStates {}

class WalletCreateLoadingState extends WalletStates {}

class WalletCreatedState extends WalletStates {}

class WalletCreateFailedState extends WalletStates {}

class WalletLoadingState extends WalletStates {}

class WalletLoadingSuccessState extends WalletStates {}

class WalletLoadingFailedState extends WalletStates {}

class WalletCurrentLoadingSuccessState extends WalletStates {}

class WalletWithdrawLoadingState extends WalletStates {}

class WalletWithdrawSuccessState extends WalletStates {}

class WalletWithdrawFailedState extends WalletStates {}

class WalletDepositLoadingState extends WalletStates {}

class WalletDepositSuccessState extends WalletStates {}

class WalletDepositFailedState extends WalletStates {}

class WalletNotificationLoadingState extends WalletStates {}

class WalletNotificationSuccessState extends WalletStates {}

class WalletNotificationFailedState extends WalletStates {}

class WalletFreezingState extends WalletStates {}

class WalletFreezingSuccessState extends WalletStates {}

class WalletFreezingFailedState extends WalletStates {}
