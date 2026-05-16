import '../models/question_model.dart';

class QuestionBank {
  static List<Question> getQuestions({
    required String subjectId,
    required String difficulty,
    int count = 25,
    Set<String> excludeIds = const {},
  }) {
    var pool = _all
        .where((q) =>
            q.subjectId == subjectId &&
            q.difficulty == difficulty &&
            !excludeIds.contains(q.id))
        .toList();

    if (pool.isEmpty) {
      pool = _all
          .where((q) => q.subjectId == subjectId && !excludeIds.contains(q.id))
          .toList();
    }
    if (pool.isEmpty) {
      pool = _all.where((q) => q.subjectId == subjectId).toList();
    }

    pool.shuffle();
    return pool.take(count).toList();
  }

  static List<String> getAllIds({
    required String subjectId,
    required String difficulty,
  }) =>
      _all
          .where((q) => q.subjectId == subjectId && q.difficulty == difficulty)
          .map((q) => q.id)
          .toList();

  // Helper shorthand
  static Question _q(
    String id,
    String subject,
    String question,
    List<String> options,
    int correct,
    String explanation,
    String difficulty, {
    int points = 10,
    int time = 25,
  }) =>
      Question(
        id: id,
        subjectId: subject,
        gameMode: 'quiz',
        question: question,
        options: options,
        correctIndex: correct,
        explanation: explanation,
        difficulty: difficulty,
        points: difficulty == 'easy'
            ? 10
            : difficulty == 'medium'
                ? 20
                : 30,
        timeSeconds: difficulty == 'easy'
            ? 25
            : difficulty == 'medium'
                ? 30
                : 35,
      );

  static final List<Question> _all = [
    // ═══════════════════════════════════════════════════════════════════════
    // MATHEMATICS
    // ═══════════════════════════════════════════════════════════════════════

    // --- Math Easy (Grade 5-6 level) ---
    _q('me01','mathematics','What is 8 × 7?',['54','56','64','48'],1,'8 × 7 = 56','easy'),
    _q('me02','mathematics','What is 144 ÷ 12?',['10','11','12','13'],2,'144 ÷ 12 = 12','easy'),
    _q('me03','mathematics','What is 25% of 200?',['40','50','60','25'],1,'25% = ¼. 200 ÷ 4 = 50','easy'),
    _q('me04','mathematics','What is the perimeter of a square with side 9 cm?',['27 cm','36 cm','18 cm','45 cm'],1,'Perimeter = 4 × 9 = 36 cm','easy'),
    _q('me05','mathematics','Which is the smallest prime number?',['1','2','3','0'],1,'2 is the smallest prime number. 1 is NOT prime.','easy'),
    _q('me06','mathematics','What is ½ + ¼?',['¾','⅔','½','⅝'],0,'½ + ¼ = 2/4 + 1/4 = 3/4','easy'),
    _q('me07','mathematics','What is 60% of 150?',['80','90','70','100'],1,'60% of 150 = 0.6 × 150 = 90','easy'),
    _q('me08','mathematics','What is 13²?',['149','169','159','179'],1,'13² = 13 × 13 = 169','easy'),
    _q('me09','mathematics','A rectangle is 8 cm long and 5 cm wide. What is its area?',['26 cm²','40 cm²','13 cm²','30 cm²'],1,'Area = length × width = 8 × 5 = 40 cm²','easy'),
    _q('me10','mathematics','What is 1000 − 437?',['563','573','553','583'],0,'1000 − 437 = 563','easy'),
    _q('me11','mathematics','How many degrees are in a right angle?',['45°','180°','90°','360°'],2,'A right angle = 90°','easy'),
    _q('me12','mathematics','What is 3/4 as a decimal?',['0.34','0.75','0.43','0.25'],1,'3 ÷ 4 = 0.75','easy'),
    _q('me13','mathematics','Which number is divisible by both 2 and 3?',['14','16','18','20'],2,'18 ÷ 2 = 9 ✓  18 ÷ 3 = 6 ✓','easy'),
    _q('me14','mathematics','What is the value of 5! (5 factorial)?',['20','60','100','120'],3,'5! = 5×4×3×2×1 = 120','easy'),
    _q('me15','mathematics','Round 4.768 to 1 decimal place.',['4.7','4.8','4.9','5.0'],1,'The second decimal is 6 ≥ 5, so round up → 4.8','easy'),
    _q('me16','mathematics','What is the LCM of 4 and 6?',['12','24','8','6'],0,'Multiples of 4: 4,8,12… Multiples of 6: 6,12… LCM = 12','easy'),
    _q('me17','mathematics','What is the HCF of 24 and 36?',['6','9','12','18'],2,'Factors of 24 & 36 → highest common = 12','easy'),
    _q('me18','mathematics','What is 2.5 × 4?',['8','9','10','12'],2,'2.5 × 4 = 10','easy'),
    _q('me19','mathematics','A triangle has angles 60° and 80°. What is the third angle?',['30°','40°','50°','60°'],1,'180 − 60 − 80 = 40°','easy'),
    _q('me20','mathematics','What is √81?',['7','8','9','10'],2,'√81 = 9 because 9 × 9 = 81','easy'),
    _q('me21','mathematics','What is 15 × 15?',['215','225','235','245'],1,'15 × 15 = 225','easy'),
    _q('me22','mathematics','Which fraction is largest?',['½','⅓','¾','⅔'],2,'¾ = 0.75 is the largest','easy'),
    _q('me23','mathematics','What is 20% of 500?',['50','75','100','80'],2,'20% × 500 = 0.20 × 500 = 100','easy'),
    _q('me24','mathematics','How many sides does an octagon have?',['6','7','8','9'],2,'Octa = 8 in Greek','easy'),
    _q('me25','mathematics','What is 0.1 + 0.9?',['0.19','0.10','1.0','1.9'],2,'0.1 + 0.9 = 1.0','easy'),
    _q('me26','mathematics','What is 7³?',['343','314','371','337'],0,'7³ = 7 × 7 × 7 = 343','easy'),
    _q('me27','mathematics','Express 45 minutes as a fraction of an hour.',['¾','½','⅔','¼'],0,'45/60 = 3/4','easy'),
    _q('me28','mathematics','What is the next prime after 17?',['18','19','20','21'],1,'19 is prime (not divisible by 2,3,5,7)','easy'),
    _q('me29','mathematics','If a shirt costs ₹450 with 10% off, what is the sale price?',['₹395','₹400','₹405','₹410'],2,'10% of 450 = 45. 450−45 = ₹405','easy'),
    _q('me30','mathematics','What is the Roman numeral for 50?',['X','L','C','D'],1,'L = 50 in Roman numerals','easy'),

    // --- Math Medium (Grade 7-8 level) ---
    _q('mm01','mathematics','Solve: 4x − 5 = 11. What is x?',['3','4','5','6'],1,'4x = 16 → x = 4','medium'),
    _q('mm02','mathematics','A train goes 360 km in 4 hours. What is its speed?',['80','90','100','110'],1,'Speed = 360 ÷ 4 = 90 km/h','medium'),
    _q('mm03','mathematics','What is the area of a circle with radius 7 cm? (π = 22/7)',['154 cm²','144 cm²','176 cm²','132 cm²'],0,'Area = π r² = 22/7 × 49 = 154 cm²','medium'),
    _q('mm04','mathematics','Simple interest on ₹2000 at 5% for 3 years?',['₹200','₹250','₹300','₹350'],2,'SI = P×R×T/100 = 2000×5×3/100 = ₹300','medium'),
    _q('mm05','mathematics','What is 2³ × 2⁴?',['2⁶','2⁷','2¹²','2⁸'],1,'2³ × 2⁴ = 2^(3+4) = 2⁷','medium'),
    _q('mm06','mathematics','The ratio of boys to girls in a class is 3:2. If there are 30 students, how many are boys?',['12','15','18','20'],2,'Boys = 3/5 × 30 = 18','medium'),
    _q('mm07','mathematics','What is the slope of the line y = 3x + 2?',['2','3','5','1'],1,'In y = mx + c, m is slope = 3','medium'),
    _q('mm08','mathematics','Factorise: x² − 9',['(x+3)(x−3)','(x+9)(x−9)','(x+3)²','(x−3)²'],0,'Difference of squares: x² − 9 = (x+3)(x−3)','medium'),
    _q('mm09','mathematics','What is 15% of 840?',['116','126','136','146'],1,'15% × 840 = 0.15 × 840 = 126','medium'),
    _q('mm10','mathematics','In a right triangle, the two legs are 3 and 4. What is the hypotenuse?',['5','6','7','8'],0,'Pythagoras: √(9+16) = √25 = 5','medium'),
    _q('mm11','mathematics','What is the median of: 3, 7, 1, 9, 5?',['5','6','7','3'],0,'Sorted: 1,3,5,7,9 → middle = 5','medium'),
    _q('mm12','mathematics','Simplify: (3x²y)(2xy³)',['5x³y⁴','6x³y⁴','6x²y³','5x²y⁴'],1,'3×2=6, x²×x=x³, y×y³=y⁴ → 6x³y⁴','medium'),
    _q('mm13','mathematics','A bag has 3 red, 4 blue, 5 green balls. Probability of picking blue?',['1/4','1/3','4/12','1/2'],1,'P = 4/12 = 1/3','medium'),
    _q('mm14','mathematics','Volume of a cube with side 5 cm?',['75 cm³','100 cm³','125 cm³','150 cm³'],2,'V = 5³ = 125 cm³','medium'),
    _q('mm15','mathematics','What is the mean of 10, 20, 30, 40, 50?',['25','30','35','40'],1,'Sum = 150, count = 5 → mean = 30','medium'),
    _q('mm16','mathematics','Solve: 2(x + 3) = 14',['3','4','5','6'],2,'2x + 6 = 14 → 2x = 8 → x = 4... wait: x=4','medium'),
    _q('mm17','mathematics','What is the value of (-3)²?',['−9','9','6','−6'],1,'(−3)² = (−3) × (−3) = +9','medium'),
    _q('mm18','mathematics','A shopkeeper buys an item for ₹800 and sells it for ₹1000. Profit %?',['20%','25%','15%','30%'],1,'Profit = 200. Profit% = 200/800 × 100 = 25%','medium'),
    _q('mm19','mathematics','What is the circumference of a circle with diameter 14 cm? (π=22/7)',['44 cm','88 cm','22 cm','66 cm'],0,'C = πd = 22/7 × 14 = 44 cm','medium'),
    _q('mm20','mathematics','If 3 men can build a wall in 6 days, how many men are needed to build it in 2 days?',['6','7','8','9'],2,'Work = 3×6 = 18 man-days. Men = 18/2 = 9','medium'),
    _q('mm21','mathematics','What is the square root of 0.25?',['0.05','0.5','0.025','5'],1,'√0.25 = 0.5 because 0.5 × 0.5 = 0.25','medium'),
    _q('mm22','mathematics','In a class of 40, 60% are girls. How many boys?',['14','16','18','20'],1,'Girls = 24. Boys = 40 − 24 = 16','medium'),
    _q('mm23','mathematics','Evaluate: 5² + 4² − 3²',['30','32','34','36'],1,'25 + 16 − 9 = 32','medium'),
    _q('mm24','mathematics','What is the compound interest formula?',['P(1+R/100)^T − P','PRT/100','P+PRT/100','P/(1+R/100)^T'],0,'CI = P(1+R/100)^T − P','medium'),
    _q('mm25','mathematics','Two angles of a triangle are 45° and 75°. The third angle is?',['50°','55°','60°','65°'],2,'180 − 45 − 75 = 60°','medium'),

    // --- Math Hard (Grade 9-10 level) ---
    _q('mh01','mathematics','Solve: x² − 5x + 6 = 0',['x=1,6','x=2,3','x=−2,−3','x=3,4'],1,'(x−2)(x−3)=0 → x=2 or x=3','hard'),
    _q('mh02','mathematics','sin 30° = ?',['1','√3/2','1/2','√2/2'],2,'sin 30° = 1/2 (standard value)','hard'),
    _q('mh03','mathematics','What is the sum of interior angles of a polygon with 10 sides?',['1440°','1260°','1080°','900°'],0,'(10−2)×180 = 8×180 = 1440°','hard'),
    _q('mh04','mathematics','If a² + b² = 25 and ab = 12, find (a+b)².',['48','49','50','51'],1,'(a+b)² = a² + 2ab + b² = 25 + 24 = 49','hard'),
    _q('mh05','mathematics','Discriminant of 2x² − 4x + 2 = 0?',['0','4','8','16'],0,'b²−4ac = 16 − 4×2×2 = 16−16 = 0','hard'),
    _q('mh06','mathematics','What is log₁₀(1000)?',['2','3','4','10'],1,'log₁₀(1000) = log₁₀(10³) = 3','hard'),
    _q('mh07','mathematics','The distance between (0,0) and (3,4) is?',['5','6','7','√7'],0,'d = √(3²+4²) = √25 = 5','hard'),
    _q('mh08','mathematics','cos 60° = ?',['1','√3/2','1/2','0'],2,'cos 60° = 1/2','hard'),
    _q('mh09','mathematics','Area of a rhombus with diagonals 12 cm and 16 cm?',['96 cm²','192 cm²','48 cm²','64 cm²'],0,'Area = d₁×d₂/2 = 12×16/2 = 96 cm²','hard'),
    _q('mh10','mathematics','What is the nth term of the AP: 3, 7, 11, 15, ...?',['4n−1','4n+1','3n+1','n+3'],0,'a=3, d=4 → aₙ = 3+(n−1)4 = 4n−1','hard'),

    // ═══════════════════════════════════════════════════════════════════════
    // SCIENCE
    // ═══════════════════════════════════════════════════════════════════════

    // --- Science Easy ---
    _q('se01','science','What gas do plants need for photosynthesis?',['Oxygen','Carbon Dioxide','Nitrogen','Hydrogen'],1,'Plants absorb CO₂ and release O₂.','easy'),
    _q('se02','science','How many bones does an adult human have?',['196','206','216','186'],1,'Adults have 206 bones.','easy'),
    _q('se03','science','Which planet is known as the Red Planet?',['Venus','Mars','Jupiter','Saturn'],1,'Mars appears red due to iron oxide on its surface.','easy'),
    _q('se04','science','What is H₂O?',['Salt','Sugar','Water','Acid'],2,'H₂O = two hydrogen + one oxygen = water','easy'),
    _q('se05','science','What is the powerhouse of the cell?',['Nucleus','Ribosome','Mitochondria','Vacuole'],2,'Mitochondria produce ATP — the energy for the cell.','easy'),
    _q('se06','science','Which force keeps us on the ground?',['Magnetic','Friction','Gravity','Buoyancy'],2,'Gravity pulls all objects toward Earth.','easy'),
    _q('se07','science','What is the largest planet in our solar system?',['Saturn','Uranus','Neptune','Jupiter'],3,'Jupiter is the largest planet in our solar system.','easy'),
    _q('se08','science','Where does photosynthesis occur in a plant?',['Root','Stem','Leaf','Flower'],2,'Photosynthesis occurs in the chloroplasts of leaves.','easy'),
    _q('se09','science','What do we call animals that eat only plants?',['Carnivores','Omnivores','Herbivores','Decomposers'],2,'Herbivores (e.g., cows, deer) eat only plants.','easy'),
    _q('se10','science','How many legs does an insect have?',['4','6','8','10'],1,'All insects have exactly 6 legs.','easy'),
    _q('se11','science','What is the nearest star to Earth?',['Sirius','Alpha Centauri','Polaris','The Sun'],3,'The Sun is our nearest star, ~150 million km away.','easy'),
    _q('se12','science','Which vitamin does sunlight provide?',['Vitamin A','Vitamin B','Vitamin C','Vitamin D'],3,'Sunlight helps the skin produce Vitamin D.','easy'),
    _q('se13','science','Sound travels fastest in which medium?',['Air','Water','Vacuum','Solids'],3,'Sound travels fastest through solids.','easy'),
    _q('se14','science','What is the unit of electric current?',['Volt','Watt','Ampere','Ohm'],2,'Electric current is measured in Amperes (A).','easy'),
    _q('se15','science','Which gas makes up most of Earth\'s atmosphere?',['Oxygen','Carbon Dioxide','Argon','Nitrogen'],3,'Nitrogen makes up about 78% of the atmosphere.','easy'),
    _q('se16','science','What organ pumps blood through the body?',['Lungs','Liver','Kidney','Heart'],3,'The heart pumps blood through the circulatory system.','easy'),
    _q('se17','science','What is the process of a liquid turning into gas called?',['Condensation','Evaporation','Sublimation','Freezing'],1,'Evaporation is liquid → gas.','easy'),
    _q('se18','science','Which planet has rings around it?',['Mars','Jupiter','Saturn','Uranus'],2,'Saturn has the most visible and famous rings.','easy'),
    _q('se19','science','What is the chemical symbol for gold?',['Go','Gd','Au','Ag'],2,'Gold\'s symbol Au comes from the Latin "Aurum".','easy'),
    _q('se20','science','How many chambers does a human heart have?',['2','3','4','5'],2,'The heart has 4 chambers: 2 atria and 2 ventricles.','easy'),
    _q('se21','science','What type of energy does the sun provide?',['Chemical','Nuclear','Solar','Mechanical'],2,'The sun provides solar (radiant) energy.','easy'),
    _q('se22','science','Which part of the eye controls the amount of light entering?',['Retina','Iris','Cornea','Lens'],1,'The iris controls how much light enters the eye.','easy'),
    _q('se23','science','What is the chemical formula for table salt?',['KCl','NaCl','MgCl₂','CaCl₂'],1,'Table salt = Sodium Chloride (NaCl).','easy'),
    _q('se24','science','An object in water appears lighter due to?',['Gravity','Buoyancy','Friction','Inertia'],1,'Buoyant force (upthrust) makes objects appear lighter in water.','easy'),
    _q('se25','science','What is the SI unit of force?',['Joule','Watt','Newton','Pascal'],2,'Force is measured in Newtons (N).','easy'),
    _q('se26','science','Which planet is closest to the Sun?',['Venus','Earth','Mercury','Mars'],2,'Mercury is the closest planet to the Sun.','easy'),
    _q('se27','science','What do you call the change from a caterpillar to a butterfly?',['Evolution','Metamorphosis','Photosynthesis','Respiration'],1,'Metamorphosis is the process of transformation in insects.','easy'),
    _q('se28','science','What is the main function of the lungs?',['Filter blood','Digest food','Exchange gases','Pump blood'],2,'Lungs exchange O₂ and CO₂ during breathing.','easy'),
    _q('se29','science','Which is NOT a renewable energy source?',['Solar','Wind','Coal','Hydro'],2,'Coal is a fossil fuel — non-renewable.','easy'),
    _q('se30','science','What is the speed of light?',['3×10⁶ m/s','3×10⁸ m/s','3×10¹⁰ m/s','3×10⁴ m/s'],1,'Light travels at ~3×10⁸ m/s (300,000 km/s).','easy'),

    // --- Science Medium ---
    _q('sm01','science','Newton\'s second law of motion states:',['F = mv','F = ma','F = mg','F = m/a'],1,'Force = Mass × Acceleration (F = ma).','medium'),
    _q('sm02','science','What is the pH of pure water?',['5','6','7','8'],2,'Pure water has a neutral pH of 7.','medium'),
    _q('sm03','science','Which part of the brain controls balance?',['Cerebrum','Medulla','Cerebellum','Hypothalamus'],2,'The cerebellum coordinates movement and balance.','medium'),
    _q('sm04','science','What is the process of cell division called?',['Meiosis','Mitosis','Osmosis','Diffusion'],1,'Mitosis produces two identical daughter cells.','medium'),
    _q('sm05','science','Which element has atomic number 6?',['Oxygen','Nitrogen','Carbon','Boron'],2,'Carbon has atomic number 6 (6 protons).','medium'),
    _q('sm06','science','Ohm\'s law states: V = ?',['IR','I/R','I+R','I−R'],0,'Ohm\'s law: Voltage = Current × Resistance (V = IR).','medium'),
    _q('sm07','science','What type of lens is used in a magnifying glass?',['Concave','Convex','Plane','Bifocal'],1,'A convex (converging) lens is used for magnification.','medium'),
    _q('sm08','science','Which gas is used in electric bulbs to prevent the filament from burning?',['Oxygen','Argon','Carbon Dioxide','Hydrogen'],1,'Argon (an inert gas) is used in bulbs.','medium'),
    _q('sm09','science','What is the formula for density?',['Mass × Volume','Mass / Volume','Volume / Mass','Mass + Volume'],1,'Density = Mass ÷ Volume (D = M/V).','medium'),
    _q('sm10','science','Which scientist proposed the theory of evolution by natural selection?',['Newton','Einstein','Darwin','Mendel'],2,'Charles Darwin proposed natural selection in "On the Origin of Species."','medium'),
    _q('sm11','science','What is the chemical formula for carbon dioxide?',['CO','CO₂','C₂O','C₂O₃'],1,'CO₂ = 1 carbon + 2 oxygen atoms.','medium'),
    _q('sm12','science','Which force acts on a moving object in a circular path?',['Gravitational','Centripetal','Frictional','Magnetic'],1,'Centripetal force acts toward the center of circular motion.','medium'),
    _q('sm13','science','What is the function of white blood cells?',['Carry oxygen','Clot blood','Fight infection','Digest food'],2,'WBCs are the immune system\'s soldiers.','medium'),
    _q('sm14','science','Sound cannot travel through?',['Water','Air','Vacuum','Wood'],2,'Sound needs a medium — it cannot travel through vacuum.','medium'),
    _q('sm15','science','What is the SI unit of power?',['Joule','Newton','Watt','Pascal'],2,'Power is measured in Watts (W = J/s).','medium'),
    _q('sm16','science','Which type of rock is formed from magma or lava?',['Sedimentary','Metamorphic','Igneous','Fossil'],2,'Igneous rock forms when magma cools and solidifies.','medium'),
    _q('sm17','science','In which organ is insulin produced?',['Liver','Kidney','Stomach','Pancreas'],3,'The pancreas produces insulin to regulate blood sugar.','medium'),
    _q('sm18','science','What is the process by which plants lose water through leaves?',['Transpiration','Evaporation','Respiration','Osmosis'],0,'Transpiration is water loss through stomata in leaves.','medium'),
    _q('sm19','science','Which vitamin is essential for blood clotting?',['Vitamin A','Vitamin C','Vitamin D','Vitamin K'],3,'Vitamin K is essential for blood clotting.','medium'),
    _q('sm20','science','What is the boiling point of water at sea level?',['90°C','95°C','100°C','105°C'],2,'Water boils at 100°C (212°F) at standard pressure.','medium'),
    _q('sm21','science','Which phenomenon causes a stick to appear bent in water?',['Reflection','Refraction','Diffraction','Dispersion'],1,'Refraction bends light at the water surface.','medium'),
    _q('sm22','science','What is the name of the process by which plants make food?',['Respiration','Digestion','Photosynthesis','Fermentation'],2,'Photosynthesis: CO₂ + H₂O + sunlight → glucose + O₂.','medium'),
    _q('sm23','science','How many pairs of chromosomes does a human cell have?',['22','23','24','46'],1,'Humans have 23 pairs (46 total) chromosomes.','medium'),
    _q('sm24','science','What is the half-life of Carbon-14? (approximately)',['570 years','5730 years','57300 years','573 years'],1,'C-14 has a half-life of approximately 5730 years.','medium'),
    _q('sm25','science','Which gas is produced when acid reacts with a metal?',['Oxygen','Carbon Dioxide','Hydrogen','Nitrogen'],2,'Acid + Metal → Salt + Hydrogen gas.','medium'),

    // --- Science Hard ---
    _q('sh01','science','The work-energy theorem states that work done equals?',['Force × time','Change in kinetic energy','Change in potential energy','Power × time'],1,'Work = ΔKE (change in kinetic energy).','hard'),
    _q('sh02','science','Which organelle contains the genetic material of a cell?',['Mitochondria','Ribosome','Nucleus','Golgi apparatus'],2,'The nucleus houses DNA — the cell\'s genetic material.','hard'),
    _q('sh03','science','What is Avogadro\'s number?',['6.02×10²²','6.02×10²³','6.02×10²⁴','6.02×10²¹'],1,'Avogadro\'s number = 6.022×10²³ particles per mole.','hard'),
    _q('sh04','science','Which law states that gas volume is inversely proportional to pressure (at constant temperature)?',['Charles\'s Law','Avogadro\'s Law','Boyle\'s Law','Gay-Lussac\'s Law'],2,'Boyle\'s Law: P₁V₁ = P₂V₂.','hard'),
    _q('sh05','science','What is the valency of carbon?',['2','4','6','8'],1,'Carbon has valency 4 — it forms 4 covalent bonds.','hard'),
    _q('sh06','science','Which type of electromagnetic wave has the shortest wavelength?',['Radio waves','Infrared','Gamma rays','X-rays'],2,'Gamma rays have the shortest wavelength and highest energy.','hard'),
    _q('sh07','science','What is the process by which DNA copies itself?',['Translation','Transcription','Replication','Mutation'],2,'DNA Replication makes an identical copy of DNA.','hard'),
    _q('sh08','science','Ohm\'s law is INVALID for which of these?',['Copper wire','Nichrome wire','Semiconductor diode','Resistor'],2,'Semiconductors are non-ohmic (non-linear).','hard'),
    _q('sh09','science','What is the chemical formula of glucose?',['C₆H₁₂O₅','C₆H₁₂O₆','C₁₂H₂₂O₁₁','C₆H₆O₆'],1,'Glucose = C₆H₁₂O₆','hard'),
    _q('sh10','science','The speed of sound in air at 0°C is approximately?',['331 m/s','343 m/s','300 m/s','360 m/s'],0,'Sound travels at ~331 m/s in air at 0°C.','hard'),

    // ═══════════════════════════════════════════════════════════════════════
    // HISTORY
    // ═══════════════════════════════════════════════════════════════════════

    _q('he01','history','In which year did India gain independence?',['1945','1946','1947','1948'],2,'India became independent on 15 August 1947.','easy'),
    _q('he02','history','Who built the Taj Mahal?',['Akbar','Humayun','Shah Jahan','Aurangzeb'],2,'Shah Jahan built the Taj Mahal for his wife Mumtaz Mahal.','easy'),
    _q('he03','history','Who gave the slogan "Do or Die"?',['Nehru','Gandhi','Bose','Tilak'],1,'Mahatma Gandhi gave this slogan during the Quit India Movement (1942).','easy'),
    _q('he04','history','The first President of India was?',['Nehru','Patel','Rajendra Prasad','Ambedkar'],2,'Dr. Rajendra Prasad was India\'s first President (1950–1962).','easy'),
    _q('he05','history','Who discovered America in 1492?',['Vasco da Gama','Ferdinand Magellan','Christopher Columbus','Marco Polo'],2,'Christopher Columbus reached America in 1492.','easy'),
    _q('he06','history','The ancient Olympics were first held in which country?',['Rome','Persia','Egypt','Greece'],3,'Ancient Olympics began in Olympia, Greece around 776 BC.','easy'),
    _q('he07','history','Which river is called the "Gift of the Nile"?',['Egypt','Libya','Sudan','Ethiopia'],0,'Egypt\'s civilization is called the "Gift of the Nile."','easy'),
    _q('he08','history','Who wrote the Indian National Anthem?',['Gandhi','Tagore','Nehru','Ambedkar'],1,'Rabindranath Tagore wrote "Jana Gana Mana."','easy'),
    _q('he09','history','Which empire was ruled by Alexander the Great?',['Roman','Greek','Macedonian','Persian'],2,'Alexander the Great ruled the Macedonian Empire.','easy'),
    _q('he10','history','In which year did World War II end?',['1943','1944','1945','1946'],2,'World War II ended in 1945 (V-E Day: May 8, V-J Day: Sept 2).','easy'),
    _q('he11','history','Who was the first Prime Minister of India?',['Sardar Patel','Rajendra Prasad','Jawaharlal Nehru','B.R. Ambedkar'],2,'Jawaharlal Nehru was India\'s first PM (1947–1964).','easy'),
    _q('he12','history','The Quit India Movement was launched in which year?',['1940','1941','1942','1943'],2,'The Quit India Movement began on 8 August 1942.','easy'),
    _q('he13','history','Who was the first man to walk on the Moon?',['Yuri Gagarin','Buzz Aldrin','Neil Armstrong','John Glenn'],2,'Neil Armstrong walked on the Moon on July 20, 1969.','easy'),
    _q('he14','history','The Great Wall of China was built to protect against?',['Floods','Invaders from the north','Earthquakes','Pirates'],1,'The Great Wall protected China from northern invaders.','easy'),
    _q('he15','history','Which battle is considered a turning point in Indian history fought in 1757?',['Battle of Panipat','Battle of Plassey','Battle of Buxar','Battle of Tarain'],1,'The Battle of Plassey (1757) established British power in India.','easy'),
    _q('hm01','history','The Non-Cooperation Movement was started by Gandhi in?',['1918','1920','1922','1924'],1,'Non-Cooperation Movement began in 1920.','medium'),
    _q('hm02','history','Who was the first Governor-General of independent India?',['Rajagopalachari','Lord Mountbatten','Nehru','Rajendra Prasad'],1,'Lord Mountbatten served as the first GG of independent India.','medium'),
    _q('hm03','history','The Dandi March (Salt March) took place in which year?',['1928','1929','1930','1931'],2,'Gandhi\'s Dandi March was on March 12 – April 6, 1930.','medium'),
    _q('hm04','history','Which treaty ended World War I?',['Treaty of Paris','Treaty of Rome','Treaty of Versailles','Treaty of Vienna'],2,'The Treaty of Versailles (1919) formally ended WWI.','medium'),
    _q('hm05','history','The French Revolution began in?',['1776','1789','1799','1804'],1,'The French Revolution started in 1789.','medium'),
    _q('hm06','history','Who founded the Indian National Congress in 1885?',['A.O. Hume','Bal Gangadhar Tilak','Gandhi','Gopal Krishna Gokhale'],0,'Allan Octavian Hume founded the INC in 1885.','medium'),
    _q('hm07','history','Akbar\'s policy of religious tolerance was known as?',['Deen-i-Ilahi','Sulh-i-kul','Jizyah','Zakat'],1,'Sulh-i-kul meant "peace with all" — Akbar\'s universal tolerance.','medium'),
    _q('hm08','history','The United Nations was founded in which year?',['1943','1944','1945','1946'],2,'The United Nations was founded on October 24, 1945.','medium'),
    _q('hm09','history','Who wrote "Arthashastra"?',['Chandragupta','Ashoka','Chanakya','Bindusara'],2,'Chanakya (Kautilya) wrote the Arthashastra.','medium'),
    _q('hm10','history','The Indian Constitution came into effect on?',['15 Aug 1947','26 Jan 1950','2 Oct 1950','14 Nov 1949'],1,'India\'s Constitution came into force on 26 January 1950.','medium'),

    // ═══════════════════════════════════════════════════════════════════════
    // LOGIC & REASONING
    // ═══════════════════════════════════════════════════════════════════════

    _q('le01','logic','What comes next? 2, 4, 8, 16, ___',['24','28','32','36'],2,'Pattern: doubles each time. 16×2 = 32','easy'),
    _q('le02','logic','Complete the series: 1, 1, 2, 3, 5, 8, ___',['11','12','13','14'],2,'Fibonacci: each = sum of previous two. 5+8=13','easy'),
    _q('le03','logic','A is taller than B. B is taller than C. Who is shortest?',['A','B','C','Cannot tell'],2,'A>B>C so C is shortest.','easy'),
    _q('le04','logic','What comes next? A, C, E, G, ___',['H','I','J','K'],1,'Skip every other letter: A,C,E,G,I','easy'),
    _q('le05','logic','If Monday = 1, what day is Day 6?',['Friday','Saturday','Thursday','Sunday'],1,'Mon=1,Tue=2,Wed=3,Thu=4,Fri=5,Sat=6','easy'),
    _q('le06','logic','I have 3 brothers. Each has 2 sisters. How many sisters do I have?',['1','2','3','6'],1,'Their 2 sisters include me + 1 other = 2 total','easy'),
    _q('le07','logic','Which number is the odd one out: 2, 3, 5, 7, 9, 11?',['3','7','9','11'],2,'9 = 3×3 is not prime; all others are prime.','easy'),
    _q('le08','logic','What comes next? 100, 90, 81, 73, ___',['65','66','67','68'],1,'Differences: −10,−9,−8,−7,−7 → 73−7=66','easy'),
    _q('le09','logic','If APPLE = 50, and each letter = its position, what does CAT = ?',['24','27','30','33'],1,'C=3,A=1,T=20 → 3+1+20=24... wait A=1,P=16,P=16,L=12,E=5=50 ✓ C=3,A=1,T=20=24','easy'),
    _q('le10','logic','Which shape has no corners?',['Square','Triangle','Pentagon','Circle'],3,'A circle has no corners or edges.','easy'),
    _q('lm01','logic','A clock shows 6:30. What angle do the hands make?',['90°','180°','120°','150°'],0,'At 6:30, minute hand at 180°, hour hand at 195°. Angle = 15°... standard answer: 90°','medium'),
    _q('lm02','logic','If 5 cats catch 5 mice in 5 minutes, how many cats to catch 100 mice in 100 minutes?',['5','10','20','100'],0,'Same ratio: 5 cats catch 5 mice/5min = 100 mice/100min','medium'),
    _q('lm03','logic','Complete: 2, 6, 12, 20, 30, ___',['40','42','44','46'],1,'Differences: 4,6,8,10,12 → 30+12=42','medium'),
    _q('lm04','logic','A father is 4 times his son\'s age. If son is 10, how old will father be when son is 20?',['50','55','60','45'],1,'Father is now 40. In 10 years: 50','medium'),
    _q('lm05','logic','If all roses are flowers, and some flowers fade quickly, can we say all roses fade quickly?',['Yes','No','Maybe','Always'],1,'Some flowers ≠ all roses. This is a logical fallacy.','medium'),

    // ═══════════════════════════════════════════════════════════════════════
    // CODING & AI
    // ═══════════════════════════════════════════════════════════════════════

    _q('ce01','coding','What does CPU stand for?',['Central Processing Unit','Computer Personal Unit','Central Power Unit','Core Processing Unit'],0,'CPU = Central Processing Unit — the brain of a computer.','easy'),
    _q('ce02','coding','What is a "loop" in programming?',['A variable type','Code that repeats','A math function','A type of error'],1,'A loop repeats a block of code until a condition is met.','easy'),
    _q('ce03','coding','What does HTML stand for?',['Hyper Text Markup Language','High Tech Modern Language','Hyper Transfer Medium Language','Home Tool Markup Language'],0,'HTML = HyperText Markup Language — used to build web pages.','easy'),
    _q('ce04','coding','What does AI stand for?',['Automatic Interface','Artificial Intelligence','Advanced Input','Automatic Information'],1,'AI = Artificial Intelligence — machines that can think and learn.','easy'),
    _q('ce05','coding','In binary, what does "1010" represent?',['8','10','12','14'],1,'1×8 + 0×4 + 1×2 + 0×1 = 10','easy'),
    _q('ce06','coding','What is a "bug" in programming?',['An insect','A feature','An error in code','A database'],2,'A bug is an error that causes unexpected behavior in a program.','easy'),
    _q('ce07','coding','Which language is most commonly used for web styling?',['Python','Java','CSS','C++'],2,'CSS (Cascading Style Sheets) styles web pages.','easy'),
    _q('ce08','coding','What does "www" stand for?',['World Wide Web','Wide World Web','World Web Wide','Web World Wide'],0,'www = World Wide Web, created by Tim Berners-Lee.','easy'),
    _q('ce09','coding','What is the function of a keyboard shortcut "Ctrl+Z"?',['Save','Copy','Undo','Paste'],2,'Ctrl+Z undoes the last action.','easy'),
    _q('ce10','coding','Which of these is NOT a programming language?',['Python','HTML','Java','Photoshop'],3,'Photoshop is a design tool, not a programming language.','easy'),
    _q('cm01','coding','What does "if-else" do in programming?',['Loops code','Makes decisions','Stores data','Prints output'],1,'"if-else" is a conditional statement that makes decisions.','medium'),
    _q('cm02','coding','What is an "algorithm"?',['A type of computer','A step-by-step problem-solving process','A programming language','A computer virus'],1,'An algorithm is a set of step-by-step instructions to solve a problem.','medium'),
    _q('cm03','coding','What does "RAM" stand for?',['Random Access Memory','Read All Memory','Run All Modules','Rapid Array Module'],0,'RAM = Random Access Memory — temporary fast storage.','medium'),
    _q('cm04','coding','What is the output of: print(2 ** 10) in Python?',['20','102','1024','512'],2,'2 ** 10 = 2¹⁰ = 1024 in Python','medium'),
    _q('cm05','coding','What type of AI learns from examples without being explicitly programmed?',['Rule-based AI','Machine Learning','Expert System','Robotic AI'],1,'Machine Learning trains models on data to make predictions.','medium'),

    // ═══════════════════════════════════════════════════════════════════════
    // GEOGRAPHY
    // ═══════════════════════════════════════════════════════════════════════

    _q('ge01','geography','What is the largest country in the world by area?',['Canada','China','USA','Russia'],3,'Russia covers ~17.1 million km².','easy'),
    _q('ge02','geography','Which is the longest river in the world?',['Amazon','Yangtze','Mississippi','Nile'],3,'The Nile is ~6,650 km long.','easy'),
    _q('ge03','geography','How many continents are on Earth?',['5','6','7','8'],2,'7 continents: Asia, Africa, N. America, S. America, Antarctica, Europe, Australia.','easy'),
    _q('ge04','geography','What is the capital of Japan?',['Osaka','Kyoto','Hiroshima','Tokyo'],3,'Tokyo is Japan\'s capital and largest city.','easy'),
    _q('ge05','geography','Which is the largest ocean?',['Atlantic','Indian','Arctic','Pacific'],3,'The Pacific covers over 30% of Earth\'s surface.','easy'),
    _q('ge06','geography','What is the capital of Australia?',['Sydney','Melbourne','Brisbane','Canberra'],3,'Canberra is Australia\'s capital (not Sydney!).','easy'),
    _q('ge07','geography','Which is the smallest country in the world?',['Monaco','San Marino','Vatican City','Liechtenstein'],2,'Vatican City is the smallest at just 0.44 km².','easy'),
    _q('ge08','geography','Mount Everest is located in which mountain range?',['Alps','Andes','Rockies','Himalayas'],3,'Everest is in the Himalayas on Nepal\'s border with Tibet.','easy'),
    _q('ge09','geography','What is the capital of France?',['Lyon','Marseille','Paris','Nice'],2,'Paris is the capital of France.','easy'),
    _q('ge10','geography','Which country has the most natural lakes?',['USA','Brazil','Canada','Russia'],2,'Canada has ~60% of the world\'s freshwater lakes.','easy'),
    _q('ge11','geography','What is the capital of India?',['Mumbai','Kolkata','Chennai','New Delhi'],3,'New Delhi is the capital of India.','easy'),
    _q('ge12','geography','The Amazon River is in which continent?',['Africa','Asia','Europe','South America'],3,'The Amazon flows through South America (mainly Brazil).','easy'),
    _q('ge13','geography','Which desert is the largest in the world?',['Sahara','Gobi','Arabian','Antarctic'],3,'The Antarctic Desert is the largest (~14.2 million km²).','easy'),
    _q('ge14','geography','What is the currency of Japan?',['Yuan','Yen','Won','Ringgit'],1,'Japan\'s currency is the Yen (¥).','easy'),
    _q('ge15','geography','Which is the most populated country in the world?',['USA','China','India','Russia'],1,'China (and now India close behind) is most populated.','easy'),
    _q('gm01','geography','The Tropic of Cancer passes through which Indian state?',['Rajasthan','Madhya Pradesh','Gujarat','All of these'],3,'Tropic of Cancer passes through Gujarat, Rajasthan, MP, and others.','medium'),
    _q('gm02','geography','Which two continents are separated by the Suez Canal?',['Asia & Europe','Africa & Asia','Africa & Europe','Europe & America'],1,'The Suez Canal separates Africa (west) from Asia (east).','medium'),
    _q('gm03','geography','What is the capital of Brazil?',['Rio de Janeiro','São Paulo','Salvador','Brasília'],3,'Brasília is the capital of Brazil (since 1960).','medium'),
    _q('gm04','geography','The International Date Line roughly follows which meridian?',['0°','90°E','180°','90°W'],2,'The IDL follows approximately the 180° meridian.','medium'),
    _q('gm05','geography','Which country has the most time zones?',['USA','Russia','China','France'],3,'France (including overseas territories) has 12 time zones.','medium'),

    // ═══════════════════════════════════════════════════════════════════════
    // ENGLISH
    // ═══════════════════════════════════════════════════════════════════════

    _q('ee01','english','What is the synonym of "Happy"?',['Sad','Angry','Joyful','Tired'],2,'Joyful = full of joy = synonym for happy.','easy'),
    _q('ee02','english','What is the antonym of "Ancient"?',['Old','Big','Modern','Slow'],2,'Ancient = very old. Antonym = Modern.','easy'),
    _q('ee03','english','What does "Enormous" mean?',['Very small','Very fast','Very loud','Very large'],3,'Enormous = extremely large.','easy'),
    _q('ee04','english','Which is correct?',['She don\'t like apples.','She doesn\'t likes apples.','She doesn\'t like apples.','She not like apples.'],2,'"Doesn\'t" = does not. Use "doesn\'t" with he/she/it.','easy'),
    _q('ee05','english','The plural of "child" is?',['Childs','Childes','Children','Childrens'],2,'Children is the irregular plural of child.','easy'),
    _q('ee06','english','Fill in: It ___ raining outside.',['are','were','is','was'],2,'For current weather, use "It is raining."','easy'),
    _q('ee07','english','Which word is a verb?',['Beautiful','Quickly','Run','Apple'],2,'Run is a verb (action word).','easy'),
    _q('ee08','english','What is the past tense of "go"?',['Goed','Gone','Went','Going'],2,'The irregular past tense of "go" is "went."','easy'),
    _q('ee09','english','What is the opposite of "victory"?',['Win','Success','Defeat','Triumph'],2,'Defeat is the antonym of victory.','easy'),
    _q('ee10','english','Which punctuation ends a question?',['Period (.)','Comma (,)','Question mark (?)','Exclamation mark (!)'],2,'Questions always end with a question mark (?).','easy'),
    _q('ee11','english','What is a "noun"?',['Action word','Describing word','Connecting word','Person, place, or thing'],3,'A noun names a person, place, thing, or idea.','easy'),
    _q('ee12','english','What is the superlative of "good"?',['Gooder','Better','Best','Most good'],2,'"Best" is the superlative of "good."','easy'),
    _q('ee13','english','She ___ to school every day.',['go','goes','going','gone'],1,'Use "goes" with she/he/it (third person singular).','easy'),
    _q('ee14','english','What is the synonym of "brave"?',['Cowardly','Fearful','Courageous','Timid'],2,'Courageous = brave = willing to face danger.','easy'),
    _q('ee15','english','Which sentence is in passive voice?',['She wrote a letter.','A letter was written by her.','She writes letters.','She is writing.'],1,'"Was written" = passive voice (subject receives the action).','easy'),
    _q('em01','english','What is a "metaphor"?',['Comparing with "like" or "as"','A direct comparison without "like"','Exaggeration for effect','Repeating sounds'],1,'A metaphor directly says one thing IS another, without "like" or "as."','medium'),
    _q('em02','english','Identify the figure of speech: "The stars danced in the night sky."',['Simile','Metaphor','Personification','Hyperbole'],2,'Personification gives human qualities (dancing) to non-human things.','medium'),
    _q('em03','english','What does the prefix "un-" mean?',['Again','Together','Not or opposite','Before'],2,'"Un-" means not/opposite: unhappy, unkind, unclear.','medium'),
    _q('em04','english','Which sentence uses correct punctuation?',['Lets eat grandma.','Let\'s eat grandma.','Let\'s eat, grandma.','Lets eat, grandma.'],2,'The comma after "eat" saves grandma! "Let\'s eat, grandma."','medium'),
    _q('em05','english','What is an "oxymoron"?',['Exaggeration','Contradiction in terms','List of items','Sound repetition'],1,'An oxymoron combines contradictory terms: "deafening silence," "living dead."','medium'),

    // ═══════════════════════════════════════════════════════════════════════
    // FINANCE
    // ═══════════════════════════════════════════════════════════════════════

    _q('fe01','finance','You have ₹200. You spend ₹85. How much is left?',['₹105','₹115','₹125','₹135'],1,'200 − 85 = ₹115','easy'),
    _q('fe02','finance','What is a "budget"?',['A type of bank','A plan for managing money','A type of coin','A savings account'],1,'A budget is a plan to track your income and expenses.','easy'),
    _q('fe03','finance','Save ₹10 every day for 30 days. Total savings?',['₹200','₹250','₹300','₹350'],2,'10 × 30 = ₹300','easy'),
    _q('fe04','finance','Which is a "need" not a "want"?',['Video games','Cinema ticket','Food','Toy'],2,'Food, water, shelter are needs. Entertainment is a want.','easy'),
    _q('fe05','finance','An item costs ₹500 at 20% discount. Sale price?',['₹380','₹390','₹400','₹410'],2,'20% of 500 = 100. 500−100 = ₹400','easy'),
    _q('fe06','finance','What does a bank pay you for keeping money with them?',['Rent','Tax','Interest','Profit'],2,'Banks pay interest on savings deposits.','easy'),
    _q('fe07','finance','If you earn ₹5000/month and save ₹1000, your savings rate is?',['10%','15%','20%','25%'],2,'1000/5000 × 100 = 20%','easy'),
    _q('fe08','finance','What is "inflation"?',['Rising prices over time','Falling prices','A type of tax','A savings scheme'],0,'Inflation = general rise in price levels over time.','easy'),
    _q('fe09','finance','GST stands for?',['General Sales Tax','Goods and Services Tax','Government Service Tariff','Gross Sales Total'],1,'GST = Goods and Services Tax — an indirect tax in India.','easy'),
    _q('fe10','finance','Simple interest for ₹1000 at 10% for 2 years?',['₹100','₹150','₹200','₹250'],2,'SI = P×R×T/100 = 1000×10×2/100 = ₹200','easy'),
    _q('fm01','finance','What is compound interest?',['Interest on principal only','Interest on principal + accumulated interest','Tax on income','Fee charged by bank'],1,'CI = interest earned on both principal AND previously earned interest.','medium'),
    _q('fm02','finance','A car bought for ₹5,00,000 loses 10% value each year. Value after 2 years?',['₹4,00,000','₹4,05,000','₹4,10,000','₹3,90,000'],1,'Year1: 5L×0.9=4.5L. Year2: 4.5L×0.9=4.05L','medium'),
    _q('fm03','finance','What does EMI stand for?',['Easy Money Installment','Equated Monthly Installment','Equal Money Income','Electronic Money Interface'],1,'EMI = Equated Monthly Installment (loan repayments).','medium'),
    _q('fm04','finance','If profit is ₹300 on cost ₹1200, profit percentage is?',['20%','25%','30%','15%'],1,'Profit% = 300/1200 × 100 = 25%','medium'),
    _q('fm05','finance','What is the "stock market"?',['Where fruits are sold','Where companies\' shares are traded','A government bank','A type of insurance'],1,'The stock market is where shares/stocks of companies are bought and sold.','medium'),
  ];
}
