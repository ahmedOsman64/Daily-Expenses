import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';

class FinancialWisdomCard extends StatefulWidget {
  const FinancialWisdomCard({super.key, this.isTransparent = false});

  final bool isTransparent;

  @override
  State<FinancialWisdomCard> createState() => _FinancialWisdomCardState();
}

class _FinancialWisdomCardState extends State<FinancialWisdomCard> {
  final List<String> _quotes = [
    // English Quotes (1-100)
    "Spend less than you earn.", "Save before you spend.", "Avoid lifestyle inflation.", "Discipline beats motivation.", "Small expenses add up.", "Wealth is built slowly.", "Focus on long-term goals.", "Money is a tool, not the goal.", "Learn financial literacy early.", "Patience creates wealth.",
    "Always have a budget.", "Track every expense.", "Build an emergency fund (3–6 months).", "Save at least 10–20% of income.", "Automate your savings.", "Cut unnecessary subscriptions.", "Differentiate needs vs wants.", "Avoid impulse buying.", "Plan big purchases in advance.", "Review your finances monthly.",
    "Avoid bad debt.", "Pay off high-interest debt first.", "Don’t use credit cards irresponsibly.", "Borrow only what you can repay.", "Debt can delay your freedom.", "Understand interest rates.", "Avoid loans for luxury items.", "Pay more than the minimum payment.", "Consolidate debt if needed.", "Being debt-free is powerful.",
    "Start investing early.", "Compound interest is powerful.", "Don’t put all money in one place (diversify).", "Invest consistently.", "Think long-term, not quick profits.", "Understand risk before investing.", "Avoid emotional decisions.", "Learn before you invest.", "Reinvest your earnings.", "Time in the market beats timing the market.",
    "Increase your income streams.", "Learn valuable skills.", "Invest in yourself.", "Don’t rely on one income source.", "Negotiate your salary.", "Side hustles can accelerate wealth.", "Build assets, not just income.", "Turn hobbies into income when possible.", "Always look for growth opportunities.", "Your skills determine your earning power.",
    "Live below your means.", "Avoid comparing yourself to others.", "Luxury doesn’t equal happiness.", "Buy quality over quantity.", "Delay gratification.", "Avoid showing off wealth.", "Simplicity saves money.", "Experiences can be more valuable than things.", "Don’t follow trends blindly.", "Be content but ambitious.",
    "Have insurance (health, life if needed).", "Plan for retirement early.", "Protect your assets.", "Create financial goals.", "Prepare for unexpected events.", "Avoid financial scams.", "Keep records of finances.", "Write a will if necessary.", "Understand taxes.", "Plan before making big financial moves.",
    "If it sounds too good, it’s risky.", "Do your own research.", "Avoid herd mentality.", "Learn from financial mistakes.", "Focus on value, not price.", "Think before spending.", "Money decisions should be logical, not emotional.", "Avoid get-rich-quick schemes.", "Question financial advice.", "Knowledge reduces risk.",
    "Build assets that generate income.", "Passive income creates freedom.", "Reinvest profits.", "Stay consistent over years.", "Wealth is a marathon, not a sprint.", "Focus on sustainability.", "Avoid unnecessary risks.", "Keep learning about money.", "Be patient with results.", "Financial freedom is built step by step.",
    "Choose financially responsible partners/friends.", "Teach others about money.", "Don’t lend money you can’t afford to lose.", "Set financial boundaries.", "Help others wisely, not blindly.", "Be honest about money matters.", "Avoid peer pressure spending.", "Surround yourself with growth-minded people.", "Generosity is good, but within limits.", "True wealth includes peace of mind.",

    // English Quotes (101-400) - Shortened for brevity in this tool call, I will include them all
    "Money follows value.", "The more problems you solve, the more you can earn.", "Wealth starts in the mind before it appears in the bank.", "Financial freedom requires sacrifice.", "Rich habits create rich results.", "Every coin has a purpose.", "Financial discipline creates confidence.", "Avoid emotional shopping.", "A budget gives freedom, not restriction.", "Wealth loves consistency.",
    "Learn to say no to unnecessary spending.", "Financial peace is priceless.", "Protect your future self.", "Good habits beat high income with bad discipline.", "Money grows where it is managed well.", "Never stop learning about finance.", "Think in years, not days.", "Build wealth quietly.", "Focus on progress, not perfection.", "Every saving starts with one decision.",
    "Save first, spend second.", "Use the 24-hour rule before buying.", "Avoid shopping when emotional.", "Bulk buying can save money.", "Compare prices before purchasing.", "Discounts are only useful if needed.", "Cheap can become expensive later.", "Maintain what you own.", "Repair before replacing.", "Create spending limits.",
    "Use cash for better spending awareness.", "Keep personal and business money separate.", "Track recurring expenses.", "Avoid paying for status.", "Don’t confuse affordability with necessity.", "Keep emergency cash accessible.", "Plan for annual expenses.", "Save for future goals separately.", "Avoid wasting food and utilities.", "Every small saving matters.",
    "Start where you are.", "Even small investments grow over time.", "Consistency beats occasional large investments.", "Never invest money you need urgently.", "Diversification reduces risk.", "Learn how markets work.", "Volatility is normal.", "Focus on fundamentals.", "Avoid panic selling.", "Don’t invest based on hype.",
    "Research before trusting influencers.", "Invest in productive assets.", "Assets should work while you sleep.", "Rebalance your portfolio periodically.", "Long-term investing wins more often.", "Wealth compounds with patience.", "Protect gains with smart strategy.", "Understand risk tolerance.", "Growth requires time.", "Think like an owner, not a gambler.",
    "Your income is your first asset.", "Learn high-income skills.", "Improve communication skills.", "Increase your market value.", "Build a professional network.", "Skills create security.", "Side income reduces risk.", "Don’t depend on one employer forever.", "Learn digital skills.", "Time is also money.",
    "Focus on productivity.", "Ask for raises when deserved.", "Keep learning new tools.", "Create multiple income streams.", "Use extra income wisely.", "Turn profits into assets.", "Entrepreneurship requires discipline.", "Income growth should match savings growth.", "Invest in reputation.", "Knowledge can create wealth faster than capital.",
    "Avoid unnecessary financial risks.", "Read contracts carefully.", "Never sign what you don’t understand.", "Keep a backup plan.", "Protect your data and accounts.", "Use strong passwords for banking apps.", "Be careful with online scams.", "Verify before sending money.", "Insurance protects against disaster.", "Protect important documents.",
    "Keep emergency contacts ready.", "Fraud prevention saves money.", "Avoid risky guarantees.", "Secure your digital wallet.", "Prepare for income loss.", "Have health protection plans.", "Avoid lending without clear terms.", "Keep financial privacy.", "Review risks regularly.", "Protect wealth as much as you build it.",
    "Wealth is created by ownership, not just income.", "Think like an investor, not a consumer.", "Delayed gratification builds empires.", "Rich people buy time, not things.", "Control your money or it will control you.", "Your habits define your financial future.", "Wealth requires clarity and vision.", "Stop trading time only for money.", "Build systems, not just effort.", "Financial independence is a decision first.",
    "Focus on assets that scale.", "Money grows with strategy.", "Be intentional with every dollar.", "Build wealth silently.", "Consistency creates exponential results.", "Financial success is a long-term game.", "Focus on leverage.", "Avoid short-term thinking.", "High income without control leads to poverty.", "Wealth is built in private.",
    "Solve real problems to make money.", "Customers are the foundation of business.", "Profit matters more than revenue.", "Keep business expenses under control.", "Cash flow is king.", "Reinvest profits wisely.", "Build systems that run without you.", "Learn sales and marketing.", "Brand builds trust.", "Provide value first.",
    "A good reputation is priceless.", "Start small, scale fast.", "Test ideas before investing heavily.", "Know your market.", "Learn from competitors.", "Focus on customer experience.", "Efficiency increases profits.", "Hire smart, not fast.", "Business risk must be calculated.", "Growth requires reinvestment.",
    "Invest with a clear strategy.", "Avoid speculation without knowledge.", "Wealth grows in strong assets.", "Understand market cycles.", "Buy value, not hype.", "Hold through volatility when fundamentals are strong.", "Learn from investment mistakes.", "Capital preservation is key.", "Risk management is everything.", "Focus on long-term compounding.",
    "Avoid overtrading.", "Patience increases returns.", "Invest regularly regardless of market mood.", "Knowledge reduces losses.", "Diversify across asset classes.", "Review investments periodically.", "Avoid emotional decisions.", "Never chase quick profits.", "Learn global markets.", "Smart investors stay calm.",
    "Build automated money systems.", "Separate income, savings, and investments.", "Use percentages, not guesses.", "Always pay yourself first.", "Track net worth regularly.", "Optimize expenses continuously.", "Increase savings rate over time.", "Design a long-term financial plan.", "Monitor cash flow.", "Financial clarity reduces stress.",
    "Set clear financial milestones.", "Use tools to manage money.", "Simplify your finances.", "Avoid financial chaos.", "Plan for taxes and obligations.", "Build predictable systems.", "Reduce financial friction.", "Align spending with goals.", "Stay organized financially.", "Review and adjust plans yearly.",
    "Fear and greed control markets.", "Emotional control is financial power.", "Confidence comes from knowledge.", "Avoid comparing your journey.", "Social pressure destroys savings.", "Financial stress comes from lack of control.", "Happiness is not equal to spending.", "Money amplifies behavior.", "Discipline creates freedom.", "Impulse is the enemy of wealth.",
    "Clarity reduces bad decisions.", "Focus beats distraction.", "Patience beats urgency.", "Habits beat talent in finance.", "Control emotions during losses.", "Learn to wait for opportunities.", "Stay calm during uncertainty.", "Financial maturity takes time.", "Mindset shapes outcomes.", "Master your mind to master your money.",
    "Millionaires think long-term in everything.", "They focus on building assets, not liabilities.", "They prioritize freedom over luxury.", "They think in terms of return on investment (ROI).", "They control emotions during financial decisions.", "They value time more than money.", "They avoid unnecessary risks.", "They stay disciplined even after success.", "They constantly learn and adapt.", "They focus on results, not appearance.",
    "They build wealth quietly.", "They delay gratification consistently.", "They stay focused on goals.", "They don’t chase trends blindly.", "They take calculated risks.", "They see opportunities where others see problems.", "They think in systems, not shortcuts.", "They prioritize financial independence.", "They understand the power of leverage.", "They protect their mindset from negativity.",
    "Build scalable income streams.", "Focus on high-impact activities.", "Create value at scale.", "Use systems to multiply output.", "Delegate low-value tasks.", "Invest in strong teams.", "Use technology to increase efficiency.", "Focus on profit margins.", "Build multiple income sources.", "Monetize knowledge and skills.",
    "Develop strong negotiation skills.", "Own equity whenever possible.", "Focus on industries with growth potential.", "Solve expensive problems.", "Build businesses that can run without you.", "Optimize operations regularly.", "Use data to make decisions.", "Build strategic partnerships.", "Focus on customer retention.", "Scale smart, not fast.",
    "Focus on asset allocation.", "Balance risk and reward carefully.", "Invest in income-producing assets.", "Understand global economic trends.", "Use diversification strategically.", "Reinvest dividends and profits.", "Think in decades, not months.", "Avoid overexposure to one asset.", "Use downturns as buying opportunities.", "Study successful investors.",
    "Protect capital before seeking growth.", "Use tax-efficient investing strategies.", "Avoid emotional trading decisions.", "Invest based on fundamentals.", "Monitor portfolio performance.", "Use compounding to your advantage.", "Limit speculative investments.", "Keep liquidity for opportunities.", "Adjust strategy as life changes.", "Focus on consistent returns.",
    "Protect wealth through diversification.", "Use legal structures for asset protection.", "Plan for generational wealth.", "Keep a portion of assets liquid.", "Insure valuable assets.", "Plan for economic downturns.", "Minimize unnecessary taxes legally.", "Secure financial accounts.", "Maintain financial privacy.", "Have a clear estate plan.",
    "Regularly review financial structures.", "Protect intellectual property.", "Avoid overleveraging.", "Maintain strong financial records.", "Use advisors when necessary.", "Diversify income globally if possible.", "Prepare for unexpected risks.", "Build long-term stability.", "Protect business continuity.", "Think beyond your lifetime.",
    "Time-block high-value work.", "Focus on what generates income.", "Avoid distractions.", "Build strong daily routines.", "Prioritize health for productivity.", "Invest in personal development.", "Track performance regularly.", "Focus on efficiency.", "Eliminate time-wasting habits.", "Make decisions quickly but wisely.",
    "Learn to say no often.", "Work with clear priorities.", "Rest strategically to maintain energy.", "Build momentum daily.", "Focus on output, not effort.", "Use tools to increase productivity.", "Keep learning from failures.", "Stay consistent under pressure.", "Measure results, not activity.", "Execute ideas relentlessly.",

    // Arabic Quotes (1-400)
    "أنفق أقل مما تكسب.", "ادخر قبل أن تنفق.", "تجنب تضخم نمط الحياة.", "الانضباط أهم من الحماس.", "المصاريف الصغيرة تتراكم.", "الثروة تُبنى ببطء.", "ركّز على الأهداف طويلة المدى.", "المال وسيلة وليس هدفًا.", "تعلّم الثقافة المالية مبكرًا.", "الصبر مفتاح الثروة.",
    "لا تنفق لإبهار الآخرين.", "تحكم في عاداتك المالية.", "المال يحتاج إدارة لا قوة فقط.", "الاستمرارية تصنع الفرق.", "كل قرار مالي له أثر.", "لا تعتمد على الحظ.", "خطط لمستقبلك المالي.", "التوازن مهم في الإنفاق.", "البساطة توفر المال.", "كن واعيًا بمصاريفك.",
    "العادات اليومية تحدد مستقبلك.", "النجاح المالي رحلة طويلة.", "لا تتخذ قرارات عاطفية.", "تعلم من أخطائك المالية.", "لا تؤجل الادخار.", "المال يحب التنظيم.", "ركّز على ما يمكنك التحكم به.", "لا تقارن نفسك بالآخرين.", "تحكم في رغباتك.", "الوعي المالي قوة.",
    "فكر قبل أن تشتري.", "استثمر في نفسك.", "تجنب الإسراف.", "كن صبورًا في بناء الثروة.", "لا تعتمد على دخل واحد.", "راقب عاداتك.", "ضع أهدافًا واضحة.", "تجنب القرارات السريعة.", "المال يحتاج صبرًا.", "الاستقلال المالي يبدأ بقرار.",
    "التوفير عادة يومية.", "ركّز على الأولويات.", "لا تستهلك كل ما تكسب.", "استعد للمستقبل.", "نظم أموالك.", "لا تتبع الآخرين عشوائيًا.", "تعلم باستمرار.", "المال أمانة.", "اجعل أهدافك واقعية.", "كن مسؤولًا ماليًا.",
    "ضع ميزانية شهرية.", "تتبع كل مصاريفك.", "أنشئ صندوق طوارئ.", "ادخر 10–20% من دخلك.", "اجعل الادخار تلقائيًا.", "قلل الاشتراكات غير الضرورية.", "فرّق بين الحاجة والرغبة.", "تجنب الشراء العشوائي.", "خطط للمشتريات الكبيرة.", "راجع ميزانيتك بانتظام.",
    "استخدم النقد أحيانًا للسيطرة.", "لا تنفق تحت الضغط.", "قارن الأسعار دائمًا.", "الجودة أهم من السعر أحيانًا.", "احتفظ بسجل مالي.", "ادخر لأهداف محددة.", "لا تشتري ما لا تحتاجه.", "استهلك بوعي.", "تجنب الهدر.", "نظم نفقاتك.",
    "ادفع لنفسك أولًا.", "قلل المصاريف الثابتة.", "استعد للمصاريف السنوية.", "لا تعتمد على الخصومات.", "الشراء الذكي يوفر المال.", "خطط لكل ريال.", "ادخر للمستقبل.", "لا تهدر الطعام.", "استخدم الموارد بحكمة.", "كن منظمًا ماليًا.",
    "لا تنفق لإرضاء الآخرين.", "تجنب التبذير.", "ضع حدودًا للإنفاق.", "راقب الفواتير.", "وفر في الطاقة والمياه.", "اجعل الادخار عادة.", "لا تتسوق وأنت غاضب.", "تحكم في العروض المغرية.", "لا تشتري بدافع العاطفة.", "فكر قبل الدفع.",
    "راقب حساباتك.", "استعد للطوارئ.", "اجعل لكل هدف حسابًا.", "ادخر حتى لو كان المبلغ صغيرًا.", "الاستمرارية أهم من الكمية.", "نظم حياتك المالية.", "قلل الكماليات.", "عش ببساطة.", "لا تشتري بدافع التقليد.", "المال يحتاج خطة.",
    "تجنب الديون غير الضرورية.", "سدد الديون عالية الفائدة أولًا.", "لا تستخدم بطاقة الائتمان بإفراط.", "اقترض بوعي.", "الدين قد يؤخر حريتك.", "افهم الفائدة جيدًا.", "لا تقترض للكماليات.", "ادفع أكثر من الحد الأدنى.", "خطط لسداد الديون.", "الحرية المالية بدون ديون.",
    "لا تستدن لإبهار الآخرين.", "قلل الالتزامات.", "احسب قدرتك على السداد.", "لا تؤجل سداد الدين.", "الدين مسؤولية كبيرة.", "تجنب القروض السريعة.", "اقرأ شروط القروض.", "لا توقع دون فهم.", "الديون تحتاج انضباط.", "خطط للخروج من الدين.",
    "لا تكرر نفس الأخطاء.", "تعلم من تجاربك.", "تجنب الفوائد العالية.", "لا تعتمد على الدين.", "اعتمد على دخلك.", "الدين عبء طويل.", "كن حذرًا ماليًا.", "لا تغامر بالاقتراض.", "راقب التزاماتك.", "الدين ليس حلًا دائمًا.",
    "تجنب الإفراط.", "احمِ نفسك من الغرق المالي.", "كن واقعيًا في الاقتراض.", "لا تبالغ في التزاماتك.", "تحكم في نفقاتك لتجنب الدين.", "خطط قبل الاقتراض.", "لا تقترض تحت ضغط.", "راقب مصاريفك.", "اعرف حدودك.", "لا تجعل الدين عادة.",
    "خطط ماليًا بحكمة.", "تجنب المخاطر.", "الديون تحتاج إدارة.", "كن مسؤولًا.", "لا تعتمد على المستقبل لسداد الدين.", "نظم التزاماتك.", "لا تتأخر في السداد.", "ادفع بانتظام.", "الدين يحتاج وعي.", "الحرية تبدأ بلا ديون.",
    "ابدأ الاستثمار مبكرًا.", "الفائدة المركبة قوية.", "لا تضع كل أموالك في مكان واحد.", "استثمر بانتظام.", "فكر على المدى الطويل.", "افهم المخاطر.", "لا تتخذ قرارات عاطفية.", "تعلم قبل أن تستثمر.", "أعد استثمار الأرباح.", "الوقت أهم من التوقيت.",
    "الاستثمار يحتاج صبرًا.", "لا تتبع الشائعات.", "ابحث جيدًا.", "نوّع استثماراتك.", "ركز على الأصول.", "لا تندفع.", "تعلم من الأخطاء.", "راقب استثماراتك.", "لا تخاطر بكل شيء.", "كن واقعيًا.",
    "استثمر في ما تفهمه.", "لا تطارد الربح السريع.", "الثبات مهم.", "ركّز على الجودة.", "لا تستثمر بدافع الخوف.", "احمِ رأس مالك.", "اجعل لك خطة.", "استثمر باستمرار.", "راقب السوق.", "كن هادئًا في التقلبات.",
    "فكر كمستثمر.", "لا تتبع القطيع.", "قراراتك يجب أن تكون مدروسة.", "التعلم المستمر مهم.", "لا تستثمر ما تحتاجه قريبًا.", "الصبر يحقق أرباحًا.", "راقب الأداء.", "تجنب العشوائية.", "نظم استثماراتك.", "لا تغامر.",
    "استثمر بذكاء.", "كن مستعدًا للخسارة.", "لا تضعف أمام الخوف.", "ركز على الأساسيات.", "لا تتعجل النتائج.", "استثمر بعقل.", "راقب التطور.", "فكر في المستقبل.", "الاستمرارية تصنع الثروة.", "النجاح يحتاج وقتًا.",
    "الثروة تُبنى بالاستثمار الذكي.", "لا تتجاهل المخاطر.", "استثمر في أصول منتجة.", "دع أموالك تعمل لأجلك.", "لا تركز على الربح فقط.", "افهم السوق جيدًا.", "تعلم من المحترفين.", "لا تتسرع في البيع.", "لا تشتري بدافع الطمع.", "حافظ على استراتيجيتك.",
    "استثمر بثقة ومعرفة.", "راقب التغيرات الاقتصادية.", "لا تستثمر عشوائيًا.", "كن صبورًا.", "راقب المخاطر.", "احمِ أرباحك.", "لا تتأثر بالإعلام.", "ركز على التحليل.", "استثمر بعقلانية.", "لا تندم على الخسائر، تعلم منها.",
    "لا تجعل العاطفة تقودك.", "استثمر للمستقبل.", "لا تعتمد على الحظ.", "راقب أداءك.", "حسن استراتيجيتك.", "استثمر بثبات.", "لا تغير خطتك بسرعة.", "كن هادئًا.", "استثمر بحكمة.", "فكر بعقل المستثمر.",
    "استثمر بوعي.", "لا تخاطر دون فهم.", "ركز على النتائج طويلة المدى.", "استثمر بذكاء.", "كن منضبطًا.", "راقب السوق.", "استثمر بثقة.", "لا تتبع الآخرين.", "فكر بنفسك.", "كن مستقلًا.",
    "تعلم باستمرار.", "طور مهاراتك.", "استثمر في نفسك.", "المعرفة قوة.", "التعلم استثمار.", "لا تتوقف عن التطوير.", "استثمر في التعليم.", "طور نفسك.", "المعرفة تزيد دخلك.", "التعلم يصنع الفرق.",
    "ركّز على بناء الأصول.", "امتلك مشاريعك الخاصة.", "فكر في التوسع.", "استثمر في الفرص الكبيرة.", "لا تضيع وقتك.", "الوقت أهم من المال.", "ابنِ مصادر دخل متعددة.", "استخدم التكنولوجيا.", "فوّض المهام.", "ركّز على النتائج.",
    "كن قائدًا ماليًا.", "خطط للمستقبل البعيد.", "لا تعتمد على وظيفة واحدة.", "ابنِ نظامًا ماليًا.", "فكر كرجل أعمال.", "استثمر في العلاقات.", "ابنِ شبكة قوية.", "التعلم لا يتوقف.", "استثمر في الفرص.", "كن مرنًا.",
    "لا تخف من الفشل.", "تعلم من التجارب.", "استمر في التطوير.", "فكر بشكل استراتيجي.", "خطط للنمو.", "ركز على الابتكار.", "استثمر في الأفكار.", "كن جريئًا بحكمة.", "لا تتوقف.", "استمر في التقدم.",
    "الثروة تحتاج قيادة.", "كن مسؤولًا.", "فكر بعيدًا.", "استثمر بذكاء.", "لا تضيع الفرص.", "كن جاهزًا.", "استغل وقتك.", "ركز على الأولويات.", "لا تتشتت.", "كن منظمًا.",
    "خطط جيدًا.", "نفّذ بسرعة.", "قيّم النتائج.", "حسّن الأداء.", "لا تتوقف عن التعلم.", "استثمر في المستقبل.", "كن صبورًا.", "لا تستعجل النجاح.", "الثروة تحتاج وقتًا.", "الاستمرارية مفتاح النجاح.",
    "فكر بعقلية المليونير.", "ركّز على القيمة.", "استثمر في الحلول.", "ابنِ نظامًا قويًا.", "لا تعتمد على الحظ.", "كن استراتيجيًا.", "استثمر بذكاء.", "لا تتبع القطيع.", "فكر بشكل مستقل.", "طور مهاراتك القيادية.",
    "ركّز على التأثير.", "لا تضيع وقتك.", "استثمر في الابتكار.", "كن مختلفًا.", "لا تخف من المخاطرة المدروسة.", "ركّز على التوسع.", "استثمر في المستقبل.", "لا تتوقف عن النمو.", "فكر بشكل كبير.", "ابنِ إرثًا ماليًا.",
    "لا تكتفِ بالقليل.", "استهدف القمة.", "ركّز على الإنجاز.", "لا تتراجع.", "استمر في التقدم.", "فكر بإيجابية.", "استثمر في الفرص الكبيرة.", "لا تضيع وقتك في الصغائر.", "ركّز على الصورة الكبيرة.", "كن طموحًا.",
    "استثمر في نفسك أولًا.", "لا تعتمد على الآخرين.", "كن قائدًا.", "استثمر بذكاء.", "ركّز على النتائج.", "لا تتشتت.", "فكر بوضوح.", "استثمر في المعرفة.", "لا تتوقف عن التعلم.", "كن مستعدًا للتحديات.",
    "ركّز على النجاح.", "لا تستسلم.", "استمر في المحاولة.", "فكر بإبداع.", "استثمر في الحلول.", "لا تضيع الفرص.", "ركّز على التقدم.", "لا تتوقف.", "استمر في النمو.", "كن قويًا.",
    "لا تخف من الفشل.", "تعلم من الأخطاء.", "استمر في التطوير.", "ركّز على الأهداف.", "لا تتراجع.", "استثمر في المستقبل.", "لا تتوقف عن التعلم.", "كن صبورًا.", "استمر في التقدم.", "النجاح يحتاج وقتًا.",
    "ركّز على الاستمرارية.", "لا تضيع وقتك.", "استثمر في نفسك.", "لا تتوقف عن النمو.", "كن طموحًا.", "استمر في التعلم.", "ركّز على المستقبل.", "لا تستسلم.", "استمر في المحاولة.", "كن قويًا.",
    "ركّز على النجاح.", "لا تتراجع.", "استثمر في الفرص.", "لا تضيع وقتك.", "استمر في التقدم.", "كن صبورًا.", "ركّز على الأهداف.", "لا تستسلم.", "استمر في التعلم.", "النجاح يحتاج صبرًا.",
    "ركّز على التميز.", "لا تتوقف عن التطوير.", "استثمر في نفسك.", "لا تتراجع.", "استمر في النمو.", "كن قويًا.", "ركّز على النجاح.", "لا تستسلم.", "استمر في التقدم.", "كن صبورًا.",
    "ركّز على المستقبل.", "لا تتوقف عن التعلم.", "استثمر في نفسك.", "لا تتراجع.", "استمر في المحاولة.", "كن طموحًا.", "ركّز على النجاح.", "لا تستسلم.", "استمر في التقدم.", "الثروة تُبنى بالصبر والعمل الذكي.",
  ];

  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _quotes.shuffle(); // Randomize the list once
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _quotes.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isTransparent) {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 800),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: Text(
          _quotes[_currentIndex],
          key: ValueKey<int>(_currentIndex),
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.tips_and_updates_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'FINANCIAL WISDOM',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: 40,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 800),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.0, 0.2),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: Text(
                          _quotes[_currentIndex],
                          key: ValueKey<int>(_currentIndex),
                          style: AppTypography.bodyMedium.copyWith(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
