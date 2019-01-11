require 'spec_helper'
require 'reader'

RSpec.describe 'Reader' do

  let(:file) { Reader.new(filename: 'random-expenses.csv') }

  it 'reads the file content' do 
    expect(file.content).to be_a Array
    expect(file.content.first).to eq ["Date", "Cost", "Category"] 
  end

  it 'can get the value from certain cells' do 
    expect(file.value_at(row: 1, column: 1)).to eq "85.8"
  end
end