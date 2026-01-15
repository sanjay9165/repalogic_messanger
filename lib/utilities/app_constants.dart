class AppConstants {
  // App Information
  static const String appTitle = 'Messanger';
  static const String appName = 'Messanger';
  static const String appTagline = 'Secure Communication';

  // Authentication Strings
  static const String welcome = 'Welcome!';
  static const String signInToContinue = 'Sign in to continue';
  static const String signInWithGoogle = 'Sign in with Google';
  static const String somethingWentWrong = 'Something went wrong, try again!';
  static const String errorPrefix = 'Error: ';
  static const String pleaseSignInFirst = 'Please sign in first';

  // Chat Rooms Strings
  static const String chatRooms = 'Chat Rooms';
  static const String noChatRoomsYet = 'No chat rooms yet';
  static const String createNewChatRoom =
      'Create a new chat room to get started';
  static const String errorLoadingChatRooms = 'Error loading chat rooms';

  // Create Chat Room Strings
  static const String createChatRoom = 'Create Chat Room';
  static const String createNewChatRoomTitle = 'Create a New Chat Room';
  static const String enterChatRoomName = 'Enter a name for your chat room';
  static const String chatRoomName = 'Chat Room Name';
  static const String chatRoomNameHint = 'e.g., Team Discussion';
  static const String pleaseEnterRoomName = 'Please enter a room name';
  static const String roomNameMinLength =
      'Room name must be at least 3 characters';
  static const String createRoom = 'Create Room';
  static const String cancel = 'Cancel';
  static const String chatRoomCreatedSuccess = 'Chat room created successfully';
  static const String failedToCreateChatRoom = 'Failed to create chat room';

  // Chat Screen Strings
  static const String participant = 'participant';
  static const String participants = 'participants';
  static const String noMessagesYet = 'No messages yet';
  static const String sendMessageToStart =
      'Send a message to start the conversation';
  static const String errorLoadingMessages = 'Error loading messages';
  static const String typeMessage = 'Type a message...';
  static const String failedToSendMessage = 'Failed to send message';

  // Invite Users Strings
  static const String inviteUsers = 'Invite Users';
  static const String searchUsersHint = 'Search users by email or name...';
  static const String noUsersAvailable = 'No users available to invite';
  static const String noUsersFound = 'No users found';
  static const String allUsersAlreadyInRoom =
      'All users are already in this chat room';
  static const String tryDifferentQuery =
      'Try searching with a different query';
  static const String invite = 'Invite';
  static const String userAlreadyInRoom = 'User is already in this chat room';
  static const String userHasBeenInvited = 'has been invited';
  static const String failedToInviteUser = 'Failed to invite user';
  static const String errorLoadingUsers = 'Error loading users';

  // Widget Strings
  static const String noMessagesYetWidget = 'No messages yet';
  static const String yesterday = 'Yesterday';
  static const String unknownUser = 'Unknown User';

  // Default Values
  static const String defaultUserInitial = 'U';
  static const String defaultChatRoomInitial = 'C';

  // Firestore Collection Names
  static const String collectionUsers = 'users';
  static const String collectionChatRooms = 'chatRooms';
  static const String collectionMessages = 'messages';
}
