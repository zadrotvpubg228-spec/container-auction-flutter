import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const String kChannelUrl = 'https://t.me/legendfirst';
const String kAdminCode = '228777';

class ContainerLot {
  final String id;
  final String title;
  final String tier;
  final String origin;
  final int avgCatch;
  final int startPrice;
  final int buyNowPrice;
  final Color accentColor;
  final List<String> clues;
  final String lootName;
  final String lootCategory;
  final int lootValue;
  final String lootNote;

  int currentBid;
  String leader;
  bool sold;
  bool opened;
  Map<String, String> botStatuses;
  List<String> bidHistory;
  bool peekDark;

  ContainerLot({
    required this.id,
    required this.title,
    required this.tier,
    required this.origin,
    required this.avgCatch,
    required this.startPrice,
    required this.buyNowPrice,
    required this.accentColor,
    required this.clues,
    required this.lootName,
    required this.lootCategory,
    required this.lootValue,
    required this.lootNote,
    int? currentBid,
    this.leader = '',
    this.sold = false,
    this.opened = false,
    Map<String, String>? botStatuses,
    List<String>? bidHistory,
    this.peekDark = false,
  })  : currentBid = currentBid ?? startPrice,
        botStatuses = botStatuses ??
            {
              'Ольга': 'в игре',
              'Барыга': 'в игре',
              'Тимур_Казань': 'в игре',
              'Mr.Bid': 'в игре',
            },
        bidHistory = bidHistory ?? [];
}

List<ContainerLot> generateThirtyContainers() {
  final templates = [
    {
      'code': 'TGHU 792648 1',
      'title': '40 футов · Эконом',
      'tier': 'Эконом',
      'origin': 'Из страны: Китай · Неоплаченное хранение',
      'avg': 72000,
      'start': 11000,
      'buy': 94000,
      'clues': ['Пахнет бензином', 'Сломанная мебель', 'В щель видно колесо'],
      'loot': 'LEAD 2112',
      'cat': 'Машина',
      'val': 150000,
      'note': 'За шинами — машина! Отправлено в гараж.',
    },
    {
      'code': 'FESU 808486 3',
      'title': '40 футов · Эконом',
      'tier': 'Эконом',
      'origin': 'Из страны: Германия · Портовый склад',
      'avg': 68000,
      'start': 12500,
      'buy': 89000,
      'clues': ['Пахнет машинным маслом', 'Ржавые полки', 'Металлический стук'],
      'loot': 'Набор кованых дисков R17',
      'cat': 'Автозапчасти',
      'val': 84000,
      'note': 'Свежий комплект дисков с лёгкими царапинами.',
    },
    {
      'code': 'MSKU 441902 7',
      'title': '20 футов · Стандарт',
      'tier': 'Стандарт',
      'origin': 'Из страны: Япония · Конфискат',
      'avg': 145000,
      'start': 26000,
      'buy': 175000,
      'clues': ['Пахнет озоном и пластиком', 'Коробки с пломбами', 'Внутри аккуратные стеллажи'],
      'loot': 'Стойка консолей и аудиотехника',
      'cat': 'Электроника',
      'val': 168000,
      'note': 'Рабочая техника в плотной заводской упаковке.',
    },
    {
      'code': 'CMAU 992104 5',
      'title': '40 футов · Бизнес',
      'tier': 'Бизнес',
      'origin': 'Из страны: США · Аукцион склада',
      'avg': 230000,
      'start': 45000,
      'buy': 275000,
      'clues': ['Запах свежей краски', 'Ящики с инструментами', 'Слышно гул генератора'],
      'loot': 'Инверторный генератор + набор спецключа',
      'cat': 'Оборудование',
      'val': 265000,
      'note': 'Отличный комплект для мастерской или выезда.',
    },
    {
      'code': 'HLXU 551820 9',
      'title': '40 футов · Премиум',
      'tier': 'Премиум',
      'origin': 'Из страны: ОАЭ · Частная коллекция',
      'avg': 420000,
      'start': 85000,
      'buy': 495000,
      'clues': ['Пахнет дорогой кожей', 'Мягкие чехлы на полу', 'Виден блеск хрома'],
      'loot': 'Купе-спорткар с тюнингом',
      'cat': 'Авто',
      'val': 540000,
      'note': 'Редкий экземпляр под плотным защитным чехлом.',
    },
    {
      'code': 'LEGX 600001 0',
      'title': '40 футов · VIP 6МВт',
      'tier': 'VIP',
      'origin': 'Из страны: Швейцария · Закрытый лот',
      'avg': 850000,
      'start': 180000,
      'buy': 980000,
      'clues': ['Холодный сухой воздух', 'Тяжёлые модульные блоки', 'Индикаторы питания в глубине'],
      'loot': 'Промышленный энергоблок + редкий лот',
      'cat': 'Энерго / VIP',
      'val': 1120000,
      'note': 'Крупный улов с высокой ликвидностью.',
    },
  ];

  final colors = [
    const Color(0xFF3A5A8C),
    const Color(0xFF4A5568),
    const Color(0xFF2B6CB0),
    const Color(0xFFB7791F),
    const Color(0xFF9B2C2C),
    const Color(0xFF2F855A),
  ];

  final List<ContainerLot> result = [];
  for (int i = 0; i < 30; i++) {
    final base = templates[i % templates.length];
    final mult = 1.0 + (i ~/ templates.length) * 0.14;
    final startP = (((base['start'] as int) * mult) / 500).round() * 500;
    final buyP = (((base['buy'] as int) * mult) / 1000).round() * 1000;
    final avgC = (((base['avg'] as int) * mult) / 1000).round() * 1000;
    final lootV = (((base['val'] as int) * mult) / 1000).round() * 1000;
    final suffix = i < templates.length ? '' : ' #${i + 1}';

    result.add(
      ContainerLot(
        id: 'lot_${i + 1}',
        title: '${base['title']}$suffix',
        tier: base['tier'] as String,
        origin: base['origin'] as String,
        avgCatch: avgC,
        startPrice: startP,
        buyNowPrice: buyP,
        accentColor: colors[i % colors.length],
        clues: List<String>.from(base['clues'] as List),
        lootName: '${base['loot']}$suffix',
        lootCategory: base['cat'] as String,
        lootValue: lootV,
        lootNote: base['note'] as String,
      ),
    );
  }
  return result;
}

void main() {
  runApp(const ContainerAuctionApp());
}

class ContainerAuctionApp extends StatelessWidget {
  const ContainerAuctionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Контейнеры · Аукцион',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B0D12),
        cardColor: const Color(0xFF151922),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFF97316),
          secondary: Color(0xFF22C55E),
        ),
      ),
      home: const AuctionHomeScreen(),
    );
  }
}

class AuctionHomeScreen extends StatefulWidget {
  const AuctionHomeScreen({super.key});

  @override
  State<AuctionHomeScreen> createState() => _AuctionHomeScreenState();
}

class _AuctionHomeScreenState extends State<AuctionHomeScreen> {
  int balance = 120000;
  int navIndex = 0;
  late List<ContainerLot> lots;
  final List> garage = [];
  final Random rng = Random();

  @override
  void initState() {
    super.initState();
    lots = generateThirtyContainers();
  }

  String fmtRub(int v) {
    final s = v.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
      buf.write(s[i]);
    }
    return '${buf.toString()} ₽';
  }

  Future<void> openChannel() async {
    final uri = Uri.parse(kChannelUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Канал: $kChannelUrl')),
      );
    }
  }

  void buyNow(ContainerLot lot) {
    if (lot.sold) return;
    if (balance < lot.buyNowPrice) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Недостаточно средств для выкупа')),
      );
      return;
    }
    setState(() {
      balance -= lot.buyNowPrice;
      lot.currentBid = lot.buyNowPrice;
      lot.leader = 'Вы';
      lot.sold = true;
      lot.bidHistory.insert(0, 'Выкуп сразу — ${fmtRub(lot.buyNowPrice)}');
    });
    _openUnboxing(lot, lot.buyNowPrice);
  }

  Future<void> _openBidding(ContainerLot lot) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BiddingScreen(
          lot: lot,
          balance: balance,
          fmtRub: fmtRub,
          onBalanceChange: (newBal) => setState(() => balance = newBal),
          onWon: (paidPrice) => _openUnboxing(lot, paidPrice),
        ),
      ),
    );
    setState(() {});
  }

  Future<void> _openUnboxing(ContainerLot lot, int paidPrice) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UnboxingScreen(
          lot: lot,
          paidPrice: paidPrice,
          fmtRub: fmtRub,
          onClaimLoot: () {
            setState(() {
              lot.opened = true;
              garage.insert(0, {
                'name': lot.lootName,
                'cat': lot.lootCategory,
                'paid': paidPrice,
                'val': lot.lootValue,
              });
            });
          },
        ),
      ),
    );
    setState(() {});
  }

  void _openAdminDialog() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF151922),
        title: const Text('Вход в админ-панель'),
        content: TextField(
          controller: ctrl,
          obscureText: true,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: 'Введите код доступа'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              if (ctrl.text.trim() == kAdminCode) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AdminScreen(
                      balance: balance,
                      fmtRub: fmtRub,
                      onAddMoney: (add) => setState(() => balance += add),
                      onResetLots: () {
                        setState(() {
                          lots = generateThirtyContainers();
                        });
                      },
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Неверный код')),
                );
              }
            },
            child: const Text('Войти'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1118),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Контейнеры', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            Text(
              'ТЕРМИНАЛ · 30 ЛОТОВ · БАЛАНС: ${fmtRub(balance)}',
              style: const TextStyle(fontSize: 11, color: Colors.white54),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: openChannel,
            tooltip: 'Telegram',
            icon: const Icon(Icons.send, color: Color(0xFFF97316)),
          ),
          IconButton(
            onPressed: _openAdminDialog,
            tooltip: 'Админка',
            icon: const Icon(Icons.admin_panel_settings, color: Colors.white70),
          ),
        ],
      ),
      body: navIndex == 0
          ? _buildMarketTab()
          : navIndex == 1
              ? _buildGarageTab()
              : _buildProfileTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navIndex,
        backgroundColor: const Color(0xFF0E1118),
        selectedItemColor: const Color(0xFFF97316),
        onTap: (i) => setState(() => navIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Рынок (30)'),
          BottomNavigationBarItem(icon: Icon(Icons.garage), label: 'Склад'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Канал / Код'),
        ],
      ),
    );
  }

  Widget _buildMarketTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: lots.length,
      itemBuilder: (context, idx) {
        final lot = lots[idx];
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF151922),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 118,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: lot.accentColor.withOpacity(0.28),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: lot.accentColor.withOpacity(0.6)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0B0D12).withOpacity(0.75),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        lot.id.toUpperCase().replaceFirst('LOT_', 'LOT-'),
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Icon(Icons.directions_boat, color: lot.accentColor, size: 34),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(lot.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(lot.tier, style: const TextStyle(fontSize: 11, color: Colors.white70)),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Text(lot.origin, style: const TextStyle(fontSize: 12, color: Colors.white54)),
              const SizedBox(height: 2),
              Text('средний улов ≈ ${fmtRub(lot.avgCatch)}',
                  style: const TextStyle(fontSize: 12, color: Colors.white70)),
              const SizedBox(height: 10),
              const Text(
                'МАНИФЕСТ ОСМОТРА',
                style: TextStyle(fontSize: 10, letterSpacing: 1, color: Colors.white38, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              for (int c = 0; c < lot.clues.length; c++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '${c + 1}. ${lot.clues[c]}',
                    style: const TextStyle(fontSize: 13, color: Color(0xFFFDBA74)),
                  ),
                ),
              const SizedBox(height: 10),
              if (lot.sold && !lot.opened)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF22C55E),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => _openUnboxing(lot, lot.currentBid),
                    icon: const Icon(Icons.lock_open),
                    label: const Text('Вскрыть контейнер', style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                )
              else if (lot.opened)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('Вскрыто: ${lot.lootName}', style: const TextStyle(color: Colors.white54)),
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF232836),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 11),
                        ),
                        onPressed: () => _openBidding(lot),
                        child: Column(
                          children: [
                            const Text('Торги', style: TextStyle(fontWeight: FontWeight.w800)),
                            Text('от ${fmtRub(lot.startPrice)}',
                                style: const TextStyle(fontSize: 11, color: Colors.white60)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF97316),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 11),
                        ),
                        onPressed: () => buyNow(lot),
                        child: Column(
                          children: [
                            const Text('Выкупить сразу', style: TextStyle(fontWeight: FontWeight.w800)),
                            Text(fmtRub(lot.buyNowPrice),
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGarageTab() {
    if (garage.isEmpty) {
      return const Center(
        child: Text('Склад пуст — выиграйте или выкупите контейнер на рынке.',
            style: TextStyle(color: Colors.white54)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: garage.length,
      itemBuilder: (ctx, i) {
        final item = garage[i];
        final profit = (item['val'] as int) - (item['paid'] as int);
        return Card(
          color: const Color(0xFF151922),
          child: ListTile(
            title: Text(item['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${item['cat']} · Заплатили: ${fmtRub(item['paid'] as int)}'),
            trailing: Text(
              '${profit >= 0 ? '+' : ''}${fmtRub(profit)}',
              style: TextStyle(
                color: profit >= 0 ? const Color(0xFF22C55E) : Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
                Card(
          color: const Color(0xFF151922),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Наш Telegram-канал', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                const Text(kChannelUrl, style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF97316), foregroundColor: Colors.black),
                  onPressed: openChannel,
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Открыть @legendfirst'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          color: const Color(0xFF151922),
          child: ListTile(
            leading: const Icon(Icons.lock, color: Color(0xFFF97316)),
            title: const Text('Админ-панель'),
            subtitle: const Text('Доступ по защищённому коду'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _openAdminDialog,
          ),
        ),
      ],
    );
  }
}
class BiddingScreen extends StatefulWidget {
  final ContainerLot lot;
  final int balance;
  final String Function(int) fmtRub;
  final ValueChanged<int> onBalanceChange;
  final ValueChanged<int> onWon;

  const BiddingScreen({
    super.key,
    required this.lot,
    required this.balance,
    required this.fmtRub,
    required this.onBalanceChange,
    required this.onWon,
  });

  @override
  State<BiddingScreen> createState() => _BiddingScreenState();
}

class _BiddingScreenState extends State<BiddingScreen> {
  late int currentBalance;
  int secondsLeft = 10;
  Timer? timer;
  final Random rng = Random();
  late int step;

  @override
  void initState() {
    super.initState();
    currentBalance = widget.balance;
    step = (widget.lot.startPrice * 0.1).round().clamp(500, 10000);
    if (widget.lot.bidHistory.isEmpty) {
      widget.lot.bidHistory.add('Старт торгов — ${widget.fmtRub(widget.lot.startPrice)}');
    }
    _startTimer();
  }

  void _startTimer() {
    timer?.cancel();
    secondsLeft = 10;
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        secondsLeft--;
        if (secondsLeft == 7 || secondsLeft == 4) {
          _botTurn();
        }
        if (secondsLeft <= 0) {
          t.cancel();
          _finishAuction();
        }
      });
    });
  }

  void _botTurn() {
    final activeBots = widget.lot.botStatuses.entries
        .where((e) => e.value != 'пас')
        .map((e) => e.key)
        .toList();
    if (activeBots.isEmpty) return;

    final bot = activeBots[rng.nextInt(activeBots.length)];
    final maxBotWilling = (widget.lot.buyNowPrice * (0.68 + rng.nextDouble() * 0.25)).round();

    if (widget.lot.currentBid + step > maxBotWilling) {
      widget.lot.botStatuses[bot] = 'пас';
      widget.lot.bidHistory.insert(0, '$bot — пас');
      return;
    }

    final jump = rng.nextInt(4) == 0 ? 2 : 1;
    final nextBid = widget.lot.currentBid + step * jump;
    widget.lot.currentBid = nextBid;
    widget.lot.leader = bot;
    widget.lot.botStatuses[bot] = nextBid > maxBotWilling * 0.85 ? 'сомневается' : 'в игре';
    widget.lot.bidHistory.insert(
      0,
      '$bot — ${widget.fmtRub(nextBid)}${jump > 1 ? ' (прыжок)' : ''}',
    );
  }

  void _placeUserBid(int stepsCount) {
    if (widget.lot.sold) return;
    final targetBid = widget.lot.currentBid + step * stepsCount;
    if (currentBalance < targetBid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не хватает баланса на такую ставку')),
      );
      return;
    }
    setState(() {
      widget.lot.currentBid = targetBid;
      widget.lot.leader = 'Вы';
      widget.lot.bidHistory.insert(0, 'Вы — ${widget.fmtRub(targetBid)}');
    });
    _startTimer();
  }

  void _finishAuction() {
    if (widget.lot.sold) return;
    widget.lot.sold = true;
    final winner = widget.lot.leader.isEmpty ? 'Барыга' : widget.lot.leader;
    widget.lot.leader = winner;
    widget.lot.bidHistory.insert(0, 'Продано! Забрал: $winner за ${widget.fmtRub(widget.lot.currentBid)}');

    if (winner == 'Вы') {
      currentBalance -= widget.lot.currentBid;
      widget.onBalanceChange(currentBalance);
      Navigator.pop(context);
      widget.onWon(widget.lot.currentBid);
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lot = widget.lot;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1118),
        title: Text(lot.title, style: const TextStyle(fontSize: 16)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF151922),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('ТЕКУЩАЯ СТАВКА', style: TextStyle(fontSize: 11, color: Colors.white54)),
                      const SizedBox(height: 4),
                      Text(
                        widget.fmtRub(lot.currentBid),
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFFF97316)),
                      ),
                      Text(
                        'Лидер: ${lot.leader.isEmpty ? 'нет' : lot.leader}',
                        style: const TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: secondsLeft <= 3 ? Colors.red.withOpacity(0.25) : Colors.white10,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${secondsLeft}с',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: secondsLeft <= 3 ? Colors.redAccent : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: lot.botStatuses.entries.map((e) {
                final isPass = e.value == 'пас';
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF151922),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: isPass ? Colors.white10 : const Color(0xFFF97316).withOpacity(0.5)),
                  ),
                  child: Text(
                    '${e.key} · ${e.value}',
                    style: TextStyle(fontSize: 12, color: isPass ? Colors.white38 : Colors.white),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            const Text('ЛЕНТА СТАВОК', style: TextStyle(fontSize: 11, color: Colors.white38, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Expanded(
              child: ListView.builder(
                itemCount: lot.bidHistory.length,
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Text('• ${lot.bidHistory[i]}', style: const TextStyle(fontSize: 13, color: Colors.white70)),
                ),
              ),
            ),
            if (!lot.sold) ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF97316),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => _placeUserBid(1),
                      child: Text('+1 шаг (${widget.fmtRub(step)})', style: const TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _placeUserBid(3),
                      child: Text('+3 шага (+${widget.fmtRub(step * 3)})'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _placeUserBid(5),
                      child: Text('+5 шагов (+${widget.fmtRub(step * 5)})'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
class UnboxingScreen extends StatefulWidget {
  final ContainerLot lot;
  final int paidPrice;
  final String Function(int) fmtRub;
  final VoidCallback onClaimLoot;

  const UnboxingScreen({
    super.key,
    required this.lot,
    required this.paidPrice,
    required this.fmtRub,
    required this.onClaimLoot,
  });

  @override
  State<UnboxingScreen> createState() => _UnboxingScreenState();
}

class _UnboxingScreenState extends State<UnboxingScreen> {
  int stage = 0;

  @override
  Widget build(BuildContext context) {
    final profit = widget.lot.lootValue - widget.paidPrice;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1118),
        title: const Text('Вскрытие контейнера'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFF151922),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: stage == 2 ? const Color(0xFF22C55E) : const Color(0xFFF97316),
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    stage == 0
                        ? Icons.lock
                        : stage == 1
                            ? Icons.flashlight_on
                            : Icons.emoji_events,
                    size: 56,
                    color: stage == 2 ? const Color(0xFF22C55E) : const Color(0xFFF97316),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    widget.lot.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  if (stage == 0)
                    const Text(
                      'Пломбы срезаны. Нажми «Приоткрыть», чтобы заглянуть внутрь.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white60),
                    )
                  else if (stage == 1)
                    Text(
                      'Луч фонарика выхватывает: ${widget.lot.clues.last}...',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFFFDBA74), fontSize: 15),
                    )
                  else ...[
                    Text(
                      widget.lot.lootName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                    const SizedBox(height: 6),
                    Text(widget.lot.lootNote, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70)),
                    const SizedBox(height: 14),
                    Text('Оценка улова: ${widget.fmtRub(widget.lot.lootValue)}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                      'Итог сделки: ${profit >= 0 ? '+' : ''}${widget.fmtRub(profit)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: profit >= 0 ? const Color(0xFF22C55E) : Colors.redAccent,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: stage == 2 ? const Color(0xFF22C55E) : const Color(0xFFF97316),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {
                  if (stage < 2) {
                    setState(() => stage++);
                  } else {
                    widget.onClaimLoot();
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  stage == 0
                      ? 'Приоткрыть и посветить фонариком'
                      : stage == 1
                          ? 'Распахнуть створки полностью'
                          : 'Забрать на склад',
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminScreen extends StatelessWidget {
  final int balance;
  final String Function(int) fmtRub;
  final ValueChanged<int> onAddMoney;
  final VoidCallback onResetLots;

  const AdminScreen({
    super.key,
    required this.balance,
    required this.fmtRub,
    required this.onAddMoney,
    required this.onResetLots,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1118),
        title: const Text('Админ-панель · 228777'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Текущий баланс: ${fmtRub(balance)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                onAddMoney(100000);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('+100 000 ₽ начислено')),
                );
              },
              child: const Text('+ 100 000 ₽ на баланс'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                onAddMoney(1000000);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('+1 000 000 ₽ начислено')),
                );
              },
              child: const Text('+ 1 000 000 ₽ на баланс'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                onResetLots();
                Navigator.pop(context);
              },
              child: const Text('Обновить все 30 контейнеров на рынке'),
            ),
          ],
        ),
      ),
    );
  }
}
