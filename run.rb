require_relative 'lib/excel_2_csv_convert'

options = {
  column_positions: {
    date: 5,
    queue_name: 3,
    handling_time: [6, 7] # mutiple elements or integer
  },
  target_format: :injixo, # or :injixo_comma_separated
  # more options (optional)
  keep_tempfile: false,  # default false
  import_path: 'import', # default 'import'
  export_path: 'export'  # default 'export'
}
Excel2CsvConvert.new(options).run