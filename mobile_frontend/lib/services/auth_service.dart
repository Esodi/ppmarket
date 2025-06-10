import 'package:graphql_flutter/graphql_flutter.dart';

class AuthService {
  final GraphQLClient client;

  AuthService(this.client);
  // This should be in your auth_service.dart file
  Future<Map<String, dynamic>?> login(String email, String password) async {
    const String loginMutation = '''
    mutation TokenCreate(\$email: String!, \$password: String!) {
      tokenCreate(email: \$email, password: \$password) {
        token
        refreshToken
        user {
          id
          email
          isActive
        }
        accountErrors {
          field
          message
          code
        }
      }
    }
  ''';

    try {
      final QueryResult result = await client.mutate(
        MutationOptions(
          document: gql(loginMutation),
          variables: {'email': email, 'password': password},
        ),
      );

      print('Login result: ${result.data}');
      print('Login exception: ${result.exception}');

      if (result.hasException) {
        return {
          'success': false,
          'error': 'Network error: ${result.exception.toString()}',
        };
      }

      final data = result.data?['tokenCreate'];

      // Check for account errors
      if (data?['accountErrors']?.isNotEmpty == true) {
        final errors = data['accountErrors'] as List;
        final errorMessages = errors.map((e) => e['message']).join(', ');
        return {'success': false, 'error': errorMessages};
      }

      // Check if token was returned
      if (data?['token'] != null) {
        final token = data['token'];
        // Store token securely (you might want to use flutter_secure_storage)
        // For now, just return success
        return {'success': true, 'token': token, 'user': data['user']};
      }

      return {'success': false, 'error': 'Login failed - no token returned'};
    } catch (e) {
      print('Login exception: $e');
      return {'success': false, 'error': 'Unexpected error: ${e.toString()}'};
    }
  }

  // This should be in your auth_service.dart file
  Future<Map<String, dynamic>> register(String email, String password) async {
    const String registerMutation = '''
    mutation AccountRegister(\$input: AccountRegisterInput!) {
      accountRegister(input: \$input) {
        user {
          id
          email
        }
        requiresConfirmation
        accountErrors {
          field
          message
          code
        }
      }
    }
  ''';

    try {
      final QueryResult result = await client.mutate(
        MutationOptions(
          document: gql(registerMutation),
          variables: {
            'input': {
              'email': email,
              'password': password,
              'redirectUrl':
                  'http://localhost:3000/confirm-account', // Frontend confirmation URL
              'channel': 'default-channel',
            },
          },
        ),
      );

      print('Registration result: ${result.data}');

      if (result.hasException) {
        return {
          'success': false,
          'error': 'Network error: ${result.exception.toString()}',
        };
      }

      final data = result.data?['accountRegister'];

      if (data?['accountErrors']?.isNotEmpty == true) {
        final errors = data['accountErrors'] as List;
        final errorMessages = errors
            .map((e) => '${e['field']}: ${e['message']}')
            .join(', ');
        return {'success': false, 'error': errorMessages};
      }

      // Registration successful
      return {
        'success': true,
        'requiresConfirmation': data['requiresConfirmation'] ?? false,
        'user': data['user'],
      };
    } catch (e) {
      return {'success': false, 'error': 'Unexpected error: ${e.toString()}'};
    }
  }

  // Add this method to your auth_service.dart file
  Future<Map<String, dynamic>> confirmAccount(
    String email,
    String token,
  ) async {
    const String confirmAccountMutation = '''
      mutation ConfirmAccount(\$email: String!, \$token: String!) {
        confirmAccount(email: \$email, token: \$token) {
          user {
            id
            email
            isActive
          }
          accountErrors {
            field
            message
            code
          }
        }
      }
    ''';

    try {
      final QueryResult result = await client.mutate(
        MutationOptions(
          document: gql(confirmAccountMutation),
          variables: {'email': email, 'token': token},
        ),
      );

      if (result.hasException) {
        return {
          'success': false,
          'error': 'Network error: ${result.exception.toString()}',
        };
      }

      final data = result.data?['confirmAccount'];

      if (data?['accountErrors']?.isNotEmpty == true) {
        final errors = data['accountErrors'] as List;
        final errorMessages = errors.map((e) => e['message']).join(', ');
        return {'success': false, 'error': errorMessages};
      }

      if (data?['user'] != null) {
        return {'success': true, 'user': data['user']};
      }

      return {'success': false, 'error': 'Account confirmation failed'};
    } catch (e) {
      return {'success': false, 'error': 'Unexpected error: ${e.toString()}'};
    }
  }
}
