import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class GoogleDriveService {
  final String _credentialsFile = dotenv.env['GCSAK_PATH']!;
  final String _folder = dotenv.env['GCDF_PATH']!;


  Future<http.Client> _getAuthClient() async {
    String credentials = await rootBundle.loadString(_credentialsFile);
    final Map<String, dynamic> key = jsonDecode(credentials);

    final accountCredentials = ServiceAccountCredentials.fromJson(key);
    final scopes = [drive.DriveApi.driveFileScope];
    return await clientViaServiceAccount(accountCredentials, scopes);
  }

  Future<void> uploadFileToDrive(String filePath) async {
    final http.Client authClient = await _getAuthClient();

    final driveApi = drive.DriveApi(authClient);

    var fileToUpload = File(filePath);
    var media = drive.Media(fileToUpload.openRead(), fileToUpload.lengthSync());

    var driveFile = drive.File();
    driveFile.name = fileToUpload.uri.pathSegments.last;

    driveFile.parents = [_folder];

    var result = await driveApi.files.create(
      driveFile,
      uploadMedia: media,
    );
    print("Uploaded file with ID: ${result.id}");
    authClient.close();
  }
}
