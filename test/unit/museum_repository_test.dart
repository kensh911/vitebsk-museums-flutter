import 'package:flutter_test/flutter_test.dart';
import 'package:vitebsk_museums/data/repositories/museum_repository.dart';

void main() {
  late MuseumRepository repo;

  setUp(() {
    repo = MuseumRepository();
  });

  group('MuseumRepository', () {
    test('возвращает 4 района', () {
      final districts = repo.getAllDistricts();
      expect(districts.length, 4);
    });

    test('все районы содержат музеи', () {
      final districts = repo.getAllDistricts();
      for (final d in districts) {
        expect(d.museums.isNotEmpty, true);
      }
    });

    test('getDistrictById возвращает верный район', () {
      final district = repo.getDistrictById('oktyabrsky');
      expect(district, isNotNull);
      expect(district!.id, 'oktyabrsky');
    });

    test('getDistrictById возвращает null для несуществующего id', () {
      final district = repo.getDistrictById('nonexistent');
      expect(district, isNull);
    });

    test('getMuseumById возвращает верный музей', () {
      final museum = repo.getMuseumById('muzey_shagala');
      expect(museum, isNotNull);
      expect(museum!.id, 'muzey_shagala');
    });

    test('getMuseumById возвращает null для несуществующего id', () {
      final museum = repo.getMuseumById('nonexistent');
      expect(museum, isNull);
    });

    test('getAllMuseums возвращает все музеи из всех районов', () {
      final museums = repo.getAllMuseums();
      final total = repo
          .getAllDistricts()
          .fold(0, (sum, d) => sum + d.museums.length);
      expect(museums.length, total);
    });
  });
}