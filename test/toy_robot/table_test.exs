defmodule ToyRobot.TableTest do
  use ExUnit.Case
  alias ToyRobot.Table

  describe "valid_position?/2" do
    setup do
      table = %Table{north_boundary: 4, east_boundary: 4}
      {:ok, table: table}
    end

    test "returns true for position at origin (0,0)", %{table: table} do
      position = %{north: 0, east: 0}
      assert Table.valid_position?(table, position) == true
    end

    test "returns true for position at boundaries (4,4)", %{table: table} do
      position = %{north: 4, east: 4}
      assert Table.valid_position?(table, position) == true
    end

    test "returns true for position within boundaries (2,3)", %{table: table} do
      position = %{north: 2, east: 3}
      assert Table.valid_position?(table, position) == true
    end

    test "returns false for position north of boundary", %{table: table} do
      position = %{north: 5, east: 2}
      assert Table.valid_position?(table, position) == false
    end

    test "returns false for position east of boundary", %{table: table} do
      position = %{north: 2, east: 5}
      assert Table.valid_position?(table, position) == false
    end

    test "returns false for position beyond both boundaries", %{table: table} do
      position = %{north: 6, east: 6}
      assert Table.valid_position?(table, position) == false
    end

    test "returns false for negative north coordinate", %{table: table} do
      position = %{north: -1, east: 2}
      assert Table.valid_position?(table, position) == false
    end

    test "returns false for negative east coordinate", %{table: table} do
      position = %{north: 2, east: -1}
      assert Table.valid_position?(table, position) == false
    end

    test "returns false for negative coordinates", %{table: table} do
      position = %{north: -1, east: -1}
      assert Table.valid_position?(table, position) == false
    end

    test "works with different table sizes" do
      small_table = %Table{north_boundary: 2, east_boundary: 2}
      large_table = %Table{north_boundary: 10, east_boundary: 10}

      # Test small table
      assert Table.valid_position?(small_table, %{north: 2, east: 2}) == true
      assert Table.valid_position?(small_table, %{north: 3, east: 1}) == false

      # Test large table
      assert Table.valid_position?(large_table, %{north: 10, east: 10}) == true
      assert Table.valid_position?(large_table, %{north: 5, east: 7}) == true
      assert Table.valid_position?(large_table, %{north: 11, east: 5}) == false
    end

    test "works with rectangular tables" do
      rectangular_table = %Table{north_boundary: 3, east_boundary: 5}

      assert Table.valid_position?(rectangular_table, %{north: 3, east: 5}) == true
      assert Table.valid_position?(rectangular_table, %{north: 4, east: 3}) == false
      assert Table.valid_position?(rectangular_table, %{north: 2, east: 6}) == false
    end
  end
end
