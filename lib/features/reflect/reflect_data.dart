import 'package:flutter/material.dart';

/// A curated ayah, or a short run of ayahs, paired with an original reflection.
///
/// Only the reflection is authored here. The Arabic and the English translation
/// are read from the bundled Quran database at render time, so Reflect shows
/// exactly the same Saheeh International text as the reader rather than a
/// second, divergent copy of it.
class ReflectVerse {
  final int surah;
  final int startAyah;
  final int? _endAyah;
  final String reflection;

  const ReflectVerse({
    required this.surah,
    required this.startAyah,
    int? endAyah,
    required this.reflection,
  }) : _endAyah = endAyah;

  int get endAyah => _endAyah ?? startAyah;
  bool get isRange => endAyah > startAyah;
  List<int> get ayahNumbers =>
      [for (var i = startAyah; i <= endAyah; i++) i];
}

class ReflectMood {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final List<ReflectVerse> verses;
  const ReflectMood({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.verses,
  });
}

const reflectMoods = <ReflectMood>[
  ReflectMood(
    id: 'anxious',
    title: 'Anxious',
    description: 'When the heart is heavy and the mind races',
    icon: Icons.sentiment_very_dissatisfied,
    color: Color(0xFF6366F1),
    verses: [
      ReflectVerse(
        surah: 13,
        startAyah: 28,
        reflection:
            'Anxiety softens when the tongue and heart return to dhikr. Try a slow, deliberate Subhan Allah, Alhamdulillah, La ilaha illa Allah, Allahu akbar.',
      ),
      ReflectVerse(
        surah: 65,
        startAyah: 3,
        reflection:
            'Tawakkul is not passivity. Do your part, then release the outcome to the One who holds it.',
      ),
      ReflectVerse(
        surah: 2,
        startAyah: 286,
        reflection:
            'What you are carrying right now is, by definition, within your capacity. Allah has already confirmed it.',
      ),
      ReflectVerse(
        surah: 94,
        startAyah: 5,
        endAyah: 6,
        reflection:
            'The ease does not come after the hardship. It comes with it. Look for it today, not tomorrow.',
      ),
      ReflectVerse(
        surah: 39,
        startAyah: 53,
        reflection:
            'Whatever you are carrying, He is bigger than it. Despair itself is a closed door; repentance is an open one.',
      ),
      ReflectVerse(
        surah: 3,
        startAyah: 173,
        reflection:
            'Repeat this when fear rises. It is the dua of those who walked into fire and found a garden.',
      ),
    ],
  ),
  ReflectMood(
    id: 'grateful',
    title: 'Grateful',
    description: 'When the heart wants to thank',
    icon: Icons.favorite,
    color: Color(0xFFEC4899),
    verses: [
      ReflectVerse(
        surah: 14,
        startAyah: 7,
        reflection:
            'Gratitude is not only a response to blessing. It is also a cause of more of it.',
      ),
      ReflectVerse(
        surah: 16,
        startAyah: 18,
        reflection:
            'Name three right now. Your breath. A person who loves you. The moment of peace you are in.',
      ),
      ReflectVerse(
        surah: 2,
        startAyah: 152,
        reflection:
            'A remembrance exchanged. You take one step and He takes ten.',
      ),
      ReflectVerse(
        surah: 27,
        startAyah: 19,
        reflection:
            'Even the ability to be grateful is a favor from Him. Ask for it.',
      ),
      ReflectVerse(
        surah: 1,
        startAyah: 2,
        reflection:
            'The first phrase of the Book. Say it as if you mean every letter.',
      ),
      ReflectVerse(
        surah: 27,
        startAyah: 40,
        reflection:
            'Sulayman said this at the peak of his power, not his need. Gratitude is a test in abundance just as patience is a test in loss.',
      ),
    ],
  ),
  ReflectMood(
    id: 'grieving',
    title: 'Grieving',
    description: 'When loss presses against the chest',
    icon: Icons.cloud,
    color: Color(0xFF64748B),
    verses: [
      ReflectVerse(
        surah: 2,
        startAyah: 155,
        endAyah: 156,
        reflection:
            'Loss returns you to a deeper truth. You belonged to Him before the loss, and still do.',
      ),
      ReflectVerse(
        surah: 57,
        startAyah: 22,
        reflection:
            'Nothing that reached you was ever going to miss you. Nothing that missed you was ever meant for you.',
      ),
      ReflectVerse(
        surah: 21,
        startAyah: 83,
        reflection:
            'He did not hide his pain. He named it to the One who could answer it.',
      ),
      ReflectVerse(
        surah: 3,
        startAyah: 139,
        reflection:
            'Grief is permitted. Weakening faith is not. Hold both truths.',
      ),
      ReflectVerse(
        surah: 39,
        startAyah: 10,
        reflection:
            'No ledger, no cap, no measure. The reward for enduring is beyond calculation.',
      ),
      ReflectVerse(
        surah: 12,
        startAyah: 86,
        reflection:
            'Yaqub had every reason to complain to people, and took it to Allah instead. Grief spoken upward is worship, not weakness.',
      ),
    ],
  ),
  ReflectMood(
    id: 'guidance',
    title: 'Seeking Guidance',
    description: 'When the path is unclear',
    icon: Icons.navigation,
    color: Color(0xFF10B981),
    verses: [
      ReflectVerse(
        surah: 1,
        startAyah: 6,
        endAyah: 7,
        reflection:
            'You ask for this seventeen times a day in salah. Mean it once.',
      ),
      ReflectVerse(
        surah: 29,
        startAyah: 69,
        reflection:
            'Guidance is not downloaded. It is walked into. Take one step toward Him.',
      ),
      ReflectVerse(
        surah: 2,
        startAyah: 2,
        reflection:
            'The guidance is already written. Open the Book.',
      ),
      ReflectVerse(
        surah: 10,
        startAyah: 57,
        reflection:
            'The Quran is not only direction. It is medicine.',
      ),
      ReflectVerse(
        surah: 24,
        startAyah: 35,
        reflection:
            'When you cannot see, turn toward the Light. The light does not need you to see it to be real.',
      ),
      ReflectVerse(
        surah: 18,
        startAyah: 24,
        reflection:
            'Even the Prophet was taught to say \'perhaps\'. Certainty about tomorrow was never yours to hold; only the asking is.',
      ),
    ],
  ),
  ReflectMood(
    id: 'faith',
    title: 'Struggling with Faith',
    description: 'When belief feels distant',
    icon: Icons.healing,
    color: Color(0xFF8B5CF6),
    verses: [
      ReflectVerse(
        surah: 50,
        startAyah: 16,
        reflection:
            'Even when He feels far, He is closer than the pulse in your neck. Distance is a feeling, not a fact.',
      ),
      ReflectVerse(
        surah: 2,
        startAyah: 186,
        reflection:
            'He does not need an appointment. Speak to Him where you are.',
      ),
      ReflectVerse(
        surah: 40,
        startAyah: 60,
        reflection:
            'The invitation was issued before you were born. The line is always open.',
      ),
      ReflectVerse(
        surah: 39,
        startAyah: 53,
        reflection:
            'Whatever distance you feel, He closes it the moment you turn.',
      ),
      ReflectVerse(
        surah: 65,
        startAyah: 3,
        reflection:
            'Sufficient. Not barely enough. Sufficient.',
      ),
      ReflectVerse(
        surah: 2,
        startAyah: 260,
        reflection:
            'Ibrahim already believed. He asked to see anyway, so that his heart would settle. Wanting reassurance is not the same as doubting.',
      ),
    ],
  ),
  ReflectMood(
    id: 'forgiveness',
    title: 'Seeking Forgiveness',
    description: 'When the heart carries a burden',
    icon: Icons.spa,
    color: Color(0xFF14B8A6),
    verses: [
      ReflectVerse(
        surah: 39,
        startAyah: 53,
        reflection:
            'All sins. Not most. Not the small ones. All of them, when turned from sincerely.',
      ),
      ReflectVerse(
        surah: 3,
        startAyah: 135,
        reflection:
            'Remembering Him right after slipping is itself a sign of faith returning.',
      ),
      ReflectVerse(
        surah: 4,
        startAyah: 110,
        reflection:
            'The door is not locked. It was never locked.',
      ),
      ReflectVerse(
        surah: 71,
        startAyah: 10,
        endAyah: 12,
        reflection:
            'Istighfar is not only closure. It is opening.',
      ),
      ReflectVerse(
        surah: 66,
        startAyah: 8,
        reflection:
            'Sincere means you mean it this time. Not that you have never slipped before.',
      ),
      ReflectVerse(
        surah: 20,
        startAyah: 82,
        reflection:
            'Repents, believes, does righteousness, then continues. Forgiveness is offered at the first step, not withheld until the last.',
      ),
    ],
  ),
  ReflectMood(
    id: 'patience',
    title: 'Needing Patience',
    description: 'When endurance is the only road',
    icon: Icons.hourglass_bottom,
    color: Color(0xFFF59E0B),
    verses: [
      ReflectVerse(
        surah: 2,
        startAyah: 153,
        reflection:
            'Patience is not passive waiting. It is active endurance while trusting.',
      ),
      ReflectVerse(
        surah: 39,
        startAyah: 10,
        reflection:
            'What you cannot measure in this life, He measures in the next.',
      ),
      ReflectVerse(
        surah: 16,
        startAyah: 127,
        reflection:
            'You do not have to summon patience from inside yourself. Ask Him for it.',
      ),
      ReflectVerse(
        surah: 103,
        startAyah: 1,
        endAyah: 3,
        reflection:
            'An entire surah whose solution ends with patience. Keep going.',
      ),
      ReflectVerse(
        surah: 70,
        startAyah: 5,
        reflection:
            'Gracious patience: sabr without the running commentary of complaint. The instruction is about how you wait, not how long.',
      ),
      ReflectVerse(
        surah: 8,
        startAyah: 46,
        reflection:
            'Patience here is not endurance alone. It is company: the promise is that He is with you while you wait, not only after.',
      ),
    ],
  ),
  ReflectMood(
    id: 'joyful',
    title: 'Joyful',
    description: 'When the soul is light',
    icon: Icons.wb_sunny,
    color: Color(0xFFFBBF24),
    verses: [
      ReflectVerse(
        surah: 10,
        startAyah: 58,
        reflection:
            'The real joy is not in what you gained. It is in who gave it.',
      ),
      ReflectVerse(
        surah: 16,
        startAyah: 97,
        reflection:
            'The good life is promised in this world, not only the next. Savor it when it visits you.',
      ),
      ReflectVerse(
        surah: 89,
        startAyah: 27,
        endAyah: 30,
        reflection:
            'The call you are listening for will come one day. Live toward it.',
      ),
      ReflectVerse(
        surah: 14,
        startAyah: 7,
        reflection:
            'Joy held well becomes more joy. Share, thank, smile at a stranger.',
      ),
      ReflectVerse(
        surah: 57,
        startAyah: 21,
        reflection:
            'Channel the energy forward. Not every joyful moment needs a reason.',
      ),
      ReflectVerse(
        surah: 55,
        startAyah: 13,
        reflection:
            'A question the surah asks thirty-one times. On a good day it is not a rebuke, it is an invitation to count what is in front of you.',
      ),
    ],
  ),
  ReflectMood(
    id: 'lonely',
    title: 'Lonely',
    description: 'When no one seems near enough to tell',
    icon: Icons.person_outline,
    color: Color(0xFF0EA5E9),
    verses: [
      ReflectVerse(
        surah: 2,
        startAyah: 186,
        reflection:
            'He did not say \'tell them I am near\'. He answered the question Himself, in the first person, without an intermediary.',
      ),
      ReflectVerse(
        surah: 50,
        startAyah: 16,
        reflection:
            'Nearer than the vein that keeps you alive. Loneliness is a feeling, and it is not a description of your actual situation.',
      ),
      ReflectVerse(
        surah: 9,
        startAyah: 40,
        reflection:
            'Said inside a cave, hunted, with one companion and no plan. The company that mattered was already there.',
      ),
      ReflectVerse(
        surah: 93,
        startAyah: 3,
        reflection:
            'Revealed after a silence that made the Prophet fear he had been abandoned. Silence from Allah is not absence.',
      ),
      ReflectVerse(
        surah: 20,
        startAyah: 46,
        reflection:
            'Before Musa faced Pharaoh he was given this, not a strategy. Being heard and seen came first.',
      ),
    ],
  ),
  ReflectMood(
    id: 'angry',
    title: 'Angry',
    description: 'When something has made your chest tight',
    icon: Icons.local_fire_department_outlined,
    color: Color(0xFFDC2626),
    verses: [
      ReflectVerse(
        surah: 3,
        startAyah: 134,
        reflection:
            'Restraining anger is listed as an act of spending, beside charity. It costs you something, and it is counted.',
      ),
      ReflectVerse(
        surah: 41,
        startAyah: 34,
        reflection:
            'Not merely repel evil, but repel it with what is better. The instruction assumes you have the worse response available and choose past it.',
      ),
      ReflectVerse(
        surah: 7,
        startAyah: 199,
        reflection:
            'Three moves in one verse: accept what is easy, ask for good, walk away from the argument you would win.',
      ),
      ReflectVerse(
        surah: 42,
        startAyah: 43,
        reflection:
            'Patience and pardon are called matters of resolve, which is to say they are strength, not the absence of it.',
      ),
      ReflectVerse(
        surah: 25,
        startAyah: 63,
        reflection:
            'The answer to being addressed harshly is one word: peace. It ends the exchange without conceding anything.',
      ),
    ],
  ),
  ReflectMood(
    id: 'afraid',
    title: 'Afraid',
    description: 'When a specific thing frightens you',
    icon: Icons.shield_outlined,
    color: Color(0xFF7C3AED),
    verses: [
      ReflectVerse(
        surah: 3,
        startAyah: 173,
        reflection:
            'Said by people who had just been told their enemy was massing against them. The fear was accurate; the conclusion was still this.',
      ),
      ReflectVerse(
        surah: 10,
        startAyah: 62,
        reflection:
            'No fear and no grief, covering both directions at once: what is coming and what has already gone.',
      ),
      ReflectVerse(
        surah: 41,
        startAyah: 30,
        reflection:
            'The reassurance is promised to those who stood firm, not to those who felt no fear. Steadiness is the condition, not calm.',
      ),
      ReflectVerse(
        surah: 3,
        startAyah: 160,
        reflection:
            'Aid from Him cannot be overcome. The verse asks you to be clear about which of these two you are relying on.',
      ),
      ReflectVerse(
        surah: 9,
        startAyah: 51,
        reflection:
            'Nothing reaches you outside what has been written. That does not make the danger smaller, it makes it accounted for.',
      ),
    ],
  ),
  ReflectMood(
    id: 'provision',
    title: 'Worried about money',
    description: 'When provision feels uncertain',
    icon: Icons.savings_outlined,
    color: Color(0xFF059669),
    verses: [
      ReflectVerse(
        surah: 42,
        startAyah: 19,
        reflection:
            'Subtle with His servants. Provision often arrives by a route too quiet to notice while you are busy watching the obvious one.',
      ),
      ReflectVerse(
        surah: 11,
        startAyah: 6,
        reflection:
            'Every creature on earth, without exception, and the responsibility is placed on Him. You are inside that sentence.',
      ),
      ReflectVerse(
        surah: 29,
        startAyah: 60,
        reflection:
            'Creatures that store nothing are fed. The comparison is not an insult; it is meant to loosen your grip.',
      ),
      ReflectVerse(
        surah: 51,
        startAyah: 22,
        reflection:
            'Your provision is described as already existing, in the heaven, waiting. It is not being manufactured in response to your panic.',
      ),
      ReflectVerse(
        surah: 2,
        startAyah: 268,
        reflection:
            'Notice who is doing the threatening. Poverty as a whispered threat is named here as a tactic, not a forecast.',
      ),
    ],
  ),
  ReflectMood(
    id: 'unwell',
    title: 'Unwell',
    description: 'When your body is failing you',
    icon: Icons.healing_outlined,
    color: Color(0xFFEC4899),
    verses: [
      ReflectVerse(
        surah: 26,
        startAyah: 80,
        reflection:
            'Ibrahim attributes the illness to no one and the cure to Him. Take the medicine and know where the healing comes from.',
      ),
      ReflectVerse(
        surah: 21,
        startAyah: 83,
        reflection:
            'Ayyub\'s complaint is two clauses long. He states his condition, then states who Allah is, and stops there.',
      ),
      ReflectVerse(
        surah: 2,
        startAyah: 153,
        reflection:
            'Two things to reach for when strength runs out, and both are available from a sickbed.',
      ),
      ReflectVerse(
        surah: 10,
        startAyah: 57,
        reflection:
            'Healing for what is in the chest is named before any physical cure. Some of what hurts is not in the body.',
      ),
      ReflectVerse(
        surah: 17,
        startAyah: 82,
        reflection:
            'Sent down as healing and mercy. On the days you cannot pray standing, you can still be read to.',
      ),
    ],
  ),
  ReflectMood(
    id: 'wronged',
    title: 'Wronged',
    description: 'When you have been treated unjustly',
    icon: Icons.balance_outlined,
    color: Color(0xFFB45309),
    verses: [
      ReflectVerse(
        surah: 14,
        startAyah: 42,
        reflection:
            'Not unaware, only delaying. The verse corrects the assumption that nothing happening now means nothing is happening.',
      ),
      ReflectVerse(
        surah: 42,
        startAyah: 41,
        reflection:
            'Responding to injustice is permitted and blameless. Being wronged does not oblige you to be silent.',
      ),
      ReflectVerse(
        surah: 4,
        startAyah: 148,
        reflection:
            'An explicit exception for the one who has been wronged. Naming what was done to you is not backbiting.',
      ),
      ReflectVerse(
        surah: 40,
        startAyah: 60,
        reflection:
            'Call upon Me and I will respond. The one door that cannot be closed to you by whoever closed the others.',
      ),
      ReflectVerse(
        surah: 3,
        startAyah: 200,
        reflection:
            'Persevere, endure, remain stationed. Three verbs, all of them active. Waiting for justice is not passivity.',
      ),
    ],
  ),
];

ReflectMood? moodById(String id) {
  for (final m in reflectMoods) {
    if (m.id == id) return m;
  }
  return null;
}

/// Every (surah, ayah) pair Reflect needs, ranges expanded.
List<(int, int)> allReflectRefs() => [
      for (final mood in reflectMoods)
        for (final verse in mood.verses)
          for (final ayah in verse.ayahNumbers) (verse.surah, ayah),
    ];
