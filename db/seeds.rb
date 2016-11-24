# パスワード初期設定

if Password.count == 0
  Password.create(
    {manager_password: "manager", user_password: "user"}
    )
end