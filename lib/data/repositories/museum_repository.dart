import 'package:latlong2/latlong.dart';
import '../models/models.dart';

class MuseumRepository {
  static final List<District> _districts = [
    District(
      id: 'oktyabrsky',
      nameRu: 'Октябрьский район',
      nameEn: 'October District',
      nameBe: 'Кастрычніцкі раён',
      center: const LatLng(55.196, 30.202),
      museums: [
        Museum(
          id: 'kraevedchesky',
          name: 'Витебский областной краеведческий музей',
          description:
              'Один из старейших музеев Беларуси, основан в 1918 году. '
              'Хранит богатейшие коллекции по истории, археологии и природе Витебщины.',
          address: 'ул. Ленина, 36',
          openHours: 'Вт–Вс: 10:00–18:00',
          admissionFee: '5 BYN',
          location: const LatLng(55.1941, 30.2012),
          districtId: 'oktyabrsky',
          exhibitions: [
            Exhibition(
              id: 'e1',
              title: 'Витебск в годы Великой Отечественной войны',
              description: 'Документы, фотографии и личные вещи участников войны.',
              dateRange: '01.03.2025 — 31.08.2025',
            ),
            Exhibition(
              id: 'e2',
              title: 'Природа Витебщины',
              description: 'Флора и фауна Витебской области: редкие виды, заповедники.',
              dateRange: 'Постоянная экспозиция',
            ),
            Exhibition(
              id: 'e3',
              title: 'Археология Поднепровья',
              description: 'Артефакты эпохи неолита и раннего Средневековья.',
              dateRange: 'Постоянная экспозиция',
            ),
          ],
        ),
        Museum(
          id: 'khudozhestvennyy',
          name: 'Витебский областной художественный музей',
          description:
              'Крупнейшее собрание изобразительного искусства в регионе: '
              'живопись, графика, скульптура белорусских и зарубежных мастеров.',
          address: 'ул. Ленина, 32',
          openHours: 'Вт–Вс: 11:00–19:00',
          admissionFee: '4 BYN',
          location: const LatLng(55.1938, 30.2008),
          districtId: 'oktyabrsky',
          exhibitions: [
            Exhibition(
              id: 'e4',
              title: 'Русская живопись XVIII–XIX веков',
              description: 'Полотна Айвазовского, Репина и Шишкина из фондов музея.',
              dateRange: 'Постоянная экспозиция',
            ),
            Exhibition(
              id: 'e5',
              title: 'Современное белорусское искусство',
              description: 'Работы молодых витебских художников.',
              dateRange: '15.04.2025 — 15.07.2025',
            ),
          ],
        ),
        Museum(
          id: 'khudozhestvennoe_uchilishche',
          name: 'Музей истории Витебского народного художественного училища',
          description:
              'Посвящён знаменитому училищу, основанному Шагалом в 1919 году, '
              'и авангардному движению УНОВИС.',
          address: 'ул. Правды, 5а',
          openHours: 'Пн–Пт: 10:00–17:00',
          admissionFee: '3 BYN',
          location: const LatLng(55.1953, 30.2031),
          districtId: 'oktyabrsky',
          exhibitions: [
            Exhibition(
              id: 'e6',
              title: 'УНОВИС: авангард в Витебске',
              description: 'История движения «Утвердители нового искусства».',
              dateRange: 'Постоянная экспозиция',
            ),
          ],
        ),
      ],
    ),
    District(
      id: 'zheleznodorozhny',
      nameRu: 'Железнодорожный район',
      nameEn: 'Railway District',
      nameBe: 'Чыгуначны раён',
      center: const LatLng(55.184, 30.171),
      museums: [
        Museum(
          id: 'muzey_shagala',
          name: 'Музей Марка Шагала',
          description:
              'Основная музейная экспозиция, посвящённая великому художнику. '
              'Здесь хранятся графика, гравюры и личные вещи Шагала.',
          address: 'ул. Путна, 2',
          openHours: 'Вт–Вс: 11:00–19:00',
          admissionFee: '6 BYN',
          location: const LatLng(55.1842, 30.1715),
          districtId: 'zheleznodorozhny',
          exhibitions: [
            Exhibition(
              id: 'e7',
              title: 'Графика Марка Шагала',
              description: 'Литографии, офорты и рисунки из парижского периода.',
              dateRange: 'Постоянная экспозиция',
            ),
            Exhibition(
              id: 'e8',
              title: 'Витебск в творчестве Шагала',
              description: 'Виды родного города на полотнах художника.',
              dateRange: '01.05.2025 — 01.10.2025',
            ),
          ],
        ),
        Museum(
          id: 'dom_muzey_shagala',
          name: 'Дом-музей Марка Шагала',
          description:
              'Дом, где родился и вырос Марк Шагал. Восстановленные интерьеры '
              'рубежа XIX–XX веков воссоздают атмосферу детства художника.',
          address: 'ул. Покровская, 11',
          openHours: 'Вт–Вс: 10:00–18:00',
          admissionFee: '5 BYN',
          location: const LatLng(55.1836, 30.1698),
          districtId: 'zheleznodorozhny',
          exhibitions: [
            Exhibition(
              id: 'e9',
              title: 'Детство Марка Шагала',
              description: 'Семейная обстановка и быт еврейского Витебска.',
              dateRange: 'Постоянная экспозиция',
            ),
          ],
        ),
      ],
    ),
    District(
      id: 'pervomaysky',
      nameRu: 'Первомайский район',
      nameEn: 'May Day District',
      nameBe: 'Першамайскі раён',
      center: const LatLng(55.212, 30.227),
      museums: [
        Museum(
          id: 'muzey_vov',
          name: 'Музей истории Великой Отечественной войны',
          description:
              'Крупная экспозиция о событиях 1941–1945 годов на Витебщине. '
              'Оружие, документы, диорамы сражений.',
          address: 'пл. Победы, 1',
          openHours: 'Вт–Вс: 10:00–18:00',
          admissionFee: '4 BYN',
          location: const LatLng(55.2115, 30.2268),
          districtId: 'pervomaysky',
          exhibitions: [
            Exhibition(
              id: 'e10',
              title: 'Оборона Витебска 1941',
              description: 'Трагические дни обороны города в первые месяцы войны.',
              dateRange: 'Постоянная экспозиция',
            ),
            Exhibition(
              id: 'e11',
              title: 'Витебск — город-герой',
              description: 'Награды, документы и свидетельства героизма витеблян.',
              dateRange: '09.05.2025 — 09.05.2026',
            ),
          ],
        ),
      ],
    ),
    District(
      id: 'ordzhonikidzesky',
      nameRu: 'Орджоникидзевский район',
      nameEn: 'Ordzhonikidze District',
      nameBe: 'Арджанікідзеўскі раён',
      center: const LatLng(55.175, 30.211),
      museums: [
        Museum(
          id: 'muzey_prirody',
          name: 'Витебский зоологический музей',
          description:
              'Коллекция чучел животных и птиц Витебской области. '
              'Интерактивные экспозиции для детей о природе родного края.',
          address: 'ул. Фрунзе, 56',
          openHours: 'Пн–Пт: 09:00–17:00',
          admissionFee: '2 BYN',
          location: const LatLng(55.1755, 30.2108),
          districtId: 'ordzhonikidzesky',
          exhibitions: [
            Exhibition(
              id: 'e12',
              title: 'Животный мир Белорусского Поозерья',
              description: 'Экспозиция о фауне Витебщины: зубры, рыси, орлы.',
              dateRange: 'Постоянная экспозиция',
            ),
            Exhibition(
              id: 'e13',
              title: 'Птицы Витебщины',
              description: 'Орнитологическая коллекция: более 200 видов птиц.',
              dateRange: '01.04.2025 — 30.09.2025',
            ),
          ],
        ),
      ],
    ),
  ];

  List<District> getAllDistricts() => _districts;

  District? getDistrictById(String id) {
    try {
      return _districts.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  Museum? getMuseumById(String id) {
    for (final district in _districts) {
      try {
        return district.museums.firstWhere((m) => m.id == id);
      } catch (_) {
        continue;
      }
    }
    return null;
  }

  List<Museum> getAllMuseums() =>
      _districts.expand((d) => d.museums).toList();
}