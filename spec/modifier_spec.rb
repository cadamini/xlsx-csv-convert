require 'spec_helper'
require 'modifier'
require 'csv'

RSpec.describe 'Modifier' do

  let(:file) { Reader.new(filename: 'random-expenses.csv') }
  let(:modifier) { Modifier.new(file_content: [["A", "B"], ["A", "B"]]) }

  it 'duplicates the file content' do 
    expect(
      modifier.duplicate
    ).to eq [["A", "B"], ["A", "B"],["A", "B"], ["A", "B"]]
  end

  it 'add a new default value into a new column' do
    expect(
      modifier.new_default_column_value('C')
    ).to eq [["A", "B", "C"], ["A", "B", "C"]]
  end

  it 'updates a file by column value from another source file' do
    source_content = Modifier.new(file_content: [[1,2],[3,4]]).file_content
    expect(
      modifier.update_value_by_value_at_column(source_content: source_content, column_position: 1)
    ).to eq [["A", "B", 2], ["A", "B", 4]]
  end

  it 'updates a hh:mm:ss time to seconds' do
    modifier = Modifier.new(file_content: [[1,2, "00:01:20"],[3,4, "00:01:20"]])
    expect(modifier.convert_time_to_seconds(column_position: 2)).to eq [[1, 2, 80], [3, 4, 80]]
  end

  it 'removes all quotation marks' do 
    expect(modifier.remove_quotation_marks).to eq  "A,B\nA,B\n"
  end

  it 'changes the separator' do 
    expect(modifier.change_separator_to(separator: ";")).to eq ["A;B\n", "A;B\n"]
  end

  it 'removes x header lines' do 
    expect(modifier.remove_headers(lines: 1)).to eq [["A", "B"]]
  end
end