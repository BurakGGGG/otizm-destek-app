import 'package:flutter/material.dart';

import '../../../core/util/search_text.dart';
import '../../../i18n/strings.g.dart';

/// Kullanıcı Rehberi içeriği — web `UserGuidePage` (sayfa kataloğu +
/// başlangıç adımları) ve `TutorialVideoLibrary` (eğitim videoları) birebir.
///
/// Yalnızca mobilde karşılığı olan bölümler listelenir: web'deki BEP raporu,
/// danışanlar ve yönetim sayfaları mobil kapsam dışı olduğu için yok.
/// Metinler arayüz metnidir (i18n); rota ve simgeler koddadır.
class GuidePage {
  const GuidePage({
    required this.icon,
    required this.route,
    required this.title,
    required this.purpose,
    required this.useWhen,
    required this.keywords,
    this.badge,
  });

  final IconData icon;
  final String route;
  final String title;

  /// Sayfa ne işe yarar?
  final String purpose;

  /// Ne zaman kullanılır?
  final String useWhen;

  /// Aramada eşleşecek ek terimler (virgülle ayrılmış).
  final String keywords;

  /// "Her gün", "İlk adım" gibi kısa rozet.
  final String? badge;

  bool matches(String query) =>
      searchMatches(query, [title, purpose, useWhen, keywords]);
}

class GuideGroup {
  const GuideGroup({
    required this.title,
    required this.description,
    required this.pages,
  });

  final String title;
  final String description;
  final List<GuidePage> pages;
}

/// Rol bazlı ilk adımlar (web `RoleStartPanel`).
class GuideStartStep {
  const GuideStartStep({
    required this.icon,
    required this.title,
    required this.description,
    required this.badge,
    this.route,
  });

  final IconData icon;
  final String title;
  final String description;
  final String badge;
  final String? route;
}

/// Eğitim videosu (web `TUTORIAL_VIDEOS`). Videolar web sunucusunda barındığı
/// için mobil, rehber sayfasını tarayıcıda ilgili videoda açar.
class TutorialVideo {
  const TutorialVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.duration,
  });

  /// Web'deki video kimliği (`?video=` parametresi) — paylaşılan veri.
  final String id;
  final String title;
  final String description;
  final String category;
  final String duration;

  bool matches(String query) =>
      searchMatches(query, [title, description, category]);
}

/// Arama sorgusuna göre süzülmüş gruplar (boş grup düşer) — web birebir.
List<GuideGroup> filterGuideGroups(List<GuideGroup> groups, String query) {
  if (query.trim().isEmpty) return groups;
  return groups
      .map((group) => GuideGroup(
            title: group.title,
            description: group.description,
            pages: group.pages.where((page) => page.matches(query)).toList(),
          ))
      .where((group) => group.pages.isNotEmpty)
      .toList();
}

int guidePageCount(List<GuideGroup> groups) =>
    groups.fold(0, (count, group) => count + group.pages.length);

/// Veli rehberi — web `PARENT_GUIDE`'ın mobilde karşılığı olan sayfaları.
List<GuideGroup> parentGuideGroups(Translations t) {
  final g = t.guide;
  return [
    GuideGroup(
      title: g.groupDaily,
      description: g.groupDailyDesc,
      pages: [
        GuidePage(
          icon: Icons.dashboard_outlined,
          route: '/home',
          title: g.pageHome,
          purpose: g.pageHomePurpose,
          useWhen: g.pageHomeWhen,
          keywords: g.pageHomeKeywords,
          badge: g.badgeDaily,
        ),
        GuidePage(
          icon: Icons.assignment_outlined,
          route: '/daily-tracker',
          title: g.pageTracker,
          purpose: g.pageTrackerPurpose,
          useWhen: g.pageTrackerWhen,
          keywords: g.pageTrackerKeywords,
          badge: g.badgeQuickLog,
        ),
        GuidePage(
          icon: Icons.chat_bubble_outline,
          route: '/messages',
          title: g.pageMessages,
          purpose: g.pageMessagesPurpose,
          useWhen: g.pageMessagesWhen,
          keywords: g.pageMessagesKeywords,
        ),
        GuidePage(
          icon: Icons.event_available_outlined,
          route: '/appointments',
          title: g.pageAppointments,
          purpose: g.pageAppointmentsPurpose,
          useWhen: g.pageAppointmentsWhen,
          keywords: g.pageAppointmentsKeywords,
        ),
        GuidePage(
          icon: Icons.health_and_safety_outlined,
          route: '/crisis',
          title: g.pageCrisis,
          purpose: g.pageCrisisPurpose,
          useWhen: g.pageCrisisWhen,
          keywords: g.pageCrisisKeywords,
          badge: g.badgeQuickHelp,
        ),
        GuidePage(
          icon: Icons.smart_toy_outlined,
          route: '/chat',
          title: g.pageAssistant,
          purpose: g.pageAssistantPurpose,
          useWhen: g.pageAssistantWhen,
          keywords: g.pageAssistantKeywords,
        ),
        GuidePage(
          icon: Icons.settings_outlined,
          route: '/settings',
          title: g.pageSettings,
          purpose: g.pageSettingsPurpose,
          useWhen: g.pageSettingsWhen,
          keywords: g.pageSettingsKeywords,
        ),
        GuidePage(
          icon: Icons.help_outline,
          route: '/help',
          title: g.pageHelp,
          purpose: g.pageHelpPurpose,
          useWhen: g.pageHelpWhen,
          keywords: g.pageHelpKeywords,
        ),
      ],
    ),
    GuideGroup(
      title: g.groupChild,
      description: g.groupChildDesc,
      pages: [
        GuidePage(
          icon: Icons.child_care_outlined,
          route: '/children',
          title: g.pageChildren,
          purpose: g.pageChildrenPurpose,
          useWhen: g.pageChildrenWhen,
          keywords: g.pageChildrenKeywords,
          badge: g.badgeFirstStep,
        ),
        GuidePage(
          icon: Icons.trending_up,
          route: '/analytics',
          title: g.pageAnalytics,
          purpose: g.pageAnalyticsPurpose,
          useWhen: g.pageAnalyticsWhen,
          keywords: g.pageAnalyticsKeywords,
        ),
        GuidePage(
          icon: Icons.volunteer_activism_outlined,
          route: '/treatment',
          title: g.pageTreatment,
          purpose: g.pageTreatmentPurpose,
          useWhen: g.pageTreatmentWhen,
          keywords: g.pageTreatmentKeywords,
        ),
        GuidePage(
          icon: Icons.assignment_turned_in_outlined,
          route: '/tasks',
          title: g.pageTasks,
          purpose: g.pageTasksPurpose,
          useWhen: g.pageTasksWhen,
          keywords: g.pageTasksKeywords,
        ),
        GuidePage(
          icon: Icons.sticky_note_2_outlined,
          route: '/notes',
          title: g.pageNotes,
          purpose: g.pageNotesPurpose,
          useWhen: g.pageNotesWhen,
          keywords: g.pageNotesKeywords,
        ),
        GuidePage(
          icon: Icons.psychology_outlined,
          route: '/behavior',
          title: g.pageBehavior,
          purpose: g.pageBehaviorPurpose,
          useWhen: g.pageBehaviorWhen,
          keywords: g.pageBehaviorKeywords,
        ),
        GuidePage(
          icon: Icons.emergency_outlined,
          route: '/emergency',
          title: g.pageEmergency,
          purpose: g.pageEmergencyPurpose,
          useWhen: g.pageEmergencyWhen,
          keywords: g.pageEmergencyKeywords,
        ),
        GuidePage(
          icon: Icons.calendar_month_outlined,
          route: '/calendar',
          title: g.pageCalendar,
          purpose: g.pageCalendarPurpose,
          useWhen: g.pageCalendarWhen,
          keywords: g.pageCalendarKeywords,
        ),
        GuidePage(
          icon: Icons.checklist_outlined,
          route: '/routines',
          title: g.pageRoutines,
          purpose: g.pageRoutinesPurpose,
          useWhen: g.pageRoutinesWhen,
          keywords: g.pageRoutinesKeywords,
        ),
      ],
    ),
    GuideGroup(
      title: g.groupCommunity,
      description: g.groupCommunityDesc,
      pages: [
        GuidePage(
          icon: Icons.groups_2_outlined,
          route: '/forum',
          title: g.pageForum,
          purpose: g.pageForumPurpose,
          useWhen: g.pageForumWhen,
          keywords: g.pageForumKeywords,
        ),
        GuidePage(
          icon: Icons.favorite_outline,
          route: '/support-wall',
          title: g.pageWall,
          purpose: g.pageWallPurpose,
          useWhen: g.pageWallWhen,
          keywords: g.pageWallKeywords,
        ),
        GuidePage(
          icon: Icons.place_outlined,
          route: '/meetups',
          title: g.pageMeetups,
          purpose: g.pageMeetupsPurpose,
          useWhen: g.pageMeetupsWhen,
          keywords: g.pageMeetupsKeywords,
        ),
        GuidePage(
          icon: Icons.local_fire_department_outlined,
          route: '/weekly-question',
          title: g.pageWeekly,
          purpose: g.pageWeeklyPurpose,
          useWhen: g.pageWeeklyWhen,
          keywords: g.pageWeeklyKeywords,
        ),
        GuidePage(
          icon: Icons.diversity_3_outlined,
          route: '/similar-families',
          title: g.pageSimilar,
          purpose: g.pageSimilarPurpose,
          useWhen: g.pageSimilarWhen,
          keywords: g.pageSimilarKeywords,
        ),
        GuidePage(
          icon: Icons.groups_outlined,
          route: '/groups',
          title: g.pageGroups,
          purpose: g.pageGroupsPurpose,
          useWhen: g.pageGroupsWhen,
          keywords: g.pageGroupsKeywords,
        ),
        GuidePage(
          icon: Icons.menu_book_outlined,
          route: '/knowledge',
          title: g.pageKnowledge,
          purpose: g.pageKnowledgePurpose,
          useWhen: g.pageKnowledgeWhen,
          keywords: g.pageKnowledgeKeywords,
        ),
      ],
    ),
  ];
}

/// Uzman rehberi — mobilde uzmanın kullandığı bölümler (danışan yönetimi ve
/// BEP web'de kalıyor).
List<GuideGroup> expertGuideGroups(Translations t) {
  final g = t.guide;
  return [
    GuideGroup(
      title: g.groupExpertWork,
      description: g.groupExpertWorkDesc,
      pages: [
        GuidePage(
          icon: Icons.event_available_outlined,
          route: '/appointments',
          title: g.pageExpertAppointments,
          purpose: g.pageExpertAppointmentsPurpose,
          useWhen: g.pageExpertAppointmentsWhen,
          keywords: g.pageAppointmentsKeywords,
          badge: g.badgeCalendar,
        ),
        GuidePage(
          icon: Icons.chat_bubble_outline,
          route: '/messages',
          title: g.pageMessages,
          purpose: g.pageExpertMessagesPurpose,
          useWhen: g.pageExpertMessagesWhen,
          keywords: g.pageMessagesKeywords,
        ),
        GuidePage(
          icon: Icons.groups_2_outlined,
          route: '/forum',
          title: g.pageForum,
          purpose: g.pageExpertForumPurpose,
          useWhen: g.pageExpertForumWhen,
          keywords: g.pageForumKeywords,
        ),
        GuidePage(
          icon: Icons.menu_book_outlined,
          route: '/knowledge',
          title: g.pageKnowledge,
          purpose: g.pageKnowledgePurpose,
          useWhen: g.pageKnowledgeWhen,
          keywords: g.pageKnowledgeKeywords,
        ),
        GuidePage(
          icon: Icons.settings_outlined,
          route: '/settings',
          title: g.pageSettings,
          purpose: g.pageSettingsPurpose,
          useWhen: g.pageSettingsWhen,
          keywords: g.pageSettingsKeywords,
        ),
      ],
    ),
  ];
}

/// Rol bazlı ilk adımlar (web `ROLE_START_STEPS`).
List<GuideStartStep> guideStartSteps(Translations t, {required bool expert}) {
  final g = t.guide;
  if (expert) {
    return [
      GuideStartStep(
        icon: Icons.event_available_outlined,
        title: g.startExpertCalendar,
        description: g.startExpertCalendarDesc,
        badge: g.badgeCalendar,
        route: '/appointments',
      ),
      GuideStartStep(
        icon: Icons.chat_bubble_outline,
        title: g.startExpertMessages,
        description: g.startExpertMessagesDesc,
        badge: g.badgeCommunication,
        route: '/messages',
      ),
      GuideStartStep(
        icon: Icons.person_outline,
        title: g.startExpertProfile,
        description: g.startExpertProfileDesc,
        badge: g.badgeProfile,
        route: '/account',
      ),
    ];
  }
  return [
    GuideStartStep(
      icon: Icons.child_care_outlined,
      title: g.startChild,
      description: g.startChildDesc,
      badge: g.badgeSetup,
      route: '/children',
    ),
    GuideStartStep(
      icon: Icons.assignment_outlined,
      title: g.startTracker,
      description: g.startTrackerDesc,
      badge: g.badgeRoutine,
      route: '/daily-tracker',
    ),
    GuideStartStep(
      icon: Icons.event_available_outlined,
      title: g.startAppointment,
      description: g.startAppointmentDesc,
      badge: g.badgeClinical,
      route: '/appointments',
    ),
    GuideStartStep(
      icon: Icons.verified_user_outlined,
      title: g.startPrivacy,
      description: g.startPrivacyDesc,
      badge: g.badgePrivacy,
      route: '/kvkk',
    ),
  ];
}

/// Veliye açık eğitim videoları — web `TUTORIAL_VIDEOS` içindeki GENERAL +
/// PARENT kayıtları (kimlikler web ile aynı; `?video=` bağlantısında kullanılır).
List<TutorialVideo> parentTutorialVideos(Translations t) {
  final g = t.guide;
  return [
    TutorialVideo(
      id: '01',
      title: g.video01,
      description: g.video01Desc,
      category: g.videoCategoryStart,
      duration: '31 sn',
    ),
    TutorialVideo(
      id: '02',
      title: g.video02,
      description: g.video02Desc,
      category: g.videoCategoryStart,
      duration: '56 sn',
    ),
    TutorialVideo(
      id: '03',
      title: g.video03,
      description: g.video03Desc,
      category: g.videoCategoryStart,
      duration: '31 sn',
    ),
    TutorialVideo(
      id: '04',
      title: g.video04,
      description: g.video04Desc,
      category: g.videoCategoryStart,
      duration: '29 sn',
    ),
    TutorialVideo(
      id: '05',
      title: g.video05,
      description: g.video05Desc,
      category: g.videoCategoryChild,
      duration: '26 sn',
    ),
    TutorialVideo(
      id: '06',
      title: g.video06,
      description: g.video06Desc,
      category: g.videoCategoryTracking,
      duration: '26 sn',
    ),
    TutorialVideo(
      id: '07',
      title: g.video07,
      description: g.video07Desc,
      category: g.videoCategoryTracking,
      duration: '26 sn',
    ),
    TutorialVideo(
      id: '08',
      title: g.video08,
      description: g.video08Desc,
      category: g.videoCategoryChild,
      duration: '26 sn',
    ),
    TutorialVideo(
      id: '09',
      title: g.video09,
      description: g.video09Desc,
      category: g.videoCategoryChild,
      duration: '31 sn',
    ),
    TutorialVideo(
      id: '10',
      title: g.video10,
      description: g.video10Desc,
      category: g.videoCategoryPlan,
      duration: '28 sn',
    ),
    TutorialVideo(
      id: '11',
      title: g.video11,
      description: g.video11Desc,
      category: g.videoCategorySupport,
      duration: '34 sn',
    ),
    TutorialVideo(
      id: '12',
      title: g.video12,
      description: g.video12Desc,
      category: g.videoCategoryPlan,
      duration: '28 sn',
    ),
    TutorialVideo(
      id: '13',
      title: g.video13,
      description: g.video13Desc,
      category: g.videoCategoryCommunity,
      duration: '28 sn',
    ),
    TutorialVideo(
      id: '14',
      title: g.video14,
      description: g.video14Desc,
      category: g.videoCategoryCommunity,
      duration: '42 sn',
    ),
    TutorialVideo(
      id: '15',
      title: g.video15,
      description: g.video15Desc,
      category: g.videoCategorySupport,
      duration: '35 sn',
    ),
  ];
}
