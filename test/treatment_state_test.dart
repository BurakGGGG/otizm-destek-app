import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/features/treatment/domain/treatment_plan.dart';
import 'package:otizm_destek_app/features/treatment/domain/treatment_state.dart';

void main() {
  group('TreatmentPageState JSON sözleşmesi (web ile birebir)', () {
    test('toJson anahtarları web TreatmentPageState ile aynı', () {
      const state = TreatmentPageState();
      expect(
        state.toJson().keys,
        containsAll([
          'gameFeedback',
          'customGoals',
          'sensoryProfile',
          'gameSessions',
          'goalProgressHistory',
          'templateGoalToggles',
          'completedPlanSteps',
          'customStories',
        ]),
      );
    });

    test('fromJson → toJson gidiş-dönüş alanları korur', () {
      final json = {
        'gameFeedback': {'2026-07-11:request-cards': 'easy'},
        'customGoals': [
          {
            'id': 'g1',
            'title': 'Göz teması',
            'focusKey': 'social',
            'done': true,
            'dueDate': '2026-08-01',
          },
        ],
        'sensoryProfile': {'sound': 40, 'touch': 60, 'visual': 80},
        'gameSessions': [
          {
            'gameId': 'turn-taking',
            'status': 'independent',
            'focusKey': 'social',
            'linkedGoal': 'Sosyal Beceriler',
            'completedAt': '2026-07-11T09:30:00.000Z',
          },
        ],
        'goalProgressHistory': [
          {'recordedAt': '2026-07-11T09:30:00.000Z', 'percent': 25},
        ],
        'templateGoalToggles': {'Sıra bekleme': true},
        'completedPlanSteps': ['2026-07-11:turn-flow'],
        'customStories': [
          {
            'id': 's1',
            'title': 'Alışverişe Gidiyorum',
            'icon': '🛒',
            'linkedGoal': 'Genel hedef',
          },
        ],
      };
      final state = TreatmentPageState.fromJson(json);
      expect(state.toJson(), json);
    });

    test('dueDate boşsa customGoals JSON anahtarı hiç yazılmaz (web gibi)', () {
      const goal = EditableGoal(
        id: 'g1',
        title: 'Deneme',
        focusKey: 'communication',
        done: false,
      );
      expect(goal.toJson().containsKey('dueDate'), isFalse);
    });

    test('eksik/boş gövdeden varsayılan duyusal profil (76/54/68)', () {
      final state = TreatmentPageState.fromJson(const {});
      expect(state.sensoryProfile.sound, 76);
      expect(state.sensoryProfile.touch, 54);
      expect(state.sensoryProfile.visual, 68);
    });
  });

  group('Saf durum geçişleri (web treatmentState.ts birebir)', () {
    test('gameFeedbackKey formatı yyyy-MM-dd:gameId', () {
      expect(gameFeedbackKey('2026-07-11', 'request-cards'),
          '2026-07-11:request-cards');
    });

    test('togglePlanStep ekler ve geri alır', () {
      final added = togglePlanStep(
        stepId: 'turn-flow',
        todayKey: '2026-07-11',
        completedPlanSteps: const [],
      );
      expect(added, ['2026-07-11:turn-flow']);
      final removed = togglePlanStep(
        stepId: 'turn-flow',
        todayKey: '2026-07-11',
        completedPlanSteps: added,
      );
      expect(removed, isEmpty);
    });

    test('toggleGameSessionForDay bugünün kaydını açar/kapatır', () {
      final games = kGameLibrary['social']!;
      final todayKey = treatmentDateKey(DateTime.now());
      final on = toggleGameSessionForDay(
        gameId: 'turn-taking',
        todayKey: todayKey,
        gameSessions: const [],
        gameFeedback: const {},
        games: games,
      );
      expect(on.gameSessions, hasLength(1));
      expect(on.gameSessions.first.status, 'assisted'); // varsayılan
      expect(on.gameSessions.first.linkedGoal, 'Sosyal Beceriler');

      final off = toggleGameSessionForDay(
        gameId: 'turn-taking',
        todayKey: todayKey,
        gameSessions: on.gameSessions,
        gameFeedback: on.gameFeedback,
        games: games,
      );
      expect(off.gameSessions, isEmpty);
    });

    test('saveGameFeedbackForDay gün anahtarlı geri bildirim + kayıt yazar',
        () {
      final games = kGameLibrary['communication']!;
      final todayKey = treatmentDateKey(DateTime.now());
      final result = saveGameFeedbackForDay(
        gameId: 'request-cards',
        status: 'independent',
        todayKey: todayKey,
        gameSessions: const [],
        gameFeedback: const {},
        games: games,
      );
      expect(result.gameFeedback['$todayKey:request-cards'], 'independent');
      expect(result.gameSessions.single.status, 'independent');
    });

    test('mergeGoalGroups şablon toggle + özel hedef yüzdesi', () {
      final base = buildGoalGroups(const [
        FocusArea(key: 'social', label: 'Sosyal beceri', reason: ''),
      ]);
      final merged = mergeGoalGroups(
        base,
        const [
          EditableGoal(
              id: 'g1', title: 'Özel', focusKey: 'social', done: true),
        ],
        const {'Sıra bekleme': true},
      );
      // 4 şablon + 1 özel = 5 öğe; 2 tamamlandı → %40.
      expect(merged.single.items, hasLength(5));
      expect(merged.single.percent, 40);
    });

    test('detectFocusAreas terapisiz varsayılan üç alanı verir', () {
      final areas = detectFocusAreas(const [], const []);
      expect(areas.map((a) => a.key),
          ['communication', 'social', 'sensory']);
    });
  });
}
