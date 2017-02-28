defmodule Mssqlex.TypesTest do
  use ExUnit.Case, async: true

  alias Mssqlex.Result

  setup_all do
    {:ok, pid} = Mssqlex.start_link([])
    Mssqlex.query(pid, "DROP DATABASE types_test;", [])
    {:ok, _, _} = Mssqlex.query(pid, "CREATE DATABASE types_test;", [])

    {:ok, [pid: pid]}
  end

  test "sql_char", %{pid: pid} do
    assert {_query, %Result{rows: [["Nathan"]]}} =
      act(pid, "char(6)", [{{:sql_char, 6}, ["Nathan"]}])
  end

  test "sql_wchar", %{pid: pid} do
    assert {_query, %Result{rows: [["e→øæ"]]}} =
      act(pid, "nchar(4)", [{{:sql_wchar, 4}, ["e→øæ"]}])
  end

  test "sql_numeric(9, 0)", %{pid: pid} do
    assert {_query, %Result{rows: [[34]]}} =
      act(pid, "numeric(9)", [{{:sql_numeric, 9, 0}, ["34"]}])
  end

  test "sql_numeric(10, 0)", %{pid: pid} do
    assert {_query, %Result{rows: [[1234567890.0]]}} =
      act(pid, "numeric(10)", [{{:sql_numeric, 10, 0}, ["1234567890"]}])
  end

  # test "sql_numeric(38, 0)", %{pid: pid} do
  #   assert {_query, %Result{rows: [["12345678901234567890123456789012345678"]]}} =
  #     act(pid, "numeric(38, 0)", [{{:sql_numeric, 38, 0}, ["12345678901234567890123456789012345678"]}])
  # end

  test "sql_numeric(5, 2)", %{pid: pid} do
    assert {_query, %Result{rows: [[123.45]]}} =
      act(pid, "numeric(5, 2)", [{{:sql_numeric, 5, 2}, ["123.45"]}])
  end

  test "sql_decimal(7, 0)", %{pid: pid} do
    assert {_query, %Result{rows: [[1234567]]}} =
      act(pid, "decimal(7)", [{{:sql_decimal, 7, 0}, ["1234567"]}])
  end

  test "sql_decimal(13, 0)", %{pid: pid} do
    assert {_query, %Result{rows: [[1234567890123.0]]}} =
      act(pid, "decimal(13)", [{{:sql_decimal, 13, 0}, ["1234567890123"]}])
  end

  # test "sql_decimal(32, 0)", %{pid: pid} do
  #   assert {_query, %Result{rows: [[12345678901234567890123456789012]]}} =
  #     act(pid, "decimal(32)", [{{:sql_decimal, 32, 0}, ["12345678901234567890123456789012"]}])
  # end

  test "sql_decimal(7, 3)", %{pid: pid} do
    assert {_query, %Result{rows: [[1234.567]]}} =
      act(pid, "decimal(7, 3)", [{{:sql_decimal, 7, 3}, ["1234.567"]}])
  end

  defp act(pid, type, params) do
    Mssqlex.query!(pid, "CREATE TABLE types_test.dbo.\"#{Base.url_encode64 type}\" (test #{type})", [])
    Mssqlex.query!(pid, "INSERT INTO types_test.dbo.\"#{Base.url_encode64 type}\" VALUES (?)", params)
    Mssqlex.query!(pid, "SELECT * FROM types_test.dbo.\"#{Base.url_encode64 type}\"", [])
  end
end
