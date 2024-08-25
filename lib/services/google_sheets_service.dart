import 'dart:convert';
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter/services.dart' show rootBundle;

class GoogleSheetsService {
  final String _spreadsheetId = 'your_spreadsheet_id';
  final String _credentialsFile = 'assets/credentials.json';
  late sheets.SheetsApi _sheetsApi;

  Future<void> init() async {
    final credentials = await rootBundle.loadString(_credentialsFile);
    final jsonCredentials = json.decode(credentials);
    final accountCredentials =
        ServiceAccountCredentials.fromJson(jsonCredentials);
    final scopes = [sheets.SheetsApi.spreadsheetsScope];

    final authClient =
        await clientViaServiceAccount(accountCredentials, scopes);
    _sheetsApi = sheets.SheetsApi(authClient);
  }

  Future<void> insertRow(List<dynamic> row) async {
    const range = 'Sheet1!A1';
    final valueRange = sheets.ValueRange.fromJson({
      'values': [row],
    });

    await _sheetsApi.spreadsheets.values.append(
      valueRange,
      _spreadsheetId,
      range,
      valueInputOption: 'RAW',
    );
  }

  Future<List<List<dynamic>>> getRows() async {
    const range = 'Sheet1!A1:Z1000';
    final response =
        await _sheetsApi.spreadsheets.values.get(_spreadsheetId, range);
    return response.values ?? [];
  }

  Future<void> deleteRow(int rowIndex) async {
    final requests = [
      sheets.Request(
        deleteDimension: sheets.DeleteDimensionRequest(
          range: sheets.DimensionRange(
            sheetId: 0, // Assuming the first sheet
            dimension: 'ROWS',
            startIndex: rowIndex - 1,
            endIndex: rowIndex,
          ),
        ),
      ),
    ];

    final batchUpdateRequest =
        sheets.BatchUpdateSpreadsheetRequest(requests: requests);
    await _sheetsApi.spreadsheets
        .batchUpdate(batchUpdateRequest, _spreadsheetId);
  }
}
