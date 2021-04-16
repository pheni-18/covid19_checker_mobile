import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

import 'package:covid19_checker_mobile/network.dart';
import 'network_test.mocks.dart';
import 'package:covid19_checker_mobile/prefectures.dart';

@GenerateMocks([http.Client])
void main() {
  test('returns Prefectures if the http call completes successfully', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await DotEnv.load(fileName: 'assets/.env');

    final client = MockClient();
    final String apiURL = DotEnv.env['API_URL'];

    when(client.get('$apiURL/all?date=20210101')).thenAnswer((_) async {
      return http.Response(
        '[{"name": "name1", "date": "2021-01-01", "count": 50}, {"name": "name2", "date": "2021-01-01", "count": 100}, {"name": "name3", "date": "2021-01-01", "count": 150}]',
        200,
      );
    });

    final Covid19APIClient covid19APIClient = Covid19APIClient(client);
    expect(await covid19APIClient.getAll('20210101'), isA<List<Prefecture>>());
  });

  test('returns empty list if the http call completes with an error', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await DotEnv.load(fileName: 'assets/.env');

    final client = MockClient();
    final String apiURL = DotEnv.env['API_URL'];

    when(client.get('$apiURL/all?date=20210101'))
        .thenAnswer((_) async => http.Response('Not Found', 404));

    final Covid19APIClient covid19APIClient = Covid19APIClient(client);
    expect(await covid19APIClient.getAll('20210101'), []);
  });
}
