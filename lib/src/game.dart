import 'dart:io';
import 'dart:math';
import 'character.dart';
import 'monster.dart';

/// 게임을 관리하는 클래스
class Game {
  Character? character;
  List<Monster> monsters = [];
  int defeatedMonsters = 0;
  final Random _random = Random();

  /// 게임 시작
  void startGame() {
    print('\n=== 게임을 시작합니다 ===\n');

    try {
      _loadCharacterStats();
      _loadMonsterStats();

      if (character == null) {
        throw Exception('캐릭터를 생성할 수 없습니다.');
      }

      _tryGiveBonusHealth();

      print('\n모든 데이터를 성공적으로 불러왔습니다!\n');
      character!.showStatus();

      while (character!.isAlive() && !monsters.isEmpty) {
        if (!_battle()) break;

        if (monsters.isNotEmpty) {
          print('\n다음 몬스터와 대결하시겠습니까? (y/n)');
          String? answer = stdin.readLineSync()?.toLowerCase();
          if (answer != 'y') break;
        }
      }

      _endGame();
    } catch (e) {
      print('오류가 발생했습니다: $e');
      exit(1);
    }
  }

  /// 전투 진행
  bool _battle() {
    Monster monster = _getRandomMonster();
    monster.setAttackPower(character!.defense);

    print('\n=== 전투 시작! ===');
    print('${character!.name} VS ${monster.name}\n');

    while (monster.isAlive() && character!.isAlive()) {
      character!.showStatus();
      monster.showStatus();

      print('\n행동을 선택하세요:');
      print('1. 공격하기');
      print('2. 방어하기');
      if (character!.canUseItem()) {
        print('3. 아이템 사용하기');
      }

      String? input = stdin.readLineSync();

      if (input == '1') {
        character!.attackEntity(monster);
      } else if (input == '2') {
        character!.defend();
      } else if (input == '3' && character!.canUseItem()) {
        character!.useItem();
        continue;
      } else {
        print('\n잘못된 입력입니다. 다시 선택해주세요.');
        continue;
      }

      if (monster.isAlive()) {
        monster.attackEntity(character!);
      }
    }

    if (monster.isAlive()) {
      return false;
    } else {
      print('\n${monster.name}을(를) 물리쳤습니다!');
      monsters.remove(monster);
      defeatedMonsters++;
      return true;
    }
  }

  /// 랜덤 몬스터 선택
  Monster _getRandomMonster() {
    return monsters[_random.nextInt(monsters.length)];
  }

  /// 캐릭터 데이터 로드
  void _loadCharacterStats() {
    try {
      final file = File('characters.txt');
      final contents = file.readAsStringSync();
      final stats = contents.split(',');

      if (stats.length != 3) {
        throw FormatException('잘못된 캐릭터 데이터 형식입니다.');
      }

      int health = int.parse(stats[0]);
      int attack = int.parse(stats[1]);
      int defense = int.parse(stats[2]);

      String name = _getCharacterName();
      character = Character(name, health, attack, defense);
    } catch (e) {
      print('캐릭터 데이터를 불러오는 데 실패했습니다: $e');
      rethrow;
    }
  }

  /// 몬스터 데이터 로드
  void _loadMonsterStats() {
    try {
      final file = File('monsters.txt');
      final lines = file.readAsLinesSync();

      for (var line in lines) {
        final stats = line.split(',');
        if (stats.length != 3) {
          throw FormatException('잘못된 몬스터 데이터 형식입니다: $line');
        }

        String name = stats[0];
        int health = int.parse(stats[1]);
        int maxAttack = int.parse(stats[2]);

        monsters.add(Monster(name, health, maxAttack));
      }
    } catch (e) {
      print('몬스터 데이터를 불러오는 데 실패했습니다: $e');
      rethrow;
    }
  }

  /// 캐릭터 이름 입력 받기
  String _getCharacterName() {
    while (true) {
      print('캐릭터의 이름을 입력하세요 (한글 또는 영문만 가능):');
      String? name = stdin.readLineSync();

      if (name == null || name.isEmpty) {
        print('이름을 입력해주세요.');
        continue;
      }

      if (!RegExp(r'^[a-zA-Z가-힣]+$').hasMatch(name)) {
        print('이름에는 한글과 영문만 사용할 수 있습니다.');
        continue;
      }

      return name;
    }
  }

  /// 게임 종료 처리
  void _endGame() {
    if (!character!.isAlive()) {
      print('\n게임 오버! ${character!.name}이(가) 쓰러졌습니다.');
    } else if (monsters.isEmpty) {
      print('\n축하합니다! 모든 몬스터를 물리쳤습니다!');
    } else {
      print('\n게임을 종료합니다.');
    }

    print('\n결과를 저장하시겠습니까? (y/n)');
    String? answer = stdin.readLineSync()?.toLowerCase();

    if (answer == 'y') {
      _saveResult();
    }
  }

  /// 게임 결과 저장
  void _saveResult() {
    try {
      final file = File('result.txt');
      final result = '''
캐릭터 이름: ${character!.name}
남은 체력: ${character!.health}
게임 결과: ${character!.isAlive() ? '승리' : '패배'}
물리친 몬스터 수: $defeatedMonsters
''';

      file.writeAsStringSync(result);
      print('결과가 저장되었습니다.');
    } catch (e) {
      print('결과를 저장하는 데 실패했습니다: $e');
    }
  }

  /// 30% 확률로 보너스 체력 부여
  void _tryGiveBonusHealth() {
    if (_random.nextDouble() < 0.3) {
      character!.health += 10;
      print('\n보너스 체력을 얻었습니다! 현재 체력: ${character!.health}');
    }
  }
}
