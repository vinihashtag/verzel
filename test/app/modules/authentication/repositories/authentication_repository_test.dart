import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:verzel/app/modules/authentication/repositories/authentication_repository.dart';

class AuthenticationRepositoryMock extends Mock
    implements AuthenticationRepository {}

void main() {
  AuthenticationRepositoryMock repository;
  // MockClient client;

  setUp(() {
    repository = AuthenticationRepositoryMock();
    // client = MockClient();
  });

  group('AuthenticationRepository Test', () {
    test("First Test", () {
      expect(repository, isInstanceOf<AuthenticationRepository>());
    });

    test('returns a Post if the http call completes successfully', () async {
      //    when(client.get('https://jsonplaceholder.typicode.com/posts/1'))
      //        .thenAnswer((_) async =>
      //            Response(data: {'title': 'Test'}, statusCode: 200));
      //    Map<String, dynamic> data = await repository.fetchPost(client);
      //    expect(data['title'], 'Test');
    });
  });
}
