require_relative 'lib/excel_2_csv_convert'

options = {
  column_positions: {
    date: 5,
    queue_name: 3,
    handling_time: [6, 7] # mutiple elements or integer
  },
  # more options (optional)
  import_path: 'import', # default 'import'
  export_path: 'export'  # default 'export'
}
Excel2CsvConvert.new(options).run