defmodule Mssqlex.LoginTest do
  use ExUnit.Case, async: true

  alias Mssqlex.Result

  test "Given valid details, connects to database" do
    assert {:ok, pid} = Mssqlex.start_link([])
    assert {:ok, _, %Result{num_rows: 1, rows: [{"test"}]}} = Mssqlex.query(pid, "SELECT 'test'", [])
  end

  test "Given invalid details, errors" do
    Process.flag(:trap_exit, true)

    assert {:ok, pid} = Mssqlex.start_link(password: "badpass")
    assert_receive {:EXIT, ^pid, _reason}
  end
end