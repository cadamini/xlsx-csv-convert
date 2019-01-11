**Please note, this is work in progress and really basic as I use this to learn tdd and ruby, please feel free to contribute via pull requests or let me know what I can inmprove.**

TODO: Current classes / methods loop through the complete file content and change one thing, it will be better to have a single loop with several operations at once.  

## Usage Instructions

#### Read a file and file @content

file = Reader.new(filename: 'yourfilename.csv')

#### Find a value in the sheet

file.value_at(row: 1, column: 1)

#### Initiate the modifier with @content from the reader

The modifier returns only arrays which can be used to build new csv files

`source = Modifier.new(file_content: file.content)`

#### Now there a couple of methods

* source.duplicate 
Mirrors the content of the file

* source.new_default_column_value(value)
Add a value in a new column to all rows

* source.update_value_by_value_at_column(source_content:, column_position:)
Read the very same cell (row+column) from another file and update the first, 
this is only working for now when the files have the same size.

* source.remove_quotation_marks
This method removes the quote values via force_quotes: false

* source.change_separator_to(separator:)
Changes the separator to the defined one.

* source.remove_headers(lines:)
Removes a certain number of lines from the top of the file. 
