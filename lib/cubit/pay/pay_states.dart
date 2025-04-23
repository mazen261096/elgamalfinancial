abstract class PayStates {}

class PayInitiateState extends PayStates {}

class PayCreateLoadingState extends PayStates {}

class PayCreateSuccessState extends PayStates {}

class PayCreateFailedState extends PayStates {}

class PayPhotoLoadingState extends PayStates {}

class PayPhotoSuccessState extends PayStates {}

class PayPhotoFailedState extends PayStates {}

class PayPhotoChooseState extends PayStates {}
