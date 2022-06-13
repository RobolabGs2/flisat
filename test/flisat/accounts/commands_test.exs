defmodule Flisat.Accounts.Commands.Test do
  use Flisat.DataCase

  alias Flisat.Accounts

  test "delete_user/1 test" do
    user = insert(:user)
    assert {:ok, _result} = Accounts.delete_user(user)
    assert {:error, :not_found} = Accounts.get_user(user.id)
  end

  test "update_user/1 test" do
    user = insert(:user, %{nickname: "oldname"})
    attrs = %{nickname: "newname"}
    assert {:ok, updated_user} = Accounts.update_user(user, attrs)
    assert updated_user.nickname == attrs.nickname
  end
end
