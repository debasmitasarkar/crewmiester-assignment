import 'package:flutter_test/flutter_test.dart';
import 'package:absence_api/src/models/member_data.dart';

void main() {
  group('MemberData JSON (de)serialisation', () {
    const fixture = {
      'id': 2650,
      'crewId': 352,
      'userId': 2664,
      'name': 'Mike',
      'image': 'https://loremflickr.com/300/400',
    };

    test('fromJson parses fields correctly', () {
      final dto = MemberData.fromJson(fixture);

      expect(dto.id, equals(2650));
      expect(dto.crewId, equals(352));
      expect(dto.userId, equals(2664));
      expect(dto.name, equals('Mike'));
      expect(dto.image, equals('https://loremflickr.com/300/400'));
    });
  });
}
