require 'spec_helper'
require 'modifier'
require 'csv'

RSpec.describe 'Modifier' do

  let(:file) { Reader.new(filename: 'random-expenses.csv') }
  let(:modifier) { Modifier.new(file_content: [["col1", "col2"], ["col1", "col2"]])}

  it 'duplicates the file content' do 
    expect(modifier.duplicate).to eq [
      ["col1", "col2"], ["col1", "col2"],
      ["col1", "col2"], ["col1", "col2"]
    ]
  end

  it 'add a new default value into a new column' do
    expect(modifier.new_default_column_value('col3')).to eq [
      ["col1", "col2", "col3"],
      ["col1", "col2", "col3"]
    ]
  end

  it 'updates a file by column value from another source file' do    
    expect(modifier.add_remote_cell_value(source_content: [[0, 2], [0, 4]], column_position: 1)
    ).to eq [["col1", "col2", 2], ["col1", "col2", 4]]
  end

  it 'updates a hh:mm:ss time to seconds' do
    content = [[1, 2, "00:01:20"], [3, 4, "00:01:20"]]
    modifier = Modifier.new(file_content: content)
    expect(modifier.convert_time_to_seconds(column_position: 2)).to eq [
      [1, 2, 80], 
      [3, 4, 80]
    ]
  end

  it 'removes all quotation marks' do 
    expect(modifier.remove_quotation_marks).to eq "col1,col2\ncol1,col2\n"
  end

  it 'changes the separator' do 
    expect(modifier.change_separator_to(separator: ";")).to eq [
      "col1;col2\n",
      "col1;col2\n"
    ]
  end

  it 'removes x header lines' do 
    expect(modifier.remove_headers(lines: 1)).to eq [["col1", "col2"]]
  end
end