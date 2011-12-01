require 'spec_helper'
require 'ostruct'

describe CIController do
  let(:controller) { CIController.new }

  let(:cookies_table) {
    [
      { 'cookie' => double('cookie1'), 'domain' => '.foo.com', 'name' => 'f0o', 'expires_at' => '2999-02-01 00:00:00 -0800', 'path' => '/', 'value' => 'foo.BAT.foobar' },
      { 'cookie' => double('cookie2'), 'domain' => '.bar.com', 'name' => 'b4r', 'expires_at' => '2888-02-01 00:00:00 -0800', 'path' => '/', 'value' => 'bar.BAT.barbar' },
      { 'cookie' => double('cookie3'), 'domain' => '.baz.com', 'name' => 'b4z', 'expires_at' => '2777-02-01 00:00:00 -0800', 'path' => '/', 'value' => 'baz.BAT.bazbar' }
    ]
  }

  before(:each) do
    controller.cookies_table  = cookies_table
    controller._cookies_table = cookies_table.dup

    controller.stub(:preserving_selected_rows).and_yield
    controller.stub(:reload_data!)
  end

  describe '#tableView:objectValueForTableColumn:row' do
    describe "Getting the value for each column in a row" do
      context "When the column name and row are valid" do

        it "should return the value for the given column and row index" do
          row = cookies_table[0]

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
    describe 'Sorting the cookies table by a column and order' do
      it "should case-insensitive sort the rows by the selected column" do
        controller.should_receive(:get_sort_descriptor) {
          OpenStruct.new({:key => 'domain', :ascending => true})
        }

        controller.tableView(double("view"), sortDescriptorsDidChange:double("old_descriptors"))

        cookies_table.map{|t| t['domain']}.should == %w[.bar.com .baz.com .foo.com]
      end

      it "should sort the rows according to the order (asc/desc)" do
        controller.should_receive(:get_sort_descriptor) {
          OpenStruct.new({:key => 'name', :ascending => false})
        }

        controller.tableView(double("view"), sortDescriptorsDidChange:double("old_descriptors"))

        cookies_table.map{|t| t['name']}.should == %w[f0o b4z b4r]
      end
    end
  end

  describe '#searchCookies' do
    context "when text was entered in the Search Field" do
      it "should filter the cookies table for the text" do
        controller.should_receive(:search_field_value) { "foobar" }

        controller.searchCookies double("sender")

        controller.cookies_table.should have(1).items
      end
    end

    context "when the Search Field is empty" do
      it "should restore the cookies table to the full list" do
        controller.should_receive(:search_field_value) { "" }

        controller.searchCookies double("sender")

        controller.cookies_table.should have(3).items
      end
    end
  end

  describe '#reloadCookies' do
    it "should call #update_and_reload! (Sanity-check test)" do
      controller.should_receive(:update_and_reload!)
      controller.reloadCookies double("sender")
    end
  end

  describe '#deleteCookies' do
    context "when deleting N selected rows" do
      it "should remove the row(s) and update/reload the list of cookies" do
        row = cookies_table.first

        controller.should_receive(:get_selected_rows) { [row] }
        controller.should_receive(:delete_cookie).with(row['cookie'])
        controller.should_receive(:update_and_reload!)

        controller.deleteCookies double("sender")
      end
    end
  end

  describe '#update_and_reload!' do
    it "should trigger method calls in a specific order" do
      call_stack = []

      controller.should_receive(:cookie_table) {
        call_stack << :cookie_table
        cookies_table.reverse
      }

      controller.should_receive(:apply_sort_to_table_view)  { call_stack << :apply_sort_to_table_view }
      controller.should_receive(:apply_search_filter)       { call_stack << :apply_search_filter }
      controller.should_receive(:reload_data!)              { call_stack << :reload_data! }

      controller.update_and_reload!

      call_stack.should == [:cookie_table, :apply_sort_to_table_view, :apply_search_filter, :reload_data!]
    end
  end

  describe '#preserving_selected_rows' do
    # @todo
  end

  describe '#apply_sort_to_table_view' do
    # @todo
  end

end
