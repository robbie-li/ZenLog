#ifndef EXCELREADER_H
#define EXCELREADER_H

#include <QObject>
#include "BasicExcel.h"

class ExcelReader : QObject {
    Q_OBJECT
  public:
    explicit ExcelReader(const QString& filepath, QObject* parent = nullptr);
    ~ExcelReader();

    size_t sheetCount() const;
    size_t rows(const size_t workSheetId) const;
    size_t cols(const size_t workSheetId) const;
    QString read(const size_t workSheetId, const size_t x, const size_t y);
  private:
    YExcel::BasicExcel* excel_file_;
};

#endif // EXCELREADER_H
