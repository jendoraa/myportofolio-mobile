import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

void main() {
  const baseUrl = 'http://test.local';

  group('ApiClient - Experience', () {
    test('getExperiences mengembalikan daftar Experience saat 200 OK', () async {
      final mockClient = MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.toString(), '$baseUrl/api/v1/experience/');
        expect(request.headers['Accept'], 'application/json');

        return http.Response(
          jsonEncode([
            {
              'id': 'uuid-1',
              'title': 'BEM Fasilkom UI',
              'position': 'Frontend Dev',
              'description': 'Membangun antarmuka web.',
              'thumbnail': 'https://example.com/img.png',
              'started_at': '2025/01/01',
              'ended_at': null,
            },
          ]),
          200,
        );
      });

      final api = ApiClient(client: mockClient, baseUrl: baseUrl);
      final result = await api.getExperiences();

      expect(result, hasLength(1));
      expect(result.first.id, 'uuid-1');
      expect(result.first.title, 'BEM Fasilkom UI');
      expect(result.first.position, 'Frontend Dev');
      expect(result.first.isOngoing, isTrue);
    });

    test('getExperiences melempar ApiException saat respons non-2xx', () async {
      final mockClient = MockClient(
        (_) async => http.Response('Internal Server Error', 500),
      );

      final api = ApiClient(client: mockClient, baseUrl: baseUrl);

      expect(
        api.getExperiences,
        throwsA(
          isA<ApiException>().having((e) => e.statusCode, 'statusCode', 500),
        ),
      );
    });

    test(
      'createExperience mengirim token auth & body snake_case tanpa id',
      () async {
        final mockClient = MockClient((request) async {
          expect(request.method, 'POST');
          expect(request.url.toString(), '$baseUrl/api/v1/experience/');
          expect(request.headers['Authorization'], 'Token secret-token');

          final body = jsonDecode(request.body) as Map<String, dynamic>;
          expect(body.containsKey('id'), isFalse);
          expect(body['title'], 'Compfest');
          expect(body['started_at'], '2025/03/01');
          expect(body['ended_at'], '2025/11/01');

          return http.Response(
            jsonEncode({
              'id': 'uuid-2',
              ...body,
            }),
            201,
          );
        });

        final api = ApiClient(client: mockClient, baseUrl: baseUrl);
        final created = await api.createExperience(
          const Experience(
            title: 'Compfest',
            position: 'Staff IT',
            description: 'Mengembangkan portal lomba.',
            thumbnail: '',
            startedAt: '2025/03/01',
            endedAt: '2025/11/01',
          ),
          token: 'secret-token',
        );

        expect(created.id, 'uuid-2');
        expect(created.title, 'Compfest');
        expect(created.isOngoing, isFalse);
      },
    );

    test('createExperience melempar ApiException(401) saat token tidak valid', () async {
      final mockClient = MockClient(
        (_) async => http.Response('{"detail":"Invalid token."}', 401),
      );

      final api = ApiClient(client: mockClient, baseUrl: baseUrl);

      expect(
        () => api.createExperience(
          const Experience(
            title: 'Test',
            position: 'Dev',
            description: 'Desc',
            thumbnail: '',
            startedAt: '2025/01/01',
          ),
          token: 'expired-token',
        ),
        throwsA(
          isA<ApiException>().having((e) => e.statusCode, 'statusCode', 401),
        ),
      );
    });
  });

  group('ApiClient - Auth', () {
    test('obtainToken mengembalikan token saat kredensial valid', () async {
      final mockClient = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.toString(), '$baseUrl/api/v1/auth/token/');
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['username'], 'admin');
        expect(body['password'], 'secret');

        return http.Response(jsonEncode({'token': 'abc123'}), 200);
      });

      final api = ApiClient(client: mockClient, baseUrl: baseUrl);
      final token = await api.obtainToken('admin', 'secret');

      expect(token, 'abc123');
    });

    test('logout mengirim header Authorization Token', () async {
      final mockClient = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.toString(), '$baseUrl/api/v1/auth/logout/');
        expect(request.headers['Authorization'], 'Token abc123');
        return http.Response('', 204);
      });

      final api = ApiClient(client: mockClient, baseUrl: baseUrl);
      await api.logout(token: 'abc123');
    });
  });
}