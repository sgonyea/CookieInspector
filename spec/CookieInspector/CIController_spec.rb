require 'spec_helper'
require 'ostruct'

describe CIController do
  let(:controller) { CIController.new }

  let(:cookies_table) {
    [{ 'domain' => '.foo.com', 'name' => 'bar', 'expires_at' => '2999-02-01 00:00:00 -0800', 'path' => '/', 'value' => 'baz.bat.foobar' }]
  }

  before(:each) do
    controller.cookies_table = cookies_table
  end

  describe '#tableView:objectValueForTableColumn:row' do
    describe "Getting the value for each column in a row" do
      context "When the column name and row are valid" do

        it "should return the value for the given column and row index" do
          row = cookies_table.first

          row.keys.each do |key|
            column  = OpenStruct.new({:identifier => key})
            value   = controller.tableView(double("view"), objectValueForTableColumn: column, row:0)

            value.should == row[key]
          end
        end

      end
    end
  end

  describe '#tableView:sortDescriptorsDidChange' do
    # @todo
  end

  describe '#searchCookies' do
    # @todo
  end

  describe '#reloadCookies' do
    # @todo
  end

  describe '#deleteCookies' do
    # @todo
  end

  describe '#apply_sort_to_table_view' do
    # @todo
  end
end
