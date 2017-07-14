#include "excel_reader.h"

ExcelReader::ExcelReader(const QString& filepath, QObject* parent) : QObject(parent), excel_file_(new YExcel::BasicExcel) {
  excel_file_->Load(filepath.toLocal8Bit().data());
}

ExcelReader::~ExcelReader() {
  delete excel_file_;
}

size_t ExcelReader::sheetCount() const {
  return excel_file_->GetTotalWorkSheets();
}

size_t ExcelReader::rows(const size_t workSheetId) const {
  return excel_file_->GetWorksheet(workSheetId)->GetTotalRows();
}

size_t ExcelReader::cols(const size_t workSheetId) const {
  return excel_file_->GetWorksheet(workSheetId)->GetTotalCols();
}

QString ExcelReader::read(const size_t workSheetId, const size_t row, const size_t col) {
  QString res = QString::fromUtf8(excel_file_->GetWorksheet(workSheetId)->Cell(row, col)->GetString());
  return res;
}
