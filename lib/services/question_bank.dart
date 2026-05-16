import '../models/question_model.dart';

class QuestionBank {
  /// Returns up to [count] questions for the given subject+difficulty,
  /// never repeating IDs in [excludeIds].
  static List<Question> getQuestions({
    required String subjectId,
    required String difficulty,
    int count = 10,
    Set<String> excludeIds = const {},
  }) {
    // All questions matching subject + difficulty, not yet used
    var pool = _allQuestions
        .where((q) =>
            q.subjectId == subjectId &&
            q.difficulty == difficulty &&
            !excludeIds.contains(q.id))
        .toList();

    // If pool is empty after exclusion, fallback: same subject any difficulty
    if (pool.isEmpty) {
      pool = _allQuestions
          .where((q) =>
              q.subjectId == subjectId && !excludeIds.contains(q.id))
          .toList();
    }

    // If still empty, use everything for this subject (reset)
    if (pool.isEmpty) {
      pool = _allQuestions
          .where((q) => q.subjectId == subjectId)
          .toList();
    }

    pool.shuffle();
    return pool.take(count).toList();
  }

  /// Returns all question IDs for a subject+difficulty (used for pool-reset logic)
  static List<String> getAllIds({
    required String subjectId,
    required String difficulty,
  }) {
    return _allQuestions
        .where((q) => q.subjectId == subjectId && q.difficulty == difficulty)
        .map((q) => q.id)
        .toList();
  }

  static final List<Question> _allQuestions = [
    // ── MATHEMATICS – EASY ──────────────────────────────────────────────────
    Question(
      id: 'math_e_1', subjectId: 'mathematics', gameMode: 'quick_calc',
      question: 'What is 7 × 8?',
      options: ['54', '56', '64', '48'], correctIndex: 1,
      explanation: '7 × 8 = 56. Think: 7 × 4 = 28, then × 2 = 56',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),
    Question(
      id: 'math_e_2', subjectId: 'mathematics', gameMode: 'quick_calc',
      question: 'What is 45 + 36?',
      options: ['71', '81', '79', '91'], correctIndex: 1,
      explanation: '45 + 36 = 81',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),
    Question(
      id: 'math_e_3', subjectId: 'mathematics', gameMode: 'quick_calc',
      question: 'What is half of 64?',
      options: ['28', '34', '32', '36'], correctIndex: 2,
      explanation: '64 ÷ 2 = 32',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),
    Question(
      id: 'math_e_4', subjectId: 'mathematics', gameMode: 'quick_calc',
      question: 'Which is the largest prime number below 20?',
      options: ['17', '19', '15', '13'], correctIndex: 1,
      explanation: '19 is prime and is the largest prime below 20.',
      difficulty: 'easy', points: 10, timeSeconds: 25,
    ),
    Question(
      id: 'math_e_5', subjectId: 'mathematics', gameMode: 'quick_calc',
      question: 'A square has sides of 5 cm. What is its perimeter?',
      options: ['20 cm', '25 cm', '15 cm', '10 cm'], correctIndex: 0,
      explanation: 'Perimeter = 4 × side = 4 × 5 = 20 cm',
      difficulty: 'easy', points: 10, timeSeconds: 25,
    ),
    Question(
      id: 'math_e_6', subjectId: 'mathematics', gameMode: 'quick_calc',
      question: 'What is 15% of 200?',
      options: ['25', '30', '35', '20'], correctIndex: 1,
      explanation: '15% of 200 = 0.15 × 200 = 30',
      difficulty: 'easy', points: 10, timeSeconds: 25,
    ),
    Question(
      id: 'math_e_7', subjectId: 'mathematics', gameMode: 'quick_calc',
      question: 'What is 12²?',
      options: ['124', '144', '132', '148'], correctIndex: 1,
      explanation: '12² = 12 × 12 = 144',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),
    Question(
      id: 'math_e_8', subjectId: 'mathematics', gameMode: 'quick_calc',
      question: 'A pizza is cut into 8 slices. You eat 3. What fraction is left?',
      options: ['3/8', '5/8', '1/2', '2/3'], correctIndex: 1,
      explanation: '8 - 3 = 5 slices left. Fraction = 5/8',
      difficulty: 'easy', points: 10, timeSeconds: 30,
    ),
    Question(
      id: 'math_e_9', subjectId: 'mathematics', gameMode: 'quick_calc',
      question: 'What is 9 × 9?',
      options: ['72', '81', '79', '90'], correctIndex: 1,
      explanation: '9 × 9 = 81',
      difficulty: 'easy', points: 10, timeSeconds: 15,
    ),
    Question(
      id: 'math_e_10', subjectId: 'mathematics', gameMode: 'quick_calc',
      question: 'What is 100 ÷ 4?',
      options: ['20', '25', '30', '40'], correctIndex: 1,
      explanation: '100 ÷ 4 = 25',
      difficulty: 'easy', points: 10, timeSeconds: 15,
    ),
    Question(
      id: 'math_e_11', subjectId: 'mathematics', gameMode: 'quick_calc',
      question: 'What is 3 + 4 × 2?',
      options: ['14', '11', '10', '7'], correctIndex: 1,
      explanation: 'BODMAS: multiply first. 4 × 2 = 8, then 3 + 8 = 11',
      difficulty: 'easy', points: 10, timeSeconds: 25,
    ),
    Question(
      id: 'math_e_12', subjectId: 'mathematics', gameMode: 'quick_calc',
      question: 'How many sides does a hexagon have?',
      options: ['5', '7', '6', '8'], correctIndex: 2,
      explanation: 'A hexagon has 6 sides. Hex = 6 in Greek.',
      difficulty: 'easy', points: 10, timeSeconds: 15,
    ),

    // ── MATHEMATICS – MEDIUM ─────────────────────────────────────────────────
    Question(
      id: 'math_m_1', subjectId: 'mathematics', gameMode: 'quick_calc',
      question: 'Solve: 3x + 7 = 22. What is x?',
      options: ['4', '5', '6', '7'], correctIndex: 1,
      explanation: '3x = 15, x = 5',
      difficulty: 'medium', points: 20, timeSeconds: 30,
    ),
    Question(
      id: 'math_m_2', subjectId: 'mathematics', gameMode: 'quick_calc',
      question: 'Area of a triangle with base 10 cm and height 8 cm?',
      options: ['80 cm²', '40 cm²', '45 cm²', '60 cm²'], correctIndex: 1,
      explanation: 'Area = ½ × 10 × 8 = 40 cm²',
      difficulty: 'medium', points: 20, timeSeconds: 35,
    ),
    Question(
      id: 'math_m_3', subjectId: 'mathematics', gameMode: 'quick_calc',
      question: 'A train travels 240 km in 3 hours. What is its speed?',
      options: ['70 km/h', '80 km/h', '90 km/h', '60 km/h'], correctIndex: 1,
      explanation: 'Speed = 240 ÷ 3 = 80 km/h',
      difficulty: 'medium', points: 20, timeSeconds: 30,
    ),
    Question(
      id: 'math_m_4', subjectId: 'mathematics', gameMode: 'puzzle',
      question: 'What is the LCM of 12 and 18?',
      options: ['24', '36', '48', '72'], correctIndex: 1,
      explanation: 'LCM(12,18) = 36',
      difficulty: 'medium', points: 20, timeSeconds: 35,
    ),
    Question(
      id: 'math_m_5', subjectId: 'mathematics', gameMode: 'quick_calc',
      question: 'What is 25% of 360?',
      options: ['80', '90', '75', '100'], correctIndex: 1,
      explanation: '25% = ¼. 360 ÷ 4 = 90',
      difficulty: 'medium', points: 20, timeSeconds: 30,
    ),
    Question(
      id: 'math_m_6', subjectId: 'mathematics', gameMode: 'quick_calc',
      question: 'What is the value of √144?',
      options: ['11', '14', '12', '13'], correctIndex: 2,
      explanation: '√144 = 12 because 12 × 12 = 144',
      difficulty: 'medium', points: 20, timeSeconds: 25,
    ),

    // ── MATHEMATICS – HARD ───────────────────────────────────────────────────
    Question(
      id: 'math_h_1', subjectId: 'mathematics', gameMode: 'quick_calc',
      question: 'If 2^n = 64, what is n?',
      options: ['4', '5', '6', '7'], correctIndex: 2,
      explanation: '2^6 = 64',
      difficulty: 'hard', points: 30, timeSeconds: 25,
    ),
    Question(
      id: 'math_h_2', subjectId: 'mathematics', gameMode: 'quick_calc',
      question: 'Sum of interior angles of a hexagon?',
      options: ['540°', '720°', '900°', '1080°'], correctIndex: 1,
      explanation: '(6-2) × 180 = 720°',
      difficulty: 'hard', points: 30, timeSeconds: 30,
    ),
    Question(
      id: 'math_h_3', subjectId: 'mathematics', gameMode: 'quick_calc',
      question: 'What is the HCF of 48 and 72?',
      options: ['12', '24', '36', '6'], correctIndex: 1,
      explanation: 'HCF(48,72) = 24',
      difficulty: 'hard', points: 30, timeSeconds: 35,
    ),

    // ── SCIENCE – EASY ───────────────────────────────────────────────────────
    Question(
      id: 'sci_e_1', subjectId: 'science', gameMode: 'quiz',
      question: 'What is the largest planet in our solar system?',
      options: ['Saturn', 'Jupiter', 'Uranus', 'Neptune'], correctIndex: 1,
      explanation: 'Jupiter is the largest planet!',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),
    Question(
      id: 'sci_e_2', subjectId: 'science', gameMode: 'quiz',
      question: 'How many bones does an adult human body have?',
      options: ['196', '206', '216', '226'], correctIndex: 1,
      explanation: 'Adults have 206 bones.',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),
    Question(
      id: 'sci_e_3', subjectId: 'science', gameMode: 'quiz',
      question: 'What gas do plants absorb during photosynthesis?',
      options: ['Oxygen', 'Nitrogen', 'Carbon Dioxide', 'Hydrogen'], correctIndex: 2,
      explanation: 'Plants absorb CO₂ and release O₂.',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),
    Question(
      id: 'sci_e_4', subjectId: 'science', gameMode: 'quiz',
      question: 'What is the chemical symbol for water?',
      options: ['WA', 'HO', 'H₂O', 'W₂O'], correctIndex: 2,
      explanation: 'Water = H₂O',
      difficulty: 'easy', points: 10, timeSeconds: 15,
    ),
    Question(
      id: 'sci_e_5', subjectId: 'science', gameMode: 'quiz',
      question: 'Which planet is known as the Red Planet?',
      options: ['Venus', 'Mercury', 'Mars', 'Jupiter'], correctIndex: 2,
      explanation: 'Mars appears red due to iron oxide.',
      difficulty: 'easy', points: 10, timeSeconds: 15,
    ),
    Question(
      id: 'sci_e_6', subjectId: 'science', gameMode: 'quiz',
      question: 'What is the powerhouse of the cell?',
      options: ['Nucleus', 'Mitochondria', 'Ribosome', 'Golgi Body'], correctIndex: 1,
      explanation: 'Mitochondria produce ATP energy.',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),
    Question(
      id: 'sci_e_7', subjectId: 'science', gameMode: 'quiz',
      question: 'How many moons does Mars have?',
      options: ['0', '1', '2', '4'], correctIndex: 2,
      explanation: 'Mars has 2 moons: Phobos and Deimos.',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),
    Question(
      id: 'sci_e_8', subjectId: 'science', gameMode: 'quiz',
      question: 'What force keeps us on the ground?',
      options: ['Magnetism', 'Friction', 'Gravity', 'Tension'], correctIndex: 2,
      explanation: 'Gravity pulls objects toward Earth.',
      difficulty: 'easy', points: 10, timeSeconds: 15,
    ),
    Question(
      id: 'sci_e_9', subjectId: 'science', gameMode: 'quiz',
      question: 'What is the closest star to Earth?',
      options: ['Sirius', 'The Sun', 'Polaris', 'Betelgeuse'], correctIndex: 1,
      explanation: 'The Sun is our nearest star, about 150 million km away.',
      difficulty: 'easy', points: 10, timeSeconds: 15,
    ),
    Question(
      id: 'sci_e_10', subjectId: 'science', gameMode: 'quiz',
      question: 'Which animal is known as the King of the Jungle?',
      options: ['Tiger', 'Elephant', 'Lion', 'Cheetah'], correctIndex: 2,
      explanation: 'The lion is called the King of the Jungle.',
      difficulty: 'easy', points: 10, timeSeconds: 15,
    ),
    Question(
      id: 'sci_e_11', subjectId: 'science', gameMode: 'quiz',
      question: 'How many legs does a spider have?',
      options: ['6', '8', '10', '12'], correctIndex: 1,
      explanation: 'Spiders are arachnids and have 8 legs.',
      difficulty: 'easy', points: 10, timeSeconds: 15,
    ),
    Question(
      id: 'sci_e_12', subjectId: 'science', gameMode: 'quiz',
      question: 'What do you call a baby frog?',
      options: ['Cub', 'Tadpole', 'Larva', 'Foal'], correctIndex: 1,
      explanation: 'A baby frog is called a tadpole.',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),

    // ── SCIENCE – MEDIUM ─────────────────────────────────────────────────────
    Question(
      id: 'sci_m_1', subjectId: 'science', gameMode: 'quiz',
      question: 'What is the speed of light in vacuum?',
      options: ['3×10⁶ m/s', '3×10⁸ m/s', '3×10¹⁰ m/s', '3×10⁴ m/s'], correctIndex: 1,
      explanation: 'Light travels at ~3×10⁸ m/s.',
      difficulty: 'medium', points: 20, timeSeconds: 25,
    ),
    Question(
      id: 'sci_m_2', subjectId: 'science', gameMode: 'quiz',
      question: 'Which part of the brain controls balance?',
      options: ['Cerebrum', 'Cerebellum', 'Medulla', 'Hypothalamus'], correctIndex: 1,
      explanation: 'The cerebellum coordinates movement and balance.',
      difficulty: 'medium', points: 20, timeSeconds: 25,
    ),
    Question(
      id: 'sci_m_3', subjectId: 'science', gameMode: 'quiz',
      question: 'What is Newton\'s second law of motion?',
      options: ['F = ma', 'E = mc²', 'P = mv', 'W = Fd'], correctIndex: 0,
      explanation: 'Force = Mass × Acceleration',
      difficulty: 'medium', points: 20, timeSeconds: 25,
    ),
    Question(
      id: 'sci_m_4', subjectId: 'science', gameMode: 'quiz',
      question: 'What is the chemical formula for table salt?',
      options: ['KCl', 'NaCl', 'MgCl₂', 'CaCl₂'], correctIndex: 1,
      explanation: 'Table salt is Sodium Chloride (NaCl).',
      difficulty: 'medium', points: 20, timeSeconds: 25,
    ),

    // ── HISTORY – EASY ───────────────────────────────────────────────────────
    Question(
      id: 'hist_e_1', subjectId: 'history', gameMode: 'timeline',
      question: 'In which year did India gain independence?',
      options: ['1945', '1946', '1947', '1948'], correctIndex: 2,
      explanation: 'India gained independence on 15 August 1947.',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),
    Question(
      id: 'hist_e_2', subjectId: 'history', gameMode: 'quiz',
      question: 'Who was the first President of the United States?',
      options: ['Abraham Lincoln', 'Thomas Jefferson', 'George Washington', 'John Adams'], correctIndex: 2,
      explanation: 'George Washington served as the first US President (1789–1797).',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),
    Question(
      id: 'hist_e_3', subjectId: 'history', gameMode: 'quiz',
      question: 'Which ancient wonder was located in Egypt?',
      options: ['Colosseum', 'Great Pyramid of Giza', 'Colossus of Rhodes', 'Hanging Gardens'], correctIndex: 1,
      explanation: 'The Great Pyramid of Giza is the only ancient wonder still standing!',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),
    Question(
      id: 'hist_e_4', subjectId: 'history', gameMode: 'quiz',
      question: 'Who built the Taj Mahal?',
      options: ['Akbar', 'Shah Jahan', 'Aurangzeb', 'Babur'], correctIndex: 1,
      explanation: 'Shah Jahan built it in memory of his wife Mumtaz Mahal.',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),
    Question(
      id: 'hist_e_5', subjectId: 'history', gameMode: 'quiz',
      question: 'The ancient Olympics were held in which country?',
      options: ['Rome', 'Egypt', 'Greece', 'Persia'], correctIndex: 2,
      explanation: 'The ancient Olympics originated in Olympia, Greece (~776 BC).',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),
    Question(
      id: 'hist_e_6', subjectId: 'history', gameMode: 'quiz',
      question: 'Who wrote the Indian National Anthem?',
      options: ['Mahatma Gandhi', 'Rabindranath Tagore', 'Jawaharlal Nehru', 'B.R. Ambedkar'], correctIndex: 1,
      explanation: 'Rabindranath Tagore wrote "Jana Gana Mana".',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),
    Question(
      id: 'hist_e_7', subjectId: 'history', gameMode: 'quiz',
      question: 'Which civilization built Machu Picchu?',
      options: ['Aztec', 'Maya', 'Inca', 'Olmec'], correctIndex: 2,
      explanation: 'Machu Picchu was built by the Inca Empire in the 15th century.',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),
    Question(
      id: 'hist_e_8', subjectId: 'history', gameMode: 'quiz',
      question: 'What was the name of the ship that sank in 1912?',
      options: ['Lusitania', 'Titanic', 'Britannic', 'Olympic'], correctIndex: 1,
      explanation: 'RMS Titanic sank on April 15, 1912.',
      difficulty: 'easy', points: 10, timeSeconds: 15,
    ),
    Question(
      id: 'hist_e_9', subjectId: 'history', gameMode: 'quiz',
      question: 'Which country was the first to land a man on the Moon?',
      options: ['Russia', 'China', 'USA', 'UK'], correctIndex: 2,
      explanation: 'USA landed Apollo 11 on the Moon in July 1969.',
      difficulty: 'easy', points: 10, timeSeconds: 15,
    ),
    Question(
      id: 'hist_e_10', subjectId: 'history', gameMode: 'quiz',
      question: 'Who invented the telephone?',
      options: ['Thomas Edison', 'Alexander Graham Bell', 'Nikola Tesla', 'Marconi'], correctIndex: 1,
      explanation: 'Alexander Graham Bell patented the telephone in 1876.',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),
    Question(
      id: 'hist_e_11', subjectId: 'history', gameMode: 'quiz',
      question: 'Which empire was ruled by Julius Caesar?',
      options: ['Greek', 'Roman', 'Ottoman', 'Persian'], correctIndex: 1,
      explanation: 'Julius Caesar was a Roman general and statesman.',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),
    Question(
      id: 'hist_e_12', subjectId: 'history', gameMode: 'quiz',
      question: 'Where was Napoleon Bonaparte born?',
      options: ['France', 'Italy', 'Corsica', 'Spain'], correctIndex: 2,
      explanation: 'Napoleon was born in Ajaccio, Corsica, in 1769.',
      difficulty: 'easy', points: 10, timeSeconds: 25,
    ),

    // ── LOGICAL REASONING – EASY ─────────────────────────────────────────────
    Question(
      id: 'logic_e_1', subjectId: 'logic', gameMode: 'puzzle',
      question: 'What comes next? 2, 4, 8, 16, ___',
      options: ['24', '32', '28', '36'], correctIndex: 1,
      explanation: 'Each number doubles: 16 × 2 = 32',
      difficulty: 'easy', points: 10, timeSeconds: 25,
    ),
    Question(
      id: 'logic_e_3', subjectId: 'logic', gameMode: 'puzzle',
      question: 'Complete: 1, 1, 2, 3, 5, 8, ___',
      options: ['11', '12', '13', '14'], correctIndex: 2,
      explanation: 'Fibonacci: each number = sum of previous two. 5+8=13',
      difficulty: 'easy', points: 10, timeSeconds: 25,
    ),
    Question(
      id: 'logic_e_4', subjectId: 'logic', gameMode: 'puzzle',
      question: 'All cats are animals. Whiskers is a cat. Whiskers is a(n)...',
      options: ['Dog', 'Animal', 'Bird', 'Plant'], correctIndex: 1,
      explanation: 'Syllogism: cats → animals, Whiskers → cat, so Whiskers → animal.',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),
    Question(
      id: 'logic_e_5', subjectId: 'logic', gameMode: 'puzzle',
      question: 'Which number is missing? 3, 6, 12, ___, 48',
      options: ['18', '24', '36', '30'], correctIndex: 1,
      explanation: 'Each number doubles: 12 × 2 = 24',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),
    Question(
      id: 'logic_e_6', subjectId: 'logic', gameMode: 'puzzle',
      question: 'I have 3 brothers. Each brother has 2 sisters. How many sisters do I have?',
      options: ['2', '6', '1', '3'], correctIndex: 0,
      explanation: 'The 2 sisters of each brother include you. So you have 1 other sister = 2 total.',
      difficulty: 'easy', points: 10, timeSeconds: 30,
    ),
    Question(
      id: 'logic_e_7', subjectId: 'logic', gameMode: 'puzzle',
      question: 'What comes next? A, C, E, G, ___',
      options: ['H', 'I', 'J', 'K'], correctIndex: 1,
      explanation: 'Skip every other letter: A, C, E, G, I',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),
    Question(
      id: 'logic_e_8', subjectId: 'logic', gameMode: 'puzzle',
      question: 'If Monday is Day 1, what day is Day 6?',
      options: ['Friday', 'Saturday', 'Sunday', 'Thursday'], correctIndex: 1,
      explanation: 'Mon=1, Tue=2, Wed=3, Thu=4, Fri=5, Sat=6',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),
    Question(
      id: 'logic_e_9', subjectId: 'logic', gameMode: 'puzzle',
      question: 'What comes next? 100, 90, 81, 73, ___',
      options: ['64', '66', '65', '63'], correctIndex: 1,
      explanation: 'Differences: -10, -9, -8, -7... so 73-7=66',
      difficulty: 'easy', points: 10, timeSeconds: 30,
    ),
    Question(
      id: 'logic_e_10', subjectId: 'logic', gameMode: 'puzzle',
      question: 'A is taller than B. B is taller than C. Who is shortest?',
      options: ['A', 'B', 'C', 'Cannot tell'], correctIndex: 2,
      explanation: 'A > B > C, so C is the shortest.',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),

    // ── CODING – EASY ────────────────────────────────────────────────────────
    Question(
      id: 'code_e_1', subjectId: 'coding', gameMode: 'logic',
      question: 'What does CPU stand for?',
      options: ['Central Processing Unit', 'Computer Personal Unit', 'Central Power Unit', 'Core Processing Unit'], correctIndex: 0,
      explanation: 'CPU = Central Processing Unit — the brain of the computer!',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),
    Question(
      id: 'code_e_2', subjectId: 'coding', gameMode: 'logic',
      question: 'In programming, what is a "loop"?',
      options: ['A type of variable', 'Code that repeats', 'A math operation', 'A type of screen'], correctIndex: 1,
      explanation: 'A loop repeats a block of code until a condition is met.',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),
    Question(
      id: 'code_e_3', subjectId: 'coding', gameMode: 'logic',
      question: 'Which of these is a programming language?',
      options: ['Excel', 'Python', 'PowerPoint', 'Chrome'], correctIndex: 1,
      explanation: 'Python is a popular programming language!',
      difficulty: 'easy', points: 10, timeSeconds: 15,
    ),
    Question(
      id: 'code_e_4', subjectId: 'coding', gameMode: 'logic',
      question: 'What does "AI" stand for?',
      options: ['Automatic Internet', 'Artificial Intelligence', 'Advanced Input', 'Automatic Information'], correctIndex: 1,
      explanation: 'AI = Artificial Intelligence.',
      difficulty: 'easy', points: 10, timeSeconds: 15,
    ),
    Question(
      id: 'code_e_5', subjectId: 'coding', gameMode: 'logic',
      question: 'In binary, what does "10" represent?',
      options: ['5', '2', '10', '3'], correctIndex: 1,
      explanation: 'Binary 10 = 1×2¹ + 0×2⁰ = 2 in decimal.',
      difficulty: 'easy', points: 10, timeSeconds: 25,
    ),
    Question(
      id: 'code_e_6', subjectId: 'coding', gameMode: 'logic',
      question: 'What does "www" stand for in a website address?',
      options: ['World Wide Web', 'World Web Wide', 'Wide World Web', 'Web World Wide'], correctIndex: 0,
      explanation: 'www = World Wide Web, invented by Tim Berners-Lee.',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),
    Question(
      id: 'code_e_7', subjectId: 'coding', gameMode: 'logic',
      question: 'Which device is used to move the cursor on a computer screen?',
      options: ['Keyboard', 'Monitor', 'Mouse', 'Speaker'], correctIndex: 2,
      explanation: 'A mouse is used to move the cursor and click on items.',
      difficulty: 'easy', points: 10, timeSeconds: 15,
    ),
    Question(
      id: 'code_e_8', subjectId: 'coding', gameMode: 'logic',
      question: 'What is a "bug" in programming?',
      options: ['An insect', 'An error in code', 'A computer virus', 'A type of loop'], correctIndex: 1,
      explanation: 'A bug is an error or mistake in a program that causes it to behave unexpectedly.',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),

    // ── GEOGRAPHY – EASY ─────────────────────────────────────────────────────
    Question(
      id: 'geo_e_1', subjectId: 'geography', gameMode: 'map',
      question: 'What is the largest country in the world by area?',
      options: ['China', 'USA', 'Canada', 'Russia'], correctIndex: 3,
      explanation: 'Russia covers about 17 million km².',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),
    Question(
      id: 'geo_e_2', subjectId: 'geography', gameMode: 'map',
      question: 'Which is the longest river in the world?',
      options: ['Amazon', 'Nile', 'Mississippi', 'Yangtze'], correctIndex: 1,
      explanation: 'The Nile stretches about 6,650 km.',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),
    Question(
      id: 'geo_e_3', subjectId: 'geography', gameMode: 'map',
      question: 'How many continents are there on Earth?',
      options: ['5', '6', '7', '8'], correctIndex: 2,
      explanation: '7 continents: Asia, Africa, N. America, S. America, Antarctica, Europe, Australia.',
      difficulty: 'easy', points: 10, timeSeconds: 15,
    ),
    Question(
      id: 'geo_e_4', subjectId: 'geography', gameMode: 'map',
      question: 'What is the capital of Japan?',
      options: ['Osaka', 'Kyoto', 'Tokyo', 'Hiroshima'], correctIndex: 2,
      explanation: 'Tokyo is Japan\'s capital.',
      difficulty: 'easy', points: 10, timeSeconds: 15,
    ),
    Question(
      id: 'geo_e_5', subjectId: 'geography', gameMode: 'map',
      question: 'Which ocean is the largest?',
      options: ['Atlantic', 'Indian', 'Arctic', 'Pacific'], correctIndex: 3,
      explanation: 'The Pacific Ocean covers more than 30% of Earth\'s surface!',
      difficulty: 'easy', points: 10, timeSeconds: 15,
    ),
    Question(
      id: 'geo_e_6', subjectId: 'geography', gameMode: 'map',
      question: 'What is the capital of Australia?',
      options: ['Sydney', 'Melbourne', 'Canberra', 'Brisbane'], correctIndex: 2,
      explanation: 'Canberra is Australia\'s capital (not Sydney!).',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),
    Question(
      id: 'geo_e_7', subjectId: 'geography', gameMode: 'map',
      question: 'Which is the smallest country in the world?',
      options: ['Monaco', 'San Marino', 'Vatican City', 'Liechtenstein'], correctIndex: 2,
      explanation: 'Vatican City is the smallest country at just 0.44 km².',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),
    Question(
      id: 'geo_e_8', subjectId: 'geography', gameMode: 'map',
      question: 'Mount Everest is located in which mountain range?',
      options: ['Alps', 'Andes', 'Himalayas', 'Rockies'], correctIndex: 2,
      explanation: 'Mount Everest is in the Himalayas on the Nepal-Tibet border.',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),

    // ── ENGLISH – EASY ───────────────────────────────────────────────────────
    Question(
      id: 'eng_e_1', subjectId: 'english', gameMode: 'vocab',
      question: 'What is the synonym of "Happy"?',
      options: ['Sad', 'Angry', 'Joyful', 'Tired'], correctIndex: 2,
      explanation: 'Joyful means full of happiness — a synonym for happy!',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),
    Question(
      id: 'eng_e_2', subjectId: 'english', gameMode: 'grammar',
      question: 'Choose the correct sentence:',
      options: ['She dont like apples.', 'She doesn\'t likes apples.', 'She doesn\'t like apples.', 'She not like apples.'],
      correctIndex: 2,
      explanation: '"Doesn\'t" = does not. With he/she/it, use "doesn\'t".',
      difficulty: 'easy', points: 10, timeSeconds: 25,
    ),
    Question(
      id: 'eng_e_3', subjectId: 'english', gameMode: 'vocab',
      question: 'What is the antonym of "Ancient"?',
      options: ['Old', 'Modern', 'Huge', 'Tiny'], correctIndex: 1,
      explanation: 'Ancient means very old. Its opposite is Modern.',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),
    Question(
      id: 'eng_e_4', subjectId: 'english', gameMode: 'vocab',
      question: 'What does "Enormous" mean?',
      options: ['Very small', 'Very fast', 'Very large', 'Very loud'], correctIndex: 2,
      explanation: 'Enormous means extremely large.',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),
    Question(
      id: 'eng_e_5', subjectId: 'english', gameMode: 'vocab',
      question: 'Which word is a noun?',
      options: ['Run', 'Beautiful', 'Quickly', 'Apple'], correctIndex: 3,
      explanation: 'Apple is a noun (a person, place, or thing).',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),
    Question(
      id: 'eng_e_6', subjectId: 'english', gameMode: 'vocab',
      question: 'What is the plural of "child"?',
      options: ['Childs', 'Childes', 'Children', 'Childrens'], correctIndex: 2,
      explanation: 'The irregular plural of child is children.',
      difficulty: 'easy', points: 10, timeSeconds: 15,
    ),
    Question(
      id: 'eng_e_7', subjectId: 'english', gameMode: 'vocab',
      question: 'Which word is an adjective?',
      options: ['Jump', 'Slowly', 'Bright', 'Table'], correctIndex: 2,
      explanation: 'Bright is an adjective — it describes a noun.',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),
    Question(
      id: 'eng_e_8', subjectId: 'english', gameMode: 'grammar',
      question: 'Fill in: ___ is raining outside.',
      options: ['He', 'She', 'It', 'They'], correctIndex: 2,
      explanation: 'We use "It" for weather: "It is raining."',
      difficulty: 'easy', points: 10, timeSeconds: 15,
    ),

    // ── FINANCE – EASY ───────────────────────────────────────────────────────
    Question(
      id: 'fin_e_1', subjectId: 'finance', gameMode: 'tycoon',
      question: 'You have ₹100. You spend ₹35. How much is left?',
      options: ['₹55', '₹65', '₹75', '₹45'], correctIndex: 1,
      explanation: '100 - 35 = 65. Track your spending!',
      difficulty: 'easy', points: 10, timeSeconds: 15,
    ),
    Question(
      id: 'fin_e_2', subjectId: 'finance', gameMode: 'tycoon',
      question: 'What is a "budget"?',
      options: ['A type of bank', 'A plan for spending money', 'A type of coin', 'A savings box'], correctIndex: 1,
      explanation: 'A budget is a plan for managing how much you earn and spend.',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),
    Question(
      id: 'fin_e_3', subjectId: 'finance', gameMode: 'tycoon',
      question: 'If you save ₹10 every day for 30 days, how much do you save?',
      options: ['₹200', '₹300', '₹400', '₹250'], correctIndex: 1,
      explanation: '10 × 30 = ₹300. Small savings add up!',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),
    Question(
      id: 'fin_e_4', subjectId: 'finance', gameMode: 'tycoon',
      question: 'Which is a "need" rather than a "want"?',
      options: ['Video games', 'New shoes', 'Food', 'Cinema ticket'], correctIndex: 2,
      explanation: 'Food is a NEED — essential for survival. Games and movies are wants.',
      difficulty: 'easy', points: 10, timeSeconds: 20,
    ),
    Question(
      id: 'fin_e_5', subjectId: 'finance', gameMode: 'tycoon',
      question: 'What does a bank do with the money you deposit?',
      options: ['Burns it', 'Lends it to others', 'Keeps it under a vault', 'Gives it away'], correctIndex: 1,
      explanation: 'Banks lend deposited money to borrowers and pay depositors interest.',
      difficulty: 'easy', points: 10, timeSeconds: 25,
    ),
    Question(
      id: 'fin_e_6', subjectId: 'finance', gameMode: 'tycoon',
      question: 'If something costs ₹500 and is 10% off, what do you pay?',
      options: ['₹400', '₹450', '₹490', '₹480'], correctIndex: 1,
      explanation: '10% of 500 = 50. 500 - 50 = ₹450.',
      difficulty: 'easy', points: 10, timeSeconds: 25,
    ),
  ];
}
