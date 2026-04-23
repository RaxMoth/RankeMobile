/// Central registry of every HTTP path the mobile app hits.
///
/// One source of truth means:
///   • renaming a route is a single-file change
///   • data sources never build paths with string-concatenation in ad-hoc places
///   • the Go backend's router definitions map 1:1 to this file during review
///
/// All paths are relative to [AppConfig.apiBaseUrl] — do NOT include the host.
/// The `/api/v1` version prefix is baked in here.
library;

abstract class ApiPaths {
  static const String _v1 = '/api/v1';

  // ── Auth ─────────────────────────────────────────────────────
  static const String authRegister = '$_v1/auth/register';
  static const String authLogin = '$_v1/auth/login';
  static const String authApple = '$_v1/auth/apple';
  static const String authRefresh = '$_v1/auth/refresh';
  static const String authLogout = '$_v1/auth/logout';

  // ── Users ────────────────────────────────────────────────────
  static const String usersMe = '$_v1/users/me';
  static String userProfile(String userId) => '$_v1/users/$userId/profile';

  // ── Lists ────────────────────────────────────────────────────
  static const String lists = '$_v1/lists';
  static const String listsPublic = '$_v1/lists/public';
  static String listById(String id) => '$_v1/lists/$id';
  static String listMembers(String id) => '$_v1/lists/$id/members';
  static String listMember(String id, String userId) =>
      '$_v1/lists/$id/members/$userId';
  static String listInvite(String id) => '$_v1/lists/$id/invite';
  static String listInviteRegenerate(String id) =>
      '$_v1/lists/$id/invite/regenerate';
  static String inviteByToken(String token) => '$_v1/lists/invite/$token';
  static String inviteJoin(String token) => '$_v1/lists/invite/$token/join';

  // ── Entries ──────────────────────────────────────────────────
  static String entryMine(String listId) => '$_v1/lists/$listId/entries/me';
  static String entriesPending(String listId) =>
      '$_v1/lists/$listId/entries/pending';
  static String entryApprove(String listId, String entryId) =>
      '$_v1/lists/$listId/entries/$entryId/approve';
  static String entryReject(String listId, String entryId) =>
      '$_v1/lists/$listId/entries/$entryId/reject';
  static String entryById(String listId, String entryId) =>
      '$_v1/lists/$listId/entries/$entryId';
}
