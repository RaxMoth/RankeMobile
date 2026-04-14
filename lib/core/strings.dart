/// Centralized UI strings for the Ranked app.
/// All user-facing text lives here for maintainability and future i18n.
abstract class S {
  // ── App ────────────────────────────────────────────────────────
  static const appName = 'RANKED';

  // ── Nav tabs ───────────────────────────────────────────────────
  static const tabHome = 'HOME';
  static const tabDiscover = 'DISCOVER';
  static const tabCreate = 'CREATE';
  static const tabProfile = 'PROFILE';

  // ── Auth ───────────────────────────────────────────────────────
  static const signIn = 'SIGN IN';
  static const signInSubtitle = 'Sign in to your account';
  static const signInApple = 'SIGN IN WITH APPLE';
  static const signUpApple = 'SIGN UP WITH APPLE';
  static const createAccount = 'CREATE ACCOUNT';
  static const signOut = 'SIGN OUT';
  static const or = 'or';
  static const noAccount = "Don't have an account? Sign up";
  static const hasAccount = 'Already have an account? Sign in';

  // ── Auth fields ────────────────────────────────────────────────
  static const email = 'Email';
  static const emailHint = 'you@example.com';
  static const emailRequired = 'Email is required';
  static const emailInvalid = 'Invalid email';
  static const password = 'Password';
  static const passwordRequired = 'Password is required';
  static const passwordTooShort = 'Password must be at least 6 characters';
  static const displayName = 'Display Name';
  static const nameRequired = 'Name is required';

  // ── Home ───────────────────────────────────────────────────────
  static const myBoards = 'MY BOARDS';
  static const participating = 'PARTICIPATING';
  static const bookmarked = 'BOOKMARKED';
  static const owned = 'OWNED';
  static const joined = 'JOINED';
  static const saved = 'SAVED';
  static const noBoardsYet = 'NO BOARDS YET';
  static const noBoardsHint =
      'CREATE A BOARD OR DISCOVER\nPUBLIC BOARDS TO GET STARTED';
  static const create = 'CREATE';
  static const discover = 'DISCOVER';
  static const failedToLoad = 'FAILED TO LOAD';

  // ── Discover ───────────────────────────────────────────────────
  static const searchBoards = 'SEARCH BOARDS...';
  static const all = 'ALL';
  static const noBoardsFound = 'NO BOARDS FOUND';
  static const tryDifferentSearch = 'TRY A DIFFERENT SEARCH OR CATEGORY';
  static const clearSearch = 'CLEAR SEARCH';

  // ── Create board ───────────────────────────────────────────────
  static const createBoard = 'CREATE BOARD';
  static const cancel = 'CANCEL';
  static const boardIdentifier = 'BOARD IDENTIFIER';
  static const boardIdentifierHint = 'E.G. Q4 REVENUE GAINS';
  static const boardIdentifierRequired = 'BOARD IDENTIFIER REQUIRED';
  static const scopeObjective = 'SCOPE & OBJECTIVE';
  static const scopeHint = 'DESCRIBE THE CRITERIA FOR ENTRY...';
  static const valueType = 'VALUE TYPE';
  static const rankOrder = 'RANK ORDER';
  static const manualRankingText = 'MANUAL RANKING FOR TEXT';
  static const highestWins = 'HIGHEST VALUE WINS';
  static const lowestWins = 'LOWEST VALUE WINS';
  static const highToLow = 'HIGH\u2192LOW';
  static const lowToHigh = 'LOW\u2192HIGH';
  static const publicRegistry = 'PUBLIC REGISTRY';
  static const visibleToAll = 'VISIBLE TO ALL USERS';
  static const category = 'CATEGORY';
  static const categoryDeselectHint = 'TAP AGAIN TO DESELECT';
  static const categoryHelp = 'OPTIONAL — HELPS USERS DISCOVER YOUR BOARD';
  static const executionRules = 'EXECUTION RULES (OPTIONAL)';
  static const rulesHint = 'SPECIFY EVIDENCE REQUIREMENTS...';
  static const commsChannels = 'COMMUNICATION CHANNELS';
  static const optional = 'OPTIONAL';
  static const termsAgreement = 'AGREEMENT OF TERMINAL SERVICE TERMS REQUIRED';
  static const previewCreate = 'PREVIEW & CREATE';
  static const boardPreview = 'BOARD PREVIEW';
  static const reviewBeforeCreation = 'REVIEW BEFORE CREATION';
  static const edit = 'EDIT';
  static const highestWinsShort = 'HIGHEST WINS';
  static const lowestWinsShort = 'LOWEST WINS';
  static const publicLabel = 'PUBLIC';
  static const privateLabel = 'PRIVATE';
  static String failedToCreateBoard(Object e) => 'FAILED TO CREATE BOARD: $e';

  // ── Value type descriptions ────────────────────────────────────
  static const valueTypeNumber =
      'NUMERIC VALUES \u2022 e.g. 48.2, 156, 31240';
  static const valueTypeDuration =
      'TIME-BASED VALUES \u2022 e.g. 15:23, 1:02:45';
  static const valueTypeText =
      'TEXT ENTRIES WITH MANUAL RANKING \u2022 e.g. "Completed Q4"';

  // ── Board detail ───────────────────────────────────────────────
  static const standings = 'STANDINGS';
  static const info = 'INFO';
  static const comms = 'COMMS';
  static const stats = 'STATS';
  static const admin = 'ADMIN';
  static const failedToLoadBoard = 'FAILED TO LOAD BOARD';
  static const goBack = 'GO BACK';
  static const noEntriesYet = 'NO ENTRIES YET';
  static const beFirstToSubmit = 'BE THE FIRST TO SUBMIT';
  static const submitNewEntry = 'SUBMIT NEW ENTRY';
  static const objective = 'OBJECTIVE';
  static const boardDetails = 'BOARD DETAILS';
  static const visibility = 'VISIBILITY';
  static const status = 'STATUS';
  static const lockedNoEntries = 'LOCKED — NO NEW ENTRIES';
  static const locked = 'LOCKED';
  static const entries = 'ENTRIES';
  static const members = 'MEMBERS';
  static const lastEntry = 'LAST ENTRY';
  static const recentActivity = 'RECENT ACTIVITY';
  static const boardAnalytics = 'BOARD ANALYTICS';
  static const justNow = 'JUST NOW';
  static const community = 'COMMUNITY';
  static const telegram = 'TELEGRAM';
  static const whatsapp = 'WHATSAPP';
  static const discord = 'DISCORD';

  // ── Entry detail / deletion ────────────────────────────────────
  static const deleteMyEntry = 'DELETE MY ENTRY';
  static const removeEntry = 'REMOVE ENTRY';
  static const remove = 'REMOVE';
  static String deleteOwnEntryConfirm =
      'Delete your entry from this board? This cannot be undone.';
  static String removeEntryConfirm(String name) =>
      "Remove $name's entry from this board?";

  // ── Submit entry ───────────────────────────────────────────────
  static const submitEntry = 'SUBMIT ENTRY';
  static const confirmSubmission = 'CONFIRM SUBMISSION';
  static const submissionReceived = 'SUBMISSION RECEIVED';
  static const pendingApproval = 'PENDING ADMIN APPROVAL';
  static const submissionApprovalHint =
      'Your entry will appear in standings\nonce approved by a moderator.';
  static const done = 'DONE';
  static const noteOptional = 'NOTE (OPTIONAL)';
  static const noteHint = 'ADD CONTEXT TO YOUR ENTRY...';
  static const value = 'VALUE';
  static const duration = 'DURATION';
  static const enterValidNumber = 'ENTER A VALID NUMBER';
  static const enterValidDuration = 'ENTER A VALID DURATION';
  static const enterValue = 'ENTER A VALUE';
  static const enterValueHint = 'ENTER YOUR VALUE...';
  static const shareProof = 'SHARE PROOF IN COMMUNITY';
  static const shareProofHint =
      'Send evidence (photos, videos) in the group chat to help admins verify your entry.';
  static String submissionFailed(Object e) => 'SUBMISSION FAILED: $e';

  // ── Pending entries (admin) ────────────────────────────────────
  static String pendingSubmissions(int count) =>
      'PENDING SUBMISSIONS ($count)';
  static const approve = 'APPROVE';
  static const reject = 'REJECT';
  static String failed(Object e) => 'FAILED: $e';

  // ── Admin tab ──────────────────────────────────────────────────
  static const editBoard = 'EDIT BOARD';
  static const editBoardSubtitle = 'MODIFY TITLE, DESCRIPTION, LINKS';
  static const lockBoard = 'LOCK BOARD';
  static const unlockBoard = 'UNLOCK BOARD';
  static const lockBoardSubtitle = 'PREVENT NEW ENTRY SUBMISSIONS';
  static const unlockBoardSubtitle = 'ALLOW NEW ENTRY SUBMISSIONS';
  static const manageMembers = 'MANAGE MEMBERS';
  static String manageMembersSubtitle(int count) =>
      '$count MEMBERS — ROLES & ACCESS';
  static const shareInvite = 'SHARE INVITE';
  static const shareInviteSubtitle = 'GENERATE INVITE LINK';
  static String shareMessage(String link) =>
      'Join my board on Ranked: rankapp://invite/$link';
  static String failedToGetInvite(Object e) => 'FAILED TO GET INVITE: $e';

  // ── Edit board sheet ───────────────────────────────────────────
  static const title = 'TITLE';
  static const boardTitle = 'BOARD TITLE';
  static const description = 'DESCRIPTION';
  static const describeBoard = 'DESCRIBE THE BOARD...';
  static const saveChanges = 'SAVE CHANGES';
  static String failedToUpdate(Object e) => 'FAILED TO UPDATE: $e';

  // ── Manage members ─────────────────────────────────────────────
  static const failedToLoadMembers = 'FAILED TO LOAD MEMBERS';
  static const noMembers = 'NO MEMBERS';
  static const removeMember = 'REMOVE MEMBER';
  static String removeMemberConfirm(String name) =>
      'Remove $name from this board?';
  static const setRole = 'SET ROLE';

  // ── Invite preview ─────────────────────────────────────────────
  static const invalidInvite = 'INVALID INVITE';
  static const inviteExpired =
      'THIS INVITE LINK MAY HAVE EXPIRED\nOR BEEN REVOKED';
  static const goHome = 'GO HOME';
  static const joinBoard = 'JOIN BOARD';
  static const alreadyMember = 'ALREADY A MEMBER';
  static const maybeLater = 'MAYBE LATER';
  static String joinedBoard(String title) => 'JOINED ${title.toUpperCase()}';
  static String failedToJoin(Object e) => 'FAILED TO JOIN: $e';

  // ── Profile ────────────────────────────────────────────────────
  static const failedToLoadBoards = 'FAILED TO LOAD BOARDS';
  static const discoverBoards = 'DISCOVER BOARDS';
  static const ownedBoards = 'OWNED BOARDS';
  static const noPublicBoards = 'NO PUBLIC BOARDS';
  static const boards = 'BOARDS';
  static const userNotFound = 'USER NOT FOUND';
  static String memberSince(String date) => 'MEMBER SINCE $date';

  // ── Onboarding ─────────────────────────────────────────────────
  static const onboardingTitle1 = 'COMPETE & RANK';
  static const onboardingBody1 =
      'Create leaderboards for anything — fitness goals, investments, gaming scores, study hours. Track who\'s on top.';
  static const onboardingTitle2 = 'BUILD YOUR CREW';
  static const onboardingBody2 =
      'Invite friends and colleagues to your boards. Coordinate via Telegram, Discord, or WhatsApp groups.';
  static const onboardingTitle3 = 'VERIFIED ENTRIES';
  static const onboardingBody3 =
      'Admins approve submissions before they go live. Share proof in your community group to climb the ranks.';
  static const skip = 'SKIP';
  static const getStarted = 'GET STARTED';
  static const next = 'NEXT';

  // ── Duration picker ────────────────────────────────────────────
  static const hh = 'HH';
  static const mm = 'MM';
  static const ss = 'SS';

  // ── Error view ─────────────────────────────────────────────────
  static const noNetwork =
      'No network connection. Please check your internet.';
  static const genericError = 'Something went wrong. Please try again.';
  static const retry = 'RETRY';

  // ── Entry detail ────────────────────────────────────────────────
  static const note = 'NOTE';
  static const viewProfile = 'VIEW PROFILE';
  static String submitted(String time) => 'SUBMITTED $time';
  static String valueTypeSubtitle(String type) => 'VALUE TYPE: $type';
  static String rankLabel(int rank) => 'RANK #$rank';
  static String dAgo(int d) => '${d}D AGO';
  static String hAgo(int h) => '${h}H AGO';
  static String mAgo(int m) => '${m}M AGO';
  static String rankActivity(String name, int rank) => '$name — RANK $rank';
  static String membersCount(int count) => '$count MEMBERS';

  // ── Misc ───────────────────────────────────────────────────────
  static const loading = 'LOADING...';
  static const na = 'N/A';
  static const badgeOverflow = '9+';
}
